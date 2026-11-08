import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/models/data_models.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/widgets/app_collection_page.dart';
import 'package:flutter_application_7/widgets/booking_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewBookingsScreen extends StatefulWidget {
  const ViewBookingsScreen({super.key});

  @override
  State<ViewBookingsScreen> createState() => _ViewBookingsScreenState();
}

class _ViewBookingsScreenState extends State<ViewBookingsScreen> {
  SharedPreferences? prefObj;
  String ip = '';
  String pid = '';

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
      pid = prefObj?.getString('providerid') ?? 'No provider ID';
    });
  }

  Future<List<Bookings>> fetchMyBookings() async {
    final url = ApiConfig.endpoint(ip, 'providerfetchbooking.php?pid=$pid');

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        debugPrint('Fetched ${data.length} provider bookings');

        // Exclude bookings with status 'accepted' or 'rejected'
        return data
            .map((booking) => Bookings.fromJson(booking))
            .where((booking) => booking.status == 'requested')
            .toList();
      } else {
        throw Exception('Failed to load bookings.');
      }
    } catch (e) {
      return [];
    }
  }

  void acceptBooking(String bookingId) async {
    final confirmed = await context.confirmAction(
      title: 'Accept booking #$bookingId?',
      message: 'This request will move to your accepted work.',
      confirmLabel: 'Accept booking',
    );
    if (!confirmed || !mounted) return;

    final url = ApiConfig.endpoint(ip, 'provideraccepted.php');

    var response = await http.post(
      Uri.parse(url),
      body: {
        'status': 'accepted',
        'id': bookingId,
      },
    );
    if (!mounted) return;

    var jsonData = jsonDecode(response.body);
    var jsonString = jsonData['message'];

    if (jsonString == 'success') {
      debugPrint('Booking $bookingId accepted');
      setState(() {}); // Refresh bookings
    } else {
      debugPrint('Booking acceptance failed');
    }
  }

  void rejectBooking(String bookingId) async {
    final confirmed = await context.confirmAction(
      title: 'Reject booking #$bookingId?',
      message:
          'This request will be marked as rejected and removed from your pending requests.',
      confirmLabel: 'Reject booking',
      destructive: true,
    );
    if (!confirmed || !mounted) return;

    final url = ApiConfig.endpoint(ip, 'providerrejected.php');

    var response = await http.post(
      Uri.parse(url),
      body: {
        'status': 'rejected',
        'id': bookingId,
      },
    );
    if (!mounted) return;

    var jsonData = jsonDecode(response.body);
    var jsonString = jsonData['message'];

    if (jsonString == 'success') {
      debugPrint('Booking $bookingId rejected');
      setState(() {}); // Refresh bookings
    } else {
      debugPrint('Booking rejection failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCollectionPage<Bookings>(
      title: 'Booking Requests',
      description: 'A new opportunity to make someone feel more at home.',
      future: fetchMyBookings(),
      emptyMessage: 'New customer requests will appear here. Check back soon.',
      onRetry: () => setState(() {}),
      itemBuilder: (context, booking, index) => BookingCard(
        booking: booking,
        name: booking.name ?? 'No Name',
        actions: [
          if (booking.status == 'requested') ...[
            ElevatedButton(
                onPressed: () => acceptBooking(booking.id),
                child: const Text('Accept')),
            OutlinedButton(
                onPressed: () => rejectBooking(booking.id),
                child: const Text('Reject')),
          ],
        ],
      ),
    );
  }
}
