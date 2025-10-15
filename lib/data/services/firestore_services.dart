import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_chat/data/models/appointment_model.dart';
import 'package:med_chat/data/models/doctor_model.dart';
import 'package:med_chat/data/models/patient_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection References
  final String _patientsCollection = 'patients';
  final String _doctorsCollection = 'doctors';
  final String _appointmentsSubCollection = 'appointments';

  Future<void> createAppointment(Appointment appointment) async {
    try {
      // Use the appointmentId from the model as the document ID
      final docRef = _db.collection('appointments').doc(appointment.appointmentId);

      // Use the model's toMap() method which now includes the ID
      await docRef.set(appointment.toMap());

      print("Appointment request created successfully with ID: ${appointment.appointmentId}");

    } catch (e) {
      print("Error creating appointment: $e");
      throw e;
    }
  }
  Future<Doctor?> getDoctorById(String uid) async {
    try {
      final doc = await _db.collection(_doctorsCollection).doc(uid).get();
      if (doc.exists) {
        return Doctor.fromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching doctor by ID: $e');
    }
    return null; // Return null if not found or if an error occurs
  }

  Future<void> updatePatientDetails(String uid,
      Map<String, dynamic> dataToUpdate) async {
    try {
      await _db.collection(_patientsCollection).doc(uid).update(dataToUpdate);
      print("Patient details updated successfully!");
    } catch (e) {
      print("Error updating patient details: $e");
      throw e; // Re-throw the error to handle it in the UI
    }
  }

  // GET operations for the current patient
  Future<Patient?> getCurrentPatient() async {
    // Get the current user from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If no user is logged in, return null
      return null;
    }

    try {
      // Fetch the document from the 'patients' collection using the user's UID
      final doc = await _db.collection(_patientsCollection).doc(user.uid).get();
      if (doc.exists) {
        // If the document exists, convert it to a Patient object and return it
        return Patient.fromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching current patient: $e');
    }
    // Return null if user document doesn't exist or an error occurs
    return null;
  }


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

  // 2. NEW METHOD: Get the count of doctors for a given category
  Future<int> getDoctorCountByCategory(String category) async {
    try {
      // Use an aggregate query to efficiently get the count from Firestore
      final countQuery = _db.collection(_doctorsCollection).where(
          'category', isEqualTo: category);
      final snapshot = await countQuery.count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      print('Error getting doctor count for category $category: $e');
      return 0;
    }
  }

  Future<List<Doctor>> getAlllDoctors() async {
    try {
      // The .limit(10) has been removed from this query
      QuerySnapshot snapshot = await _db
          .collection(_doctorsCollection)
          .get();

      return snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching all doctors: $e');
      return [];
    }
  }

  Future<List<Doctor>> getAllDoctors() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(_doctorsCollection)
          .limit(10) // Limit the result to 10 doctors
          .get();
      // Map each document to a Doctor object and return the list
      return snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching all doctors: $e');
      return []; // Return an empty list in case of an error
    }
  }
}









