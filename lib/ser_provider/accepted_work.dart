import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP address';
      pId = prefObj?.getString('providerid') ?? 'No provider ID';
    });
  }

  Future<List<Bookings>> fetchMyAcceptedWorks() async {
    String url = 'http://$ip/homecare_app/fetchmyworks.php?pid=$pId';

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
    String url = 'http://$ip/homecare_app/markworkcompleted.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'id': bookingId,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Work marked as completed!')),
        );
        setState(() {}); // Refresh the list
      } else {
        throw Exception('Failed to update work status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted Works'),
      ),
      body: FutureBuilder<List<Bookings>>(
        future: fetchMyAcceptedWorks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 50,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No bookings available',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            );
          } else {
            final bookings = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Booking ID: ${booking.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${booking.dateOfBooking}'),
                        Text('Time: ${booking.timeOfBooking}'),
                        Text('Status: ${booking.status}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        markWorkAsCompleted(booking.id);
                      },
                      child: const Text('Complete'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}