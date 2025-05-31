class UserModel {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final int? age;
  final String? phone;
  final double? weight;
  final double? height;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.age,
    this.phone,
    this.weight,
    this.height,
    this.address,
  });


  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['Id'] ?? '',
      name: map['Name'] ?? '',
      email: map['Email'] ?? '',
      imageUrl: map['ImageURL'],
      age: map['Age'] != null ? int.tryParse(map['Age'].toString()) : null,
      phone: map['Phone'],
      weight: map['Weight'] != null
          ? double.tryParse(map['Weight'].toString())
          : null,
      height: map['Height'] != null
          ? double.tryParse(map['Height'].toString())
          : null,
      address: map['Address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'Email': email,
      'ImageURL': imageUrl,
      'Age': age,
      'Phone': phone,
      'Weight': weight,
      'Height': height,
      'Address': address,
    };
  }

  String get formattedHeight =>
      height != null ? '${height!.toStringAsFixed(1)} CM' : 'Non défini';
  String get formattedWeight =>
      weight != null ? '${weight!.toStringAsFixed(1)} KG' : 'Non défini';
  String get formattedAge => age != null ? '$age ans' : 'Non défini';

  // Calcul de l'IMC
  double? get bmi {
    if (weight != null && height != null && height! > 0) {
      double heightInMeters = height! / 100;
      return weight! / (heightInMeters * heightInMeters);
    }
    return null;
  }

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return 'Non calculable';
    
    if (bmiValue < 18.5) return 'Insuffisance pondérale';
    if (bmiValue < 25) return 'Poids normal';
    if (bmiValue < 30) return 'Surpoids';
    return 'Obésité';
  }
}
