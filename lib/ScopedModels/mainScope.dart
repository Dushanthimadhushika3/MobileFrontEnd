import 'package:scoped_model/scoped_model.dart';
import 'package:codegen/ScopedModels/scopeModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:codegen/services/users.dart';

class MainModel extends Model with User,Events{


}
