import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_turkmen_admin/screens/tutorials_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });
  static String routePath = '/login';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  String _errorMessage = '';
  String loggingRequestStatus = 'idle';

  void submitForm() async {
    setState(() {
      _errorMessage = '';
      loggingRequestStatus = 'pending';
    });

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _email, password: _password)
        .then((credential) async {
      bool authorized;
      final currentUser = credential.user;
      if (currentUser == null) {
        authorized = false;
      } else {
        final userData = (await FirebaseFirestore.instance
                .doc('users/${currentUser.uid}')
                .get())
            .data();
        if (userData == null) {
          authorized = false;
        } else {
          authorized = userData['admin'];
        }
      }

      if(authorized && mounted) {
        context.push(TutorialsListScreen.routePath);
      } else {
        setState(() {
          _errorMessage = "You don't have admin permissions";
        });
      }
    }).onError((FirebaseAuthException error, stackTrace) {
      if (error.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'No user found for that email.';
        });
      } else if (error.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Wrong password provided for that user.';
        });
      } else {
        setState(() {
          _errorMessage = 'Something went wrong';
        });
      }
    }).whenComplete(() {
      setState(() {
        loggingRequestStatus = 'idle';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
                image: AssetImage('assets/images/modern-turkmen-logo.png'),
                height: 149),
            SizedBox(
              width: 400.0,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                submitForm();
                              }
                            },
                            decoration: const InputDecoration(
                                hintText: 'Email',
                                icon: Icon(
                                  Icons.mail,
                                )),
                            validator: (value) => value!.isEmpty
                                ? 'Please enter an email address'
                                : null,
                            onSaved: (value) => _email = value!,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                submitForm();
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              icon: Icon(
                                Icons.lock,
                              ),
                            ),
                            obscureText: true,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a password'
                                : null,
                            onSaved: (value) => _password = value!,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                          child: ElevatedButton(
                            child: loggingRequestStatus == 'pending'
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text('Login'),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                submitForm();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
