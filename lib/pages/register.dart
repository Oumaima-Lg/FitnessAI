import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/components/gradient.dart';
import 'package:fitness/models/User.dart';
import 'package:fitness/pages/login.dart';
import 'package:fitness/services/Auth_service.dart';
import 'package:fitness/services/database.dart';
import 'package:fitness/services/shared_pref.dart';
import 'package:fitness/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness/pages/completeRegister.dart';
import 'package:random_string/random_string.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isLoading = false;

  final UserService _userService = UserService();

  String email = "", password = "", name = "";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signup() async {
    try {
      if (await AuthService().signup(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          phone: phoneController.text)) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const CompleteRegister()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'inscription')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur inattendue: $e')),
      );
    }
  }

  // registration() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     // UserCredential userCredential = await FirebaseAuth.instance
  //     //     .createUserWithEmailAndPassword(email: email, password: password);

  //     String userId = randomAlphaNumeric(10);

  //     UserModel newUser = UserModel(
  //       id: userId,
  //       name: nameController.text.trim(),
  //       email: emailController.text.trim(),
  //       phone: phoneController.text.trim().isNotEmpty
  //           ? phoneController.text.trim()
  //           : null,
  //       imageUrl: null,
  //       age: null,
  //       weight: null,
  //       height: null,
  //       address: null,
  //     );

  //     await _userService.registerUser(newUser);

  //     setState(() {
  //       _isLoading = false;
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Color(0xFF0A1653),
  //       content: Text(
  //         "Registered Successfully",
  //         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
  //       ),
  //     ));

  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => CompleteRegister()),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });

  //     String errorMessage = "";
  //     Color backgroundColor = Colors.red;

  //     switch (e.code) {
  //       case 'weak-password':
  //         errorMessage = "Password Provided is too Weak";
  //         backgroundColor = Colors.orangeAccent;
  //         break;
  //       case 'email-already-in-use':
  //         errorMessage = "Account Already exists";
  //         backgroundColor = const Color.fromARGB(255, 216, 160, 160);
  //         break;
  //       case 'invalid-email':
  //         errorMessage = "Invalid email address";
  //         break;
  //       default:
  //         errorMessage = "Registration failed: ${e.message}";
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: backgroundColor,
  //       content: Text(
  //         errorMessage,
  //         style: TextStyle(fontSize: 18.0),
  //       ),
  //     ));
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text(
  //         "Registration failed: ${e.toString()}",
  //         style: TextStyle(fontSize: 18.0),
  //       ),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        width: double.infinity,
        height: double.infinity,
        /* background degrade : */
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E2F55),
              Color(0xFF23253C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          Text('Hey There,',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                          SizedBox(height: 4),
                          Text(
                            'Create an Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 44),
                        ],
                      )
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextFormField(
                          controller: nameController,
                          hintText: 'Full Name',
                          prefixIcon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Phone Number Field
                        _buildTextFormField(
                          controller: phoneController,
                          hintText: 'Phone Number',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Email Field
                        _buildTextFormField(
                          controller: emailController,
                          hintText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Password Field
                        _buildTextFormField(
                          controller: passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: !_passwordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white60,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 52),

                        // Register Button
                        GradientComponent.gradientButton(
                          text: 'Register',
                          maxWidth: 220,
                          maxHeight: 50,
                          // onPressed: () {
                          //   if (nameController.text != "" &&
                          //       emailController.text != "" &&
                          //       passwordController.text != "") {
                          //     setState(() {
                          //       name = nameController.text;
                          //       email = emailController.text;
                          //       password = passwordController.text;
                          //     });
                          //     // registration();

                          //   }
                          // },
                          onPressed: () async {
                            await signup();
                          },
                        ),
                        SizedBox(height: 16),

                        // ------------ Or --------------- (dividor)
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white24)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Or',
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 14),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white24)),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Social Login Options
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomSocialIcon(
                              borderColor: Color(0xFF423C3D),
                              child: Image.asset('images/google_icon.png',
                                  width: MediaQuery.of(context).size.width),
                            ),
                            const SizedBox(width: 20),
                            CustomSocialIcon(
                              borderColor: Color(0xFF423C3D),
                              child: Image.asset('images/facebook_icon.png',
                                  width: MediaQuery.of(context).size.width),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),

                        SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to login page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFF983BCB),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white38),
        prefixIcon: Icon(prefixIcon, color: Colors.white60),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Color(0xFF161818),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
      ),
      validator: validator,
    );
  }
}

class CustomSocialIcon extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  const CustomSocialIcon({
    super.key,
    required this.child,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: Center(child: child),
    );
  }
}
