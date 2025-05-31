import 'package:fitness/components/gradient.dart';
import 'package:fitness/pages/login.dart';
import 'package:fitness/services/user_service.dart';
import 'package:fitness/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompleteRegister extends StatefulWidget {
  const CompleteRegister({super.key});

  @override
  State<CompleteRegister> createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String? selectedGender;
  final UserService _userService = UserService();


  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }


  Future<void> completeProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }


    if (!_userService.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('No user logged in. Please register again.'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserModel? currentUser = _userService.currentUser;
      
      if (currentUser == null) {
        throw Exception('No current user found');
      }
      
      DateTime birthDate = DateTime.parse(_dobController.text);
      int age = calculateAge(birthDate);


      UserModel updatedUser = UserModel(
        id: currentUser.id,
        name: currentUser.name,
        email: currentUser.email,
        phone: currentUser.phone,
        imageUrl: currentUser.imageUrl,
        age: age,
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        address: currentUser.address,
      );


      await _userService.updateUser(updatedUser);

      setState(() {
        _isLoading = false;
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF0A1653),
          content: Text(
            'Profile completed successfully!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      );

      // Naviguer vers la page de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );

    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error completing profile: ${e.toString()}',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      );
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 39),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    Image.asset(
                      'images/register.png',
                      width: 300,
                      height: 200,
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

                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      decoration: _inputDecoration(Icons.person, 'Choose Gender'),
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
                      validator: null,
                    ),

                    const SizedBox(height: 16),

                    // Date de naissance
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _dobController,
                      readOnly: true,
                      decoration: _inputDecoration(Icons.calendar_month, 'Date of Birth'),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          _dobController.text = "${picked.toLocal()}".split(' ')[0];
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
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                            decoration: _inputDecoration(Icons.monitor_weight, 'Your Weight'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your weight';
                              }
                              double? weight = double.tryParse(value);
                              if (weight == null || weight <= 0) {
                                return 'Please enter a valid weight';
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        const SizedBox(width: (20)),

                        Image.asset(
                          'images/Kg.png',
                          width: 62,
                          height: 62,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Taille
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _heightController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                            decoration: _inputDecoration(Icons.height, 'Your Height'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your height';
                              }
                              double? height = double.tryParse(value);
                              if (height == null || height <= 0) {
                                return 'Please enter a valid height';
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        const SizedBox(width: (20)),

                        Image.asset(
                          'images/Cm.png',
                          width: 65,
                          height: 65,
                        ),
                      ],
                    ),

                    const SizedBox(height: 52),

                    // Bouton Next avec loading
                    _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF983BCB),
                            ),
                          )
                        : GradientComponent.gradientButton(
                            text: 'Next   >',
                            maxWidth: 220,
                            maxHeight: 50,
                            onPressed: completeProfile,
                          ),

                    const SizedBox(height: 16),

                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => Login()),
                    //     );
                    //   },
                    //   child: Text(
                    //     'Skip for now',
                    //     style: TextStyle(
                    //       color: Colors.white60,
                    //       fontSize: 14,
                    //     ),
                    //   ),
                    // ),
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