import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nata/utils/image_strings.dart';
import 'package:nata/utils/sizes.dart';
import 'package:nata/utils/text_strings.dart';
import 'package:nata/view/auth_pages/login_screen.dart';
import 'package:nata/view/auth_pages/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // var mediaQuery = MediaQuery.of(context);
    var height = MediaQuery.of(context).size.height;
    // var brightness = mediaQuery.platformBrightness;
    // final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDarkMode ? tSecondaryColor : tPrimaryColor,
      body: Container(
              padding: const EdgeInsets.all(tDefaultSize),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(image: const AssetImage(tWelcomeScreenImage), height: height * 0.5),
                  Column(
                    children: [
                      Text(
                        tWelcomeTitle,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        tWelcomeSubTitle,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:
                              OutlinedButton(
                                onPressed: () => Get.to(() => const LoginScreen()), 
                                child: const Text(tLogin))),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                          child:
                              ElevatedButton(onPressed: () => Get.to(() => const SignUpScreen()),
                              child: const Text(tSignup))),
                    ],
                  )
                ],
              ),
            ),
          );
    //   ])
    // );
  }
}
