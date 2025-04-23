import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_owners/utils/api_client.dart';
import 'package:frontend_for_owners/utils/user_util.dart';
import 'package:frontend_for_owners/widgets/details_card.dart';

class _GuestRequest {
  _GuestRequest({
    required this.enterTime,
    required this.leaveTime,
    required this.guestName,
    required this.guestPhone,
    required this.requestCode,
    required this.qrCode,
  });

  final DateTime enterTime;
  final DateTime leaveTime;
  final String guestName;
  final String guestPhone;
  final String requestCode;
  final String qrCode;
}

class GuestRequeseDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GuestRequestDetailsPageState();
  }
}

class _GuestRequestDetailsPageState extends State<GuestRequeseDetailsPage> {
  List<_GuestRequest> _guestRequests = [];
  Future<void> _getAllRequests() async {
    try {
      int uid = await UserUtil.getUid() ?? 0;
      if (uid == 0) throw Exception("用户加载失败");
      Response response = await ApiClient()
          .dio
          .get("/guest/get_requests_by_owner?ownerId=$uid");
      if (response.statusCode == 200) {
        List data = response.data['data'] ?? [];
        setState(() {
          _guestRequests = data.map<_GuestRequest>((item) {
            return _GuestRequest(
              enterTime: DateTime.parse(item['enterTime']),
              leaveTime: DateTime.parse(item['leaveTime']),
              guestName: item['guestName'] ?? '',
              guestPhone: item['guestPhone'] ?? '',
              requestCode: item['requestCode'] ?? '',
              qrCode: item['hash'] ?? '',
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
  void initState() {
    super.initState();
    _getAllRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('登记详情'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: _guestRequests.isEmpty
                ? Container(
                    alignment: Alignment.center, child: Text("没有待使用的登记"))
                : ListView.builder(
                    itemCount: _guestRequests.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(height: 10),
                          DetailsCard(
                            enterTime: _guestRequests[index].enterTime,
                            leaveTime: _guestRequests[index].leaveTime,
                            guestName: _guestRequests[index].guestName,
                            guestPhone: _guestRequests[index].guestPhone,
                            requestCode: _guestRequests[index].requestCode,
                            qrCode: _guestRequests[index].qrCode,
                            pageKind: 1,
                          ),
                          if (index == _guestRequests.length - 1)
                            SizedBox(height: 10),
                        ],
                      );
                    }),
          ),
        ));
  }
}
