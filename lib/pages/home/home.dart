import 'package:flutter/material.dart';
import 'package:sentient_app/pages/home/my_drawer.dart';
import 'package:sentient_app/pages/home/register.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[  //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: _onShare),
        ],
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar( //底部导航栏
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: '聊天'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: '好友'),
          BottomNavigationBarItem(icon: Icon(Icons.apartment_rounded), label: '社区'),
          BottomNavigationBarItem(icon: Icon(Icons.account_box_rounded), label: '我的'),
        ],
        type: BottomNavigationBarType.fixed, //解决导航栏超过3个不显示颜色
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _onAdd,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onItemTapped(int index) {
    print('index:' + index.toString());
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAdd() {
    print('add');
  }

  void _onShare() {
    print('share');
  }
}