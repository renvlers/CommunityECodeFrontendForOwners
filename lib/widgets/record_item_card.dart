import 'package:flutter/material.dart';

class RecordItemCard extends StatefulWidget {
  const RecordItemCard({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RecordItemCardState();
  }
}

class _RecordItemCardState extends State<RecordItemCard> {
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
