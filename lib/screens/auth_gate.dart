import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_chat/data/services/auth_services.dart';
import 'package:med_chat/main.dart';

import 'loginPage.dart';
  // Your existing login page

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Listen to the authentication state stream from your AuthService
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          // 1. If the stream is still loading, show a progress indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. If the snapshot has data, it means the user is logged IN
          if (snapshot.hasData) {
            // So, show the main content of your app (e.g., HomePage)
            return BottomNavigate();
          }


          else {

            return const Loginpage();
          }
        },
      ),
    );
  }
}