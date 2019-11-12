import 'package:scoped_model/scoped_model.dart';
import 'package:codegen/ScopedModels/mainScope.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:codegen/services/users.dart';
import 'package:codegen/services/clinical.dart';

mixin User on Model {
  //String o;
  Users _authenticatedUser;
  Users get authenticatedUser => _authenticatedUser;

  void login(
      String email, int id, String name, String role, int grade, String clz,String photourl,Map<String,String> childrenName) {
    _authenticatedUser = Users(
        id: id,
        uemail: email,
        uName: name,
        urole: role,
        stuGrade: grade,
        stuClass: clz,
        uimageurl: photourl,
    uchildrenNames: childrenName);
    saveUser(_authenticatedUser);
    notifyListeners();
  }

  void saveUser(Users newUser) {
    _authenticatedUser = newUser;
    notifyListeners();
  }
}
mixin Events on Model {
  List<Clinical> _events = List<Clinical>();
  List<Clinical> get events => _events;
 

  void eventList(var getevent) {

    for(int i=0;i<getevent.length;i++)
    {_events.add(Clinical(
        eId: getevent[i]['eventId'],
      createDate: getevent[i]['createDate'],
      edate: getevent[i]['date'],
      eName: getevent[i]['eventName'],
      evenue: getevent[i]['venue'],
      description: getevent[i]['description'],
      imageUrl: getevent[i]['imageUrl'],));
    //_events.insert(i, Clinical(eId: eId,createDate: createDate,edate: edate,eName: eName,evenue: evenue,description: description));}
    }saveEvents(_events, _events.length);
    notifyListeners();
  }

  void saveEvents(List<Clinical> upcomingEvents, int length) {
    _events = upcomingEvents;
for(int i=0;i<length;i++)
  {print(upcomingEvents[i].eName);}  

    notifyListeners();
  }
}
mixin Parent on User {}
