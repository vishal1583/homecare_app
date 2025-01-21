import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/widgets/date.dart';
import 'package:flutter_application_7/widgets/time.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProviderDetailsScreen extends StatefulWidget {
  const ProviderDetailsScreen({
    super.key,
    required this.providerName,
    required this.providerEmail,
    required this.providerPhoneNo,
    required this.providerLocation,
    required this.providerSkills,
  });

  final String providerName;
  final String providerEmail;
  final String providerPhoneNo;
  final String providerLocation;
  final String providerSkills;

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen> {
  SharedPreferences? _prefObj;
  String ip = '';
  String userId = '';
  String providerId = '';
  String? selectedDate;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  // Load the IP address
  Future<void> _loadDetails() async {
    _prefObj = await SharedPreferences.getInstance();
    setState(() {
      ip = _prefObj?.getString('ip') ?? 'No IP';
      userId = _prefObj?.getString('userid') ?? 'no user id';
      providerId = _prefObj?.getString('providerid') ?? 'no provider id';
    });
  }

  // Update selected date and time
  void _updateSelectedDate(String date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _updateSelectedTime(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  bool isServiceBookable() => selectedDate != null && selectedTime != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            color: vanillaShade,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: softBlue,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMyCard(
                    icon: Icons.person,
                    title: 'Name',
                    value: widget.providerName,
                  ),
                  _buildMyCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: widget.providerEmail,
                  ),
                  _buildMyCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    value: widget.providerPhoneNo,
                  ),
                  _buildMyCard(
                    icon: Icons.location_on,
                    title: 'Location',
                    value: widget.providerLocation,
                  ),
                  _buildMyCard(
                    icon: Icons.build,
                    title: 'Skills',
                    value: widget.providerSkills,
                  ),
                  // const SizedBox(height: 2),

                  // Pass the callback to update selected date
                  // Pass the callback to update selected time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DateScreen(updateSelectedDate: _updateSelectedDate),
                      const SizedBox(width: 25),
                      TimeScreen(updateSelectedTime: _updateSelectedTime),
                    ],
                  ),


                  const SizedBox(height: 20),
                  Text(
                    selectedDate != null
                        ? "Selected Date: $selectedDate"
                        : "Please select your date",
                    style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  Text(
                    selectedTime != null
                        ? "Selected Time: $selectedTime"
                        : "Please select your time",
                    style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // Book Service button
                  Center(
                    child: ElevatedButton(
                      onPressed: isServiceBookable()
                        ? () {
                            bookMyService(
                              userId,
                              providerId,
                              selectedDate!,
                              selectedTime!,
                            );
                          }
                        : null,               //disable button
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isServiceBookable() ? accentOrange : Colors.grey.shade100,
                      ),
                      child: const Text(
                        'Book Service',
                        // style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white,fontWeight: FontWeight.bold)
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void bookMyService(String userId, String providerId, String date, String time)async 
  {
    print("...Booking Details...");
    print("User ID: $userId");
    print("Provider ID: $providerId");
    print("Selected Date: $date");
    print("Selected Time: $time");

    String url = 'http://$ip/homecare_app/userbooking.php';

    var response = await http.post(
      Uri.parse(url),
      body: {
        'user_id': userId,
        'provider_id': providerId,
        'date_of_booking': date,
        'time_of_booking': time,
        // 'status': '',
      },
    );

    var jsonData = jsonDecode(response.body);
    var jsonString = jsonData['message'];
    print('BookingScreen jsonMessage: $jsonString');

    if (jsonString == 'success') {
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service booked successfully! Please wait for Service Provider to respond')));
    }else{
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service booking Failed')));
    }
  }

  Widget _buildMyCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
