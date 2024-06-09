import 'package:flutter/material.dart';
import 'package:nata/utils/image_strings.dart';
import 'package:nata/utils/sizes.dart';
import 'package:nata/utils/text_strings.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("OR"),
        const SizedBox(
          height: tFormHeight - 20,
        ),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Image(
              image: AssetImage(tGoogleLogoImage),
              width: 20.0,
            ),
            label: const Text(tSignInWithGoogle),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: tAlreadyHaveAnAccount,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const TextSpan(
              text: tLogin,
              style: TextStyle(color: Colors.blue))
          ])),
        )
      ],
    );
  }
}