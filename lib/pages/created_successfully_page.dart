// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend_for_owners/pages/home_page.dart';
import 'package:frontend_for_owners/widgets/details_card.dart';

class CreatedSuccessfullyPage extends StatefulWidget {
  const CreatedSuccessfullyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreatedSuccessfullyPageState();
}

class _CreatedSuccessfullyPageState extends State<CreatedSuccessfullyPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: Text('错误'), centerTitle: true),
        body: Center(child: Text('未收到参数')),
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text("登记成功"), centerTitle: true),
        body: SafeArea(
            child: Container(
                margin: EdgeInsets.all(10),
                child: ListView(children: [
                  DetailsCard(
                    enterTime: args['enterTime'] ?? DateTime.now(),
                    leaveTime: args['leaveTime'] ?? DateTime.now(),
                    guestName: args['guestName'] ?? "访客姓名",
                    guestPhone: args['guestPhone'] ?? "访客手机号",
                    requestCode: args['requestCode'] ?? "访问代码",
                    qrCode: args['qrCode'] ?? "二维码",
                    pageKind: 0,
                  ),
                  SizedBox(height: 15),
                  Ink(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                        ); // 跳转到登录页面并清除导航栈
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "返回首页",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ]))));
  }
}
