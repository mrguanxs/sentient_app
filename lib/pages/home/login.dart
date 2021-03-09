import 'package:flutter/material.dart';
import 'package:sentient_app/api/apis.dart';
import 'package:sentient_app/component/loading.dart';
import 'package:sentient_app/entity/entity.dart';
import 'package:sentient_app/pages/home/home.dart';
import 'package:sentient_app/pages/home/register.dart';

class LoginPage extends StatefulWidget{

  @override
  State createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>{
  final GlobalKey _formKey= new GlobalKey<FormState>();

  TextEditingController _usernameController =  TextEditingController();
  TextEditingController _passwordController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('home  $context');
    print('home  ${Navigator.of(context)}');
    Loading.ctx = context;//注入context
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
                      controller: _usernameController,
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
                      controller: _passwordController,
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
                onPressed: _onLogin,
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
                onPressed: () async {
                  //todo 注册页面
                  print('注册');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return RegisterPage();
                      })
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 void _onLogin() async {
    //验证表单
   if((_formKey.currentState as FormState).validate()){
     //登录请求
     UserInfoEntity user;
     try{
       print('发起登录');
       user = await AuthApi.pwdLogin(_usernameController.text, _passwordController.text);
       print('user' + user.toString());
       Navigator.push(
           context,
           MaterialPageRoute(builder: (context){
             return MyHomePage(title: user.username,);
           })
       );
     }catch(e){
       print('登录失败');
     }finally{
       print('登录结束');
     }
   }
  }


}