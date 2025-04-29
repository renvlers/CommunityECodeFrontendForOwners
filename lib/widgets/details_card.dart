import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend_for_owners/pages/home_page.dart';
import 'package:frontend_for_owners/utils/api_client.dart';
import 'package:frontend_for_owners/utils/date_time_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class DetailsCard extends StatefulWidget {
  final DateTime enterTime;
  final DateTime leaveTime;
  final String guestName;
  final String guestPhone;
  final String requestCode;
  final String qrCode;

  final int pageKind;

  final Function? setParentState;

  const DetailsCard(
      {super.key,
      required this.enterTime,
      required this.leaveTime,
      required this.guestName,
      required this.guestPhone,
      required this.requestCode,
      required this.qrCode,
      required this.pageKind,
      this.setParentState});

  @override
  State<StatefulWidget> createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  late final DateTime enterTime;
  late final DateTime leaveTime;
  late final String guestName;
  late final String guestPhone;
  late final String requestCode;
  late final String qrCode;

  late final int pageKind;

  late Function? setParentState;

  final GlobalKey _globalKey = GlobalKey();

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    enterTime = widget.enterTime;
    leaveTime = widget.leaveTime;
    guestName = widget.guestName;
    guestPhone = widget.guestPhone;
    requestCode = widget.requestCode;
    qrCode = widget.qrCode;
    pageKind = widget.pageKind;
    setParentState = widget.setParentState;
  }

  RepaintBoundary _getBoundary() {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 217, 237, 255),
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            Row(children: [
              Text(DateTimeUtil.getString(enterTime)),
              Spacer(),
              Container(
                width: 48,
                height: 1,
                color: Colors.grey,
              ),
              Spacer(),
              Text(DateTimeUtil.getString(leaveTime))
            ]),
            SizedBox(height: 10),
            Row(children: [
              Icon(Icons.person),
              Text(guestName),
              Spacer(),
              Icon(Icons.phone),
              Text(guestPhone)
            ]),
            SizedBox(height: 24),
            Text(requestCode, style: TextStyle(fontSize: 36)),
            SizedBox(height: 10),
            QrImageView(data: qrCode, version: QrVersions.auto, size: 200),
            SizedBox(height: 24)
          ])),
    );
  }

  Future<void> _captureAndShare() async {
    setState(() {
      _isVisible = true;
    });

    // 等待一帧，确保绘制完成
    await Future.delayed(Duration.zero);
    await WidgetsBinding.instance.endOfFrame;

    setState(() {
      _isVisible = false;
    });

    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$qrCode.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: '访客登记信息');
    } catch (e) {
      print("分享失败: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 217, 237, 255),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Row(children: [
                Text(DateTimeUtil.getString(enterTime)),
                Spacer(),
                Container(
                  width: 48,
                  height: 1,
                  color: Colors.grey,
                ),
                Spacer(),
                Text(DateTimeUtil.getString(leaveTime))
              ]),
              SizedBox(height: 10),
              Row(children: [
                Icon(Icons.person),
                Text(guestName),
                Spacer(),
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
                    onPressed: () async {
                      // Add share functionality here
                      await _captureAndShare();
                    },
                    icon: Icon(Icons.share),
                    label: Text("分享"),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))))),
                Spacer(),
                ElevatedButton.icon(
                    onPressed: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('确认撤回'),
                          content: Text('确定要撤回该登记吗？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('取消'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('确认'),
                            ),
                          ],
                        ),
                      );
                      if (confirm != true) return;

                      try {
                        Response response = await ApiClient().dio.delete(
                            "/guest/delete_request?requestCode=$requestCode");
                        if (response.statusCode == 200 && pageKind == 0) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false,
                          );
                        } else if (response.statusCode == 200 &&
                            pageKind == 1) {
                          setParentState!();
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
                    icon: Icon(Icons.undo),
                    label: Text("撤回"),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))))),
              ])
            ])),
        Offstage(
            offstage: !_isVisible,
            child: Opacity(opacity: 0.1, child: _getBoundary()))
      ],
    );
  }
}
