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
