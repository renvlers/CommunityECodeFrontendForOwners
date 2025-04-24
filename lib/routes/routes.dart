import 'package:flutter/material.dart';
import 'package:frontend_for_owners/pages/created_successfully_page.dart';
import 'package:frontend_for_owners/pages/guest_record_page.dart';
import 'package:frontend_for_owners/pages/guest_request_details_page.dart';
import 'package:frontend_for_owners/pages/guest_request_page.dart';
import 'package:frontend_for_owners/pages/home_page.dart';
import 'package:frontend_for_owners/pages/login_page.dart';
import 'package:frontend_for_owners/pages/reset_password_page.dart';

class Routes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.homePage:
        return pageRoute(HomePage(), settings: settings);
      case RoutePath.loginPage:
        return pageRoute(LoginPage(), settings: settings);
      case RoutePath.guestRequestPage:
        return pageRoute(GuestRequestPage(), settings: settings);
      case RoutePath.guestRecordPage:
        return pageRoute(GuestRecordPage(), settings: settings);
      case RoutePath.resetPasswordPage:
        return pageRoute(ResetPasswordPage(), settings: settings);
      case RoutePath.guestRequestDetailsPage:
        return pageRoute(GuestRequeseDetailsPage(), settings: settings);
      case RoutePath.createdSuccessfullyPage:
        return pageRoute(CreatedSuccessfullyPage(), settings: settings);
    }
    return null;
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
  static const String homePage = "/home";
  static const String loginPage = "/login_page";
  static const String guestRequestPage = "/guest_request_page";
  static const String guestRecordPage = "/guest_record_page";
  static const String resetPasswordPage = "/reset_password_page";
  static const String guestRequestDetailsPage = "/guest_request_details_page";
  static const String createdSuccessfullyPage = "/created_successfully_page";
}
