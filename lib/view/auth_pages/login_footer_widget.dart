// import 'package:flutter/material.dart';
// import 'package:test_app6/utils/image_strings.dart';
// import 'package:test_app6/utils/sizes.dart';
// import 'package:test_app6/utils/text_strings.dart';

// class LoginFooterWidget extends StatelessWidget {
//   const LoginFooterWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text("OR"),
//         const SizedBox(
//           height: tFormHeight - 20,
//         ),
//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton.icon(
//             icon: const Image(
//               image: AssetImage(tGoogleLogoImage),
//               width: 20.0,
//             ),
//             onPressed: () {
              
//             },
//             label: const Text(tSignInWithGoogle),
//           ),
//         ),
//         const SizedBox(
//           height: tFormHeight - 20,
//         ),
//         TextButton(
//             onPressed: () {},
//             child: Text.rich(TextSpan(
//                 text: tDontHaveAnAccount,
//                 style: Theme.of(context).textTheme.bodyMedium,
//                 children: const [
//                   TextSpan(
//                       text: tSignup,
//                       style: TextStyle(color: Colors.blue))
//                 ])))
//       ],
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nata/services/auth_services.dart';
import 'package:nata/utils/image_strings.dart';
import 'package:nata/utils/sizes.dart';
import 'package:nata/utils/text_strings.dart';
import 'package:nata/view/menu_pages/menu.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(
          height: tFormHeight - 20,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(
              image: AssetImage(tGoogleLogoImage),
              width: 20.0,
            ),
            onPressed: () async {
              try {
                User? user = await AuthService().signInWithGoogle();
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Nata',)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login dibatalkan oleh pengguna")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal login: $e")),
                );
              }
            },
            label: const Text(tSignInWithGoogle),
          ),
        ),
        const SizedBox(
          height: tFormHeight - 20,
        ),
        TextButton(
          onPressed: () {},
          child: Text.rich(TextSpan(
            text: tDontHaveAnAccount,
            style: Theme.of(context).textTheme.bodyMedium,
            children: const [
              TextSpan(text: tSignup, style: TextStyle(color: Colors.blue))
            ],
          )),
        ),
      ],
    );
  }
}
