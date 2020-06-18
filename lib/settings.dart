import 'package:flutter/material.dart';

import 'common.dart';
import 'about.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> setAdvanceTimeForTileColorChanging() async {
    int i = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('设置提醒时间'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 5);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('5 分钟'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 10);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('10 分钟'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 30);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('30 分钟'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 60);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('1 小时'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 120);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('2 小时'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 180);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('3 小时'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 360);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text('6 小时'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 720);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: const Text('12 小时'),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1440);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Text('24 小时'),
                ),
              ),
            ],
          );
        });

    if (i != null) {
      setState(() {
        Global.advanceTimeForTileColorChanging = i;
        Global.prefs.setInt('ADVANCETIMEFORTILECOLORCHANGING',
            Global.advanceTimeForTileColorChanging);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('设置'),
        ),
        body: new ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text(
                '待办事项条目逾期变色提醒',
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              title: Text('设置提醒时间'),
              subtitle: Text('提前 ${Global.advanceTimeForTileColorChanging < 60 ? '${Global
                  .advanceTimeForTileColorChanging} 分钟' : '${(Global
                  .advanceTimeForTileColorChanging ~/ 60)} 小时'}变色条目以提醒逾期'),
              onTap: () {
                setState(() {
                  setAdvanceTimeForTileColorChanging();
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 10),
              child: Text(
                '关于',
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              title: Text('关于应用'),
              subtitle: Text('开发团队与版本信息'),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return About();
                }));
              },
            ),
          ],
        ));
  }
}
