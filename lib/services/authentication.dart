/*import 'dart:async';
import 'dart:convert' show json;
import 'package:codegen/ui/screens/studentProfile.dart';
import "package:http/http.dart" as http;
import 'package:codegen/ui/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:codegen/services/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codegen/services/users.dart';
import 'dart:convert';


class Authentication extends StatefulWidget{
 @override
  State<StatefulWidget> createState() => new _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>{
  static final _AuthenticationState _singleton = new _AuthenticationState._internal();
    Users currentUser = new Users();
    
    factory _AuthenticationState() {
    return _singleton;
    }
  _AuthenticationState._internal();

  GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

  Future<void> handleSignIn(String _currentRole,BuildContext context) async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      if(account != null){
        print("Signed in " + _googleSignIn.currentUser.displayName);
      login(account,_currentRole,context);
     }
      else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (error) {
      print(error);

    }
  }
  void userSave(String user,BuildContext context,String _currentRole,String name,String bday,int weight,String tele) async{
        print('USER SERVICE : '+user);
     SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('USER_DATA', user);
      if(user != null)
      {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StudentProfileScreen(_googleSignIn.currentUser.email,_googleSignIn.currentUser.photoUrl,_googleSignIn.currentUser.id,_currentRole,name,bday,weight,tele)));
      }
    }
    
 //Map<String, dynamic> user = jsonDecode(Users);
  void login(GoogleSignInAccount account,String _currentRole,BuildContext context) async {
    try {
      Users user = new Users();
      user.email = account.email;
      user.name = account.displayName;
     // user.role = _currentRole;
     
      //print(user.urole);
      //http.Response res = await http.get(Urls.USER_API + "/login");
      //Users.fromJson(json.decode(res.body));
      //print('user role ${user.role}');
      http.Response response =
          await http.post(
          Urls.USER_API + "/login",
          headers: {"Content-Type": "application/json"},
          body: json.encode(user.toMap()).toString());
      print("${Urls.USER_API}/${account.email}");
      print('response service ' + response.body);
      final body = json.decode(response.body);
      final em = body['payload'];
      String my = json.encode(em);
      final payload = json.decode(my);
      //table entities
      //String email = payload['email'];
      String role = payload['role'];
      String name = payload['name'];
      String bday = payload['dob'];
      int weight = payload['weight'];
      String tele = payload['contactNo'];
      print(tele);
      print(body);
      if (response.statusCode == 200 && body['status']=="success" && role==_currentRole) {
        userSave(json.encode(json.decode(response.body)),context,_currentRole,name,bday,weight,tele);
        
      } else {
        print('err');
      }
    } catch (e) {
      print('login service ' + e.toString());
    }
  }
  }*/