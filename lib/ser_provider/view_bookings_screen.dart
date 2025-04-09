import 'dart:convert';
import 'package:dart_casing/dart_casing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/models/data_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP';
      pid = prefObj?.getString('providerid') ?? 'No provider ID';
    });
  }

  Future<List<Bookings>> fetchMyBookings() async {
    String url = 'http://$ip/homecare_app/providerfetchbooking.php?pid=$pid';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data);

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
    String url = 'http://$ip/homecare_app/provideraccepted.php';

    var response = await http.post(
      Uri.parse(url),
      body: {
        'status': 'accepted',
        'id': bookingId,
      },
    );

    var jsonData = jsonDecode(response.body);
    var jsonString = jsonData['message'];

    if (jsonString == 'success') {
      print('Booking $bookingId accepted');
      setState(() {}); // Refresh bookings
    } else {
      print('Booking acceptance failed');
    }
  }

  void rejectBooking(String bookingId) async {
    String url = 'http://$ip/homecare_app/providerrejected.php';

    var response = await http.post(
      Uri.parse(url),
      body: {
        'status': 'rejected',
        'id': bookingId,
      },
    );

    var jsonData = jsonDecode(response.body);
    var jsonString = jsonData['message'];

    if (jsonString == 'success') {
      print('Booking $bookingId rejected');
      setState(() {}); // Refresh bookings
    } else {
      print('Booking rejection failed');
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
       case 'accepted':
      return Colors.green; // Represents a positive state.
    case 'rejected':
      return Colors.red; // Represents a negative state.
    case 'requested':
      return Colors.orange; // Represents a pending or intermediate state.
    case 'completed':
      return Colors.blue; // Represents a task successfully finished.
    case 'paid':
      return Colors.teal; // Represents a financial transaction successfully made.
    default:
      return Colors.grey; // Fallback for unknown statuses.
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Bookings'),
      ),
      body: FutureBuilder<List<Bookings>>(
        future: fetchMyBookings(),
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
          } else {                              // snapshot has data
            final bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final providerbookings = bookings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Booking ID: ${providerbookings.id}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          'Customer Name: ${Casing.pascalCase(providerbookings.name ?? 'No Name')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        // Text(
                        //   'Provider ID: ${providerbookings.providerId}',
                        //   style: const TextStyle(fontSize: 16),
                        // ),
                        Text(
                          'Date: ${providerbookings.dateOfBooking}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Time: ${providerbookings.timeOfBooking}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              Casing.pascalCase(providerbookings.status),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: getStatusColor(providerbookings.status),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        providerbookings.status == 'requested'
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      acceptBooking(providerbookings.id);
                                    },
                                    child: const Text('Accept'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      rejectBooking(providerbookings.id);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Reject'),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
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
