import 'package:flutter/material.dart';
import 'package:frontend_for_owners/routes/routes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 账号输入框
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: '手机号',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入手机号';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          // 密码输入框
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: '密码',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入密码';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          // 登录按钮
          Ink(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // 处理登录逻辑
                  print("账号: ${_usernameController.text}");
                  print("密码: ${_passwordController.text}");
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.all(16),
                child: Text(
                  "登录",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RoutePath.resetPasswordPage);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text("忘记密码？"),
            ),
          )
        ],
      ),
    );
  }
}
