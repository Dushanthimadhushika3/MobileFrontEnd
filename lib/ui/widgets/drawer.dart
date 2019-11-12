import 'dart:io';

import 'package:codegen/services/users.dart';
import 'package:codegen/ui/screens/calendarevent.dart';
import 'package:codegen/ui/screens/clzStudents.dart';
import 'package:codegen/ui/screens/home.dart';
import 'package:codegen/ui/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:codegen/ScopedModels/mainScope.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer(this.model);

  //final String image;
  final MainModel model;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> handleSignOut( BuildContext context) async {
    try {
      GoogleSignInAccount logout = await _googleSignIn.signOut();
      if (logout == null) {
        exit(0);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ));

      }else {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(model.authenticatedUser.roleName,model.authenticatedUser.grade),
        ));

      }


      //exit(0);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildUserAcc(BuildContext context, MainModel model) {
    //users.name = login().name;
    //print(login());

    return [
      UserAccountsDrawerHeader(
        accountName: Text(model.authenticatedUser.name,
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        accountEmail: Text(model.authenticatedUser.email,
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/drawerimage.jpg"),
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(model.authenticatedUser.imageurl),
        ),
      ),
    ];
  }

  List<Widget> _buildLabels(BuildContext context, MainModel model) {
    List<Widget> labelListTiles = [];
    if (model.authenticatedUser.roleName == 'Parent') {
      labelListTiles.add(
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Children'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ClzStudentsScreen(model.authenticatedUser.grade,model.authenticatedUser.clz,model.authenticatedUser.roleName,model.authenticatedUser.id),
            ));
          },
        ),
      );
    } else {
      labelListTiles.add(
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text('Students'),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ClzStudentsScreen(model.authenticatedUser.grade,model.authenticatedUser.clz,model.authenticatedUser.roleName,model.authenticatedUser.id),
            ));
          },
        ),
      );
    }
    labelListTiles.add(ListTile(
      leading: Icon(Icons.event),
      title: Text('Upcoming clinical events'),
      onTap: () {
        //model.eventList(jsonData);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => MyCalendarPage(),
        ));
      },
    ));
    labelListTiles.add(ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(model.authenticatedUser.roleName,model.authenticatedUser.grade),
        ));
      },
    ));
    labelListTiles.add(ListTile(
      title: Text('About us'),
     leading: Icon(Icons.info),
     subtitle: Text('Contact us : 0371234567'),
      //subtitle: Text('Contact us : 0371234567'),
    ));
    labelListTiles.add(ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('Logout'),
      onTap: () {
        //model.eventList(jsonData);
        Navigator.pop(context);
        handleSignOut(context);

      },
    ));
    return labelListTiles;
  }
    List<Widget> _buildDrawerList(BuildContext context, MainModel model) {
    List<Widget> children = [];
    children
      ..addAll(_buildUserAcc(context, model))
      ..addAll(_buildLabels(context, model));
    return children;
  }
return Drawer(
      
              child: ListView(
            padding: EdgeInsets.zero,
            children: _buildDrawerList(context,model),
         ));
    
   
  }
}