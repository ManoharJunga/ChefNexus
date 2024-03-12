// ignore_for_file: unused_element, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import 'forgot_password.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        _controllerEmail.text,
        _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        _controllerEmail.text,
        _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        errorMessage = 'Failed to sign in with Google: $e';
      });
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // Use the `credential` to sign in with Apple
    } catch (e) {
      print(e.toString());
      setState(() {
        errorMessage = 'Failed to sign in with Apple: $e';
      });
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
    } catch (e) {
      print(e.toString());
      setState(() {
        errorMessage = 'Failed to sign in with Facebook: $e';
      });
    }
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _brandLogo() {
    return SizedBox(
      height: 200, // Adjust the height as needed
      child: Image.asset('assets/logo.png'),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Error: $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead'),
    );
  }

  Widget _forgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight, // Align to the right
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
    );
  }

  Widget _socialLoginButton({
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          imagePath,
          width: 24, // Adjust the width as needed
          height: 24, // Adjust the height as needed
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(33, 19, 55, 1), // Set the background color here
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _brandLogo(), // Include the brand logo widget here
              const SizedBox(height: 60),
              _entryField('Email', _controllerEmail),
              const SizedBox(height: 20),
              _entryField('Password', _controllerPassword),
              const SizedBox(height: 20),
              _errorMessage(),
              const SizedBox(height: 10),
              _forgotPasswordButton(),
              const SizedBox(height: 30),
              _submitButton(),
              const SizedBox(height: 10),
              _loginOrRegisterButton(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialLoginButton(
                    imagePath: 'assets/google_icon.png',
                    onPressed: signInWithGoogle,
                  ),
                  const SizedBox(width: 10),
                  _socialLoginButton(
                    imagePath: 'assets/apple_icon.png',
                    onPressed: signInWithApple,
                  ),
                  const SizedBox(width: 10),
                  _socialLoginButton(
                    imagePath: 'assets/facebook_icon.png',
                    onPressed: signInWithFacebook,
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
