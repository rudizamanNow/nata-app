import 'package:flutter/material.dart';
import 'package:nata/utils/image_strings.dart';
import 'package:nata/utils/sizes.dart';
import 'package:nata/utils/text_strings.dart';
import 'package:nata/view/auth_pages/form_header_widget.dart';
import 'package:nata/view/auth_pages/signup_footer_widget.dart';
import 'package:nata/view/auth_pages/signup_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: const Column(
              children: [
                FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                  imageHeight: 0.15,
                ),
                SignUpFormWidget(),
                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}