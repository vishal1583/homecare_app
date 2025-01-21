import 'package:flutter/material.dart';
import 'package:flutter_application_7/select_user.dart';
import 'package:flutter_application_7/ser_provider/accepted_work.dart';
import 'package:flutter_application_7/ser_provider/view_bookings_screen.dart';
import 'package:flutter_application_7/ser_provider/profile_screen2.dart';
import 'package:flutter_application_7/ser_provider/feedback_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    setState(() {
      providerName = _provider?.getString('providername') ?? 'No Name';
      // print(_provider!.containsKey('providername'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Welcome $providerName !',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text('Service Provider',style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold))
              ],
            ),
            const SizedBox(height: 25),
            Text(
              'Here\'s your dashboard to manage services :',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  DashboardCard(
                    icon: Icons.person_rounded,
                    title: 'My Profile',
                    onTapping: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileScreen2()));
                    },
                  ),
                  DashboardCard(
                    icon: Icons.assignment_rounded,
                    title: 'View Bookings',
                    onTapping: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewBookingsScreen()));
                    },
                  ),
                  DashboardCard(
                    icon: Icons.work_rounded, 
                    title: 'Accepted Work', 
                    onTapping: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AcceptedWorkScreen()));
                    }
                  ),
                  DashboardCard(
                    icon: Icons.feedback_rounded, 
                    title: 'Feedback', 
                    onTapping: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedBackViewScreen()));
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
            ),
          ],
        ),
      ),
    );
  }

  void logOut(BuildContext context) {
    // body
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SelectUserScreen()),
        (route) => false);
    print('$providerName(service provider) log out');
    print('-------------------------------');
  }
}
