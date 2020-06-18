import 'package:flutter/material.dart';
import 'common.dart';
import 'jsoner.dart';

class ModifyTodo extends StatefulWidget {
  ModifyTodo({Key key}) : super(key: key);

  @override
  ModifyTodoState createState() => new ModifyTodoState();
}

class ModifyTodoState extends State<ModifyTodo> {
  //输入框获取焦点
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  TextEditingController _textControllerTitle = TextEditingController();
  TextEditingController _textControllerDescription = TextEditingController();

  DateTime _tempTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _tempTime.hour, minute: _tempTime.minute));
    if (picked != null) {
      setState(() {
        _tempTime = DateTime(_tempTime.year, _tempTime.month, _tempTime.day,
            picked.hour, picked.minute);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _tempTime,
        firstDate: DateTime(2017),
        lastDate: DateTime(2117));
    if (picked != null) {
      setState(() {
        _tempTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _tempTime.hour,
          _tempTime.minute,
        );
      });
    }
  }

  @override
  void initState() {
    _textControllerTitle.text = Global.jsList[Global.jsListTileIndex].title;
    _textControllerDescription.text =
        Global.jsList[Global.jsListTileIndex].description;
    _tempTime = Global.jsList[Global.jsListTileIndex].time;
  }

  @override
  Widget build(BuildContext context) {
    //设置标题栏下的三个按钮
    List<Widget> list = <Widget>[
      new ListTile(
        title: new Text(
            '${_tempTime.hour.toString().padLeft(2, '0')}:${_tempTime.minute.toString().padLeft(2, '0')}'),
        leading: new Icon(Icons.access_time),
        onTap: () {
          _selectTime(context);
        },
      ),
      new ListTile(
        title: new Text(
            '${_tempTime.year} 年 ${_tempTime.month} 月 ${_tempTime.day} 日，星期${Global.intToWeekday(_tempTime.weekday)}'),
        leading: new Icon(Icons.today),
        onTap: () {
          _selectDate(context);
        },
      ),
    ];

    Widget themeContainer = Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 5),
        child: TextField(
          controller: _textControllerTitle,
          cursorColor: Colors.orange,
          focusNode: focusNode1,
          autofocus: true,
          maxLength: 20,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(hintText: '标题'),
        ));

    //定义容器放置按钮
    Widget buttonCon = Container(
      child: new Padding(
        padding: const EdgeInsets.all(5.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: list),
      ),
    );
    //定义‘其他说明’输入框容器
    Widget noteContainer = Container(
      margin: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
      //padding:const EdgeInsets.all(20.0),
      child: TextField(
        controller: _textControllerDescription,
        focusNode: focusNode2,
        cursorColor: Colors.orange,
        keyboardType: TextInputType.text,
        maxLines: 8,
        decoration: new InputDecoration(
            hintText: '备注',
            border: new OutlineInputBorder(
              //添加边框
              gapPadding: 50.0,
              borderRadius: BorderRadius.circular(0.0),
            ),
            helperStyle: TextStyle(),
            contentPadding: const EdgeInsets.all(10)),
      ), //指定输入方式为文本输入
    );

    return Scaffold(
      appBar: AppBar(
        title: new Text('修改待办事项'),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Builder(
            builder: (context) => new IconButton(
                icon: new Icon(Icons.done),
                //color: Colors.white,
                onPressed: () {
                  _textControllerTitle.text.isNotEmpty
                      ? setState(() {
                          Global.jsList[Global.jsListTileIndex].title =
                              _textControllerTitle.text;
                          Global.jsList[Global.jsListTileIndex].description =
                              _textControllerDescription.text;
                          Global.jsList[Global.jsListTileIndex].time =
                              _tempTime;
                          jsonFileMaker(
                              Global.jsListTitleListIndex == 0
                                  ? Global.defaultJsFile.path
                                  : Global
                                      .jsFilesList[
                                          Global.jsListTitleListIndex - 1]
                                      .path,
                              Global.jsList);
                          Navigator.pop(context);
                        })
                      : setState(() {
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                              new SnackBar(content: new Text("请输入标题。")));
                        });
                } //按下保存回调
                ),
          )
        ],
      ),
      //ListView包装各个容器
      body: ListView(
        children: <Widget>[
          themeContainer, //标题输入
          buttonCon, //按钮组
          noteContainer, //‘其他说明’
        ],
      ),
    );
  }

  //日前按钮,设置默认显示的日期为当前
  DateTime initialDate = DateTime.now();

  void showDefaultYearPicker(BuildContext context) async {
    final DateTime dateTime = await showDatePicker(
      context: context,
      //定义控件打开时默认选择日期
      initialDate: initialDate,
      //定义控件最早可以选择的日期
      firstDate: DateTime(2018, 1),
      //定义控件最晚可以选择的日期
      lastDate: DateTime(2022, 1),
    );
    if (dateTime != null && dateTime != initialDate) {}
  }
}
