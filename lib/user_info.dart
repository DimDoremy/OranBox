import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'common.dart';

class UserInfo extends StatefulWidget {
  UserInfo({Key key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Future<File> getLocalUserAvatar(File file) async {
    var localUserAvatar;
    // 获取应用目录
    await file
        .copy(
            '${(await getApplicationDocumentsDirectory()).path}/user_avatar.avt')
        .then((fl) {
      localUserAvatar = fl;
    });
    return localUserAvatar;
  }

  Future getImage() async {
    var pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    await getLocalUserAvatar(pickedImage).then((image) {
      setState(() {
        Global.userAvatar = image;
        Global.isUserAvatarExists = true;
        pickedImage.delete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('个人信息'),
      ),
      body: new Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: new Hero(
                    tag: '抽屉头像',
                    child: GestureDetector(
                        child: ClipOval(
                            child: Global.isUserAvatarExists
                                ? Image(
                                    image: FileImageEx(Global.userAvatar),
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover)
                                : Image.asset('image/default_avatar.png',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover)),
                        onTap: getImage)),
              )),
          Material(
            child: Ink(
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChangeUserName();
                  }));
                },
                child: Container(
                    child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.person,
                          size: 30,
                        ),
                        width: 60,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '用户名',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Container(
                            height: 5,
                          ),
                          Text(
                            Global.userName.isEmpty ? '橙盒用户' : Global.userName,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ),
            ),
          ),
          Material(
            child: Ink(
              child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChangeUserStatic();
                    }));
                  },
                  child: Container(
                      child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.mode_edit,
                            size: 30,
                          ),
                          width: 60,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '个性签名',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Container(
                              height: 5,
                            ),
                            Text(
                              Global.userStatic.isEmpty ? '有计划的一天从橙盒开始。' : Global.userStatic,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    ),
                  ))),
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeUserName extends StatefulWidget {
  ChangeUserName({Key key}) : super(key: key);

  @override
  _ChangeUserNameState createState() => _ChangeUserNameState();
}

class _ChangeUserNameState extends State<ChangeUserName> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = Global.userName;
    _textController.selection =
        TextSelection(baseOffset: 0, extentOffset: _textController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改用户名'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                setState(() {
                  Global.userName = _textController.text;
                  Global.prefs.setString('USERNAME', Global.userName);
                  Navigator.pop(context);
                });
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: TextField(
          controller: _textController,
          autofocus: true,
          maxLength: 8,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: '用户名',
              hintText: '橙盒用户'),
        ),
      ),
    );
  }
}

class ChangeUserStatic extends StatefulWidget {
  ChangeUserStatic({Key key}) : super(key: key);

  @override
  _ChangeUserStaticState createState() => _ChangeUserStaticState();
}

class _ChangeUserStaticState extends State<ChangeUserStatic> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = Global.userStatic;
    _textController.selection =
        TextSelection(baseOffset: 0, extentOffset: _textController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改个性签名'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                setState(() {
                  Global.userStatic = _textController.text;
                  Global.prefs.setString('USERSTATIC', Global.userStatic);
                  Navigator.pop(context);
                });
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: TextField(
          controller: _textController,
          autofocus: true,
          maxLength: 16,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.edit),
            labelText: '个性签名',
          ),
        ),
      ),
    );
  }
}
