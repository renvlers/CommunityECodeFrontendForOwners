import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_owners/utils/api_client.dart';
import 'package:frontend_for_owners/utils/user_util.dart';
import 'package:frontend_for_owners/widgets/record_item_card.dart';

class _GuestRecord {
  _GuestRecord({
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
}

class GuestRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GuestRecordPageState();
  }
}

class _GuestRecordPageState extends State<GuestRecordPage> {
  List<_GuestRecord> _guestRecords = [];

  @override
  void initState() {
    super.initState();
    _getRecordsByOwnerId();
  }

  Future<void> _getRecordsByOwnerId() async {
    try {
      Response response = await ApiClient()
          .dio
          .get("/guest/get_records_by_owner?ownerId=${UserUtil.getUid()}");
      if (response.statusCode == 200) {
        List data = response.data['data'] ?? [];
        setState(() {
          _guestRecords = data.map<_GuestRecord>((item) {
            return _GuestRecord(
              id: item['id'],
              enterTime: DateTime.parse(item['enterTime']),
              leaveTime: DateTime.parse(item['leaveTime']),
              guestName: item['guestName'],
              guestPhone: item['guestPhone'],
              entrance: item['entrance'],
              ownerId: item['ownerId'],
              requestCode: item['requestCode'],
              qrCode: item['hash'],
              status: item['status'],
            );
          }).toList();
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("通行记录"), centerTitle: true),
      body: SafeArea(
          child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: _guestRecords.isEmpty
                  ? Container(
                      alignment: Alignment.center, child: Text("没有您所登记的访客通行记录"))
                  : ListView.builder(
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          SizedBox(height: 10),
                          RecordItemCard(
                            id: _guestRecords[index].id,
                            enterTime: _guestRecords[index].enterTime,
                            leaveTime: _guestRecords[index].leaveTime,
                            guestName: _guestRecords[index].guestName,
                            guestPhone: _guestRecords[index].guestPhone,
                            entrance: _guestRecords[index].entrance,
                            ownerId: _guestRecords[index].ownerId,
                            requestCode: _guestRecords[index].requestCode,
                            qrCode: _guestRecords[index].qrCode,
                            status: _guestRecords[index].status,
                          ),
                          if (index == _guestRecords.length - 1)
                            SizedBox(height: 10)
                        ]);
                      },
                    ))),
    );
  }
}
