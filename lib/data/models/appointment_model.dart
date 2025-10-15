import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final String status;
  final String patientsConcern;
  final DateTime? appointmentDate; // This should be nullable
  final String doctorsMessage;

  Appointment({
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.patientsConcern,
    this.appointmentDate, // Not required
    required this.doctorsMessage,
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Appointment(
      appointmentId: data['appointmentId'] ?? doc.id,
      patientId: data['patientId'] ?? '',
      doctorId: data['doctorId'] ?? '',
      status: data['status'] ?? 'pending',
      patientsConcern: data['patientsConcern'] ?? '',
      // **FIX 1:** Safely handle a null date from Firestore
      appointmentDate: (data['appointmentDate'] as Timestamp?)?.toDate(),
      doctorsMessage: data['doctorsMessage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'doctorId': doctorId,
      'status': status,
      'patientsConcern': patientsConcern,
      // **FIX 2:** Safely handle a null date when writing to Firestore
      'appointmentDate': appointmentDate != null ? Timestamp.fromDate(appointmentDate!) : null,
      'doctorsMessage': doctorsMessage,
    };
  }
}