import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_chat/data/models/doctor_model.dart';
import 'package:med_chat/data/models/patient_model.dart';
import 'package:med_chat/data/services/firestore_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signUpPatient({
    required Patient patientData,
    required String password,
  }) async {
    try {
      print('🔵 Starting signup process...');

      // Step 1: Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: patientData.email,
        password: password,
      );

      print('✅ Auth user created with UID: ${userCredential.user?.uid}');

      if (userCredential.user == null) {
        throw Exception('User creation failed - user is null');
      }

      // Step 2: Get the actual UID
      String uid = userCredential.user!.uid;

      // Step 3: Create patient data map with actual UID
      Map<String, dynamic> patientMap = {
        'uid': uid,
        'email': patientData.email,
        'name': patientData.name,
        'profileImageUrl': patientData.profileImageUrl,
        'age': patientData.age,
        'gender': patientData.gender,
        'height': patientData.height,
        'weight': patientData.weight,
        'bloodGroup': patientData.bloodGroup,
        'contactNumber': patientData.contactNumber,
        'medicalDetails': patientData.medicalDetails,

      };

      print('🔵 Saving to Firestore with UID: $uid');

      // Step 4: Save to Firestore using UID as document ID
      await _firestore.collection('patients').doc(uid).set(patientMap);

      print('✅ Patient data saved to Firestore successfully!');

      return userCredential.user;

    } on FirebaseAuthException catch (e) {
      print('❌ FirebaseAuthException: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak (minimum 6 characters)';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled';
          break;
        default:
          errorMessage = e.message ?? 'Authentication error occurred';
      }

      throw Exception(errorMessage);

    } on FirebaseException catch (e) {
      print('❌ FirebaseException: ${e.code} - ${e.message}');
      throw Exception('Database error: ${e.message}');

    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Signup failed: ${e.toString()}');
    }
  }





  // Sign In
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ${e.message}');
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

