import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:codegen/services/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codegen/ui/widgets/googleSignupBtn.dart';
import 'package:codegen/services/users.dart';
import 'package:codegen/ui/screens/home.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'package:codegen/ScopedModels/mainScope.dart';

//import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _LoginScreenState _singleton = new _LoginScreenState._internal();
  Users currentUser = new Users();

  factory _LoginScreenState() {
    return _singleton;
  }
  _LoginScreenState._internal();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  List _roles = ["Teacher", "Parent"];
  bool _acceptTerms = false;
  Map<String, String> children;

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentRole;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentRole = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String role in _roles) {
      items.add(new DropdownMenuItem(value: role, child: new Text(role)));
    }
    return items;
  }

  Text _buildText2() {
    return Text(
      '"Protection is better than cure"',
      textAlign: TextAlign.center,
      //
    );
  }

  Text _buildText3() {
    return Text(
      'Select the role :',
      style: Theme.of(context).textTheme.subtitle,
      textAlign: TextAlign.left,
      //
    );
  }

  BoxDecoration _buildBackground() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/MediBackground.jpg"),
        fit: BoxFit.fitHeight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Text _buildText1() {
      return Text(
        'Welcome to Cloud Smart School',
        style: Theme.of(context).textTheme.headline,
        textAlign: TextAlign.center,
        //'Protection is better than cure',
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: _buildBackground(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Center(
                    child: ClipRect(
                      clipBehavior: Clip.antiAlias,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Form(
                            child: Column(
                              children: <Widget>[
                                //SizedBox(height: 10.0),
                                _buildText1(),
                                SizedBox(height: 10.0),
                                //_buildText2(),
                            Text(
                              '"Protection is better than cure"',
                              textAlign: TextAlign.center,
                            style:TextStyle(fontStyle: FontStyle.italic)),
                                SizedBox(height: 10.0),
                                _buildText3(),
                                new DropdownButton(
                                  //hint:Text("Select the role :"),
                                  value: _currentRole,
                                  items: _dropDownMenuItems,
                                  onChanged: changedDropDownItem,
                                ),
                                SwitchListTile(
                                  value: _acceptTerms,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _acceptTerms = value;
                                    });
                                  },
                                  title: Text("Accepts terms"),
                                ),
                                SizedBox(height: 15.0),
                                ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
                                return GoogleSignUpButton(onPressed: () {
                                  if (_acceptTerms) {
                                    handleSignIn(_currentRole, context,model.login);
                                  }
                                  else
                                    {
                                      _acceptTermsError();
                                    }
                                });})
                              ],
                            ),
                          ),
                          height: 350,
                          width: 350,
                          decoration: new BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changedDropDownItem(String selectedRole) {
    setState(() {
      _currentRole = selectedRole;
    });
  }

  void userSave(String user, BuildContext context, String _currentRole,
      String name, int weight, String tele,int id,int grade,String clz,Function login,Map<String, String> children) async {
    print('USER SERVICE : ' + user);
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('USER_DATA', user);
    //FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(credential);
    if (user != null) {
      final QuerySnapshot result =
      await Firestore.instance.collection('users').where('id', isEqualTo: id).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(id.toString()).setData({
          'photoUrl': _googleSignIn.currentUser.photoUrl,
          'id': id,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });}
      login (_googleSignIn.currentUser.email,id,name,_currentRole,grade,clz,_googleSignIn.currentUser.photoUrl,children);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(_currentRole,grade)));
    }
  }

  Future<void> handleSignIn(String _currentRole, BuildContext context,Function login) async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();

      if (account != null) {
        print("Signed in " + _googleSignIn.currentUser.displayName);
        userLogin(account, _currentRole, context,login);

      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        _loginErrorUser();
      }
    } catch (error) {
      print(error);
      _loginErrorNetwork();
    }
  }

  void userLogin(GoogleSignInAccount account, String _currentRole,
      BuildContext context,Function login) async {
    try {
      Users user = new Users();
      user.email = account.email;
      user.name = account.displayName;
      user.roleName = _currentRole;
      http.Response response = await http.post(Urls.USER_API + "/login",
          headers: {"Content-Type": "application/json"},
          body: json.encode(user.toMap()).toString());
      print("${Urls.USER_API}/${account.email}");
      print('response service ' + response.body);
      final body = json.decode(response.body);
     //print('response service2 ' +body);
      final em = body['payload'];
      if (response.statusCode == 200 &&
          body['status'] == "success") {
      List ch = em['children'];
      String name = em['name'];
      print(ch);
      //DateTime bday = payload['dob'];
      int weight = em['weight'];
      int id = em['uid'];
      int grade = em['grade'];
      String tele = em['contactNo'];
      String clz = em['clz'];
      String stname;
      children ={};
      for(var i = 0; i < ch.length; i++)
      { stname=(ch[i]['name']);
      children[(ch[i]['indexNo'])]=stname;
     } print(children);
      print(tele);
      print(body);

        userSave(json.encode(json.decode(response.body)), context, _currentRole,
            name, weight, tele,id,grade,clz,login,children);
      } else {
        print('err');
        _loginErrorUser();
      }
    } catch (e) {
      print('login service ' + e.toString());
      _loginErrorNetwork();
    }
  }

  Future<void> _loginErrorUser() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid User'),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),
          //backgroundColor: Colors.brown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 1.7,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please check the role and email.',style: TextStyle(color: Colors.black,fontSize: 15.0)),
                Text('Only registered parents and teachers of cloud smart school can use this app',style: TextStyle(color: Colors.black,fontSize: 15.0)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok',style: TextStyle(fontSize: 18.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginErrorNetwork() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Server Error'),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 1.7,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please try again later',style: TextStyle(color: Colors.black,fontSize: 15.0)),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Try again!',style: TextStyle(fontSize: 18.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _acceptTermsError() async {
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
                Text('Please accept terms and conditions',style: TextStyle(color: Colors.red,fontSize: 18.0)),

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok',style: TextStyle(fontSize: 18.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
