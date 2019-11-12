import 'package:codegen/services/disease.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:codegen/services/mediHistory.dart';
import 'package:codegen/services/urls.dart';
import "package:http/http.dart" as http;
import 'package:intl/intl.dart';
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'package:codegen/ScopedModels/mainScope.dart';

class StuMedical extends StatefulWidget {
  StuMedical(this.childName);

  final String childName;
  @override
  _StuMedicalState createState() => _StuMedicalState(childName);
}

class _StuMedicalState extends State {
  final _formKey = GlobalKey<FormState>();
  final _mediHistory = MedicalHistory();
  String _currentChild;
  String _currentDisease;
  List data = List();
  String condition;
  String childName;
  //bool isEnable;
  _StuMedicalState(this.childName);

  @override
  void initState() {
    this.getDisease();
    super.initState();
    //isEnable=false;
  }

  Future getDisease() async {
    try {
      Diseases disease = Diseases();
      http.Response response = await http.post(Urls.DISEASE_API,
          headers: {"Content-Type": "application/json"},
          body: json.encode(disease.toMap()).toString());
      if (response.statusCode == 200){
      setState(() {
        print(response.body);
        final resBody = json.decode(response.body);
        print(resBody);
            data = resBody;
            data.add("Other");
      });}
    } catch (e) {
      print('Disease service error ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }
        ),title: Text('Medical Details')),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: Column(children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Builder(
                          builder: (context) => Form(
                              key: _formKey,
                              child:Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  child: ScopedModelDescendant<MainModel>(
                                      builder: (BuildContext context,
                                          Widget child, MainModel model) {

                              return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    new DropdownButton(
                                      hint: new Text(childName),
                                      items: model.authenticatedUser.childrenName.values.map((item) {
                                        return new DropdownMenuItem<String>(
                                          child: new Text(item),
                                          value: item,
                                        );
                                      }).toList(),
                                      value: _currentChild,
                                      onChanged:  (value){setState(() {
                                        _currentChild = value;
                                        print(value);
                                        for (var i = 0; i < model.authenticatedUser.childrenName.values.toList().length; ++i) {

                                          if(model.authenticatedUser.childrenName.values.toList()[i]==_currentChild)
                                          {
                                            print("test");
                                            print(model.authenticatedUser.childrenName.keys.toList()[i]);
                                            _mediHistory.indexNumber = model.authenticatedUser.childrenName.keys.toList()[i];
                                          }
                                        }

                                      });},
                                    ),
                                    new DropdownButton(
                                      hint: new Text("Select the disease"),
                                      items: data.map((item) {
                                        return new DropdownMenuItem<String>(
                                          child: new Text(item),
                                          value: item.toString(),
                                        );
                                      }).toList(),
                                      value: _currentDisease,
                                      onChanged: (value){ setState(() {
                                        _currentDisease = value;
                                      });},

                                    ),
                                   Container(child: _renderWidget(),),
                                   /* TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Disease Name'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter your last name.';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(() =>
                                            _mediHistory.studiseaseName = val)),*/
                                    DateTimePickerFormField(
                                      inputType: InputType.date,
                                        format: DateFormat("yyyy-MM-dd"),
                                        initialDate: DateTime.now(),
                                        editable:false,
                                        decoration: InputDecoration(
                                            labelText: 'Occured Date'),
                                        validator: (value) {
                                          if (value.toString().length<3) {
                                            return 'Please enter the date';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(() =>
                                            _mediHistory.stuoccurredDate =
                                                val.toString())),
                                    TextFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Description'),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter description';
                                          }
                                          return null;
                                        },
                                        onSaved: (val) => setState(() =>
                                            _mediHistory.stuspecialNotes =
                                                val)),
                                   

                                          RaisedButton(
                                              onPressed: () async {
                                                final form =
                                                    _formKey.currentState;
                                                if (form.validate()) {
                                                  form.save();
                                                  _mediHistory.stumedicineIds =
                                                      null;
                                                  _mediHistory.stuupdatedByUid=model.authenticatedUser.uid;
                                                  _mediHistory.stuoccurredAt="Home";
                                                  print(model.authenticatedUser.grade);
                                                  http.Response mediHis =
                                                      await http.post(
                                                          Urls
                                                              .MEDICAL_HISTORY_API,
                                                          headers: {
                                                            "Content-Type":
                                                                "application/json"
                                                          },
                                                          body: json
                                                              .encode(
                                                                  _mediHistory
                                                                      .toMap())
                                                              .toString());

                                                  print(mediHis);
                                                  _showDialog();

                                                }
                                              },
                                              child: Text('Save'))

                                  ]); })),)))
                ])))));
  }
_renderWidget(){
    if(_currentDisease=="Other")
      {
        return TextFormField(
            decoration: InputDecoration(
                labelText: 'Disease Name'),
            onSaved: (val) => setState(() =>
            _mediHistory.studiseaseName = val));
      }
    else
    {
      _mediHistory.studiseaseName = _currentDisease;
    }
}

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 1.7,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Saved Successfully...!',style: TextStyle(color: Colors.black,fontSize: 18.0)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              //child: Text('Ok',style: TextStyle(fontSize: 18.0)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
