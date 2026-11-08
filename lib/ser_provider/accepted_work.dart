import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/widgets/app_collection_page.dart';
import 'package:flutter_application_7/widgets/booking_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/data_models.dart';

class AcceptedWorkScreen extends StatefulWidget {
  const AcceptedWorkScreen({super.key});

  @override
  State<AcceptedWorkScreen> createState() => _AcceptedWorkScreenState();
}

class _AcceptedWorkScreenState extends State<AcceptedWorkScreen> {
  SharedPreferences? prefObj;
  String ip = '';
  String pId = '';

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  Future<void> loadPref() async {
    prefObj = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP address';
      pId = prefObj?.getString('providerid') ?? 'No provider ID';
    });
  }

  Future<List<Bookings>> fetchMyAcceptedWorks() async {
    final url = ApiConfig.endpoint(ip, 'fetchmyworks.php?pid=$pId');

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Bookings.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load accepted works');
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> markWorkAsCompleted(String bookingId) async {
    final confirmed = await context.confirmAction(
      title: 'Mark booking #$bookingId complete?',
      message:
          'Confirm that the work is finished. The customer can then record their payment.',
      confirmLabel: 'Mark complete',
    );
    if (!confirmed || !mounted) return;

    final url = ApiConfig.endpoint(ip, 'markworkcompleted.php');

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'id': bookingId,
        },
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Work marked as completed!')),
          );
        setState(() {}); // Refresh the list
      } else {
        throw Exception('Failed to update work status');
      }
    } catch (e) {
      if (!mounted) return;
      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCollectionPage<Bookings>(
      title: 'Accepted Work',
      description: 'Your upcoming visits and the work you have taken on.',
      future: fetchMyAcceptedWorks(),
      emptyMessage: 'Accept a booking request to see your next job here.',
      onRetry: () => setState(() {}),
      itemBuilder: (context, booking, index) => BookingCard(
        booking: booking,
        name: booking.name ?? 'Scheduled service',
        actions: [
          ElevatedButton(
              onPressed: () => markWorkAsCompleted(booking.id),
              child: const Text('Mark complete'))
        ],
      ),
    );
  }
}
