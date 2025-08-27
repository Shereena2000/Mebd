import 'package:flutter/material.dart';
import 'package:medb/Settings/constants/sized_box.dart';
import 'package:medb/Settings/utils/images.dart';
import 'package:medb/Settings/utils/p_colors.dart';
import 'package:medb/Settings/utils/p_text_styles.dart';
import '../../../Settings/common/custom_outline_button.dart';
import '../../../Settings/common/custom_text_feild.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: Padding(
          
          padding: const EdgeInsets.only(left:   8.0),
          child: Image.asset(Images.medbIcon),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          CircleAvatar(
            backgroundColor: PColors.blue,
            radius: 50,
            child: Icon(Icons.person, color: PColors.white, size: 50),
          ),
          SizeBoxH(15),
          Align(
            alignment: Alignment.center,
            child: Text("Update Profile Pocture", style: PTextStyles.bodySmall),
          ),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'First Name'),
          SizeBoxH(15),
          Row(
            children: [
              Expanded(child: CustomTextFeild(hintText: 'Middle Name')),
              SizeBoxV(15),
              Expanded(child: CustomTextFeild(hintText: 'Last Name')),
            ],
          ),

          SizeBoxH(15),
          CustomTextFeild(hintText: 'Age'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'Select Gender'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'Email'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'Contact Name'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'Designation'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'Address'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'City'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'District'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'State'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'Country'),
          SizeBoxH(15),
          CustomTextFeild(hintText: 'Postal Code'),
          SizeBoxH(15),
          CustomOutlineButton(onPressed: () {}, text: 'Update Profile'),
          SizeBoxH(15),
          CustomOutlineButton(
            onPressed: () {},
            text: 'Update Contact No.',
            bgcolor: PColors.white,
            textcolor: PColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
