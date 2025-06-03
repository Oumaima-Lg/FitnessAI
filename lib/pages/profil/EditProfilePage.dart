import 'package:fitness/components/gradient.dart';
import 'package:fitness/pages/bottomnavbar.dart';
import 'package:fitness/pages/profile.dart';
import 'package:fitness/services/database.dart';
import 'package:fitness/services/shared_pref.dart';
import 'package:flutter/material.dart';
import '../../components/textStyle/textstyle.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {super.key,
      required this.name,
      required this.email,
      required this.phone,
      required this.weight,
      required this.height});

  final String name;
  final String email;
  final String phone;
  final String weight;
  final String height;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  // final String _initialName = "Melissa Peters";
  // final String _initialEmail = "melpeters@gmail.com";
  // final String _initialPassword = "**********";
  // final String _initialPhone = "06726272733";
  // final String _initialDob = "23/05/1995";

  // String _birthDate = "23/05/1995";
  // String _weight = "70";
  // String _height = "183";
  // bool _passwordVisible = false;

  String? name, id, email, phone, address, weight, height, age, imageURL;

  updateUserProfile() async {
    try {
      await SharedpreferenceHelper().saveUserName(_nameController.text);
      await SharedpreferenceHelper().saveUserEmail(_emailController.text);
      await SharedpreferenceHelper().saveUserPhone(_phoneController.text);
      await SharedpreferenceHelper().saveUserWeight(weight!);
      await SharedpreferenceHelper().saveUserHeight(height!);

      Map<String, dynamic> userInfoMap = {
        "Name": _nameController.text,
        "Email": _emailController.text,
        "Phone": _phoneController.text,
        "weight": weight,
        "height": height,
        "age": age,
        "Id": id, // Utilisez l'UID de Firebase Auth
      };

      await DatabaseMethods().updateUserDetails(id!, userInfoMap);

      // Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: const Color.fromARGB(255, 118, 70, 122),
        ),
      );
// GradientComponent.switchBetweenPages(ProfilePage())
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  GradientComponent.switchBetweenPages(BottomNavBar())));
    } catch (e) {
      print("Error updating user profile: $e");
      // Handle error, show a message to the user, etc.
    }
    // Update user profile in shared preferences
  }

  gettheshredpref() async {
    name = await SharedpreferenceHelper().getUserName();
    id = await SharedpreferenceHelper().getUserId();
    email = await SharedpreferenceHelper().getUserEmail();
    phone = await SharedpreferenceHelper().getUserPhone();
    age = await SharedpreferenceHelper().getUserAge();
    weight = await SharedpreferenceHelper().getUserWeight();
    height = await SharedpreferenceHelper().getUserHeight();
    // address = await SharedpreferenceHelper().getUserAddress();

    setState(() {});
  }

  @override
  void initState() {
    gettheshredpref();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (name == null ||
        email == null ||
        phone == null ||
        weight == null ||
        height == null ||
        age == null ||
        id == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: titleTextStyle(),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileForm(),
              const SizedBox(height: 32),
              Center(
                child: GradientComponent.gradientButton(
                  text: 'Save changes',
                  maxWidth: 220,
                  maxHeight: 50,
                  onPressed: () {
                    updateUserProfile();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Name"),
        _buildTextField(_nameController),
        const SizedBox(height: 16),
        _buildLabel("Email"),
        _buildTextField(_emailController),
        const SizedBox(height: 16),
        // _buildLabel("Password"),
        // _buildTextField(_passwordController, obscureText: true),
        const SizedBox(height: 16),
        _buildLabel("Phone Number"),
        _buildTextField(_phoneController, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        // _buildLabel("Date of Birth"),
        // _buildDatePicker(),
        const SizedBox(height: 16),
        _buildLabel("Weight"),
        _buildDropdown(weight!, List.generate(500, (i) => (0 + i).toString()),
            suffix: "kg"),
        const SizedBox(height: 16),
        _buildLabel("Height"),
        _buildDropdown(height!, List.generate(500, (i) => (0 + i).toString()),
            suffix: "cm"),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    String getInitialValue() {
      if (controller == _nameController) return name!;
      if (controller == _emailController) return email!;
      // if (controller == _passwordController) return _initialPassword;
      if (controller == _phoneController) return phone!;
      // if (controller == _dobController) return age!;
      return "";
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE8ACFF).withAlpha((255 * 0.3).toInt()),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText:
            // controller == _passwordController ? !_passwordVisible :
            obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
          hintText: getInitialValue(),
          hintStyle:
              const TextStyle(color: Color(0xFFC7B0C2)), // Updated color here
          suffixIcon:
              // controller == _passwordController
              //   ? IconButton(
              //       icon: Icon(
              //         _passwordVisible ? Icons.visibility_off : Icons.visibility,
              //         color: Colors.white60,
              //       ),
              //       onPressed: () {
              //         setState(() {
              //           _passwordVisible = !_passwordVisible;
              //         });
              //       },
              //     )
              //   :
              null,
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, {String? suffix}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFFE8ACFF).withAlpha((255 * 0.3).toInt()),
            width: 1),
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          value: value,
          menuMaxHeight: 200, // Limite la hauteur du menu déroulant
          onChanged: (newValue) => setState(() {
            if (newValue != null) {
              if (suffix == "kg") {
                weight = newValue;
              } else if (suffix == "cm") {
                height = newValue;
              }
            }
          }),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: SizedBox(
                width: 60, // Largeur du contenu dans la liste déroulante
                child: Text(
                  suffix != null ? "$item $suffix" : item,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }).toList(),
          dropdownColor: const Color(0xFF2B2D4A),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: InputBorder.none,
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          isExpanded: true,
        ),
      ),
    );
  }

  // Widget _buildDatePicker() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(
  //           color: const Color(0xFFE8ACFF).withAlpha((255 * 0.3).toInt()),
  //           width: 1),
  //     ),
  //     child: TextFormField(
  //       controller: _dobController,
  //       readOnly: true,
  //       style: const TextStyle(color: Colors.white, fontSize: 16),
  //       decoration: InputDecoration(
  //         contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  //         border: InputBorder.none,
  //         hintText: age!,
  //         hintStyle: const TextStyle(color: Color(0xFFC7B0C2)),
  //         suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
  //       ),
  //       onTap: () async {
  //         try {
  //           List<String> parts = age!.split('/');
  //           DateTime initialDate = DateTime(
  //             int.parse(parts[2]),
  //             int.parse(parts[1]),
  //             int.parse(parts[0]),
  //           );

  //           DateTime? pickedDate = await showDatePicker(
  //             context: context,
  //             initialDate: initialDate,
  //             firstDate: DateTime(1900),
  //             lastDate: DateTime.now(),
  //             builder: (context, child) {
  //               return Theme(
  //                 data: Theme.of(context).copyWith(
  //                   colorScheme: const ColorScheme.light(
  //                     primary: Color(
  //                         0xFF983BCB), // couleur des boutons (OK / Cancel)
  //                     onPrimary: Colors.white, // texte sur boutons
  //                     surface: Colors.white, // fond des boîtes de dialogue
  //                     onSurface: Colors.black, // texte
  //                   ),
  //                   dialogBackgroundColor:
  //                       Colors.white, // fond principal du calendrier
  //                   textButtonTheme: TextButtonThemeData(
  //                     style: TextButton.styleFrom(
  //                       foregroundColor: Color(0xFF983BCB), // texte des boutons
  //                     ),
  //                   ),
  //                 ),
  //                 child: child!,
  //               );
  //             },
  //           );

  //           if (pickedDate != null) {
  //             setState(() {
  //               _birthDate = "${pickedDate.day.toString().padLeft(2, '0')}/"
  //                   "${pickedDate.month.toString().padLeft(2, '0')}/"
  //                   "${pickedDate.year}";
  //               _dobController.text = _birthDate;
  //             });
  //           }
  //         } catch (e) {
  //           print("Erreur lors du parsing de la date : $e");
  //         }
  //       },
  //     ),
  //   );
  // }
}
