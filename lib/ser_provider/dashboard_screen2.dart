import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/extensions/string_extension.dart';
import 'package:flutter_application_7/select_user.dart';
import 'package:flutter_application_7/ser_provider/accepted_work.dart';
import 'package:flutter_application_7/ser_provider/feedback_view.dart';
import 'package:flutter_application_7/ser_provider/profile_screen2.dart';
import 'package:flutter_application_7/ser_provider/view_bookings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/dashboard_layout.dart';
import '../widgets/dashboardcard.dart';

class DashboardScreen2 extends StatefulWidget {
  const DashboardScreen2({super.key});

  @override
  State<DashboardScreen2> createState() => _DashboardScreen2State();
}

class _DashboardScreen2State extends State<DashboardScreen2> {
  SharedPreferences? _provider;
  String ip = '';
  String providerName = '';

  @override
  void initState() {
    super.initState();
    _loadProviderName();
    _loadPref();
  }

  // load the IP address
  Future<void> _loadPref() async {
    setState(() {
      ip = _provider?.getString('ip') ?? 'No IP Address';
    });
  }

  // load provider details
  Future<void> _loadProviderName() async {
    _provider = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      providerName = _provider?.getString('providername') ?? 'No Name';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homecare')),
      body: DashboardLayout(
        welcomeText: 'Welcome, ${providerName.capitalize()}.',
        role: 'Service Provider',
        cards: [
          DashboardCard(
            icon: Icons.assignment_rounded,
            title: 'View Bookings',
            onTapping: () {
              context.navigator.push(MaterialPageRoute(
                  builder: (context) => const ViewBookingsScreen()));
            },
          ),
          DashboardCard(
              icon: Icons.work_rounded,
              title: 'Accepted Work',
              onTapping: () {
                context.navigator.push(MaterialPageRoute(
                    builder: (context) => const AcceptedWorkScreen()));
              }),
          DashboardCard(
            icon: Icons.feedback_rounded,
            title: 'Feedback',
            onTapping: () {
              context.navigator.push(MaterialPageRoute(
                  builder: (context) => const FeedBackViewScreen()));
            },
          ),
          DashboardCard(
            icon: Icons.person_rounded,
            title: 'My Profile',
            onTapping: () {
              context.navigator.push(MaterialPageRoute(
                  builder: (context) => const ProfileScreen2()));
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
    debugPrint('Provider logged out: $providerName');
  }
}
