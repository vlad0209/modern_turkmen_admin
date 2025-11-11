import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../view_model/login_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  String _errorMessage = '';
  Future<void>? _pendingLogin;

  void submitForm() async {
    try {
      final future = ref.read(loginViewModelProvider.notifier).login(
            email: _email,
            password: _password,
          );
      setState(() {
        _errorMessage = '';
        _pendingLogin = future;
      });
      await future;
      if (mounted) {
        context.go('/tutorials');
      }
    } on Exception catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    }
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
                          child: FutureBuilder(
                              future: _pendingLogin,
                              builder: (context, asyncSnapshot) {
                                return ElevatedButton(
                                  child: asyncSnapshot.connectionState ==
                                          ConnectionState.waiting
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
                                );
                              }),
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
