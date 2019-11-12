class Clinical {
  int eId;
  DateTime createDate;
  String edate;
  String eName;
  String evenue;
  String description;
  String imageUrl;

  Clinical.withId(this.eId, this.createDate,this.edate, this.eName,this.evenue,this.description,this.imageUrl);

  Clinical({this.eId, this.createDate, this.edate, this.eName,this.evenue,this.description,this.imageUrl});

  toMap() {
    var map = Map<String, dynamic>();

    try {
      if(eId != null)
      map["eventId"] = eId;

      if(createDate != null)
      map["createdDate"] = createDate;

       if(edate != null)
      map["date"] = edate;

       if(eName != null)
      map["eventName"] = eName;

       if(evenue != null)
      map["venue"] = evenue;

      if(description != null)
      map["eventDescription"] = description;

      if(imageUrl != null)
      map["imageUrl"] = imageUrl;

       
    } catch (e) {
      print('mapp error ${e.toString()}');
    }

    return map;
  }

  DateTime get createdDate => createDate;

  set createdDate(DateTime value) {
    createDate = value;
  }

     String get date => edate;

  set date(String value) {
    edate = value;
  }

    String get eventName => eName;

  set eventName(String value) {
    eName = value;
  }
    String get eventDescription => description;

  set eventDescription (String value) {
    description = value;
  }
String get imageUrls => imageUrl;
   set imageUrls (String value) {
    imageUrl = value;
  }


  factory Clinical.fromJson(Map<String, dynamic> json) {
    //var json = Map<String, dynamic>();
    return Clinical(
      eId: json['eventId'],
      createDate: json['createDate'],
      edate: json['date'],
      eName: json['eventName'],
      evenue: json['venue'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
//print(name);
  String get venue => evenue;

  set venue(String value) {
    evenue = value;
  }
 
}
