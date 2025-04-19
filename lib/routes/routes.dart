import 'package:flutter/material.dart';
import 'package:frontend_for_owners/pages/guest_record_page.dart';
import 'package:frontend_for_owners/pages/guest_request_page.dart';
import 'package:frontend_for_owners/pages/home_page.dart';
import 'package:frontend_for_owners/pages/login_page.dart';
import 'package:frontend_for_owners/pages/reset_password_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.homePage:
        return pageRoute(HomePage());
      case RoutePath.loginPage:
        return pageRoute(LoginPage());
      case RoutePath.guestRequestPage:
        return pageRoute(GuestRequestPage());
      case RoutePath.guestRecordPage:
        return pageRoute(GuestRecordPage());
      case RoutePath.resetPasswordPage:
        return pageRoute(ResetPasswordPage());
    }
    return pageRoute(Scaffold(
      body: SafeArea(child: Center(child: Text("页面${settings.name}不存在"))),
    ));
  }

  static MaterialPageRoute pageRoute(Widget page,
      {RouteSettings? settings,
      bool? fullScreenDialog,
      bool? maintainState,
      bool? allowSnapshotting}) {
    return MaterialPageRoute(
        builder: (context) {
          return page;
        },
        settings: settings,
        fullscreenDialog: fullScreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}

class RoutePath {
  static const String homePage = "/home_page";
  static const String loginPage = "/login_page";
  static const String guestRequestPage = "/guest_request_page";
  static const String guestRecordPage = "/guest_record_page";
  static const String resetPasswordPage = "/reset_password_page";
}
