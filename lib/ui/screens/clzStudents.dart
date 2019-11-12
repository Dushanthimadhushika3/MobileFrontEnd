import 'package:codegen/ui/screens/messagingScreen.dart';
import 'package:codegen/ui/screens/stuMedical.dart';
import 'package:codegen/ui/screens/studentProfile.dart';
import 'package:codegen/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:codegen/services/urls.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;
import 'package:codegen/services/users.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:codegen/ScopedModels/mainScope.dart';

class ClzStudentsScreen extends StatefulWidget {
  ClzStudentsScreen(this.currentGrade, this.currentClass, this.currentRole,this.currentId);
  final int currentGrade;
  final String currentClass;
  final String currentRole;
  final int currentId;

  @override
  State<StatefulWidget> createState() =>
      new _ClzStudentsScreenState(currentGrade, currentClass, currentRole,currentId);
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Profile', icon: Icons.account_box),
  CustomPopupMenu(title: '', icon: Icons.message),
  CustomPopupMenu(title: 'Send Message to Admin', icon: Icons.message),
  CustomPopupMenu(title: '')
];

class _ClzStudentsScreenState extends State<ClzStudentsScreen> {
  List<String> _listViewData = [];
  int currentGrade;
  String currentClass;
  String currentRole;
  int currentId;
  bool isParent;
  _ClzStudentsScreenState(
      this.currentGrade, this.currentClass, this.currentRole,this.currentId);

  var resBody;
  String appBarTitle;

  @override
  void initState() {
    this.findStudent(currentGrade, currentClass,currentId);
    if (currentRole == 'Teacher') {
      print(currentRole);
      choices[1].title = 'Send Message to Parent';
      appBarTitle = 'Students';
      isParent=false;
    } else {
      print(currentRole);
      choices[1].title = 'Send Message to Teacher';
      choices[3].title = 'Add Medical Record';
      choices[3].icon = Icons.add;
      appBarTitle = 'Children';
      isParent=true;
    }
    super.initState();
  }

  CustomPopupMenu _selectedChoices = choices[0];

  //List data = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: _listViewData
              .map((data) => Card(
                  color: Colors.white,
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      Container(
                        constraints: new BoxConstraints.expand(
                          height: 150.0,
                        ),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new NetworkImage(resBody[_listViewData.indexOf(data)]['imageurl']),
                              fit: BoxFit.contain),
                        ),
                        child: new Stack(
                          children: <Widget>[
                            new Positioned(
                              right: 0.0,
                              //bottom: 0.0,
                              child: new Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(120.0, 0.0, 0.0, 0.0),
                                  child: ScopedModelDescendant<MainModel>(
                                      builder: (BuildContext context,
                                          Widget child, MainModel model) {
                                    return PopupMenuButton<CustomPopupMenu>(
                                      //enabled: (currentRole == 'Teacher'),
                                      elevation: 3.2,
                                      initialValue: choices[0],
                                      onCanceled: () {
                                        print('You have not chossed anything');
                                      },
                                      tooltip: 'This is tooltip',
                                      itemBuilder: (BuildContext context) {
                                        return choices
                                            .map((CustomPopupMenu choice) {
                                          return PopupMenuItem<CustomPopupMenu>(
                                              value: choice,
                                              //child:Text(choice.title),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(choice.icon),
                                                  Text(choice.title),
                                                ],
                                              ));
                                        }).toList();
                                      },
                                      onSelected: (value) async {
                                        setState(() {
                                          _selectedChoices = value;
                                        });
                                        if (_selectedChoices == choices[0]) {
                                          int i = _listViewData.indexOf(data);
                                          print(i);
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                StudentProfileScreen(
                                                    resBody[i]),
                                          ));
                                        } else if (_selectedChoices ==
                                            choices[1]) {
                                          int i = _listViewData.indexOf(data);
                                         int peerId = isParent ? resBody[i]
                                         ['teacherID']:resBody[i]
                                         ['parentID'];
                                         //print();

                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Chat(
                                                    peerId:peerId,
                                                    model: model),
                                          ));
                                        } else if (_selectedChoices ==
                                            choices[2]) {
                                          try {
                                            Users user = new Users();
                                            user.roleName = "admin";
                                            http.Response response = await http
                                                .post(Urls.ALL_USER_API,
                                                    headers: {
                                                      "Content-Type":
                                                          "application/json"
                                                    },
                                                    body: json
                                                        .encode(user.toMap())
                                                        .toString());

                                            var resBody =
                                                json.decode(response.body);
                                            print(resBody);
                                            //var Admin =
                                            String photoUrl =
                                                resBody[0]['imageUrl'];
                                            print(photoUrl);
                                            int peerId = resBody[0]['uid'];
                                            //Navigator.pop(context);
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Chat(
                                                      peerId: peerId,
                                                      model: model),
                                            ));
                                          } catch (e) {
                                            print('Admin service error ' +
                                                e.toString());
                                          }
                                        } else {
                                          if (currentRole == 'Teacher') {
                                            return;
                                          } else {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  StuMedical(resBody[_listViewData.indexOf(data)]['name']),
                                            ));
                                          }
                                        }
                                      },
                                      icon: Icon(Icons.list),
                                    );
                                  })),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        resBody[_listViewData.indexOf(data)]['name'],
                        //softWrap: true,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ))))
              .toList(),
        ),
        drawer: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
//model.eventList(jsonData);

          return MyDrawer(model);
        }));
  }

  Future findStudent(int _currentGrade, String _currentClass,int _currentId) async {
    print(_currentGrade);
    print(_currentClass);
    print(_currentId);
    try {
      Users user = new Users();
      http.Response response;
      if(currentRole=="Teacher") {
        user.grade = _currentGrade;
        user.clz = _currentClass;
        user.roleName = "student";
        response = await http.post(Urls.USER_API + "/clzStudents",
            headers: {"Content-Type": "application/json"},
            body: json.encode(user.toMap()).toString());
      }
      else{
        user.id = _currentId;
        print(user.id);
        response = await http.post(Urls.USER_API + "/children",
            headers: {"Content-Type": "application/json"},
            body: json.encode(user.toMap()).toString());
      }
      setState(() {
        print(response.body);
        resBody = json.decode(response.body);
        //final name = event['eventName'];
        print(resBody.length);
        _listViewData = [];

        for (var j = 0; j < resBody.length; j++) {
          _listViewData.add(json.decode(response.body)[j]['uid']);
          //stuImage[json.decode(response.body)[j]['name']]=_listViewData;
        }print(_listViewData);
      });
    } catch (e) {
      print('Sos service error ' + e.toString());
    }
  }
}
