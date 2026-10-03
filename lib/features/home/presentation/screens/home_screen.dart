import 'package:dart_ewelink_api/dart_ewelink_api.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold();
  }

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
