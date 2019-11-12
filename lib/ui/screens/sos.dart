import 'package:codegen/ScopedModels/mainScope.dart';
import 'package:codegen/ui/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:codegen/services/urls.dart';
import "package:http/http.dart" as http;
import 'dart:convert' show json;
import 'package:codegen/services/users.dart';
import 'package:codegen/services/sosD.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:scoped_model/scoped_model.dart';
//import 'package:codegen/ui/screens/home.dart';

class SosScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SosScreenState();

}

class _SosScreenState extends State<SosScreen> {

  String message = "This is an emergency message! Your child has injured.";


  String _currentStudent;
  String _currentGrade;
  String _currentClass;


  List data = List();

  List<String> recipents = [];
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: AppBar(
          title: Text("Medi App - SOS"),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              height: MediaQuery.of(context).size.height,
              child:Center(
                child: Column(children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Enter Grade :',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                    //validator: (val) => val.length == null ? 'Enter valid grade' : null,
                    onChanged: (text) {_currentGrade = text;},

                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Enter Class :',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent))),
                    //validator: (val) => val.length == null ? 'Enter valid class' : null,
                    onChanged: (text) {_currentClass = text;},
                  ),
                  SizedBox(height: 25.0),
                  MaterialButton(
                    color: Colors.grey,
                    child: Text("Find"),
                    onPressed: () =>findStudent(_currentGrade, _currentClass),
                  ),
                  SizedBox(height: 25.0),
                  //Text('Select the student : ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                  new DropdownButton(
                    hint: new Text("Select the student"),
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['name'].toString(),
                      );
                    }).toList(),
                    value: _currentStudent,
                    onChanged: changedDropDownItem,
                  ),
                  MaterialButton(
                    color: Colors.greenAccent,
                    child: Text("Send SMS"),
                    onPressed: () =>sosmgs(message,recipents,_currentStudent),
                  ),
                ]),
              )),),
        drawer: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
//model.eventList(jsonData);

              return MyDrawer(model);
            }));

  }

  void findStudent(String _currentGrade,String _currentClass) async {
    print(_currentGrade);
    print(_currentClass);
    try {
      Users user = new Users();
      user.grade = int.parse(_currentGrade);
      user.clz = _currentClass;
      user.roleName = "student";
      http.Response response = await http.post(Urls.USER_API + "/clzStudents",
          headers: {"Content-Type": "application/json"},
          body: json.encode(user.toMap()).toString());
      print(response.body);
      final resBody = json.decode(response.body);
      //tele = resBody['contactNo'];
      print(resBody);
      //print(tele);
      if (response.statusCode == 200){
        setState((){
          //final stuNames = json.decode();
          data = resBody;
        });}
    } catch (e) {
      print('Sos service error ' + e.toString());
    }
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      _currentStudent = selectedItem;
    });
  }
  void sosmgs(String message, List<String> recipents,String _currentStudent) async {
    print(_currentStudent);
    try{Users user = new Users();
    user.name = _currentStudent;
    http.Response response = await http.post(Urls.USER_API + "/contactNo",
        headers: {"Content-Type": "application/json"},
        body: json.encode(user.toMap()).toString());
    final res = json.decode(response.body);
    final out = res['payload'];
    user.id = out['uid'];
    user.contactNo = out['contactNo'];

    print(res);
    recipents.add(user.contactNo.toString());
    String _result =
    await FlutterSms.sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    SosD sos = new SosD();
    //sos.occuredDate = (DateTime.now()).toString();
    //print(sos.occuredDate);
    sos.userId = user.id;
    print(sos.userId);
    http.Response resSos = await http.post(Urls.SOS_API,
        headers: {"Content-Type": "application/json"},
        body: json.encode(sos.toMap()).toString());
    print(resSos);
    print(_result);}
    catch(e){
      print("Error in messaging "+e.toString());
    }
    //soscl(BuildContext context);
  }

}
