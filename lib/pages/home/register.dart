import 'package:flutter/material.dart';
import 'package:sentient_app/api/apis.dart';
import 'package:sentient_app/entity/entity.dart';
import 'package:sentient_app/pages/home/login.dart';

class RegisterPage extends StatefulWidget{

  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage>{
  final GlobalKey _formKey= new GlobalKey<FormState>();
  TextEditingController _usernameController =  TextEditingController();
  TextEditingController _passwordController =  TextEditingController();
  TextEditingController _emailController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('注册')),
      body: Container(
        padding: EdgeInsets.all(55.0),
        child: Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    //用户名
                    TextFormField(
                      autofocus: false,
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,vertical: 10
                        ),
                        hintText: '用户名',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)
                        )
                      ),
                      validator: (value){
                        if(value.length < 1){
                          return '请输入用户名';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      autofocus: false,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,vertical: 10
                          ),
                          hintText: '邮箱',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                      validator: (value){
                        RegExp reg = new RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$');
                        if(!reg.hasMatch(value)){
                          return '请输入邮箱';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      autofocus: false,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,vertical: 10
                          ),
                          hintText: '密码',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          )
                      ),
                      validator: (value){
                        if(value.length < 6){
                          return '密码最少6位';
                        }
                        return null;
                      },
                    )
                  ],
                )
            ),
            SizedBox(height: 25),
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width -110,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: FlatButton(
                child: Text(
                  '注册',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: _onRegister
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRegister() async {
    //验证表单
    if((_formKey.currentState as FormState).validate()){
      //登录请求
      UserInfoEntity user;
      try{
        print('发起注册');
        user = await AuthApi.register(_usernameController.text, _emailController.text, _passwordController.text);
        print('user' + user.toString());
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context){
              return LoginPage();
            })
        );
      }catch(e){
        print('注册失败');
      }finally{
        print('注册结束');
      }
    }
  }
}