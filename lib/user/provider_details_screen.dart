import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/extensions/string_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/widgets/app_detail_page.dart';
import 'package:flutter_application_7/widgets/date.dart';
import 'package:flutter_application_7/widgets/provider_detail_row.dart';
import 'package:flutter_application_7/widgets/time.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    if (!mounted) return;
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
    return AppDetailPage(
      title: 'Provider Details',
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primarySoft,
                    child: Icon(Icons.person_outline_rounded, size: 32)),
                const SizedBox(height: 20),
                Text(widget.providerName.capitalize(),
                    style: context.theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(widget.providerSkills.capitalize(),
                    style: context.theme.textTheme.bodyLarge),
                const Divider(height: 36),
                ProviderDetailRow(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: widget.providerEmail),
                ProviderDetailRow(
                    icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: widget.providerPhoneNo),
                ProviderDetailRow(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    value: widget.providerLocation),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text('Make time for your home.',
            style: context.theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text(
            'Choose your preferred date and time. Your provider will review the request.'),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Your visit', style: context.theme.textTheme.titleMedium),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    DateScreen(updateSelectedDate: _updateSelectedDate),
                    TimeScreen(updateSelectedTime: _updateSelectedTime),
                  ],
                ),
                const SizedBox(height: 22),
                Text(isServiceBookable()
                    ? 'Your preferred visit: $selectedDate at $selectedTime.'
                    : 'Select both a date and time to request a booking.'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isServiceBookable()
                      ? () => bookMyService(
                          userId, providerId, selectedDate!, selectedTime!)
                      : null,
                  child: const Text('Request booking'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void bookMyService(
      String userId, String providerId, String date, String time) async {
    debugPrint("...Booking Details...");
    debugPrint("User ID: $userId");
    debugPrint("Provider ID: $providerId");
    debugPrint("Selected Date: $date");
    debugPrint("Selected Time: $time");

    final url = ApiConfig.endpoint(ip, 'userbooking.php');

    var response = await http.post(
      Uri.parse(url),
      body: {
        'user_id': userId,
        'provider_id': providerId,
        'date_of_booking': date,
        'time_of_booking': time,
      },
    );
    if (!mounted) return;

    var jsonData = jsonDecode(response.body);
    var jsonString = jsonData['message'];
    debugPrint('BookingScreen jsonMessage: $jsonString');

    if (jsonString == 'success') {
      context.navigator.pop();
      context.navigator.pop();
      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text(
                'Service booked successfully! Please wait for Service Provider to respond')));
    } else {
      context.navigator.pop();
      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Service booking Failed')));
    }
  }
}
