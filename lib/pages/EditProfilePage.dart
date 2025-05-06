import 'package:fitness/components/gradient.dart';
import 'package:flutter/material.dart';
import '../components/textStyle/textstyle.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: "Melissa Peters");
  final _emailController = TextEditingController(text: "melpeters@gmail.com");
  final _passwordController = TextEditingController(text: "**********");
  final _phoneController = TextEditingController(text: "06726272733");
  final _dobController = TextEditingController(text: "23/05/1995");
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
        _buildDropdown(_weight, List.generate(200, (i) => (30 + i).toString()), suffix: "kg"),
        const SizedBox(height: 16),

        _buildLabel("Height"),
        _buildDropdown(_height, List.generate(200, (i) => (130 + i).toString()), suffix: "cm"),
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

  Widget _buildTextField(TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: controller == _passwordController ? !_passwordVisible : obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          // Ajout du suffixIcon pour le champ mot de passe
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
      border: Border.all(color: Colors.white, width: 1), // Ajout de la bordure blanche
    ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<String>(
          value: value,
          menuMaxHeight: 200, // Limite la hauteur du menu déroulant
          onChanged: (newValue) => setState(() {
            if (newValue != null) {
              if (suffix == "kg") _weight = newValue;
              else if (suffix == "cm") _height = newValue;
            }
          }),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Container(
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
      border: Border.all(color: Colors.white, width: 1), // Ajout de la bordure blanche
      ),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
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
                    colorScheme: ColorScheme.dark(
                      primary:Color(0xFF983BCB),
                      onPrimary: Colors.white,
                        surface: const Color(0xFF2E2F55),
                      onSurface: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              setState(() {
                _dobController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                _birthDate = _dobController.text;
              });
            }
          } catch (e) {
            // Gestion d’erreur si le format de la date est invalide
          }
        },
      ),
    );
  }
}
