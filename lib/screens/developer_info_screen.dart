import 'package:flutter/material.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text("Developer Info"),
        backgroundColor: Colors.black,
        // Custom back button using image
        leading: IconButton(
          icon: Image.asset(
            'assets/icon/arrow.png',
            width: 24,
            height: 24,
            color: Colors.white, // optional tint for dark mode
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/icon/emran.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              "Emran",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Backend & Mobile Developer",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "\"Innovation distinguishes between a leader and a follower.\"",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: Image.asset('assets/icon/email.png', width: 24, height: 24),
              title: const Text("emranahmed2723@gmail.com", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: Image.asset('assets/icon/github.png', width: 24, height: 24),
              title: const Text("github.com/emran-dev", style: TextStyle(color: Colors.white)),
              onTap: () {
                // TODO: launch GitHub URL
              },
            ),
            ListTile(
              leading: Image.asset('assets/icon/linkedin.png', width: 24, height: 24),
              title: const Text("linkedin.com/in/emran-ahmed-548866168/", style: TextStyle(color: Colors.white)),
              onTap: () {
                // TODO: launch LinkedIn URL
              },
            ),
          ],
        ),
      ),
    );
  }
}