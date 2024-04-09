import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller/providers/auth_provider.dart';
import 'package:seller/widgets/image_picker.dart';
import 'package:seller/widgets/register_form.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  static const String id = 'registration-screen';

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context);
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ShopPicCard(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: RegisterForm(),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
