import 'package:medb/Features/auth/login/view_model/login_view_model.dart';
import 'package:medb/Features/auth/register/view_model/register_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
ChangeNotifierProvider<RegisterViewModel>(create: (_) => RegisterViewModel()),
ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
];
