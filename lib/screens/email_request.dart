import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:seller/screens/waiting_screen.dart';
import 'package:seller/services/firebase_services.dart';

class RegisterYourEmail extends StatelessWidget {
  const RegisterYourEmail({Key? key});

  static const String id = 'email-registration';

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'REGISTER YOUR EMAIL',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            const SizedBox(height: 30),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please Enter Your Email';
                }
                return null;
              },
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String enteredEmail = emailController.text.trim();
                if (enteredEmail.isNotEmpty) {
                  EasyLoading.show(status: 'Loading...');
                  await _services.saveEmail(enteredEmail);
                  Navigator.pushNamed(context, WaitingScreen.id);
                  EasyLoading.dismiss();
                  EasyLoading.showSuccess('Your Email has been Sent');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
