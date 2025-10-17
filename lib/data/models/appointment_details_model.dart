import 'package:med_chat/data/models/appointment_model.dart';
import 'package:med_chat/data/models/doctor_model.dart';

// A helper class to combine appointment and doctor data for the UI
class AppointmentDetails {
  final Appointment appointment;
  final Doctor doctor;

  AppointmentDetails({
    required this.appointment,
    required this.doctor,
  });
}