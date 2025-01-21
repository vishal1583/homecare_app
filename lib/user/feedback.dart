import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key, required this.bookingID, required this.userID, required this.providerID});

  final String bookingID;
  final String userID;
  final String providerID;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController commentsController = TextEditingController();
  double rating = 0;
  SharedPreferences? prefObj;
  String ip = '';

  Future<void> loadPref() async {
    prefObj = await SharedPreferences.getInstance();
    setState(() {
      ip = prefObj?.getString('ip') ?? 'NO IP';
    });
  }

  Future<void> feedback() async {
    String url = 'http://$ip/homecare_app/feedback.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'booking_id': widget.bookingID,
          'user_id': widget.userID,
          'provider_id' : widget.providerID,
          'rating': rating.toString(),
          'comments': commentsController.text,
        },
      );

      var jsonBody = jsonDecode(response.body);
      var jsonString = jsonBody['message'];

      if (jsonString == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback Submitted Successfully')),
        );
        Navigator.pop(context);
        Navigator.pop(context);
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback Submission Failed')),
        );
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
        
        title: const Text('Feedback'),
        // actions: [
        //   const SizedBox(width: 10),
        //   ElevatedButton(
        //     onPressed: (){
        //       Navigator.pop(context);
        //       Navigator.pop(context);
        //   }, child: const Text('Skip'),
        //   ),
        //   const SizedBox(width: 10),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rate Your Experience',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: rating,
                minRating: 0,
                maxRating: 5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, s) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: commentsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Comments',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid value';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      feedback();
                    }
                  },
                  child: const Text('Submit Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
