// ignore_for_file: unnecessary_null_comparison
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/providers/auth_provider.dart';
import 'package:seller/screens/login_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  late String email;
  late String mobile;
  late String password;
  late String name;
  bool _isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('boyProfilePicture/${_nameController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    //after upload file, file url path to save in firebase

    String downloadUrl = await _storage
        .ref('boyProfilePicture/${_nameController.text}')
        .getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: GlobalStyles.green,
          content: Text(message),
        ),
      );
    }

    setState(() {
      _emailController.text = _authData.email ?? '';
      email = _authData.email ?? '';
    });

    return _isLoading
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              GlobalStyles.green,
            ),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Name';
                      }
                      setState(() {
                        _nameController.text = value;
                      });
                      setState(() {
                        name = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.add_business,
                        color: Colors.grey,
                      ),
                      labelText: 'Your Name',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter  Your Number';
                      }
                      setState(() {
                        mobile = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixText: '+63',
                      prefixIcon: const Icon(
                        Icons.phone_android,
                        color: Colors.grey,
                      ),
                      labelText: 'Mobile Number',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    enabled: false,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      labelText: 'Email Address',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Password';
                      }
                      if (value.length < 6) {
                        return 'Password Should be a Minimum of 6';
                      }
                      setState(() {
                        password = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                      labelText: 'Password',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Your Password';
                      }
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        return "Password doesn't Match";
                      }
                      if (value.length < 6) {
                        return 'Password Should be a Minimum of 6';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: Colors.grey,
                      ),
                      labelText: 'Confirm Password',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    maxLines: 5,
                    controller: _addressController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Provide Your Address';
                      }
                      if (_authData.shopLatitude == null) {
                        return 'Please Provide Your Address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.contact_mail,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.location_searching),
                        onPressed: () {
                          _addressController.text = 'Locating... Please Wait.';
                          _authData.getCurrentAddress().then(
                            (address) {
                              if (address != null) {
                                setState(
                                  () {
                                    _addressController.text =
                                        '${_authData.storePlaceName} \n ${_authData.shopAddress}';
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                      labelText: 'Store Address',
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: GlobalStyles.green,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_authData.image == null) {
                        scaffoldMessage('Please upload your profile picture');
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      _authData
                          .registerRider(email, password)
                          .then((credential) {
                        if (credential != null &&
                            credential.user != null &&
                            credential.user!.uid != null) {
                          uploadFile(_authData.image.path).then((url) {
                            if (url != null) {
                              _authData.saveRiderDataToFirestore(
                                url: url,
                                mobile: mobile,
                                name: name,
                                password: password,
                                context: context,
                              );

                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              scaffoldMessage(
                                  'Failed to upload Raider profile');
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          });
                        } else {
                          scaffoldMessage(_authData.error);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    } else {
                      scaffoldMessage('Please Provide your Profile...');
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(
                        Size(GlobalStyles.screenWidth(context), 40)),
                    backgroundColor: MaterialStatePropertyAll(
                      GlobalStyles.green,
                    ),
                    shape: const MaterialStatePropertyAll(
                      BeveledRectangleBorder(side: BorderSide.none),
                    ),
                  ),
                  child: const Text('Register'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already Have an Account?',
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
