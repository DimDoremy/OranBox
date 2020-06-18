import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' hide context;

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'common.dart';
import 'modify_todo.dart';
import 'jsoner.dart';

class ChangeListName extends StatefulWidget {
  ChangeListName({Key key}) : super(key: key);

  @override
  _ChangeListNameState createState() => _ChangeListNameState();
}

class _ChangeListNameState extends State<ChangeListName> {
  TextEditingController _textController = TextEditingController();

  Future _renameJsonFile(String listName) async {
    var bytes = utf8.encode(listName);
    String base64 = base64Encode(bytes).replaceAll('/', '_');
    File file = File(Global.jsFilesList[Global.jsListTitleListIndex - 1].path);
    var fileName =
        basename(Global.jsFilesList[Global.jsListTitleListIndex - 1].path);
    String fileTimeTag = fileName.substring(0, 14);
    await file.rename('${Global.jsFilesDir.path}/$fileTimeTag$base64.json');
    await Global.listUserJsDir().then((_) => Global.jsListTitle =
        Global.jsListTitleList[Global.jsListTitleListIndex - 1]);
  }

  @override
  void initState() {
    _textController.text = Global.jsListTitle;
    _textController.selection =
        TextSelection(baseOffset: 0, extentOffset: _textController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('重命名清单'),
        actions: <Widget>[
          Builder(
              builder: (context) => new IconButton(
                  icon: new Icon(Icons.done),
                  onPressed: () {
                    _textController.text.isNotEmpty
                        ? setState(() {
                            _renameJsonFile(_textController.text)
                                .then((_) => Navigator.pop(context));
                          })
                        : setState(() {
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                                new SnackBar(content: new Text("请输入标题。")));
                          });
                  }))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: TextField(
          controller: _textController,
          autofocus: true,
          maxLength: 8,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.edit),
            labelText: '清单名称',
          ),
        ),
      ),
    );
  }
}

class TodoListView extends StatefulWidget {
  TodoListView({Key key, this.title, @required this.onChanged})
      : super(key: key);

  final title;
  final ValueChanged onChanged;

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  // 滑动性控制器
  final SlidableController slidableController = SlidableController();

  Future _deleteList() async {
    File file = File(Global.jsFilesList[Global.jsListTitleListIndex - 1].path);
    await file.delete();
    await Global.listUserJsDir().then((_) {
      Global.jsListTitle = '任务';
      decodeGetClass(Global.defaultJsFile.path).then((list) {
        widget.onChanged(list);
        Global.jsList = list;
        Global.jsListTitleListIndex = 0;
        Navigator.of(context).pop(true);
      });
    });
  }

  Future<bool> _showDeleteListDialog() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('删除清单'),
            content: Text('您确定要删除该清单？'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('取消')),
              FlatButton(
                onPressed: () {
                  setState(() {
                    _deleteList();
                  });
                },
                child: Text('确定'),
                disabledTextColor: Colors.grey,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      ///物理：总是可滑动（无效）
      physics: const AlwaysScrollableScrollPhysics(),

      /// 切片
      slivers: <Widget>[
        /// 切片应用栏
        SliverAppBar(
          /// 活动栏大小
          expandedHeight: 200.0,

          /// 滑动相关参数
          floating: false,
          pinned: true,
          snap: false,
          forceElevated: true,

          /// 主题明暗
          brightness: Brightness.light,

          /// 右侧按钮
          actions: Global.jsListTitleListIndex == 0
              ? null
              : <Widget>[
                  PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                          value: 'rename',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('重命名该清单'),
                          )),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                            leading: Icon(Icons.delete), title: Text('删除该清单')),
                      )
                    ],
                    onSelected: (String action) {
                      setState(() {
                        switch (action) {
                          case 'rename':
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChangeListName();
                            }));
                            break;
                          case 'delete':
                            _showDeleteListDialog();
                            break;
                        }
                      });
                    },
                  )
                ],

          /// 活动栏
          flexibleSpace: FlexibleSpaceBar(
            // 标题是否居中
            centerTitle: true,
            title: GestureDetector(
              child: Text(Global.jsListTitle),
              onTap: () {
                if (Global.jsListTitleListIndex != 0) {
                  setState(() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChangeListName();
                    }));
                  });
                }
              },
            ),
            background: Image.asset(
              "image/appbar_background.jpg",
              color: Colors.orange,
              // 色彩合成模式
              colorBlendMode: BlendMode.color,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),

        /// 切片滚动列表
        Global.jsList.isEmpty
            ? SliverFillRemaining(
                child: Center(
                child: Text(
                  '这里什么都还没有哦～\n快使用右下角的「＋」按钮来新建一条待办事项吧！',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ))
            : SliverFixedExtentList(
                /// 列表项大小
                itemExtent: 70,

                /// 生成切片列表项
                delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    /// 根据列表项是否被勾选以应用删除线
                    TextStyle textStyle = Global.jsList[index].isFinished
                        ? TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey)
                        : TextStyle();

                    void _handleCheckCircleChanged(bool newValue) {
                      setState(() {
                        Global.jsList[index].isFinished = newValue;
                      });
                    }

                    /// 删除列表项
                    void _deleteItem() {
                      setState(() {
                        var removedItem = Global.jsList[index];
                        Global.jsList.removeAt(index);
                        jsonFileMaker(
                            Global.jsListTitleListIndex == 0
                                ? Global.defaultJsFile.path
                                : Global
                                    .jsFilesList[
                                        Global.jsListTitleListIndex - 1]
                                    .path,
                            Global.jsList);
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("已删除待办事项「${removedItem.title}」。"),
                          action: new SnackBarAction(
                              label: '撤销',
                              onPressed: () {
                                setState(() {
                                  Global.jsList.insert(index, removedItem);
                                  jsonFileMaker(
                                      Global.jsListTitleListIndex == 0
                                          ? Global.defaultJsFile.path
                                          : Global
                                              .jsFilesList[
                                                  Global.jsListTitleListIndex -
                                                      1]
                                              .path,
                                      Global.jsList);
                                });
                              }),
                        ));
                      });
                    }

                    return new Slidable(
                      actionPane: SlidableBehindActionPane(),

                      /// 滑动按钮半径
                      actionExtentRatio: 0.20,
                      key: new Key(index.toString()),
                      controller: slidableController,
                      //onDismissed: (direction),
                      /// 居中容器
                      child: Material(
                        child: Ink(
                          child: InkWell(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.centerLeft,

                                /// 列表项
                                child: new AnimatedSwitcher(
                                  /// 持续时间
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    ///执行缩放动画
                                    return FadeTransition(
                                        child: child, opacity: animation);
                                  },
                                  child: Container(
                                    color: Global.jsList[index].isFinished
                                        ? Colors.grey[200]
                                        : Global.jsList[index].time
                                                .isBefore(DateTime.now())
                                            ? Color.fromARGB(100, 255, 107, 42
                                    )
                                            : DateTime.now()
                                                    .add(Duration(
                                                        minutes: Global
                                                            .advanceTimeForTileColorChanging))
                                                    .isAfter(Global
                                                        .jsList[index].time)
                                                ? Colors.orange[100]
                                                : null,
                                    child: ListTile(
                                      // key: Key(Global.listItems[index][0] +
                                      //    Global.listItems[index][1] + textStyle.toString()),
                                      /// 列表项头：动画勾选圈
                                      key: ValueKey<int>(
                                          Global.jsList[index].isFinished
                                              ? 1
                                              : 0),
                                      leading: new AnimatedCheckCircle(
                                        index: index,
                                        onChanged: _handleCheckCircleChanged,
                                      ),
                                      title: Text(
                                        '${Global.jsList[index].title}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: textStyle,
                                      ),
                                      subtitle: Global.jsList[index].time
                                                  .isBefore(DateTime.now()) &&
                                              !Global.jsList[index].isFinished
                                          ? Text('已逾时', style: textStyle)
                                          : Global.jsList[index].description
                                                  .isNotEmpty
                                              ? Text(
                                                  '${Global.jsList[index].description}',
                                                  style: textStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                )
                                              : Text(
                                                  '截止时间：${Global.jsList[index].time.year} 年 ${Global.jsList[index].time.month} 月 ${Global.jsList[index].time.day} 日　${Global.jsList[index].time.hour.toString().padLeft(2, '0')}:${Global.jsList[index].time.minute.toString().padLeft(2, '0')}',
                                                  style: textStyle),

                                      /// 点击动作
                                      onTap: () {
                                        Global.jsListTileIndex = index;
                                        //导航到新路由
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ModifyTodo();
                                        }));
                                      },
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),

                      /// 滑动按钮
                      actions: <Widget>[
                        IconSlideAction(
                          caption: '删除',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: _deleteItem,
                        ),
                      ],

                      /// 另一个方向的按钮
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: '删除',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: _deleteItem,
                        ),
                      ],
                    );
                  },

                  /// 列表项数量
                  childCount: Global.jsList.length,
                ),
              ),
      ],
    );
  }
}

/// 动画勾选圈
class AnimatedCheckCircle extends StatefulWidget {
  const AnimatedCheckCircle({this.index, @required this.onChanged, Key key})
      : super(key: key);

  @override
  _AnimatedCheckCircleState createState() => _AnimatedCheckCircleState();

  /// 列表项定位
  final index;
  final ValueChanged<bool> onChanged;
}

///动画勾选圈State类
class _AnimatedCheckCircleState extends State<AnimatedCheckCircle> {
  bool checkCircleIsTapped = true;

  @override
  Widget build(BuildContext context) {
    /// 动画切换器
    return AnimatedSwitcher(
      /// 持续时间
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        ///执行缩放动画
        return ScaleTransition(child: child, scale: animation);
      },

      /// 图标按钮
      child: new IconButton(
        icon: Global.jsList[widget.index].isFinished
            ? Icon(
                Icons.check_circle,
                color: Colors.orange,
              )
            : Icon(
                Icons.check_circle_outline,
              ),
        iconSize: 28,

        ///当key变化时，动画生效
        key: ValueKey<int>(checkCircleIsTapped ? 1 : 0),

        onPressed: () {
          setState(() {
            /// 切换当前列表项勾选状态
            widget.onChanged(Global.jsList[widget.index].isFinished =
                !Global.jsList[widget.index].isFinished);
            checkCircleIsTapped = !checkCircleIsTapped;
            jsonFileMaker(
                Global.jsListTitleListIndex == 0
                    ? Global.defaultJsFile.path
                    : Global.jsFilesList[Global.jsListTitleListIndex - 1].path,
                Global.jsList);
          });
        },
      ),
    );
  }
}
