// ignore_for_file: unnecessary_null_comparison, prefer_final_fields
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/auth_provider.dart';
import 'package:seller/screens/email_request.dart';
import 'package:seller/screens/deliveries_screen.dart';
import 'package:seller/screens/registration_screen.dart';
import 'package:seller/services/firebase_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  late Icon icon;
  bool _visible = false;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  late String email = '';
  late String? password;

  @override
  Widget build(BuildContext context) {
    AuthProvider _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                  "lib/images/delivery.png",
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.3), BlendMode.dstATop),
              ),
            ),
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'L',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 40),
                          ),
                          Image.asset(
                            'lib/images/logo.png',
                            height: 40,
                          ),
                          const Text(
                            'GIN',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 40),
                          )
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Delivery App',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Email';
                          }
                          final bool _isValid =
                              EmailValidator.validate(_emailController.text);
                          if (!_isValid) {
                            return 'Invalid Email Address';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // Update email when text changes
                          setState(() {
                            email = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Password';
                          }

                          setState(() {
                            password = value;
                          });
                          return null;
                        },
                        obscureText: !_visible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.vpn_key),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                            icon: _visible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Enter "rider" if not yet registered',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show(status: 'Please Wait...');

                            _services.validateUser(email).then((value) {
                              if (value.exists) {
                                if ((value.data()
                                        as Map<String, dynamic>)['password'] ==
                                    password) {
                                  _authData
                                      .loginRider(email, password)
                                      .then((credential) {
                                    if (credential != null &&
                                        credential.user != null &&
                                        credential.user!.uid != null) {
                                      print('Found');
                                      EasyLoading.showSuccess(
                                          'Logged in Successfully!');
                                      Navigator.pushReplacementNamed(
                                          context, DeliveriesScreen.id);
                                    } else {
                                      EasyLoading.showInfo(
                                              'Need to Complete Registration')
                                          .then((value) {
                                        _authData.getEmail(email);
                                        Navigator.pushNamed(
                                            context, RegistrationScreen.id);
                                      });
                                      print('Not Logged In');
                                    }
                                  });
                                } else {
                                  EasyLoading.showError('Invalid Password');
                                }
                              } else {
                                EasyLoading.showError(
                                    '$email is not registered.');
                              }
                            });
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              Size(GlobalStyles.screenWidth(context), 40)),
                          backgroundColor:
                              MaterialStateProperty.all(GlobalStyles.green),
                          shape: MaterialStateProperty.all(
                              const BeveledRectangleBorder(
                                  side: BorderSide.none)),
                        ),
                        child: const Text('Login'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an Account?",
                            style: TextStyle(color: Colors.black54),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegisterYourEmail.id);
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
