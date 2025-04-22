import 'package:flutter/material.dart';
import 'package:frontend_for_owners/widgets/details_card.dart';

class GuestRequeseDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GuestRequestDetailsPageState();
  }
}

class _GuestRequestDetailsPageState extends State<GuestRequeseDetailsPage> {
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
            child: Expanded(
                child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Column(
                          // children: [SizedBox(height: 10), DetailsCard()],
                          );
                    })),
          ),
        ));
  }
}
