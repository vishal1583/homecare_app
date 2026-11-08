import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/extensions/string_extension.dart';
import 'package:flutter_application_7/select_user.dart';
import 'package:flutter_application_7/user/available_service_screen.dart';
import 'package:flutter_application_7/user/my_bookings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dashboard_layout.dart';
import '../widgets/dashboardcard.dart';
import 'profile_screen1.dart';

class DashboardScreen1 extends StatefulWidget {
  const DashboardScreen1({super.key});

  @override
  State<DashboardScreen1> createState() => _DashboardScreen1State();
}

class _DashboardScreen1State extends State<DashboardScreen1> {
  SharedPreferences? prefObj;

  String ip = '';
  String username = '';
  String id = '';

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  // load the essential details from SharedPreferences
  Future<void> _loadPref() async {
    prefObj = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP Address';
      id = prefObj?.getString('userid') ?? 'No user ID';
      username = prefObj?.getString('username') ?? 'No user name';
    });
  }

  // Log Out
  Future<void> logOut(BuildContext context) async {
    final confirmed = await context.confirmAction(
      title: 'Log out of Homecare?',
      message:
          'You will return to the welcome screen and can sign in again anytime.',
      confirmLabel: 'Log out',
    );
    if (!confirmed || !context.mounted) return;

    context.navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SelectUserScreen()),
        (route) => false);
    debugPrint('User logged out: $username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homecare')),
      body: DashboardLayout(
        welcomeText: 'Welcome, ${username.capitalize()}.',
        role: 'General User',
        cards: [
          DashboardCard(
            icon: Icons.view_list_rounded,
            title: 'Available Services',
            onTapping: () {
              context.navigator.push(MaterialPageRoute(
                  builder: (context) => const AvailableServiceScreen()));
            },
          ),
          DashboardCard(
              icon: Icons.book,
              title: 'My Bookings',
              onTapping: () {
                context.navigator.push(MaterialPageRoute(
                    builder: (context) => const MyBookingsScreen()));
              }),
          DashboardCard(
            icon: Icons.person_rounded,
            title: 'My Profile',
            onTapping: () {
              context.navigator.push(MaterialPageRoute(
                  builder: (context) => const ProfileScreen1()));
            },
          ),
          DashboardCard(
            icon: Icons.logout_rounded,
            title: 'Logout',
            onTapping: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }
}
