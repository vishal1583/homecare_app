import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/models/data_models.dart';
import 'package:flutter_application_7/user/feedback.dart';
import 'package:flutter_application_7/user/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants/my_theme.dart';

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
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP';
      userid = prefObj?.getString('userid') ?? 'No user ID';
    });
    print(userid);
  }

  Future<List<Bookings>> getUserBookings() async {
    String url = 'http://$ip/homecare_app/usermybookings.php?uid=$userid';

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((booking) => Bookings.fromJson(booking)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      return [];
    }
  }

// requested, accepted, rejected,completed,paid 
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
      return Colors.cyan; // Represents a financial transaction successfully made.
    default:
      return Colors.grey; // Fallback for unknown statuses.
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: FutureBuilder<List<Bookings>>(
        future: getUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings available'));
          }
          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final myBookings = bookings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: vanillaShade,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Booking ID: ${myBookings.id}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyTheme.lightTheme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          Icon(
                            Icons.access_time,
                            color: getStatusColor(myBookings.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${myBookings.dateOfBooking}',
                        style: TextStyle(
                          color: MyTheme.lightTheme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Time: ${myBookings.timeOfBooking}',
                        style: TextStyle(
                          color: MyTheme.lightTheme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Provider ID: ${myBookings.providerId}',
                        style: TextStyle(
                          color: MyTheme.lightTheme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your userID: ${myBookings.userId}',
                        style: TextStyle(
                          color: MyTheme.lightTheme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Text(
                            'Booking Status: ',
                            style: TextStyle(
                              color: MyTheme.lightTheme.textTheme.bodySmall?.color,
                            ),
                          ),
                          Text(
                            myBookings.status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getStatusColor(myBookings.status),
                            ),
                          ),
                          if(myBookings.status == 'paid')
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded,color: Colors.cyan,),
                              const SizedBox(width: 145),
                              ElevatedButton(onPressed: (){
                                
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedbackScreen(bookingID: myBookings.id, userID: myBookings.userId,providerID: myBookings.providerId,)));
                              }, child: const Text('Feedback'))
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      if(myBookings.status == 'completed')
                      ElevatedButton(
                        onPressed: (){
                          // Payment
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentScreen(bookingID: myBookings.id)));
                        }, 
                        child: const Text('Make Payment'),
                        ),
                      
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
