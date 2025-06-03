import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/components/gradient.dart';
import 'package:fitness/pages/login.dart';
import 'package:fitness/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompleteRegister extends StatefulWidget {
  const CompleteRegister(
      {super.key,
      required this.email,
      required this.password,
      required this.name,
      required this.phone});
  final String email;
  final String password;
  final String name;
  final String phone;

  @override
  State<CompleteRegister> createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String? selectedGender;

  registration() async {
    if (widget.name != "" && widget.email != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: widget.email, password: widget.password);

        // UTILISER L'UID DE FIREBASE AUTH COMME ID
        String userId = userCredential.user!.uid;

        Map<String, dynamic> userInfoMap = {
          "Name": widget.name,
          "Email": widget.email,
          "Phone": widget.phone,
          "weight": _weightController.text,
          "height": _heightController.text,
          "age": _dobController.text,
          "Id": userId, // Utilisez l'UID de Firebase Auth
        };

        await DatabaseMethods().addUserDetails(userInfoMap, userId);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color(0xFF0A1653),
          content: Text(
            "Registered Successfully",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Password Provided is too Weak",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        } // SnackBar
        else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: const Color.fromARGB(255, 216, 160, 160),
            content: Text(
              "Account Already exists",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        } // SnackBar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
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
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 39),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    Image.asset(
                      'images/register.png',
                      width: 399,
                      height: 266,
                    ),

                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Let's complete your profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "It will help us to know more about you!",
                            style: TextStyle(
                              color: Color(0xFF8F8588),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Genre
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration:
                          _inputDecoration(Icons.person, 'Choose Gender'),
                      dropdownColor: const Color(0xFF161818),
                      style: const TextStyle(color: Colors.white),
                      items: ['Male', 'Female'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Date de naissance
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _dobController,
                      readOnly: true,
                      decoration: _inputDecoration(
                          Icons.calendar_month, 'Date of Birth'),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _dobController.text =
                              "${picked.toLocal()}".split(' ')[0];
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Poids
                    Row(
                      children: [
                        // Champ de saisie étirable
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration: _inputDecoration(
                                Icons.monitor_weight, 'Your Weight'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your weight';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(width: (20)),

                        // Image extérieure
                        Image.asset(
                          'images/Kg.png', // ton chemin vers l'image
                          width: 62,
                          height: 62,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Taille
                    Row(
                      children: [
                        // Champ de saisie étirable
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]'))
                            ],
                            decoration:
                                _inputDecoration(Icons.height, 'Your Height'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your height';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(width: (20)),

                        // Image extérieure
                        Image.asset(
                          'images/Cm.png', // ton chemin vers l'image
                          width: 65,
                          height: 65,
                        ),
                      ],
                    ),

                    const SizedBox(height: 52),

                    GradientComponent.gradientButton(
                      text: 'Next   >',
                      maxWidth: 220,
                      maxHeight: 50,
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        registration();
                        // }
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      prefixIcon: Icon(icon, color: Colors.white60),
      filled: true,
      fillColor: const Color(0xFF161818),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  @override
  void dispose() {
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}
