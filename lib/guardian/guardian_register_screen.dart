import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/login_screen.dart';
import 'package:women_safety_app/utils/constants.dart';
import '../components/PrimaryButton.dart';
import '../components/SecondaryButton.dart';
import '../components/custom_textfield.dart';
import '../model/user_model.dart';

class RegisterGuardianScreen extends StatefulWidget {
  @override
  State<RegisterGuardianScreen> createState() => _RegisterGuardianScreenState();
}

class _RegisterGuardianScreenState extends State<RegisterGuardianScreen> {
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    _formKey.currentState!.save();
    if (_formData['password'] != _formData['rpassword']) {
      dialogueBox(context, 'password and retype password should be equal');
    } else {
      progressIndicator(context);
      try {
        setState(() {
          isLoading = true;
        });
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _formData['gemail'].toString(),
                password: _formData['password'].toString());
        if (userCredential.user != null) {
          final v = userCredential.user!.uid;
          DocumentReference<Map<String, dynamic>> db =
              FirebaseFirestore.instance.collection('users').doc(v);

          final user = UserModel(
              name: _formData['name'].toString(),
              phone: _formData['phone'].toString(),
              womanEmail: "",
              guardianEmail: _formData['gemail'].toString(),
              id: v,
              guardiansWomenEmails: [
                _formData['cemail'.trim()].toString(),
                _formData['c1email'.trim()].toString(),
                _formData['c2email'.trim()].toString(),
                _formData['c3email'.trim()].toString(),
                _formData['c4email'.trim()].toString()
              ],
              type: 'guardian');
          final jsonData = user.toJson();
          await db.set(jsonData).whenComplete(() {
            goTo(context, LoginScreen());
            setState(() {
              isLoading = false;
            });
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          dialogueBox(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          dialogueBox(context, 'The account already exists for that email.');
        }
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
        });
        dialogueBox(context, e.toString());
      }
    }
    print(_formData['gemail']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "REGISTER AS GUARDIAN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                     SizedBox(height: 10.0,),
                        Image.asset(
                          'assets/logo.png',
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(height: 10.0,),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextField(
                                hintText: 'Enter name',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.name,
                                prefix: Icon(Icons.person),
                                onsave: (name) {
                                  _formData['name'] = name ?? "";
                                },
                                validate: (email) {
                                  if (email!.isEmpty || email.length < 3) {
                                    return 'Enter correct name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10.0,),
                              CustomTextField(
                                hintText: 'Enter phone',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.phone,
                                prefix: Icon(Icons.phone),
                                onsave: (phone) {
                                  _formData['phone'] = phone ?? "";
                                },
                                validate: (email) {
                                  if (email!.isEmpty || email.length < 10) {
                                    return 'Enter correct phone';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10.0,),
                              CustomTextField(
                                hintText: 'Enter your email',
                                textInputAction: TextInputAction.next,
                                keyboardtype: TextInputType.emailAddress,
                                prefix: Icon(Icons.person),
                                onsave: (email) {
                                  _formData['gemail'] = email ?? "";
                                },
                                validate: (email) {
                                  if (email!.isEmpty ||
                                      email.length < 3 ||
                                      !email.contains("@")) {
                                    return 'Enter correct email';
                                  }
                                },
                              ),
                              SizedBox(height: 10.0,),
                              Divider(height: 1,color: Colors.grey,),
                              SizedBox(height: 10.0,),
                              Row(
                                children: [
                                  Column(children: [
                                    SizedBox(width: 25,),
                                  ],),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        CustomTextField(
                                          hintText: 'Enter woman email',
                                          textInputAction: TextInputAction.next,
                                          keyboardtype: TextInputType.emailAddress,
                                          prefix: Icon(Icons.person),
                                          onsave: (cemail) {
                                            _formData['cemail'] = cemail ?? "";
                                          },
                                          validate: (email) {
                                            if (email!.isEmpty ||
                                                email.length < 3 ||
                                                !email.contains("@")) {
                                              return 'Enter correct email';
                                            }
                                          },
                                        ),
                                        SizedBox(height: 10.0,),
                                        CustomTextField(
                                          hintText: 'Enter woman 2 email',
                                          textInputAction: TextInputAction.next,
                                          keyboardtype: TextInputType.emailAddress,
                                          prefix: Icon(Icons.person),
                                          onsave: (c1email) {
                                            _formData['c1email'] = c1email ?? "";
                                          },

                                        ),
                                        SizedBox(height: 10.0,),
                                        CustomTextField(
                                          hintText: 'Enter woman 3 email',
                                          textInputAction: TextInputAction.next,
                                          keyboardtype: TextInputType.emailAddress,
                                          prefix: Icon(Icons.person),
                                          onsave: (c2email) {
                                            _formData['c2email'] = c2email ?? "";
                                          },
                                        ),
                                        SizedBox(height: 10.0,),
                                        CustomTextField(
                                          hintText: 'Enter woman 4 email',
                                          textInputAction: TextInputAction.next,
                                          keyboardtype: TextInputType.emailAddress,
                                          prefix: Icon(Icons.person),
                                          onsave: (c3email) {
                                            _formData['c3email'] = c3email ?? "";
                                          },

                                        ),
                                        SizedBox(height: 10.0,),
                                        CustomTextField(
                                          hintText: 'Enter woman 5 email',
                                          textInputAction: TextInputAction.next,
                                          keyboardtype: TextInputType.emailAddress,
                                          prefix: Icon(Icons.person),
                                          onsave: (c4email) {
                                            _formData['c4email'] = c4email ?? "";
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Divider(height: 1,color: Colors.grey,),
                              SizedBox(height: 10.0,),
                              CustomTextField(
                                hintText: 'Enter password',
                                isPassword: isPasswordShown,
                                prefix: Icon(Icons.vpn_key_rounded),
                                validate: (password) {
                                  if (password!.isEmpty ||
                                      password.length < 7) {
                                    return 'Enter correct password';
                                  }
                                  return null;
                                },
                                onsave: (password) {
                                  _formData['password'] = password ?? "";
                                },
                                suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPasswordShown = !isPasswordShown;
                                      });
                                    },
                                    icon: isPasswordShown
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility)),
                              ),
                              SizedBox(height: 10.0,),
                              CustomTextField(
                                hintText: 'Retype password',
                                isPassword: isRetypePasswordShown,
                                prefix: Icon(Icons.vpn_key_rounded),
                                validate: (password) {
                                  if (password!.isEmpty ||
                                      password.length < 7) {
                                    return 'Enter correct password';
                                  }
                                  return null;
                                },
                                onsave: (password) {
                                  _formData['rpassword'] = password ?? "";
                                },
                                suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isRetypePasswordShown =
                                            !isRetypePasswordShown;
                                      });
                                    },
                                    icon: isRetypePasswordShown
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility)),
                              ),
                              SizedBox(height: 10.0,),
                              PrimaryButton(
                                  title: 'REGISTER',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _onSubmit();
                                    }
                                  }),
                              SizedBox(height: 20.0,),
                              SecondaryButton(
                                  title: 'Login with your account',
                                  onPressed: () {
                                    goTo(context, LoginScreen());
                                  }),
                              SizedBox(height: 40.0,),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
