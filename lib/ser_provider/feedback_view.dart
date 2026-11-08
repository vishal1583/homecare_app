import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/constants/my_colors.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/widgets/app_collection_page.dart';
import 'package:flutter_application_7/widgets/app_empty_state.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/feedback_model.dart';

export '../models/feedback_model.dart';

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
    if (!mounted) return;
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
      if (!mounted) return;
      setState(() {
        feedbackList = feedback;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<List<FeedbackModel>> getFeedback() async {
    final url = ApiConfig.endpoint(ip, 'fetchfeedback.php?pid=$pid');

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
      appBar: AppBar(title: const Text('Customer Feedback')),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? const AppEmptyState(
                    title: 'Could not load feedback',
                    message: 'Please return to this page and try again.',
                    icon: Icons.wifi_off_outlined)
                : AppCollectionContent<FeedbackModel>(
                    title: 'Words from your customers',
                    description:
                        'See the difference your work makes, one home at a time.',
                    items: feedbackList,
                    emptyMessage:
                        'Customer reviews will appear here after completed bookings.',
                    icon: Icons.rate_review_outlined,
                    itemBuilder: (context, feedback, index) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer #${feedback.userId}',
                                style: context.theme.textTheme.titleMedium),
                            const SizedBox(height: 6),
                            Text('Booking #${feedback.bookingId}',
                                style: context.theme.textTheme.bodySmall),
                            const SizedBox(height: 18),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: RatingBarIndicator(
                                  rating: double.parse(feedback.rating),
                                  itemCount: 5,
                                  itemSize: 22,
                                  itemPadding: const EdgeInsets.only(right: 4),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star_rounded,
                                      color: AppColors.accent)),
                            ),
                            const SizedBox(height: 18),
                            Text(feedback.comments,
                                style: context.theme.textTheme.bodyLarge),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
