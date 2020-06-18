import 'package:flutter/material.dart';

class About extends StatefulWidget {
  _AboutState createState() => new _AboutState();
}

class _AboutState extends State<About> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        child: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            highlightColor: Colors.white30,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: new Text(
            '关于应用'
          ),
          //centerTitle:true,
          backgroundColor: Colors.orange,
        ),
        preferredSize: Size.fromHeight(60),
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
              width: double.infinity,
              height: 300.0,
              decoration: new BoxDecoration(
                //color:Colors.white,//white70,
              ),

              child: new ListView(
                  children: <Widget>[
                    new Center(
                      child: new Container(
                        margin: EdgeInsets.only(top: 80.0),
                        //margin: EdgeInsets.only(top:80.0),
                        width: 120.0,
                        height: 120.0,
                        child: Image.asset('image/default_avatar.png'),
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 30.0),
                      child:
                      new Text(
                          '橙盒',
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(
                            color: Colors.black,
                          )
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(top: 3.0),
                      child: new Text(
                        'v1.0.0-qust',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(
                          color: Colors.black38,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ]
              )
          ),
          new Container(
            margin: EdgeInsets.only(top: 30.0),
            child: new Column(
              children: <Widget>[
                new Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: 'Developed by',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black38,
                            )
                        ),
                        TextSpan(
                            text: ' Oran',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.orange,
                            )
                        ),
                        TextSpan(
                          text: 'box',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Align(
                  alignment: Alignment.center,
                  child: new Text(
                    'All rights reserved.',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}