import 'package:flutter/material.dart';

class RecordItemCard extends StatefulWidget {
  const RecordItemCard({
    super.key,
    required this.id,
    required this.enterTime,
    required this.leaveTime,
    required this.guestName,
    required this.guestPhone,
    required this.entrance,
    required this.ownerId,
    required this.requestCode,
    required this.qrCode,
    required this.status,
  });

  final int id;
  final DateTime enterTime;
  final DateTime leaveTime;
  final String guestName;
  final String guestPhone;
  final String entrance;
  final int ownerId;
  final String requestCode;
  final String qrCode;
  final int status;

  @override
  State<StatefulWidget> createState() {
    return _RecordItemCardState();
  }
}

class _RecordItemCardState extends State<RecordItemCard> {
  late final int id;
  late final DateTime enterTime;
  late final DateTime leaveTime;
  late final String guestName;
  late final String guestPhone;
  late final String entrance;
  late final int ownerId;
  late final String requestCode;
  late final String qrCode;
  late final int status;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    enterTime = widget.enterTime;
    leaveTime = widget.leaveTime;
    guestName = widget.guestName;
    guestPhone = widget.guestPhone;
    entrance = widget.entrance;
    ownerId = widget.ownerId;
    requestCode = widget.requestCode;
    qrCode = widget.qrCode;
    status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10)), // 此处卡片的背景颜色应当取决于该记录的状态
        child: Column(
          children: [
            Row(children: [
              Row(children: [
                Icon(Icons.home, color: Colors.white),
                Text("进出时间", style: TextStyle(color: Colors.white))
              ]),
              Spacer(),
              Row(children: [
                Icon(Icons.person, color: Colors.white),
                Text("访客姓名", style: TextStyle(color: Colors.white))
              ]),
            ]),
            SizedBox(height: 36),
            Row(children: [
              Row(children: [
                Icon(Icons.phone, color: Colors.white),
                Text("访客手机号", style: TextStyle(color: Colors.white))
              ]),
              Spacer(),
              Row(children: [
                Icon(Icons.start, color: Colors.white),
                Text("状态", style: TextStyle(color: Colors.white))
              ])
            ])
          ],
        ));
  }
}
