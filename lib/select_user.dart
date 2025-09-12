import 'package:flutter/material.dart';
import 'ser_provider/login_screen2.dart';
import 'user/login_screen1.dart';
import 'constants/my_colors.dart';

class SelectUserScreen extends StatelessWidget {
  const SelectUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User Type'),
      ),
      body: Center(
        child: Container(
          color: vanilla,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Image.asset('assets/man.png'),

                // Title
                const Text(
                  'Welcome! Please select your user type:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 40),

                // General User Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: softBlue,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen1()),
                    );
                  },
                  child: const Text(
                    'General User',
                    style: TextStyle(
                      fontSize: 18,
                      color: vanillaShade,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Service Provider Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: softBlue,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen2()),
                    );
                  },
                  child: const Text(
                    'Service Provider',
                    style: TextStyle(
                      fontSize: 18,
                      color: vanillaShade,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
