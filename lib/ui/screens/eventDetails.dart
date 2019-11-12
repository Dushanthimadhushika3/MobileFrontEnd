import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetail extends StatefulWidget {
  final events;
  EventDetail(this.events);
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
        title: Text("Events"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                "${widget.events['eventName'] == null ? 'Title Here' : widget.events['eventName']}",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: widget.events['eventName'],
                    child: FadeInImage.assetNetwork(
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      height: 280.0,
                      width: MediaQuery.of(context).size.width,
                      placeholder:
                          'assets/loading.gif',
                      image: widget.events['imageUrl'] == null
                          ? 'https://ichef.bbci.co.uk/news/660/cpsprodpb/1347F/production/_108157987_sickkids_getty.jpg'

                          : widget.events['imageUrl'],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Venue : ",
                    style: Theme.of(context).textTheme.body2,
                  ),
                  Expanded(
                    child: Text(
                      "${widget.events['venue'] == null ? 'Ananymous Author' : widget.events['venue'].toString()}",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Date : ",
                    style: Theme.of(context).textTheme.body2,
                  ),
                  Expanded(
                    child: Text(
                      "${widget.events['date'] == null ? 'Ananymous Author' : widget.events['date'].toString()}",
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
              child: Text(
                  "${widget.events['description'] == null ? 'Description of Article' : widget.events['description']}",
                  style: Theme.of(context).textTheme.subhead),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "For More Info Contact Sick Room Officer",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
