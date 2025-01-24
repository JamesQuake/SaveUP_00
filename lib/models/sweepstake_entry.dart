import 'package:cloud_firestore/cloud_firestore.dart';

class SweepstakeEntry {
  final String userId;
  final String fullName;
  final String userEmail;    // Optional user email
  final DateTime optedInAt;
  final DateTime wonAt;
  final bool hasWon;
  final Map<String, dynamic> additionalData; // For any extra data

  SweepstakeEntry({
    this.userId,
    this.fullName,
    this.userEmail,
    this.optedInAt,
    this.wonAt,
    this.hasWon = false,
    this.additionalData,
  });

  factory SweepstakeEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SweepstakeEntry(
      userId: data['userId'] as String,
      fullName: data['fullName'] as String,
      userEmail: data['userEmail'] as String,
      optedInAt: (data['optedInAt'] as Timestamp).toDate(),
      wonAt: data['wonAt'] != null 
          ? (data['wonAt'] as Timestamp).toDate() 
          : null,
      hasWon: data['hasWon'] ?? false,
      additionalData: data['additionalData'] as Map<String, dynamic>,
    );
  }

  factory SweepstakeEntry.fromJson(Map<String, dynamic> json, {String docId}) {
    return SweepstakeEntry(
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      userEmail: json['userEmail'] as String,
      optedInAt: json['optedInAt'] is Timestamp 
          ? (json['optedInAt'] as Timestamp).toDate()
          : DateTime.parse(json['optedInAt'].toString()),
      wonAt: json['wonAt'] != null 
          ? (json['wonAt'] is Timestamp 
              ? (json['wonAt'] as Timestamp).toDate()
              : DateTime.parse(json['wonAt'].toString()))
          : null,
      hasWon: json['hasWon'] ?? false,
      additionalData: json['additionalData'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'userEmail': userEmail,
      'optedInAt': Timestamp.fromDate(optedInAt),
      'wonAt': wonAt != null ? Timestamp.fromDate(wonAt) : null,
      'hasWon': hasWon,
      'additionalData': additionalData,
    };
  }

  // Create a copy of the entry with modified fields
  SweepstakeEntry copyWith({
    String id,
    String userId,
    String fullName,
    String userEmail,
    DateTime optedInAt,
    DateTime wonAt,
    bool hasWon,
    Map<String, dynamic> additionalData,
  }) {
    return SweepstakeEntry(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      userEmail: userEmail ?? this.userEmail,
      optedInAt: optedInAt ?? this.optedInAt,
      wonAt: wonAt ?? this.wonAt,
      hasWon: hasWon ?? this.hasWon,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  String toString() {
    return 'SweepstakeEntry(userId: $userId, fullName: $fullName, optedInAt: $optedInAt, wonAt: $wonAt, hasWon: $hasWon)';
  }
} 