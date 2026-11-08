import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/models/data_models.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/user/feedback.dart';
import 'package:flutter_application_7/user/payment_screen.dart';
import 'package:flutter_application_7/widgets/app_collection_page.dart';
import 'package:flutter_application_7/widgets/booking_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  SharedPreferences? prefObj;
  String ip = '';
  String userid = '';

  @override
  void initState() {
    super.initState();

    loadDetails();
  }

  Future<void> loadDetails() async {
    prefObj = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP';
      userid = prefObj?.getString('userid') ?? 'No user ID';
    });
    debugPrint('Loading bookings for user: $userid');
  }

  // view bookings
  Future<List<Bookings>> getUserBookings() async {
    final url = ApiConfig.endpoint(ip, 'usermybookings.php?uid=$userid');

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('Fetched ${data.length} user bookings');
        return data.map((booking) => Bookings.fromJson(booking)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      return [];
    }
  }

// requested, accepted, rejected,completed,paid
  @override
  Widget build(BuildContext context) {
    return AppCollectionPage<Bookings>(
      title: 'My Bookings',
      description:
          'Every visit, from the first request to the finishing touch.',
      future: getUserBookings(),
      emptyMessage:
          'Your bookings will appear here once you request a service.',
      onRetry: () => setState(() {}),
      itemBuilder: (context, booking, index) => BookingCard(
        booking: booking,
        name: booking.name ?? 'No Name',
        actions: [
          if (booking.status == 'paid')
            OutlinedButton(
              onPressed: () => context.navigator.push(MaterialPageRoute(
                  builder: (context) => FeedbackScreen(
                      bookingID: booking.id,
                      userID: booking.userId,
                      providerID: booking.providerId))),
              child: const Text('Leave feedback'),
            ),
          if (booking.status == 'completed')
            ElevatedButton(
              onPressed: () => context.navigator.push(MaterialPageRoute(
                  builder: (context) => PaymentScreen(bookingID: booking.id))),
              child: const Text('Make Payment'),
            ),
        ],
      ),
    );
  }
}
