import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_chat/data/models/appointment_details_model.dart';
import 'package:med_chat/utils/colors.dart';



class JoinAppointment extends StatelessWidget {
  // Accepts the full appointment details from the previous page
  final AppointmentDetails details;
  const JoinAppointment({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    // Get the scheduled time and the current time
    final scheduledTime = details.appointment.appointmentDate;
    final now = DateTime.now();

    // Helper function to format the time for display
    String formatTime(DateTime time) {
      return DateFormat('MMM d, yyyy \'at\' hh:mm a').format(time);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(details.doctor.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // This is the core logic:
              // 1. Check if the scheduled time is null (as a safeguard)
              if (scheduledTime == null)
                const Text("Appointment time has not been set by the doctor yet.")
              // 2. Check if the current time is BEFORE the scheduled time
              else if (now.isBefore(scheduledTime))
                _buildWaitMessage(formatTime(scheduledTime))
              // 3. Otherwise, the time is now or has passed, so show the join button
              else
                _buildJoinButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for the "Wait" message
  Widget _buildWaitMessage(String formattedTime) {
    return Column(
      children: [
        Icon(Icons.timer_outlined, size: 80, color: Colors.grey.shade400),
        const SizedBox(height: 20),
        const Text(
          "It's not time for your appointment yet.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Please come back at the scheduled time:\n$formattedTime",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildJoinButton(BuildContext context) {
    // Get the current user from Firebase Auth to get their ID
    final user = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        Icon(Icons.video_call, size: 80, color: AppColors.appColor),
        const SizedBox(height: 20),
        const Text(
          "Your appointment is ready!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appColor,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          onPressed: () {
            // 4. Implement the navigation logic

          },
          child: const Text("Join the Meeting", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}