import 'package:fauth_app/firebaseAuthDemo.dart';
import 'package:fauth_app/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'dart:core';

import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  static String passwordString;


  bool _isSuccess;
  String _userEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _displayName,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (String value) {
                        passwordString = value;
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),

                    TextFormField(
                      controller: _confirmpasswordController,
                      decoration: const InputDecoration(
                          labelText: 'Confirm Password'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }

                        if (value.compareTo(passwordString) != 0) {
                          return 'Passwords does not match .Please try again';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      child: OutlineButton(
                          child: Text("Register"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _registerAccount();
                            }
                          }
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _registerAccount() async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        await user.updateProfile(displayName: _displayName.text);
        final user1 = _auth.currentUser;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                FirebaseAuthDemo(
                  // user: user1,
                )));
      } else {
        _isSuccess = false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}


