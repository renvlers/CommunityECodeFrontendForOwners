import 'package:flutter/material.dart';
import 'package:frontend_for_owners/pages/created_successfully_page.dart';
import 'package:frontend_for_owners/routes/routes.dart';

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
    _leaveDateTime = now.add(Duration(minutes: 30));
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
          _leaveDateTime = selectedDateTime.add(Duration(minutes: 30));
        }
      } else {
        _leaveDateTime = selectedDateTime;
      }
    });
  }

  void _clearDateTime(bool isEnterTime) {
    setState(() {
      if (isEnterTime) {
        _enterDateTime = null;
      } else {
        _leaveDateTime = null;
      }
    });
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return "${dateTime.year}-${_pad(dateTime.month)}-${_pad(dateTime.day)} "
        "${_pad(dateTime.hour)}:${_pad(dateTime.minute)}";
  }

  String _pad(int value) => value.toString().padLeft(2, '0');

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
                  suffixIcon: _enterDateTime != null
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => _clearDateTime(true),
                        )
                      : null,
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _formatDateTime(_enterDateTime),
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
                  suffixIcon: _leaveDateTime != null
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => _clearDateTime(false),
                        )
                      : null,
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: _formatDateTime(_leaveDateTime),
                ),
                validator: (value) => _validateLeaveTime(),
              ),
            ),
          ),
          SizedBox(height: 24),

          // 提交按钮
          Ink(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  print("访客姓名: ${_nameController.text}");
                  print("访客手机号: ${_phoneController.text}");
                  print("进入时间: ${_enterDateTime.toString()}");
                  print("离开时间: ${_leaveDateTime.toString()}");

                  // 处理提交访客登记逻辑

                  Navigator.pushNamed(
                      context, RoutePath.createdSuccessfullyPage);
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
