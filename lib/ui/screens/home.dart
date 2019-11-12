import 'package:codegen/services/message.dart';
import 'package:codegen/ui/screens/eventDetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:codegen/services/clinical.dart';
import 'package:codegen/ui/screens/sos.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert' show json;
import 'package:scoped_model/scoped_model.dart';
import 'package:codegen/ScopedModels/mainScope.dart';
import 'package:codegen/services/urls.dart';
import 'package:codegen/ui/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.currentRole,this.grade);
  final String currentRole;
  final int grade;
  @override
  State<StatefulWidget> createState() => new _HomeScreenState(currentRole,grade);
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final Firestore _db = Firestore.instance;

  List<Message> messages = [];
  List<String> recipents = [];
  // Map<DateTime, List> _events;
  List<String> list = [];
  Clinical clinical = new Clinical();
  List<Clinical> eventList = [];
  var jsonData;
  int counter = 0;
  String currentRole;
  int grade;
  Icon iconSOS;
  bool isButtonDisabled;
  String messageTopic;

  _HomeScreenState(this.currentRole,this.grade);

  @override
  void initState() {
    this.getData();
    super.initState();
    String topic;
    String subTopic;

    //print(topic);
    if(currentRole=='Teacher'){
      setState(() {
        //_firebaseMessaging.unsubscribeFromTopic('test');
        topic = grade.toString()+"-"+currentRole;
        isButtonDisabled=false;
      });

    }else{
      setState(() {
        topic = grade.toString()+"-"+currentRole;
        subTopic = grade.toString()+"-Student";
        _firebaseMessaging.subscribeToTopic(subTopic);
        isButtonDisabled=true;
      });
    }
    _firebaseMessaging.subscribeToTopic(topic);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage:$message");
      final notification = message['notification'];
      setState(() {
        messages.add(
            Message(title: notification['title'], body: notification['body']));
        counter++;
      });
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch:$message");
      //showDia(message);
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume:$message");

      setState(() {
        counter++;
      });
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

  }

  Future getData() async {
    final response = await http.post(Urls.CALENDAR_API);
    setState(() {
      jsonData = json.decode(response.body);
    });
  }

  Future showDia() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications'),
            titleTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple,fontStyle:FontStyle.italic,fontSize: 20.0),
          content: SingleChildScrollView(
              child: ListBody(
            children: messages.map(buildMessage).toList(),
          )),
        );
      },
    );
  }

  Widget buildMessage(Message message) {
    return ListTile(title: Text(message.title), subtitle: Text(message.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          actions: <Widget>[
            isButtonDisabled ? Container():IconButton(
        icon: Icon(Icons.local_hospital,color: Colors.red,size: 40.0),
        onPressed: () {
          soscl(context);
        }
    ),

            // Using Stack to show Notification Badge
            new Stack(
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      showDia();
                      setState(() {
                        counter = 0;
                      });
                    }),
                counter != 0
                    ? new Positioned(
                        right: 11,
                        top: 11,
                        child: new Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '$counter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : new Container()
              ],
            ),
          ],
        ),
        body: Center(
          //child:SpinKitWave(color: Colors.white, type: SpinKitWaveType.start),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: getData,
            child: Column(children: <Widget>[
              //SpinKitWave(color: Colors.black, type: SpinKitWaveType.start),
              Expanded(
                child: eventCard,
              )
            ]),
          ),
        ),
        drawer: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
//model.eventList(jsonData);
              //messageTopic=model.authenticatedUser.uid.toString();
              //_firebaseMessaging.subscribeToTopic(messageTopic);
          return MyDrawer(model);
        }));
    //});
  }

  Widget get eventCard {
    print("hi");
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: jsonData == null ? 0 : jsonData.length,
      padding: new EdgeInsets.all(10.0),
      itemBuilder: (context, index) {
        return ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
          print(jsonData[index]['eventId']);
          return new Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 1.7,
              child: new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: new Column(children: [
                    new Row(children: [
                      new Expanded(
                        child: new GestureDetector(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new Padding(
                                padding: new EdgeInsets.only(
                                    left: 4.0,
                                    right: 8.0,
                                    bottom: 8.0,
                                    top: 8.0),
                                child: new Text(
                                  jsonData[index]['eventName'],
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              new Padding(
                                padding: new EdgeInsets.only(
                                    left: 4.0, right: 4.0, bottom: 4.0),
                                child: new Text(
                                  jsonData[index]['description'],
                                  style: new TextStyle(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EventDetail(jsonData[index]),
                              ),
                            );
                          },
                        ),
                      ),
                      new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: new EdgeInsets.only(top: 8.0),
                              child: new SizedBox(
                                height: 100.0,
                                width: 100.0,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/loading.gif',
                                  image: jsonData[index]['imageUrl'] == null
                                      ? 'https://ichef.bbci.co.uk/news/660/cpsprodpb/1347F/production/_108157987_sickkids_getty.jpg'
                                      : jsonData[index]['imageUrl'],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ])
                    ])
                  ])));
        });
      },
    );
  }

  void soscl(BuildContext context) async {
    launch("tel:0779973563");

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => SosScreen(),
    ));
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
