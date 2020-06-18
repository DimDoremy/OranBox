import 'dart:convert';
import 'dart:io';

// 用于保存 json 数据的类
class Jsoner {
  // 解析 json 中的成员（全部定义公有）
  String title;
  String description;
  DateTime time;
  bool isFinished;

  // 构造函数
  Jsoner(this.title, this.description, int year, int month,
      int day, int hour, int minute, this.isFinished) {
    this.time = new DateTime(year, month, day, hour, minute);
  }

  // 从解析好的Map中生成的构造函数
  Jsoner.fromJson(Map jsonMap) {
    this.title = jsonMap["Title"];
    this.description = jsonMap["Description"];
    this.time = new DateTime(jsonMap["TimeYear"], jsonMap["TimeMonth"],
        jsonMap["TimeDay"], jsonMap["TimeHour"], jsonMap["TimeMinute"]);
    this.isFinished = jsonMap["isFinished"];
  }

  // 将类转换为键值对方法
  Map toMap() {
    Map map = new Map();
    map['Title'] = this.title;
    map['Description'] = this.description;
    map['TimeYear'] = this.time.year;
    map['TimeMonth'] = this.time.month;
    map['TimeDay'] = this.time.day;
    map['TimeHour'] = this.time.hour;
    map['TimeMinute'] = this.time.minute;
    map['isFinished'] = this.isFinished;
    return map;
  }

  // 重载 toString 方法
  @override
  String toString() {
    String jsonStr = '{' +
        'Title: ' +
        this.title.toString() +
        ", " +
        'Description: ' +
        this.description.toString() +
        ", " +
        'TimeYear: ' +
        this.time.year.toString() +
        ", " +
        'TimeMonth: ' +
        this.time.month.toString() +
        ", " +
        'TimeDay: ' +
        this.time.day.toString() +
        ", " +
        'TimeHour: ' +
        this.time.hour.toString() +
        ", " +
        'TimeMinute: ' +
        this.time.minute.toString() +
        ", " +
        'isFinished: ' +
        this.isFinished.toString() +
        '}';
    return jsonStr;
  }
}

// 读取文件部分
// 变量：读取文件名
// 返回值：文件内容的字符串
Future<String> readIOSync(String fileName) async {
    File readFile = new File(fileName);
    return readFile.readAsString().then((_){
      return _;
    });
}

// 写入文件部分
// 变量：读取文件名，写入文本
// 返回值：布尔变量
bool writeIOSync(String fileName, String text) {
  try {
    File writeFile = new File(fileName);
    var sink = writeFile.openWrite();
    sink.write(text);
    sink.close();
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

// 解析并得到 jsoner 类的包装函数
// 变量：读取文件名
// 返回值：由 jsoner 类构成的 list
Future<List<Jsoner>> decodeGetClass(String filename) async {
  String _str = await readIOSync(filename);
  List _list = jsonDecode(_str);
  List<Jsoner> _jsList = List();
  for (var item in _list) {
    _jsList.add(new Jsoner.fromJson(item));
  }
  return _jsList;
}

// 通过 jsoner 类新建/覆写文件
// 变量：读取文件名，jsoner 类的 list
// 返回值：布尔变量
bool jsonFileMaker(String fileName, List<Jsoner> list) {
  List<Map> jsonList = new List(); // 用于存储类转换后的 list
  for (var item in list) {
    jsonList.add(item.toMap());
  }
  String jsonStr = jsonEncode(jsonList);
  if (writeIOSync(fileName, jsonStr)) {
    return true;
  }
  return false;
}