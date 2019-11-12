import 'package:flutter/material.dart';
import 'package:codegen/ui/screens/login.dart';
import 'package:codegen/ui/theme.dart';
//import 'package:codegen/ui/screens/home.dart';
import 'package:codegen/ScopedModels/mainScope.dart';
import 'package:scoped_model/scoped_model.dart';

MainModel usermodel = new MainModel();
class MediApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>( 
    model: usermodel,
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloud Smart School',
      theme: buildTheme(),
      initialRoute: '/',
      routes: {
        // If you're using navigation routes, Flutter needs a base route.
        // We're going to change this route once we're ready with
        // implementation of HomeScreen.

        '/': (context) => LoginScreen(),
        //'/home': (context) => HomeScreen(),
      },
    ));
  }
}
