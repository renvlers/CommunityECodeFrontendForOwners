import 'package:flutter/material.dart';
import 'package:frontend_for_owners/widgets/visitor_form.dart';

class GuestRequestPage extends StatefulWidget {
  const GuestRequestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GuestRequestPageState();
  }
}

class _GuestRequestPageState extends State<GuestRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("访客登记"), centerTitle: true),
        body: SafeArea(
          child: Container(
              margin: EdgeInsets.all(10),
              child: ListView(
                children: [VisitorForm()],
              )),
        ));
  }
}
