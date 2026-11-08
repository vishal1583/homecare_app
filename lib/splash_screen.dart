import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/select_user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      context.navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => const SelectUserScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home_work_outlined,
                  size: 64, color: Color(0xFFBEE3CD)),
              SizedBox(height: 24),
              Text('Homecare',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1)),
              SizedBox(height: 8),
              Text('A little help. A better home.',
                  style: TextStyle(color: Color(0xFFD6E7DE))),
              SizedBox(height: 32),
              SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Color(0xFFBEE3CD))),
            ],
          ),
        ),
      ),
    );
  }
}
