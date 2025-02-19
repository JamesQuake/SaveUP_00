import 'package:cloud_firestore/cloud_firestore.dart';

class SweepstakeSetup {
  final DateTime entryDeadline;
  final DateTime drawingDate;
  final int requiredRewardsPoints;
  final DateTime updatedAt;
  final bool status;
  final String image;
  final String title;
  final String description;

  SweepstakeSetup({
    this.entryDeadline,
    this.drawingDate,
    this.requiredRewardsPoints,
    this.updatedAt,
    this.status,
    this.image = '',
    this.title = '',
    this.description = '',
  });

  factory SweepstakeSetup.fromFirestore(Map<String, dynamic> data) {
    return SweepstakeSetup(
      entryDeadline: (data['entry_deadline'] as Timestamp).toDate(),
      drawingDate: (data['drawing_date'] as Timestamp).toDate(),
      requiredRewardsPoints: data['required_rewards_points'] ?? 1500,
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      status: data['status'] ?? false,
      image: data['image'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}