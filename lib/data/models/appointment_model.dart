import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final String status; // 'pending', 'approved', 'cancelled'
  final String patientsConcern; // New field for the patient's concern
  final DateTime appointmentDate; // Renamed to clarify as 'data&time'
  final String doctorsMessage; // New field for the doctor's message

  Appointment({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.patientsConcern,
    required this.appointmentDate,
    required this.doctorsMessage,
  });

  // Factory constructor to create an Appointment from a Firestore document
  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Appointment(
      appointmentId: doc.id,
      patientId: data['patientId'] ?? '',
      doctorId: data['doctorId'] ?? '',
      status: data['status'] ?? 'pending',
      patientsConcern: data['patientsConcern'] ?? '',
      appointmentDate: (data['appointmentDate'] as Timestamp).toDate(),
      doctorsMessage: data['doctorsMessage'] ?? '',
    );
  }

  // Method to convert Appointment object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'status': status,
      'patientsConcern': patientsConcern,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'doctorsMessage': doctorsMessage,
    };
  }
}