import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final String? phone;
  final String? location;
  final String? gender;
  final String? profileImage;

  UserModel({
    required this.uid,
    this.name,
    this.email,
    this.phone,
    this.location,
    this.gender,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'gender': gender,
      'profileImage': profileImage,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      location: map['location'],
      gender: map['gender'],
      profileImage: map['profileImage'],
    );
  }
}
