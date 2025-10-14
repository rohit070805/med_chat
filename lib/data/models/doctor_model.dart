import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String uid;
  final String name;
  final String category;
  final String email;
  final int experienceInYears;
  final String about;
  final String qualification;

  Doctor({
    required this.uid,
    required this.name,
    required this.category,
    required this.email,
    required this.experienceInYears,
    required this.about,
    required this.qualification,
  });

  // Factory constructor to create a Doctor from a Firestore document
  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Doctor(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      email: data['email'] ?? '',
      experienceInYears: data['experienceInYears'] ?? 0,
      about: data['about'] ?? '',
      qualification: data['qualification'] ?? '',
    );
  }

  // Method to convert Doctor object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'category': category,
      'email': email,
      'experienceInYears': experienceInYears,
      'about': about,
      'qualification': qualification,
    };
  }
}