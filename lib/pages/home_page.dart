import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_owners/pages/login_page.dart';
import 'package:frontend_for_owners/routes/routes.dart';
import 'package:frontend_for_owners/utils/api_client.dart';
import 'package:frontend_for_owners/utils/user_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  int? uid;
  String? username;
  String? phone;
  String? roomNumber;

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _initializeHomePage();
  }

  Future<void> _initializeUser() async {
    uid = await UserUtil.getUid() ?? 0;
    username = await UserUtil.getName() ?? "";
    phone = await UserUtil.getPhoneNumber() ?? "";
    roomNumber = await UserUtil.getRoomNumber() ?? "";
  }

  Future<void> _initializeHomePage() async {
    bool loggedIn = await _checkLoginStatus();

    if (loggedIn) {
      await _initializeUser();
    }
  }

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
      return false;
    }

    return true;
  }

  // 页面列表
  List<Widget> _buildPages(BuildContext context) {
    return [
      SafeArea(
        child: ListView(children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutePath.guestRequestPage);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/guest_request.png",
                            width: 80, height: 80),
                        Expanded(child: Container()),
                        const Text(
                          "访客登记",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                          context, RoutePath.guestRequestDetailsPage);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/guest_details.png",
                            width: 80, height: 80),
                        Expanded(child: Container()),
                        const Text(
                          "登记详情",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutePath.guestRecordPage);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/guest_record.png",
                            width: 80, height: 80),
                        Expanded(child: Container()),
                        const Text(
                          "通行记录",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutePath.homePage);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Image.asset("assets/images/ai.png",
                            width: 80, height: 80),
                        Expanded(child: Container()),
                        const Text(
                          "智能助手",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        )
                      ]),
                    ),
                  ),
                )),
          ),
        ]),
      ),
      SafeArea(
          child: Container(
              margin: EdgeInsets.all(10),
              child: ListView(children: [
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 217, 237, 255),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      Icon(Icons.person_outline_rounded,
                          color: Colors.black, size: 96),
                      SizedBox(width: 30),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username ?? "业主姓名",
                                style: TextStyle(fontSize: 20)),
                            Text(phone ?? "业主手机号"),
                            Text(roomNumber ?? "门牌号")
                          ]),
                      Expanded(
                        child: SizedBox(),
                      )
                    ])),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: Ink(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePath.resetPasswordPage);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text("修改密码",
                                      style: TextStyle(color: Colors.white)),
                                )))),
                    SizedBox(width: 10),
                    Expanded(
                        child: Ink(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("提示"),
                                        content: Text("你确定要退出吗？"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 关闭对话框
                                            },
                                            child: Text("取消"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await _logout();
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()),
                                                (route) => false,
                                              ); // 跳转到登录页面并清除导航栈
                                            },
                                            child: Text("确定"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text("退出登录",
                                      style: TextStyle(color: Colors.white)),
                                ))))
                  ],
                )
              ])))
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _title = [Text("首页"), Text("我的")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title[_selectedIndex],
        centerTitle: true,
      ),
      body: _buildPages(context)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
