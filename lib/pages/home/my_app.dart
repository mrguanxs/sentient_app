import 'package:flutter/material.dart';
import 'package:sentient_app/pages/home/home.dart';
import 'package:sentient_app/tool/cache_tool.dart';

import 'login.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  //判断是否登录
  bool _ifLogin = false;
  _getLoginState() async {
    _ifLogin = await CacheTool.getLoginState();
  }

  @override
  void initState() {
    super.initState();
    //判断是否登录
    _getLoginState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentient',
      theme: ThemeData(
        //icon主题色
        primaryIconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.light,
        primaryColor: new Color.fromRGBO(255, 0, 215, 1.0),
        accentColor: Colors.cyan[300],
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _ifLogin ? MyHomePage(title: 'Home') : LoginPage()
    );

  }



}