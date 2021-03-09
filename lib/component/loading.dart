
import 'package:flutter/material.dart';

Set dict = Set();
bool isShow = false;
class Loading{
  static dynamic ctx;

  static void before(uri){
    dict.add(uri);
    //处理并发请求出现多个弹窗
    if(isShow == true || dict.length >= 2){
      return;
    }
    //修改弹窗状态
    isShow = true;
    //打开弹窗
    showDialog(
      context: ctx,
        barrierDismissible: false,
        builder: (context){
        return Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          ),
        );
      }
    );
  }

  static void complete(uri){
    dict.remove(uri);
    //关闭弹窗
    if(dict.length == 0 && isShow) {
      isShow = false;
      Navigator.of(ctx, rootNavigator: true).pop();
    }
  }

}