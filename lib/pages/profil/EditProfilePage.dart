import 'package:fitness/components/gradient.dart';
import 'package:flutter/material.dart';
import '../../components/textStyle/textstyle.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  final String _initialName = "Melissa Peters";
  final String _initialEmail = "melpeters@gmail.com";
  final String _initialPassword = "**********";
  final String _initialPhone = "06726272733";
  final String _initialDob = "23/05/1995";

  String _birthDate = "23/05/1995";
  String _weight = "70";
  String _height = "183";
  bool _passwordVisible = false;

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
    return Scaffold(
      backgroundColor: const Color(0xFF2E2F55),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2F55),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: titleTextStyle(),
        ),
      ),
      body: Container(
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
                  onPressed: () {},
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
        _buildLabel("Password"),
        _buildTextField(_passwordController, obscureText: true),
        const SizedBox(height: 16),
        _buildLabel("Phone Number"),
        _buildTextField(_phoneController, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildLabel("Date of Birth"),
        _buildDatePicker(),
        const SizedBox(height: 16),
        _buildLabel("Weight"),
        _buildDropdown(_weight, List.generate(200, (i) => (30 + i).toString()),
            suffix: "kg"),
        const SizedBox(height: 16),
        _buildLabel("Height"),
        _buildDropdown(_height, List.generate(200, (i) => (130 + i).toString()),
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
      if (controller == _nameController) return _initialName;
      if (controller == _emailController) return _initialEmail;
      if (controller == _passwordController) return _initialPassword;
      if (controller == _phoneController) return _initialPhone;
      if (controller == _dobController) return _initialDob;
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
            controller == _passwordController ? !_passwordVisible : obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
          hintText: getInitialValue(),
          hintStyle:
              const TextStyle(color: Color(0xFFC7B0C2)), // Updated color here
          suffixIcon: controller == _passwordController
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white60,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
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
                _weight = newValue;
              } else if (suffix == "cm") _height = newValue;
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

  Widget _buildDatePicker() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFFE8ACFF).withAlpha((255 * 0.3).toInt()),
            width: 1),
      ),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
          hintText: _initialDob,
          hintStyle: const TextStyle(color: Color(0xFFC7B0C2)),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
        ),
        onTap: () async {
          try {
            List<String> parts = _birthDate.split('/');
            DateTime initialDate = DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(
                          0xFF983BCB), // couleur des boutons (OK / Cancel)
                      onPrimary: Colors.white, // texte sur boutons
                      surface: Colors.white, // fond des boîtes de dialogue
                      onSurface: Colors.black, // texte
                    ),
                    dialogBackgroundColor:
                        Colors.white, // fond principal du calendrier
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF983BCB), // texte des boutons
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              setState(() {
                _birthDate = "${pickedDate.day.toString().padLeft(2, '0')}/"
                    "${pickedDate.month.toString().padLeft(2, '0')}/"
                    "${pickedDate.year}";
                _dobController.text = _birthDate;
              });
            }
          } catch (e) {
            print("Erreur lors du parsing de la date : $e");
          }
        },
      ),
    );
  }
}
