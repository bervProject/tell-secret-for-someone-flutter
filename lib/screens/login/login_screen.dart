import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tsfs/endpoint.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Login'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (!value.isValidEmail()) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            // Process data.
                            setState(() {
                              _isLoading = true;
                            });
                            var bodyData = {
                              'strategy': 'local',
                              'email': _emailController.value.text,
                              'password': _passwordController.value.text,
                            };
                            http
                                .post(
                              Endpoint.getAuth(),
                              headers: {
                                HttpHeaders.contentTypeHeader:
                                    'application/json'
                              },
                              body: jsonEncode(bodyData),
                            )
                                .then((response) {
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                print(response.body);
                                var messageResponse = jsonDecode(response.body);
                                print(messageResponse['accessToken']);
                              } else {
                                var messageResponse = jsonDecode(response.body);
                                var messageData = messageResponse['message'];
                                var errorMessage = messageData == null
                                    ? 'Server can\'t be contacted'
                                    : messageData;
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                  ),
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }).catchError((onError) {
                              setState(() {
                                _isLoading = false;
                              });
                              print(onError);
                            });
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
