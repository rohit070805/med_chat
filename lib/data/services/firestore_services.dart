import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_chat/data/models/appointment_model.dart';
import 'package:med_chat/data/models/doctor_model.dart';
import 'package:med_chat/data/models/patient_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection References
  final String _patientsCollection = 'patients';
  final String _doctorsCollection = 'doctors';
  final String _appointmentsSubCollection = 'appointments';




  Future<void> requestAppointment(Appointment appointment) async {
    // ye chudega modify krna hai
    WriteBatch batch = _db.batch();

    // Create a new document reference for the appointment to get a unique ID
    DocumentReference appointmentRef = _db.collection(_patientsCollection)
        .doc(appointment.patientId)
        .collection(_appointmentsSubCollection)
        .doc();

    // 1. Create the appointment in the patient's subcollection
    batch.set(appointmentRef, appointment.toMap());

    // 2. Create the same appointment in the doctor's subcollection
    DocumentReference doctorAppointmentRef = _db.collection(_doctorsCollection)
        .doc(appointment.doctorId)
        .collection(_appointmentsSubCollection)
        .doc(appointmentRef.id); // Use the same ID
    batch.set(doctorAppointmentRef, appointment.toMap());

    // Commit the batch
    await batch.commit();
  }

  // READ operations
  Future<List<Doctor>> getDoctorsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_doctorsCollection)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching doctors by category: $e');
      return [];
    }
  }

  Future<List<Doctor>> getTopDoctors() async {
    // isko change karna hai
    try {
      QuerySnapshot snapshot = await _db
          .collection(_doctorsCollection)
          .orderBy('rating', descending: true)
          .limit(10) // Get the top 10 rated doctors
          .get();
      return snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching top doctors: $e');
      return [];
    }
  }

  // Get upcoming appointments for a patient (real-time stream)
  Stream<List<Appointment>> getUpcomingAppointments(String patientId) {
    // ye bhi change krna hai
    return _db
        .collection(_patientsCollection)
        .doc(patientId)
        .collection(_appointmentsSubCollection)
        .where('status', isEqualTo: 'approved')
        .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.now())
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Appointment.fromFirestore(doc)).toList());
  }


  Stream<List<Appointment>> getPendingAppointments(String patientId) {
    // ye bhi
    return _db
        .collection(_patientsCollection)
        .doc(patientId)
        .collection(_appointmentsSubCollection)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Appointment.fromFirestore(doc)).toList());
  }







  Future<void> withdrawAppointmentRequest(String appointmentId, String patientId, String doctorId) async {
    WriteBatch batch = _db.batch();
    // Delete from patient's subcollection
    DocumentReference patientAppointmentRef = _db.collection(_patientsCollection).doc(patientId).collection(_appointmentsSubCollection).doc(appointmentId);
    batch.delete(patientAppointmentRef);
    // Delete from doctor's subcollection
    DocumentReference doctorAppointmentRef = _db.collection(_doctorsCollection).doc(doctorId).collection(_appointmentsSubCollection).doc(appointmentId);
    batch.delete(doctorAppointmentRef);
    await batch.commit();
  }
}

