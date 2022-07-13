import 'package:captcha/bottomnav.dart';
import 'package:captcha/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  bool _obscureText2 = true;
  String diffrentPassword = "";

  //email and password firebase
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstPassword = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

//reges pw validator
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        } else if (snapshot.hasData) {
          return const BottomNav(
            index: 0,
          );
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Stack(children: [
                  ClipPath(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 328,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 174, 22, 121),
                              Color.fromARGB(255, 255, 70, 191),
                            ],
                          ),
                        )),
                    clipper: MyCustomClipper(),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 78,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 35,
                          ),
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 46,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 231, 231, 231)),
                            ),
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                        ],
                      ),
                      Image.asset(
                        "assets/images/logo1.png",
                        height: 180,
                        width: 180,
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Theme(
                              data: Theme.of(context).copyWith(
                                primaryColor: Colors.grey,
                              ),
                              child: TextFormField(
                                cursorColor:
                                    const Color.fromARGB(255, 130, 137, 247),
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(37),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(37),
                                      borderSide:
                                          const BorderSide(color: Colors.grey)),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Color.fromARGB(255, 167, 166, 166),
                                  ),
                                  labelText: 'Full Name',
                                  labelStyle: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 167, 166, 166)),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    (value != null && value.isEmpty)
                                        ? 'Field should not be empty'
                                        : null,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor:
                                  const Color.fromARGB(255, 130, 137, 247),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(37),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(37),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  size: 20,
                                  color: Color.fromARGB(255, 167, 166, 166),
                                ),
                                labelText: 'Email address',
                                labelStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 167, 166, 166)),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (email) => email != null &&
                                      !EmailValidator.validate(email)
                                  ? 'Enter a valid email'
                                  : null,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (contact) => contact!.isEmpty
                                  ? "Contact cannot be empty."
                                  : null,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              controller: phoneController,
                              cursorColor:
                                  const Color.fromARGB(255, 130, 137, 247),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(37),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(37),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  size: 19.5,
                                  color: Color.fromARGB(255, 167, 166, 166),
                                ),
                                labelText: 'Phone',
                                labelStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 167, 166, 166)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              obscureText: _obscureText,
                              controller: firstPassword,
                              textInputAction: TextInputAction.next,
                              cursorColor:
                                  const Color.fromARGB(255, 130, 137, 247),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(37),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(37),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                prefixIcon: const Icon(
                                  Icons.security,
                                  size: 19.5,
                                  color: Color.fromARGB(255, 167, 166, 166),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: (() {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  }),
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 23,
                                    color: const Color.fromARGB(
                                        255, 167, 166, 166),
                                  ),
                                ),
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 167, 166, 166)),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) => (value != null &&
                                      !regex.hasMatch(value))
                                  ? '1 uppercase, 1 numeric and 1 special character\nand must have 8 characters'
                                  : null,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                obscureText: _obscureText2,
                                controller: passwordController,
                                cursorColor:
                                    const Color.fromARGB(255, 130, 137, 247),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(37),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(37),
                                      borderSide:
                                          const BorderSide(color: Colors.grey)),
                                  prefixIcon: const Icon(
                                    Icons.security,
                                    size: 19.5,
                                    color: Color.fromARGB(255, 167, 166, 166),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        _obscureText2 = !_obscureText2;
                                      });
                                    }),
                                    child: Icon(
                                      _obscureText2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 23,
                                      color: const Color.fromARGB(
                                          255, 167, 166, 166),
                                    ),
                                  ),
                                  labelText: 'Repeat Password',
                                  labelStyle: const TextStyle(
                                      fontSize: 18,
                                      color:
                                          Color.fromARGB(255, 167, 166, 166)),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    (value != firstPassword.text)
                                        ? ' Password do not match'
                                        : null),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              onPressed: register,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.check,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "SIGN UP",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  fixedSize: const Size(285, 50),
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                  primary:
                                      const Color.fromARGB(255, 253, 253, 253),
                                  onPrimary:
                                      const Color.fromARGB(255, 53, 53, 53)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "Terms of Service",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 190, 189, 189)),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        }
      },
    );
  }

  Future register() async {
    // ignore: unused_local_variable
    User? user = FirebaseAuth.instance.currentUser;
    // var phoneNumber = phoneController.text.trim();

    // ignore: unrelated_type_equality_checks
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(emailController.text.trim().toLowerCase())
          .set({
        'email': emailController.text.trim().toLowerCase(),
        'name': nameController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'role': "user",
        'adminrole': "user",
      });

      Get.snackbar('Irasshaimase!', 'Registered Successfully',
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromARGB(126, 255, 255, 255));
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // email already used
      Get.snackbar('Error Occurred', e.message.toString(),
          duration: const Duration(milliseconds: 2000),
          backgroundColor: const Color.fromARGB(126, 255, 255, 255));
      Get.back();
      navigatorKey.currentState!.popUntil((route) => route.isActive);
    }
  }
}
