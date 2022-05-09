import 'package:carapp/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  bool _showPwd = true;
  final pwd = TextEditingController();
  final cnfrmpwd = TextEditingController();
  late bool hasUppercase;
  late bool hasDigits;
  late bool hasLowercase;
  late bool hasSpecialCharacters;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var _userName = '';
  var _userEmail = '';
  var _userPasswrod = '';
  bool right = false;
  bool _showCnfrmPwd = true;


  void password() {
    setState(() {
      _showPwd = !_showPwd;
    });
  }

  void passwordC() {
    setState(() {
      _showCnfrmPwd = !_showCnfrmPwd;
    });
  }

  void validation() {
    hasUppercase = (pwd.text).contains(RegExp(r'[A-Z]'));
    hasDigits = (pwd.text).contains(RegExp(r'[0-9]'));
    hasLowercase = (pwd.text).contains(RegExp(r'[a-z]'));
    hasSpecialCharacters =
        (pwd.text).contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters) {
      setState(() {
        right = true;
      });

      return;
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              elevation: 10,
              content: FittedBox(
                  child: Column(
                children: <Widget>[
                  const Text('  Passwords must have :',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('   1. Atleast one Uppercase letter ',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('    2. Atleast one Lowercase letter ',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('    3. Atleast one Special character',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  const Text('    4. Atleast one number from 0-9!',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              )),
            );
          });
    }
  }

  void saveAll() async {
    UserCredential authResult;
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        setState(() {
          isLoading = true;
        });
        authResult = await _auth.createUserWithEmailAndPassword(
            email: _userEmail, password: _userPasswrod);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'email': _userEmail.trim(),
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const Home(),
            ),
                (route) => false
        );
      } on PlatformException catch (err) {
        var message = 'An error occurred, pelase check your credentials!';

        if (err.message != null) {
          message = err.message!;
        }
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: const Text("Oops something went wrong"),
                  content: FittedBox(
                      child: Column(children: <Widget>[
                    Text(err.message == null
                        ? "sorry for incovinience"
                        : message),
                    IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ])));
            });

        setState(() {
          isLoading = false;
        });
        debugPrint(err.message);
      } catch (err) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: const Text("Oops something went wrong"),
                  content: FittedBox(
                      child: Column(children: <Widget>[
                    const Text("sorry for incovinience"),
                    IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ])));
            });

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.all(25),
            color: Colors.white70,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                    TextFormField(
                      initialValue: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email*',
                           prefixIcon: Icon(Icons.email,color: Colors.black,),
                         
                          ),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid Email.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _userEmail = value;
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        _userEmail = value!;
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      controller: pwd,
                      
                      decoration: InputDecoration(
                          labelText: 'Password*',
                           prefixIcon: const Icon(Icons.lock,color: Colors.black,),
                          suffixIcon: IconButton(
                            icon: _showPwd
                                ? const Icon(Icons.visibility_off,
                                    color: Colors.black)
                                : const Icon(Icons.visibility, color: Colors.black),
                            onPressed: () => password(),
                          )),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      obscureText: _showPwd,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _userPasswrod = value;
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        _userPasswrod = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      controller: cnfrmpwd,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password*',
                          prefixIcon: const Icon(Icons.lock,color: Colors.black,),
                          suffixIcon: IconButton(
                            icon: _showCnfrmPwd
                                ? const Icon(Icons.visibility_off,
                                    color: Colors.black)
                                : const Icon(Icons.visibility, color: Colors.black),
                            onPressed: () => passwordC(),
                          )),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      obscureText: _showCnfrmPwd,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (value != pwd.text) {
                          return 'Passwrods do not match!';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        isLoading
                            ? Container(
                                child: const CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                ),
                                alignment: Alignment.center,
                              )
                            : Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black),
                                    child: TextButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        _formKey.currentState!.validate()
                                            ? validation()
                                            : debugPrint('');

                                        right ? saveAll() : debugPrint('');
                                      },
                                      child: Column(
                                        children: const <Widget>[
                                          Text('Sign Up',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}