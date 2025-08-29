import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medb/Settings/utils/images.dart';
import '../../../Settings/helper/secure_storage.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/utils/p_pages.dart';
import '../../../Service/auth_repository.dart';
import '../../../Features/main_screen/view_model/menu_navigation_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final SecureStorageService _storage = SecureStorageService();
  final AuthRepository _authRepository = AuthRepository();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      log("🚀 SplashScreen: Starting comprehensive authentication check");
      
      // Minimum splash screen display time
      final splashDelay = Future.delayed(const Duration(milliseconds: 2500));
      
      // Perform authentication check
      final authenticationResult = await _performDetailedAuthCheck();
      
      // Wait for minimum splash time
      await splashDelay;
      
      if (mounted) {
        if (authenticationResult.isAuthenticated) {
          log("✅ User authenticated - navigating to home");
          _navigateToHome();
        } else {
          log("❌ User not authenticated - navigating to login");
          _navigateToLogin(authenticationResult.message);
        }
      }
      
    } catch (e) {
      log("❌ App initialization error: $e");
      if (mounted) {
        _navigateToLogin("App initialization failed. Please try again.");
      }
    }
  }

  Future<AuthCheckResult> _performDetailedAuthCheck() async {
    try {
      // Step 1: Check if basic credentials exist
      await _storage.debugStorage();
      
      final accessToken = await _storage.getAccessToken();
      final loginKey = await _storage.getLoginKey();
      final userDetails = await _storage.getUserDetails();

      if (accessToken == null || accessToken.isEmpty) {
        return AuthCheckResult(
          isAuthenticated: false,
          message: "No access token found",
        );
      }

      if (loginKey == null || loginKey.isEmpty) {
        return AuthCheckResult(
          isAuthenticated: false,
          message: "No login key found",
        );
      }

      log("✅ Basic credentials found - validating session");

      // Step 2: Validate session by attempting token refresh
      try {
        final refreshResult = await _authRepository.refreshToken();
        
        if (refreshResult != null && refreshResult['accessToken'] != null) {
          // Update stored token with refreshed one
          await _storage.saveAccessToken(refreshResult['accessToken']);
          log("✅ Token refreshed successfully - session valid");
          
          return AuthCheckResult(
            isAuthenticated: true,
            message: "Session validated and token refreshed",
          );
        } else {
          log("❌ Token refresh failed - session expired");
          return AuthCheckResult(
            isAuthenticated: false,
            message: "Session expired. Please login again.",
          );
        }
      } catch (refreshError) {
        log("❌ Token refresh error: $refreshError");
        
        // If refresh fails, the session might be invalid
        // But we'll give benefit of doubt and let user try
        // The actual validation will happen when they make API calls
        if (accessToken.isNotEmpty && loginKey.isNotEmpty) {
          log("⚠️ Refresh failed but tokens exist - allowing login attempt");
          return AuthCheckResult(
            isAuthenticated: true,
            message: "Using existing session (refresh unavailable)",
          );
        } else {
          return AuthCheckResult(
            isAuthenticated: false,
            message: "Session validation failed",
          );
        }
      }

    } catch (e) {
      log("❌ Detailed auth check failed: $e");
      return AuthCheckResult(
        isAuthenticated: false,
        message: "Authentication check failed",
      );
    }
  }

  Future<void> _loadAppData() async {
    try {
      if (mounted) {
        log("📱 Loading saved app data...");
        
        // Load saved menus
        final menuProvider = context.read<MenuNavigationProvider>();
        await menuProvider.loadMenus();
        
        if (menuProvider.hasMenus()) {
          log("✅ Menus loaded: ${menuProvider.menus.length} items");
        } else {
          log("⚠️ No saved menus found");
        }
      }
    } catch (e) {
      log("❌ Error loading app data: $e");
      // Don't fail authentication for app data loading issues
    }
  }

  Future<void> _cleanupInvalidSession() async {
    try {
      await _storage.clear();
      _authRepository.clearCookies();
      
      if (mounted) {
        await context.read<MenuNavigationProvider>().clearMenus();
      }
      
      log("🗑️ Invalid session data cleared");
    } catch (e) {
      log("❌ Error during session cleanup: $e");
    }
  }

  void _navigateToLogin([String? message]) {
    if (!mounted) return;
    
    log("🔄 Navigating to login screen");
    
    // Show message if provided
    if (message != null && message.isNotEmpty && 
        message != "No access token found" && 
        message != "No login key found") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor:PColors.teal,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }
    
    Navigator.pushNamedAndRemoveUntil(
      context,
      PPages.login,
      (route) => false,
    );
  }

  void _navigateToHome() async {
    if (!mounted) return;
    
    try {
      // Load app data before navigation
      await _loadAppData();
      
      log("🏠 Navigating to home screen");
      
      Navigator.pushNamedAndRemoveUntil(
        context,
        PPages.mainPageUi,  // CRITICAL FIX: Navigate to home, not login
        (route) => false,
      );
    } catch (e) {
      log("❌ Error during home navigation: $e");
      // If home navigation fails, go to login as fallback
      _navigateToLogin("Error loading home screen. Please login again.");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        Images.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                "MedB",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                "Your Health, Our Priority",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 50),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCheckResult {
  final bool isAuthenticated;
  final String message;

  AuthCheckResult({
    required this.isAuthenticated,
    required this.message,
  });

  @override
  String toString() {
    return 'AuthCheckResult(isAuthenticated: $isAuthenticated, message: $message)';
  }
}