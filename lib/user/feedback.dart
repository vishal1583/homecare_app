import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen(
      {super.key,
      required this.bookingID,
      required this.userID,
      required this.providerID});

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
    if (!mounted) return;
    setState(() {
      ip = prefObj?.getString('ip') ?? 'NO IP';
    });
  }

  Future<void> feedback() async {
    final url = ApiConfig.endpoint(ip, 'feedback.php');

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'booking_id': widget.bookingID,
          'user_id': widget.userID,
          'provider_id': widget.providerID,
          'rating': rating.toString(),
          'comments': commentsController.text,
        },
      );
      if (!mounted) return;

      var jsonBody = jsonDecode(response.body);
      var jsonString = jsonBody['message'];

      if (jsonString == 'success') {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Feedback Submitted Successfully')),
          );
        context.navigator.pop();
        context.navigator.pop();
      } else {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Feedback Submission Failed')),
          );
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
  void dispose() {
    commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: 'Feedback',
      heading: 'How did it go?',
      description:
          'Share your experience to help others choose their next service.',
      icon: Icons.rate_review_outlined,
      formKey: _formKey,
      children: [
        const Text(
          'Rate Your Experience',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: RatingBar.builder(
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
            )),
        const SizedBox(height: 16),
        TextFormField(
          controller: commentsController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Comments',
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
    );
  }
}
