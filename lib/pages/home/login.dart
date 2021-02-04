import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{

  @override
  State createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>{
  final GlobalKey _formKey= new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Container(
        padding: EdgeInsets.all(55.0),
        //垂直布局
        child: Column(
          children: <Widget>[
            //使用form表单
            Form(
              key: _formKey,
                child: Column(
                  children: <Widget>[
                    //用户名
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10
                        ),
                        hintText: '用户名或邮箱',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      validator: (value){
                        if(value.length < 1){
                          return '请输入用户名或邮箱';
                        }
                        return null;
                      },
                    ),
                    // 间隔
                    SizedBox(height: 20),
                    //密码
                    TextFormField(
                      obscureText: true,
                      autofocus: false,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10
                        ),
                        hintText: '密码',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      validator: (value){
                        if(value.length <6){
                          return '密码最少6位';
                        }
                        return null;
                      },
                    )
                  ],
                )
            ),
            Row(
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width -200,),
                FlatButton(
                    child: Text('找回密码'),
                    onPressed: (){
                      //todo 找回密码页面
                      print('找回密码');
                    }
                )
              ],
            ),
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width -110,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: FlatButton(
                child: Text(
                  '登录',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: (){
                  if((_formKey.currentState as FormState).validate()){
                    //todo 登录请求
                    print('登录');
                  }
                },
              ),
            ),
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width -110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)
              ),
              child: FlatButton(
                child: Text(
                  '注册账号',
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: (){
                  //todo 注册页面
                  print('注册');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}