class SosD {
  int sid;
  DateTime sosOccuredDate;
  int userId;

  SosD.withId(this.sid, this.sosOccuredDate,this.userId);

  SosD({this.sid, this.sosOccuredDate, this.userId});

  toMap() {
    var map = Map<String, dynamic>();

    try {
      if(sid != null)
      map["sosid"] = sid;

      if(sosOccuredDate != null)
      map["occuredDate"] = sosOccuredDate;

       if(userId != null)
      map["user_id"] = userId;
    } catch (e) {
      print('mapp error ${e.toString()}');
    }

    return map;
  }

  int get sosid => sid;

  set sosid(int value) {
    sid = value;
  }

    DateTime get occuredDate => sosOccuredDate;

  set occuredDate(DateTime value) {
    sosOccuredDate = value;
  }

  factory SosD.fromJson(Map<String, dynamic> json) {
    //var json = Map<String, dynamic>();
    return SosD(
      sid: json['sosid'],
      sosOccuredDate: json['occuredDate'],
      userId: json['user_id'],
    );
  }
  int get userid => userId;

  set userid(int value) {
    userId = value;
  }
}
