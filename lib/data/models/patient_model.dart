import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String uid;
  final String email;
  final String name;
  final String? profileImageUrl;
  final int? age;
  final String? gender;
  final double? height;
  final double? weight;
  final String? bloodGroup;
  final String? contactNumber;
  final String? medicalDetails;

  Patient({
    required this.uid,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.bloodGroup,
    this.contactNumber,
    this.medicalDetails,
  });

  // Factory constructor to create a Patient from Firestore
  factory Patient.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Patient(
      uid: data['uid'] ?? doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      age: data['age'],
      gender: data['gender'],
      height: (data['height'] as num?)?.toDouble(),
      weight: (data['weight'] as num?)?.toDouble(),
      bloodGroup: data['bloodGroup'],
      contactNumber: data['contactNumber'],
      medicalDetails: data['medicalDetails'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bloodGroup': bloodGroup,
      'contactNumber': contactNumber,
      'medicalDetails': medicalDetails,
    };
  }
}
