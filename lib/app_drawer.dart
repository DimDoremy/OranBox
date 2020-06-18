import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'common.dart';
import 'settings.dart';
import 'user_info.dart';
import 'jsoner.dart';

// 抽屉
class AppDrawer extends StatefulWidget {
  AppDrawer({Key key, @required this.onChanged}) : super(key: key);

  final ValueChanged onChanged;

  @override
  _AppDrawerState createState() => new _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  /// 创建新Json文件（新Todo List）
  Future _createNewJsonFile(String listName) async {
    var bytes = utf8.encode(listName);
    String base64 = base64Encode(bytes).replaceAll('/', '_');
    var now = new DateTime.now();
    var file = new File(
        '${Global.jsFilesDir.path}/${now.year.toString()}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}$base64.json');
    await file.create();
    jsonFileMaker(file.path, new List<Jsoner>());
    await Global.listUserJsDir();
    var len = Global.jsListTitleList.length;
    print(len);
    Future.delayed(Duration(microseconds: 500), () {
      decodeGetClass(Global.jsFilesList[Global.jsListTitleList.length - 1].path)
          .then((list) {
        widget.onChanged(list);
        Global.jsList = list;
        Global.jsListTitle =
            Global.jsListTitleList[Global.jsListTitleList.length - 1];
        Global.jsListTitleListIndex = Global.jsListTitleList.length;
        Navigator.of(context).pop(true);
      });
    });
  }

  /// 弹出新建清单对话框
  Future<bool> _showCreateListDialog() {
    TextEditingController _textController = TextEditingController();
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('清单名称'),
            content: TextField(
              controller: _textController,
              autofocus: true,
              maxLength: 8,
              onChanged: (_) {
                (context as Element).markNeedsBuild();
              },
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('取消')),
              FlatButton(
                onPressed: (_textController.text.isNotEmpty)
                    ? () {
                        _createNewJsonFile(_textController.text);
                        Navigator.pop(context);
                      }
                    : null,
                child: Text('确定'),
                disabledTextColor: Colors.grey,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Material(
                  child: Ink(
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                new MaterialPageRoute(builder: (context) {
                              return UserInfo();
                            }));
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 30.0, bottom: 20),
                            color: Colors.orangeAccent,
                            child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.settings),
                                      onPressed: () {
                                        Navigator.push(context,
                                            CupertinoPageRoute(
                                                builder: (context) {
                                          return Settings();
                                        }));
                                      },
                                    ),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0),
                                          child: Hero(
                                            tag: '抽屉头像',
                                            child: ClipOval(
                                                child: Global.isUserAvatarExists
                                                    ? Image(
                                                        image: FileImageEx(
                                                            Global.userAvatar),
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover)
                                                    : Image.asset(
                                                        'image/default_avatar.png',
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover)),
                                          ),
                                        ),
                                        Text(
                                          Global.userName.isEmpty
                                              ? '橙盒用户'
                                              : Global.userName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: (Text(
                                                Global.userStatic.isEmpty
                                                    ? '有计划的一天从橙盒开始。'
                                                    : Global.userStatic))),
                                      ]),
                                ]),
                          )))),
              Expanded(
                  child: ListView.builder(
                      itemCount: Global.jsListTitleList.length + 1,
                      itemBuilder: (context, index) {
                        Color _iconColor = index == Global.jsListTitleListIndex
                            ? Colors.orange
                            : Colors.grey;
                        return index == 0
                            ? ListTile(
                                leading: Icon(
                                  Icons.bookmark,
                                  color: _iconColor,
                                ),
                                title: const Text('任务'),
                                onTap: () {
                                  Global.jsListTitle = '任务';
                                  decodeGetClass(Global.defaultJsFile.path)
                                      .then((list) {
                                    widget.onChanged(list);
                                    Global.jsList = list;
                                    Global.jsListTitleListIndex = index;
                                    Navigator.pop(context);
                                  });
                                },
                              )
                            : ListTile(
                                leading: Icon(Icons.list, color: _iconColor),
                                title: Text(Global.jsListTitleList[index - 1]),
                                onTap: () {
                                  Global.jsListTitle =
                                      Global.jsListTitleList[index - 1];
                                  decodeGetClass(Global.jsFilesList[index - 1]
                                          .path)
                                      .then((list) {
                                    widget.onChanged(list);
                                    Global.jsList = list;
                                    print(list);
                                    Global.jsListTitleListIndex = index;
                                    print(Global.jsListTitleList.length);
                                    Navigator.pop(context);
                                  });
                                },
                              );
                      })),
              ListTile(
                leading: const Icon(Icons.add, size: 36, color: Colors.orange),
                title: const Text(
                  '新建待办清单',
                  textScaleFactor: 1.25,
                  style: TextStyle(color: Colors.orange),
                ),
                onTap: () {
                  setState(() {
                    _showCreateListDialog();
                  });
                },
              ),
            ])));
  }
}
