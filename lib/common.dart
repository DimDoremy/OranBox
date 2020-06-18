import 'jsoner.dart';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'dart:convert';

/// 重写FIleImage类，使头像动态刷新
class FileImageEx extends FileImage {
  int fileSize;

  FileImageEx(File file, {double scale = 1.0})
      : assert(file != null),
        assert(scale != null),
        super(file, scale: scale) {
    fileSize = file.lengthSync();
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final FileImageEx typedOther = other;
    return file?.path == typedOther.file?.path &&
        scale == typedOther.scale &&
        fileSize == typedOther.fileSize;
  }
}

class Global {

  static List<Jsoner> jsList; //從json讀取的列表
  static String jsStr; //從內置文件中預讀的字符串（寫入應用目錄用）
  static List<FileSystemEntity> jsFilesList; //js文件遍历列表
  static List jsListTitleList = List(); //存储jsList名称的列表
  static var jsListTitleListIndex;
  static String jsListTitle;
  static var jsListTileIndex;
  static var jsClass; //JSON類列表
  static File defaultJsFile; //應用目錄中的預置json文件
  static Directory jsFilesDir;
  static bool isDefaultJsFileExists;
  static bool isUserJsDirExists;

  static File userAvatar; //用戶頭像
  static bool isUserAvatarExists;

  static SharedPreferences prefs;
  static String userName;
  static String userStatic;
  static int advanceTimeForTileColorChanging;

  static Future<File> _getLocalFile() async {
    // 获取应用目录
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/default_todo_list.json');
  }

  /// 遍历用户json文件夹
  static Future listUserJsDir() async {
    jsFilesList = jsFilesDir.listSync();
    jsFilesList.sort((a, b) => a.path.compareTo(b.path));

    /// 生成title列表
    jsListTitleList.clear();
    for (var i in jsFilesList) {
      String filename = basename(i.path).replaceAll('_', '/');
      var bytes = base64Decode(filename.substring(14, filename.length - 5));
      var title = utf8.decode(bytes);
      jsListTitleList.add(title);
    }
  }

  /// int转星期
  static String intToWeekday(int a) {
    switch (a) {
      case 1:
        return '一';
        break;
      case 2:
        return '二';
        break;
      case 3:
        return '三';
        break;
      case 4:
        return '四';
        break;
      case 5:
        return '五';
        break;
      case 6:
        return '六';
        break;
      case 7:
        return '日';
        break;
    }
  }

  /// 初始化应用数据
  static Future init() async {

    /// 初始化预设列表
    defaultJsFile = new File(
        '${(await getApplicationDocumentsDirectory()).path}/default_todo_list.json');

    /// 如果預設json文件不存在則以預先準備的文件創建之
    isDefaultJsFileExists = await defaultJsFile.exists();
    if (isDefaultJsFileExists == false) {
      jsStr = await rootBundle.loadString('json/test.json');
      defaultJsFile = await _getLocalFile();
      await defaultJsFile.writeAsString(jsStr);
    }

    /// 将默认json list写入jsList类中
    decodeGetClass(defaultJsFile.path).then((list) {
      jsList = list;
    });
    jsListTitle = '任务';
    jsListTitleListIndex = 0;

    jsFilesDir = new Directory(
        '${(await getApplicationDocumentsDirectory()).path}/user_js_list');
    isUserJsDirExists = await jsFilesDir.exists();
    if (isUserJsDirExists == false) {
      jsFilesDir.create();
    }

    await listUserJsDir();

    userAvatar = new File(
        '${(await getApplicationDocumentsDirectory()).path}/user_avatar.avt');
    isUserAvatarExists = await userAvatar.exists();

    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('USERNAME') == null)
      prefs.setString('USERNAME', '橙盒用户');
    if (prefs.getString('USERSTATIC') == null)
      prefs.setString('USERSTATIC', '有计划的一天从橙盒开始。');
    if (prefs.getInt('ADVANCETIMEFORTILECOLORCHANGING') == null)
      prefs.setInt('ADVANCETIMEFORTILECOLORCHANGING', 5);
    userName = prefs.getString('USERNAME');
    userStatic = prefs.getString('USERSTATIC');
    advanceTimeForTileColorChanging = prefs.getInt('ADVANCETIMEFORTILECOLORCHANGING');

  }
}