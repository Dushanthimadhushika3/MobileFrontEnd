class Users {
  int id;
  String uName;
  String uemail;
  String urole;
  int stuGrade;
  String stuClass;
  String ucontactNo;
  String uimageurl;
  Map<String,String> uchildrenNames;
  

  Users.withId(this.id, this.uName,this.uemail, this.urole,this.stuGrade,this.stuClass,this.ucontactNo,this.uimageurl,this.uchildrenNames);

  Users({this.id, this.uemail, this.uName, this.urole,this.stuGrade,this.stuClass,this.ucontactNo,this.uimageurl,this.uchildrenNames});

  toMap() {
    var map = Map<String, dynamic>();

    try {
      if(id != null)
      map["uid"] = id;

      if(uemail != null)
      map["email"] = uemail;

       if(uName != null)
      map["name"] = uName;

      if(uchildrenNames != null)
        map["childrenName"] = uchildrenNames;

       if(urole != null)
      map["roleName"] = urole;

       if(stuGrade != null)
      map["grade"] = stuGrade;

       if(stuClass != null)
      map["clz"] = stuClass;

       if(ucontactNo != null)
      map["contactNo"] = ucontactNo;
    } catch (e) {
      print('mapp error ${e.toString()}');
    }

    return map;
  }

  String get email => uemail;

  set email(String value) {
    uemail = value;
  }

    int get grade => stuGrade;

  set grade(int value) {
    stuGrade = value;
  }

    String get clz => stuClass;

  set clz(String value) {
    stuClass = value;
  }

String get imageurl => uimageurl;

  set imageurl(String value) {
    uimageurl = value;
  }

  String get contactNo => ucontactNo;

  set contactNo(String value) {
    ucontactNo = value;
  }
  factory Users.fromJson(Map<String, dynamic> json) {
    //var json = Map<String, dynamic>();
    return Users(
      id: json['uid'],
      uemail: json['email'],
      uName: json['name'],
      urole: json['roleName'],
      ucontactNo:json['contactNo'],
      uimageurl:json['imageurl'],
      uchildrenNames: json['children']
    );
  }
//print(name);
  String get name => uName;

  set name(String value) {
    uName = value;
  }
 String get roleName => urole;

  set roleName(String value) {
    urole = value;
  }
  Map<String,String> get childrenName => uchildrenNames;

  set childrenName(Map<String,String> value) {
    uchildrenNames = value;
  }
  int get uid => id;

  set uid(int value) {
    id = value;
  }
}
