import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailsCard extends StatefulWidget {
  @override
  _DetailsCardState createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 217, 237, 255),
            borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Row(children: [
            Text("2025-04-20 08:00"),
            Expanded(child: SizedBox()),
            Container(
              width: 48,
              height: 1,
              color: Colors.grey,
            ),
            Expanded(child: SizedBox()),
            Text("2025-04-20 12:00")
          ]),
          SizedBox(height: 10),
          Row(children: [
            Icon(Icons.person),
            Text("访客姓名"),
            Expanded(child: SizedBox()),
            Icon(Icons.phone),
            Text("13996939699")
          ]),
          SizedBox(height: 24),
          Text("123456", style: TextStyle(fontSize: 36)),
          SizedBox(height: 10),
          QrImageView(data: "123456", version: QrVersions.auto, size: 200),
          SizedBox(height: 24),
          Row(children: [
            ElevatedButton.icon(
                onPressed: () {
                  // Add share functionality here
                },
                icon: Icon(Icons.share),
                label: Text("分享"),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))))),
            Expanded(child: SizedBox()),
            ElevatedButton.icon(
                onPressed: () {
                  // Add revoke functionality here
                },
                icon: Icon(Icons.undo),
                label: Text("撤回"),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))))),
          ])
        ])); // Replace with your widget implementation
  }
}
