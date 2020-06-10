class Entity {
  int id;
  String email;
  String name;

  Entity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    email = json['name'];
  }
}
