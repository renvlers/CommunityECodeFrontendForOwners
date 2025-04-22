import 'package:flutter/material.dart';
import 'package:frontend_for_owners/utils/date_time_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailsCard extends StatefulWidget {
  final DateTime enterTime;
  final DateTime leaveTime;
  final String guestName;
  final String guestPhone;
  final String requestCode;
  final String qrCode;

  const DetailsCard({
    super.key,
    required this.enterTime,
    required this.leaveTime,
    required this.guestName,
    required this.guestPhone,
    required this.requestCode,
    required this.qrCode,
  });

  @override
  _DetailsCardState createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  late final DateTime enterTime;
  late final DateTime leaveTime;
  late final String guestName;
  late final String guestPhone;
  late final String requestCode;
  late final String qrCode;

  @override
  void initState() {
    super.initState();
    enterTime = widget.enterTime;
    leaveTime = widget.leaveTime;
    guestName = widget.guestName;
    guestPhone = widget.guestPhone;
    requestCode = widget.requestCode;
    qrCode = widget.qrCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 217, 237, 255),
            borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Row(children: [
            Text(DateTimeUtil.getString(enterTime)),
            Expanded(child: SizedBox()),
            Container(
              width: 48,
              height: 1,
              color: Colors.grey,
            ),
            Expanded(child: SizedBox()),
            Text(DateTimeUtil.getString(leaveTime))
          ]),
          SizedBox(height: 10),
          Row(children: [
            Icon(Icons.person),
            Text(guestName),
            Expanded(child: SizedBox()),
            Icon(Icons.phone),
            Text(guestPhone)
          ]),
          SizedBox(height: 24),
          Text(requestCode, style: TextStyle(fontSize: 36)),
          SizedBox(height: 10),
          QrImageView(data: qrCode, version: QrVersions.auto, size: 200),
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
        ]));
  }
}
