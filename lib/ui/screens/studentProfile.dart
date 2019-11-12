import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';


class StudentProfileScreen extends StatefulWidget {
  final student;
  StudentProfileScreen(this.student);
  @override
  State<StatefulWidget> createState() => new _StudentProfileScreenState(student);
}

class _StudentProfileScreenState extends State<StudentProfileScreen>{
  String alMedi='';
  String diseases='';
  String sports='';
final student;
  _StudentProfileScreenState(this.student);

   @override
  void initState() {
   for(var j = 0; j < student['medicineName'].length; j++){
     print(student['medicineName']);
       alMedi+=student['medicineName'][j];
       if(student['medicineName'].length != j+1)
        alMedi+=',';
      }
   for(var j = 0; j < student['diseases'].length; j++){
     print(student['diseases']);
     diseases+=student['diseases'][j];
     if(student['diseases'].length != j+1)
       diseases+=',';
   }
   for(var j = 0; j < student['sports'].length; j++){
     print(student['sports']);
     sports+=student['sports'][j];
     if(student['sports'].length != j+1)
       sports+=',';
   }
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    print(student['uid']);
    print(student['medicineName']);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            scrollDirection: Axis.vertical,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.grey,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(student['name'],
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 25.0,
                          )),
                      background: Image.network(
                        student['imageurl'],
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      )),
                ),
                SliverPersistentHeader( 
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(icon: Icon(Icons.info), text: "General Info"),
                          Tab(
                              icon: Icon(Icons.add_circle_outline),
                              text: "Health Info"),
                        ],
                      ),
                    ),
                    pinned: true,
                    floating: false,
                  ),
                
              ];
            },
            body: SafeArea(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      SizedBox(height: 20.0),
                                      Text('Name : ' + student['name']),
                                      SizedBox(height: 20.0),
                                      Text('Email : ' + student['email']),
                                      SizedBox(height: 20.0),
                                      Text('Index No : ' + student['indexNo']),
                                      SizedBox(height: 20.0),
                                      Text('Grade : ' +
                                          student['grade'].toString()),
                                      SizedBox(height: 20.0),
                                      Text('Class : ' + student['clz']),
                                      SizedBox(height: 20.0),
                                      Text('Address : ' + student['address']),
                                      SizedBox(height: 20.0),
                                      Text('Teacher : ' +
                                          student['teacherName']),
                                      SizedBox(height: 20.0),
                                      Text('Parent : ' + student['parentName']),
                                      SizedBox(height: 20.0),
                                      Text('Parent Email : ' +
                                          student['parentEmail']),
                                      SizedBox(height: 20.0),
                                      Text('Birth Day : ' +
                                          student['dob'].toString()),
                                      SizedBox(height: 20.0),
                                      Text('Restricted Sports : '+sports),
                                      SizedBox(height: 20.0),
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 20.0),
                                      Text('Weight : ' +
                                          student['weight'].toString()),
                                      SizedBox(height: 20.0),
                                      Text('Height : ' +
                                          student['height'].toString()),
                                      SizedBox(height: 20.0),
                                      Text('Blood Group : ' +
                                          student['bloodgroup']),
                                      SizedBox(height: 20.0),
                                      Text('Alergic Drugs : '+alMedi),
                                      SizedBox(height: 20.0),
                                      Text('Diseases : '+diseases),
                                      SizedBox(height: 20.0),
                                    ]),
                              ],
                            )))))),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
