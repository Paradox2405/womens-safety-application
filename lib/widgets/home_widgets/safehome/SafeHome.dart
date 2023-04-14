import 'dart:async';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:women_safety_app/components/PrimaryButton.dart';
import 'package:women_safety_app/db/db_services.dart';
import 'package:women_safety_app/model/contactsm.dart';

class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _curentPosition;
  String? _curentAddress;
  late var _timer;
  bool _isLoading=true;
  LocationPermission? permission;

  @override
  void initState() {
    super.initState();
   _getPermission();
    _getCurrentLocation();
    _setTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _getPermission() async {
    await [Permission.locationWhenInUse].request();
    await [Permission.sms].request();
  }
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "sent");
    } else {
      Fluttertoast.showToast(msg: "failed");
    }
  }

_getCurrentLocation() async {
  Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true)
      .then((Position position) {
    setState(() {
      _isLoading=false;
      _curentPosition = position;
      print("Lat: ${_curentPosition!.latitude} Long:${_curentPosition!.longitude}");
      _getAddressFromLatLon();
    });
  }).catchError((e) {
    print(e);
    Fluttertoast.showToast(msg: e.toString());
  });
}
  _setTimer() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions are denied");
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
        Fluttertoast.showToast(
            msg: "Location permissions are permanently denied");
      }
    }
    _timer=Timer.periodic(Duration(seconds: 10), (timer) {
  _getCurrentLocation();
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
            "${place.locality},${place.postalCode},${place.street},";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }


  showModelSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child:_isLoading?Center(child: CircularProgressIndicator()): Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You are currently at: \n\n ${_curentAddress??""} \n\n SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOU EMERGENCY CONTACTS?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 40),
                PrimaryButton(
                    title: "SEND ALERT",
                    onPressed: () async {
                      List<TContact> contactList =
                          await DatabaseHelper().getContactList();

                      String messageBody =
                          "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude},${_curentPosition!.longitude}";
                      if(contactList.isNotEmpty) {
                              if (await _isPermissionGranted()) {
                                contactList.forEach((element) {
                                  _sendSms("${element.number}",
                                      "i am in trouble $messageBody");
                                });
                              } else {
                                Fluttertoast.showToast(msg: "something wrong");
                              }
                            } else{
                        Fluttertoast.showToast(msg: "Please add emergency contacts first");
                      }
                          }),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModelSafeHome(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  ListTile(
                    title: Text("Send Location"),
                    subtitle: Text("Share Location"),
                  ),
                ],
              )),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/route.jpg')),
            ],
          ),
        ),
      ),
    );
  }
}
