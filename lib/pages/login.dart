import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/components/gradient.dart';
import 'package:fitness/pages/bottomnavbar.dart';
import 'package:fitness/pages/register.dart';
import 'package:fitness/services/Auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  AuthService _authService = AuthService();

  String email = "", password = "", name = "";
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

   Future<void> _userLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await _authService.signInWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );
        
        if (user != null) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => BottomNavBar()
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
    // try {
    //   await FirebaseAuth.instance
    //       .signInWithEmailAndPassword(email: email, password: password);
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => Container(
    //           decoration: BoxDecoration(
    //             gradient: LinearGradient(
    //               colors: [
    //                 Color(0xFF2E2F55),
    //                 Color(0xFF23253C),
    //               ],
    //               begin: Alignment.topLeft,
    //               end: Alignment.bottomRight,
    //             ),
    //           ),
    //           child: BottomNavBar(),
    //         ),
    //       ));
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(
    //         "No user Found for that Email",
    //         style: TextStyle(fontSize: 18.0, color: Colors.black),
    //       ),
    //     ));
    //   } else if (e.code == 'wrong-password') {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text(
    //         "Wrong Password Provided by User",
    //         style: TextStyle(fontSize: 18.0, color: Colors.black),
    //       ),
    //     ));
    //   }
    // }
  }

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
                            'Welcome Back',
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

                        // Login Button
                        GradientComponent.gradientButton(
                          text: 'Login',
                          maxWidth: 220,
                          maxHeight: 50,
                          onPressed: () {
                            setState(() {
                              if (emailController.text != "" &&
                                  passwordController.text != "") {
                                email = emailController.text;
                                password = passwordController.text;
                                _userLogin();
                              }
                            });
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
                              borderColor: Colors.white24,
                              child: Image.asset('images/google_icon.png',
                                  width: MediaQuery.of(context).size.width),
                            ),
                            const SizedBox(width: 20),
                            CustomSocialIcon(
                              borderColor: Colors.white24,
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
                              'Don\'t have an account yet? ',
                              style: TextStyle(color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                              },
                              child: Text(
                                'Register',
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
