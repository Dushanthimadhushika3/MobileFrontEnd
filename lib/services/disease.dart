class Diseases{
  String diName;
  Diseases.withId(this.diName);

  Diseases({this.diName});

  toMap() {
    var map = Map<String, dynamic>();

    try {
      if(diName != null)
        map["name"] = diName;

    } catch (e) {
      print('mapp error ${e.toString()}');
    }
    return map;}

  String get name => diName;

  set name(String value) {
    diName = value;
  }

  factory Diseases.fromJson(Map<String, dynamic> json) {
    //var json = Map<String, dynamic>();
    return Diseases(
      diName: json['name']
    );
  }


}