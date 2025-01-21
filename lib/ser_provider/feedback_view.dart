import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackModel {
  final String feedbackId;
  final String bookingId;
  final String userId;
  final String providerId;
  final String rating;
  final String comments;

  FeedbackModel({
    required this.feedbackId,
    required this.bookingId,
    required this.userId,
    required this.providerId,
    required this.rating,
    required this.comments,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      feedbackId: json['feedback_id'],
      bookingId: json['booking_id'],
      userId: json['user_id'],
      providerId: json['provider_id'],
      rating: json['rating'],
      comments: json['comments'],
    );
  }
}

class FeedBackViewScreen extends StatefulWidget {
  const FeedBackViewScreen({super.key});

  @override
  State<FeedBackViewScreen> createState() => _FeedBackViewScreenState();
}

class _FeedBackViewScreenState extends State<FeedBackViewScreen> {
  SharedPreferences? prefObj;
  String ip = '';
  String pid = '';
  List<FeedbackModel> feedbackList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  Future<void> loadPref() async {
    prefObj = await SharedPreferences.getInstance();
    setState(() {
      ip = prefObj?.getString('ip')?.trim() ?? 'NO IP';
      pid = prefObj?.getString('providerid')?.trim() ?? 'NO provider ID';
    });

    // Fetch feedback after preferences are loaded
    fetchAndSetFeedback();
  }

  Future<void> fetchAndSetFeedback() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final feedback = await getFeedback();
      setState(() {
        feedbackList = feedback;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<FeedbackModel>> getFeedback() async {
    String url = 'http://$ip/homecare_app/fetchfeedback.php?pid=$pid';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FeedbackModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load feedback');
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work History'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : feedbackList.isEmpty
                  ? const Center(child: Text('No feedback found.'))
                  : ListView.builder(
                      itemCount: feedbackList.length,
                      itemBuilder: (context, index) {
                        final feedback = feedbackList[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text('User ID: ${feedback.userId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RatingBar.builder(
                                  initialRating: double.parse(feedback.rating),
                                  minRating: 1,
                                  itemSize: 24,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                const SizedBox(height: 4),
                                Text(feedback.comments),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
