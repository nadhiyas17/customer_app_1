// user_model.dart
class UserModel {
  final String name;
  final String email;
  final String age;
  final String gender;
  final String bloodGroup;

  UserModel({
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.bloodGroup,
  });

  // You can also add a method to convert this to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'blood_group': bloodGroup,
    };
  }
}
