import 'package:dart_ewelink_api/dart_ewelink_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../models/delegate_user_ui_model.dart';
import '../models/device_ui_model.dart';
import '../models/home_dummy_data.dart';
import '../tabs/delegate_tab.dart';
import '../tabs/devices_tab.dart';
import '../widgets/common/home_background.dart';
import '../widgets/common/home_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _currentTab = HomeTab.devices;

  void _onTabSelected(HomeTab tab) {
    FocusScope.of(context).unfocus();
    setState(() => _currentTab = tab);
  }

  void _onDeviceTap(DeviceUiModel device) {
    // TODO: navigate to the device dashboard / camera snapshot screen.
  }

  void _onActivateDelegation(DelegateUserUiModel user, DateTimeRange period) {
    // TODO: call the delegation use case once the domain layer is ready.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: ColorManager.surfaceLight,
          content: Text(StringsManager.delegationActivated(user.fullName)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorManager.homeBackground,
        // Lets content scroll behind the floating tab bar; tabs read the
        // resulting bottom padding from MediaQuery.
        extendBody: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: HomeBackground(
                showSecondaryGlow: _currentTab == HomeTab.devices,
              ),
            ),
            SafeArea(
              bottom: false,
              // IndexedStack keeps each tab's state (search, selection, dates).
              child: IndexedStack(
                index: _currentTab.index,
                children: [
                  DevicesTab(
                    devices: HomeDummyData.devices,
                    onDeviceTap: _onDeviceTap,
                  ),
                  DelegateTab(
                    users: HomeDummyData.delegateUsers,
                    onActivateDelegation: _onActivateDelegation,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: HomeTabBar(
          currentTab: _currentTab,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }

  // Existing eWeLink sample — to be moved to the data layer.
  connect()async{
    var ewelink = Ewelink(email: '<your ewelink email>',
      password: '<your ewelink password>',
      region: '<your ewelink region>',);
    await ewelink.getCredentials();
    var device = await ewelink.getDevice(deviceId: "");
    List<EwelinkDevice> devices = await ewelink.getDevices();
    await ewelink.toggleDevice(deviceId: devices.first.deviceid);
  }
}
