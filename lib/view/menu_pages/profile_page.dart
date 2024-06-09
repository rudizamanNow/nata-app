
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nata/services/auth_services.dart';
import 'package:nata/view/auth_pages/login_screen.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.grey,
          ),
        ),
      ),
      body: user != null ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? 'https://via.placeholder.com/150'),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(
              user.displayName ?? 'No display name',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              user.email ?? 'No email',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut();
                Get.offAll(()=> const LoginScreen());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ) : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

