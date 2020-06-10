class Option {
  int id;
  String name;
  int votes;

  Option();

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    votes = json['votes'];
  }
}
