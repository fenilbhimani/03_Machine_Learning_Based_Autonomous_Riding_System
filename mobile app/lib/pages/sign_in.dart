import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './sign_up.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  static const routeName = 'SignIN';

  SignIn({Key? key}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  bool _showPwd = true;
  final pwd = TextEditingController();
  late bool hasUppercase;
  late bool hasDigits;
  late bool hasLowercase;
  late bool hasSpecialCharacters;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var _userEmail = '';
  var _userPasswrod = '';

  void password() {
    setState(() {
      _showPwd = !_showPwd;
    });
  }

  void validation() {
    hasUppercase = (pwd.text).contains(RegExp(r'[A-Z]'));
    hasDigits = (pwd.text).contains(RegExp(r'[0-9]'));
    hasLowercase = (pwd.text).contains(RegExp(r'[a-z]'));
    hasSpecialCharacters =
        (pwd.text).contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    if (hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters) {
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

  void save() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        await _auth.signInWithEmailAndPassword(
            email: _userEmail.trim(), password: _userPasswrod.trim());

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(),
            ),
                (route) => false
        );
      } on PlatformException catch (err) {
        var message = 'An error occurred, please check your credentials!';
        if (err.message != null) {
          message = err.message!;
        }
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: const Text("Oops something went wrong"),
                  content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: Column(children: <Widget>[
                        Text(
                          err.message == null
                              ? "sorry for incovinience"
                              : message,
                          style: const TextStyle(fontSize: 15),
                        ),
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
      } catch (err) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: const Text("Oops something went wrong"),
                  content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.20,
                      child: Column(children: <Widget>[
                        const Text(
                          "sorry for incovinience",
                          style: TextStyle(fontSize: 15),
                        ),
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
                      height: MediaQuery.of(context).size.height * 0.16,
                    ),
                    const Center(
                        child: Text('Login to your account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                    ),
                    TextFormField(
                      initialValue: null,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Colors.black)),
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        _userEmail = value;
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        _userEmail = value!.trim();
                      },
                    ),
                    TextFormField(
                      initialValue: null,
                      controller: pwd,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock,color: Colors.black,),
                          suffixIcon: IconButton(
                            icon: _showPwd
                                ? const Icon(Icons.visibility_off,color: Colors.black,)
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
                        FocusScope.of(context).unfocus();

                        _userPasswrod = value.trim();
                      },
                      onSaved: (value) {
                        _userPasswrod = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                                child: TextButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    save();
                                  },
                                  child: Column(
                                    children: const <Widget>[
                                      Text('Log In',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white)),
                                      SizedBox(height: 3),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),

                      child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => const SignUp()));
                        },
                        child: Column(
                          children: const <Widget>[
                            Text('New user?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            SizedBox(width: 5),
                            Text(
                              'Create a new account.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
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
