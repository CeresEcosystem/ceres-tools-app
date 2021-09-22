import 'package:ceres_locker_app/core/widgets/side_menu/side_menu.dart';
import 'package:ceres_locker_app/presentation/tracker/tracker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackerView extends GetView<TrackerController> {
  const TrackerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: Container(),
    );
  }
}
