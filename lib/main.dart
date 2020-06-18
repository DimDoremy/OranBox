import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dart:io';

import 'common.dart';
import 'app_drawer.dart';
import 'todo_list_view.dart';
import 'add_todo.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '橙盒',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: '待辦事項清單'),
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
    );
  }
}

// 应用主页
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// 应用主页State类
class _MyHomePageState extends State<MyHomePage> {
  void _handleDrawerChanged(newValue) {
    setState(() {
      print('newValue');
      Global.jsList = newValue;
    });
  }

  void _handleTodoListViewChanged(newValue) {
    setState(() {
      print('newValueTodoListView');
      Global.jsList = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 脚手架
    return new Scaffold(
      // 抽屉
      drawer: new AppDrawer(onChanged: _handleDrawerChanged),
      // 客制滚动界面
      body: new TodoListView(
        title: widget.title,
        onChanged: _handleTodoListViewChanged,
      ),
      //悬浮按钮
      floatingActionButton: new FloatingActionButton(
          // 图标
          child: Icon(Icons.add),
          // 按下动作
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddTodo();
            }));
          }),
    );
  }
}
