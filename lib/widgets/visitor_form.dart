import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_owners/routes/routes.dart';
import 'package:frontend_for_owners/utils/api_client.dart';
import 'package:frontend_for_owners/utils/date_time_util.dart';
import 'package:frontend_for_owners/utils/user_util.dart';

class VisitorForm extends StatefulWidget {
  const VisitorForm({super.key});

  @override
  _VisitorFormState createState() => _VisitorFormState();
}

class _VisitorFormState extends State<VisitorForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime? _enterDateTime;
  DateTime? _leaveDateTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _enterDateTime = now;
    _leaveDateTime = now.add(Duration(minutes: 120));
  }

  String? _validateLeaveTime() {
    if (_leaveDateTime == null) return '请选择离开时间';
    if (_enterDateTime != null && _leaveDateTime!.isBefore(_enterDateTime!)) {
      return '离开时间不能早于进入时间';
    }
    return null;
  }

  Future<void> _selectDateTime(bool isEnterTime) async {
    DateTime now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(Duration(days: 365)),
      lastDate: now.add(Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isEnterTime) {
        _enterDateTime = selectedDateTime;
        // 如果当前离开时间比新的进入时间早，也自动更新一下
        if (_leaveDateTime != null &&
            _leaveDateTime!.isBefore(selectedDateTime)) {
          _leaveDateTime = selectedDateTime.add(Duration(minutes: 120));
        }
      } else {
        _leaveDateTime = selectedDateTime;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // 访客姓名
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: '访客姓名',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入访客姓名';
              return null;
            },
          ),
          SizedBox(height: 16),

          // 访客手机号
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: '访客手机号',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '请输入访客手机号';
              if (value.length != 11) return '访客手机号必须为11位';
              return null;
            },
          ),
          SizedBox(height: 16),

          // 进入时间
          GestureDetector(
            onTap: () => _selectDateTime(true),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '进入时间',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: DateTimeUtil.getString(_enterDateTime),
                ),
                validator: (value) {
                  if (_enterDateTime == null) return '请选择进入时间';
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 16),

          // 离开时间
          GestureDetector(
            onTap: () => _selectDateTime(false),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: '离开时间',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: DateTimeUtil.getString(_leaveDateTime),
                ),
                validator: (value) => _validateLeaveTime(),
              ),
            ),
          ),
          SizedBox(height: 24),
          Ink(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: () async {
                try {
                  Response response = await ApiClient().dio.get(
                      "/guest/get_records_by_owner?ownerId=${await UserUtil.getUid()}");
                  if (response.statusCode == 200) {
                    List data = response.data['data'];
                    data = data
                        .map((e) => jsonEncode({
                              'guestName': e['guestName'],
                              'guestPhone': e['guestPhone'],
                            }))
                        .toSet()
                        .map((e) => jsonDecode(e))
                        .toList();
                    final selected = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('选择历史访客'),
                          content: SizedBox(
                            width: double.maxFinite,
                            height: data.isEmpty ? 50 : 300,
                            child: data.isEmpty
                                ? Text("您当前没有历史访客")
                                : ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final item = data[index];
                                      return ListTile(
                                        title: Text(item['guestName'] ?? ''),
                                        subtitle:
                                            Text(item['guestPhone'] ?? ''),
                                        onTap: () {
                                          Navigator.of(context).pop(item);
                                        },
                                      );
                                    },
                                  ),
                          ),
                        );
                      },
                    );

                    if (selected != null) {
                      setState(() {
                        _nameController.text = selected['guestName'] ?? '';
                        _phoneController.text = selected['guestPhone'] ?? '';
                      });
                    }
                  }
                } on DioException catch (e) {
                  String errorMessage = e.toString();
                  if (e.response != null &&
                      e.response?.data != null &&
                      e.response?.data['message'] != null) {
                    errorMessage = e.response?.data['message'];
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: Text(
                  "从记录中导入",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // 提交按钮
          Ink(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  print("访客姓名: ${_nameController.text}");
                  print("访客手机号: ${_phoneController.text}");
                  print("进入时间: ${_enterDateTime.toString()}");
                  print("离开时间: ${_leaveDateTime.toString()}");

                  // 处理提交访客登记逻辑
                  try {
                    Response response = await ApiClient()
                        .dio
                        .post('/guest/create_request', data: {
                      "enterTime": _enterDateTime!.toIso8601String(),
                      "leaveTime": _leaveDateTime!.toIso8601String(),
                      "guestName": _nameController.text,
                      "guestPhone": _phoneController.text,
                      "ownerId": await UserUtil.getUid()
                    });
                    if (response.statusCode == 200) {
                      DateTime enterTime =
                          DateTime.parse(response.data['data']['enterTime']);
                      DateTime leaveTime =
                          DateTime.parse(response.data['data']['leaveTime']);
                      String guestName = response.data['data']['guestName'];
                      String guestPhone = response.data['data']['guestPhone'];
                      String requestCode = response.data['data']['requestCode'];
                      String qrCode = response.data['data']['hash'];
                      Navigator.pushNamed(
                        context,
                        RoutePath.createdSuccessfullyPage,
                        arguments: {
                          'enterTime': enterTime,
                          'leaveTime': leaveTime,
                          'guestName': guestName,
                          'guestPhone': guestPhone,
                          'requestCode': requestCode,
                          'qrCode': qrCode,
                        },
                      );
                    }
                  } on DioException catch (e) {
                    String errorMessage = e.toString();
                    if (e.response != null &&
                        e.response?.data != null &&
                        e.response?.data['message'] != null) {
                      errorMessage = e.response?.data['message'];
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: Text(
                  "提交",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
