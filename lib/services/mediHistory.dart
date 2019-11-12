class MedicalHistory {
    String indexNumber;
    String studiseaseName;
    String stuoccurredDate;
    List<String> stumedicineIds;
    String stuspecialNotes;
    int stuupdatedByUid;
    String stuoccurredAt;

  MedicalHistory.withId(this.indexNumber, this.studiseaseName,this.stuoccurredDate,this.stuspecialNotes, this.stuupdatedByUid,this.stumedicineIds,this.stuoccurredAt);

  MedicalHistory({this.indexNumber, this.studiseaseName,this.stuoccurredDate,this.stuspecialNotes, this.stuupdatedByUid,this.stumedicineIds,this.stuoccurredAt});

  toMap() {
    var map = Map<String, dynamic>();

    try {
      if(indexNumber != null)
      map["studentIndexNumber"] = indexNumber;

      if(studiseaseName != null)
      map["diseaseName"] = studiseaseName;

      if(stuoccurredDate != null)
      map["occurredDate"] = stuoccurredDate;

       if(stuspecialNotes != null)
      map["specialNotes"] = stuspecialNotes;

       if(stuupdatedByUid != null)
      map["updatedByUid"] = stuupdatedByUid;

      if(stumedicineIds != null)
      map["medicineIds"] = stumedicineIds;

      if(stuoccurredAt != null)
      map["occurredAt"] = stuoccurredAt;

    } catch (e) {
      print('mapp error ${e.toString()}');
    }

    return map;
  }

  String get studentIndexNumber => indexNumber;

  set studentIndexNumber(String value) {
    indexNumber = value;
  }

    int get updatedByUid => stuupdatedByUid;

  set updatedByUid(int value) {
    stuupdatedByUid = value;
  }

    String get diseaseName => studiseaseName;

  set diseaseName(String value) {
    studiseaseName = value;
  }

   String get occurredAt => stuoccurredAt;

  set occurredAt(String value) {
    stuoccurredAt = value;
  }

 String get occuredDate => stuoccurredDate;

  set occuredDate(String value) {
    stuoccurredDate = value;
  }

  List<String> get medicineIds => stumedicineIds;

  set medicineIds(List<String> value) {
    stumedicineIds = value;
  }
  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    //var json = Map<String, dynamic>();
    return MedicalHistory(
      stuupdatedByUid: json['updatedByUid'],
      indexNumber: json['studentIndexNumber'],
      studiseaseName: json['diseaseName'],
      stuoccurredDate: json['occuredDate'],
      stuspecialNotes:json['specialNotes'],
      stumedicineIds:json['medicineIds'],
      stuoccurredAt:json['occurredAt'],
    );
  }
//print(name);
  String get specialNotes => stuspecialNotes;

  set specialNotes(String value) {
    stuspecialNotes = value;
  }
 
}
