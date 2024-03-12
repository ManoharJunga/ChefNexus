import 'package:flutter/material.dart';
import 'package:chef_nexus/auth.dart';
import 'package:chef_nexus/pages/loginregister_page.dart';
import 'package:chef_nexus/pages/home_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? _buildLoadingScreen()
        : StreamBuilder(
            stream: Auth().authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return const LoginPage();
              }
            },
          );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        width: double.infinity, // Take the full width of the screen
        height: double.infinity,
        decoration: const BoxDecoration(
          color:
              Color.fromRGBO(33, 19, 55, 1), // Set the background color to blue
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Your logo image asset path
                  height: 300, // Adjust the height as needed
                ),
                const SizedBox(height: 20),
                const Text(
                  "Loading...",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
