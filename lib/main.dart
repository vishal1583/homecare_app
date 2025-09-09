import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_theme.dart';
import 'package:flutter_application_7/ip_address.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: MyTheme.lightTheme,
      home: const IpAddressScreen(),
    );
  }
}

