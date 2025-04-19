import 'package:flutter/material.dart';
import 'package:frontend_for_owners/widgets/record_item_card.dart';

class GuestRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GuestRecordPageState();
  }
}

class _GuestRecordPageState extends State<GuestRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("通行记录"), centerTitle: true),
      body: SafeArea(
        child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Expanded(
                child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return Column(
                    children: [SizedBox(height: 10), RecordItemCard()]);
              },
            ))),
      ),
    );
  }
}
