import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/components/gradient.dart';
import 'package:fitness/models/User.dart';
import 'package:fitness/pages/bottomnavbar.dart';
import 'package:fitness/pages/register.dart';
import 'package:fitness/services/user_service.dart';
import 'package:fitness/services/database.dart';
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

  final UserService _userService = UserService();
  bool _isLoading = false;

  String email = "", password = "", name = "";
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  userLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        bool initialized = await _userService.initializeUser();
        
        print("Firebase user authenticated: ${firebaseUser.uid}");
        print("Firebase user email: ${firebaseUser.email}");


        print(
            "Tentative de récupération des données pour UID: ${firebaseUser.uid}");
        


        try {
          final userData =
              await DatabaseMethods().getUserDetails(firebaseUser.uid);
          print("Données brutes récupérées: $userData");

          if (userData != null && userData.isNotEmpty) {
            print("Données utilisateur trouvées!");
            print("Clés disponibles: ${userData.keys.toList()}");

            UserModel user = UserModel.fromMap(userData);
            print("UserModel créé: ${user.name}, Email: ${user.email}, ID: ${user.id}");

            await _userService.loginUser(user);
            print("Utilisateur connecté via UserService");


            if (mounted) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Container(
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
                      child: BottomNavBar(),
                    ),
                  ));
            }
          } else {
            print("ERREUR: userData est null ou vide");
            print("userData == null: ${userData == null}");
            if (userData != null) {
              print("userData.isEmpty: ${userData.isEmpty}");
            }

            // Alternative: Essayer d'initialiser l'utilisateur directement
            print("Tentative d'initialisation via UserService...");
            bool initialized = await _userService.initializeUser();

            if (initialized && _userService.isLoggedIn) {
              print("Utilisateur initialisé avec succès via UserService");
              print("Current user: ${_userService.currentUser?.name}");

              if (mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Container(
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
                        child: BottomNavBar(),
                      ),
                    ));
              }
            }
          }
        } catch (e) {
          print("Erreur lors de la récupération des données Firestore: $e");
          print("Type d'erreur: ${e.runtimeType}");

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Erreur de récupération des données: $e",
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Aucun utilisateur trouvé avec cet email";
          break;
        case 'wrong-password':
          errorMessage = "Mot de passe incorrect";
          break;
        case 'invalid-email':
          errorMessage = "Format d'email invalide";
          break;
        case 'user-disabled':
          errorMessage = "Ce compte a été désactivé";
          break;
        case 'too-many-requests':
          errorMessage = "Trop de tentatives. Réessayez plus tard";
          break;
        default:
          errorMessage = "Erreur de connexion: ${e.message}";
      }

      print("Firebase Auth Exception: ${e.code} - ${e.message}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            errorMessage,
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print("Erreur générale lors de la connexion: $e");
      print("Type d'erreur: ${e.runtimeType}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Une erreur inattendue s'est produite: $e",
            style: TextStyle(fontSize: 14.0, color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        width: double.infinity,
        height: double.infinity,
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
                        _isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF983BCB)),
                              )
                            : GradientComponent.gradientButton(
                                text: 'Login',
                                maxWidth: 220,
                                maxHeight: 50,
                                onPressed: () {
                                  if (emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    email = emailController.text.trim();
                                    password = passwordController.text;
                                    userLogin();
                                  }
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

class CustomSocialIcon extends StatelessWidget {
  final Color borderColor;
  final Widget child;

  const CustomSocialIcon({
    Key? key,
    required this.borderColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: child),
    );
  }
}
