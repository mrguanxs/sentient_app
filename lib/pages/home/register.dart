import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{

  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage>{

  @override
  Widget build(BuildContext context) {
    final GlobalKey _formKey= new GlobalKey<FormState>();
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
                onPressed: (){
                  if((_formKey.currentState as FormState).validate()){
                    //todo 注册请求
                    print('注册');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}