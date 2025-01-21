import 'package:flutter/material.dart';
import 'package:flutter_application_7/select_user.dart';
// import 'package:flutter_application_7/user/feedback.dart';
import 'package:flutter_application_7/user/my_bookings_screen.dart';
import 'package:flutter_application_7/user/available_service_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP Address';
      id = prefObj?.getString('userid') ?? 'No user ID';
      username = prefObj?.getString('username') ?? 'No user name';
    });
  }

  // Log Out
  void logOut(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SelectUserScreen()),
        (route) => false);
    // await user!.clear();
    print('$username(general user) log out');
    print('-----------------------------------------------');
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
                  'Welcome $username',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text('General User',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen1()));
                    },
                  ),
                  DashboardCard(
                    icon: Icons.view_list_rounded,
                    title: 'Available Services',
                    onTapping: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AvailableServiceScreen()));
                    },
                  ),
                  DashboardCard(
                      icon: Icons.book,
                      title: 'My Bookings',
                      onTapping: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyBookingsScreen()));
                      }),
                  // DashboardCard(
                  //     icon: Icons.feedback_rounded,
                  //     title: 'FeedBack',
                  //     onTapping: () {
                  //       Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedbackScreen(bookingID: bookingID, userID: userID)));
                  //     },
                  //   ),
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
}
