
class Student {
  int id;
  int major_id;
  String lastName;
  String firstName;
  int gender;
  String phone;
  String email;

  Student({this.id = 0, required this.major_id, required this.lastName, 
    required this.firstName, required this.gender, required this.phone, required this.email});
}