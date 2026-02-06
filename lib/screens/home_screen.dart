import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:driver/global/globalVariables.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';


class home_screen extends StatefulWidget {
  @override
  State<home_screen> createState() => home_screenState();
}

class home_screenState extends State<home_screen> {
 
  bool IsGoingToTheEnd = true;
  bool right = true;
  Map a = {};
  bool isenable = true;
  List <Marker> _marker = [];
  List<LatLng> startpoint = [];
  List<LatLng> endpoint = [];
  List<LatLng> poin = [];
  final Set<Polyline> _poluline = {};
  late GoogleMapController controller;
  FirebaseFirestore firebasedatabase = FirebaseFirestore.instance;
  FirebaseAuth currentuser = FirebaseAuth.instance;
 
  CollectionReference drivercollection =
      FirebaseFirestore.instance.collection("Drivers");
  CollectionReference stops = FirebaseFirestore.instance.collection("Stops");
  late var _positionStreamSubscription;

//      Get Drivers location from database
 Stream<dynamic> getdriverlocation(BuildContext context) async* {
    drivercollection.snapshots().listen((QuerySnapshot) async {
      for (QueryDocumentSnapshot document in QuerySnapshot.docs) {
        final Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;
        
        double c = double.parse(data['latitude'].toString());
        double d = double.parse(data['langitude'].toString());
        String markerid = data['MarkerId'].toString();
        var prefs = await SharedPreferences.getInstance();
        var getusername = prefs.getString('username');
        if ((data['latitude'].toString() == "0" && data['langitude'].toString() == "0") ||
                !document.get("IsOn")){
                  _marker.removeWhere(
                    (element) => element.markerId == MarkerId(markerid));
                }
        // if(c==0 && d==0){}
        else{        
          int existingIndex = _marker.indexWhere(
                    (element) => element.markerId == MarkerId(markerid));
                    if (existingIndex != -1 && getusername == data['MarkerId']) {
                      controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(c, d),
            zoom: 30,
          )))
              .onError((error, stackTrace) {
            print(error);
          });
                      _marker[existingIndex] =  Marker(
              markerId: MarkerId(data['MarkerId'].toString()),
              position: LatLng(c, d),
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size.square(3.0)),
                  "assets/redbus-removebg-preview1.png"),
            );
                    } 
                    else if( existingIndex == -1 && getusername == data['MarkerId']){
                            controller
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(c, d),
            zoom: 30,
          )))
              .onError((error, stackTrace) {
            print(error);
          });
                       _marker.add(
            Marker(
              markerId: MarkerId(data['MarkerId'].toString()),
              position: LatLng(c, d),
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size.square(3.0)),
                  "assets/redbus-removebg-preview1.png"),
            ),
                       );

                    }
           else if (existingIndex != -1){
            _marker[existingIndex] =  Marker(
              markerId: MarkerId(data['MarkerId'].toString()),
              position: LatLng(c, d),
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size.square(3.0)),
                  "assets/removebg-preview.png"),
            );
           }
           else if(existingIndex == -1){
_marker.add(
            Marker(
              markerId: MarkerId(data['MarkerId'].toString()),
              position: LatLng(c, d),
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size.square(3.0)),
                  "assets/removebg-preview.png"),
            ),
                       );
           }
        }
    



 if (getusername == markerid){
                  
       if (startpoint.isNotEmpty) {
          List<Marker> udaipurstart = [
            Marker(
              markerId: MarkerId('start point1'),
              position:
                  LatLng(startpoint.first.latitude, startpoint.first.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(50),
            ),
          ];
          _marker.addAll(udaipurstart);
          if (Geolocator.distanceBetween(c, d,
                      startpoint.first.latitude, startpoint.first.longitude) <=
                  300 &&
              IsGoingToTheEnd == false) {
            IsGoingToTheEnd = true;
            stops.doc(getusername.toString()).update({
              'IsGoingToTheEnd': IsGoingToTheEnd,
            });
          }
        }
        if (endpoint.isNotEmpty) {
           var prefs = await SharedPreferences.getInstance();
                          var getusername = prefs.getString('username');
          List<Marker> dabokend = [
            Marker(
              markerId: MarkerId('end point1'),
              position:
                  LatLng(endpoint.first.latitude, endpoint.first.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(30),
            ),
          ];
          _marker.addAll(dabokend);
          if (Geolocator.distanceBetween(c, d,
                      endpoint.first.latitude, endpoint.first.longitude) <=
                  300 &&
              IsGoingToTheEnd == true) {
            IsGoingToTheEnd = false;
            stops.doc(getusername.toString()).update({
              'IsGoingToTheEnd': IsGoingToTheEnd,
            });
          }
        }
           }
      }
    }).onError((Error) async {
      await Future.delayed(Duration(seconds: 1));
      exit(0);
    });
    while (true) {
      yield _marker;
      await Future.delayed(Duration(seconds: 1));
    }
  }


//   sending location to database
  sendlocation() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var getusername = prefs.getString('username');

      CollectionReference stops =
          FirebaseFirestore.instance.collection("Stops");
      drivercollection.doc(getusername.toString()).update({
        'IsOn': isenable,
      });

      stops.doc(getusername.toString()).update({
        'IsOn': isenable,
      });
      // _positionStreamSubscription =

      backgroundService.startService();
    } catch (e) {
      print(e);
    }
  }
  make () async{
  await Future.delayed(Duration(seconds: 3)).then((value) => ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('fetching location plese wait...'))));
  }

  addroute() async {
    int i;

    var prefs = await SharedPreferences.getInstance();
    var getusername = prefs.getString('username');
    DocumentSnapshot<Map<String, dynamic>>? doc = await FirebaseFirestore
        .instance
        .collection("route")
        .doc(getusername.toString())
        .get();
    if (doc.exists) {
      print('adding rought...');
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      for (i = 1; i <= data.length; i++) {
        GeoPoint a = data[i.toString()];
        List<LatLng> k = [LatLng(a.latitude, a.longitude)];
        poin.addAll(k);
        if (i == 1) {
          startpoint.add(LatLng(a.latitude, a.longitude));
        }
        print(i);
        print(data.length);
        if (i == data.length ) {
          endpoint.add(LatLng(a.latitude, a.longitude));
        }
      }
    }
  }

  // external image for marker

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  void addcostommarker() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/marker.png')
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //set polylines
    addroute();
    _poluline.add(
      Polyline(
          polylineId: PolylineId('j'),
          points: poin,
          color: Color.fromARGB(255, 6, 6, 6),
          width: 5,
          jointType: JointType.round,
          endCap: Cap.roundCap,
          startCap: Cap.squareCap,
          zIndex: -1),
    );
    sendlocation();
    make();
  }

  @override
  Widget build(BuildContext context) {
     
    return StreamBuilder<dynamic>(
        stream: getdriverlocation(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
        
            print(snapshot.data);
           
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromARGB(255, 243, 121, 121),
                  shadowColor: const Color.fromARGB(255, 255, 255, 255),
                  title: Text(
                    'Driver App',
                    selectionColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () async {
                            backgroundService.invoke("stopService");
                          var prefs = await SharedPreferences.getInstance();
                          var getusername = prefs.getString('username');
                          // Remove data for the 'counter' key.
                          right = false;
                          // _positionStreamSubscription.cancel();
                        await  drivercollection.doc(getusername.toString()).update({
                            'IsOn': false,
                          });
                           await stops
                                                .doc(getusername.toString())
                                                .update({
                                              'IsOn': false,
                                            });
                          // var prefs = await SharedPreferences.getInstance();
                          await prefs.remove('username');

                          Navigator.popAndPushNamed(context, '/login');
                        },
                        icon: Icon(
                          Icons.logout_outlined,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ))
                  ],
                ),
                body: Stack(children: [
                  GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: LatLng(20.5937, 78.9629)),
                      markers: Set<Marker>.of(snapshot.data),
                      zoomControlsEnabled: false,
                      polylines: _poluline,
                      onMapCreated: (controller) {
                        this.controller = controller;
                      }),
                  Positioned(
                      bottom: 20.0,
                      right: 0.0,
                      child: Opacity(
                        opacity: 1,
                        child: Container(
                            width: 200.0,
                            height: 50.0,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Color.fromARGB(255, 243, 121, 121))),
                              onPressed: () async {
                                Switch(
                                    value: isenable,
                                    onChanged: (value) {
                                      setState(() {
                                        isenable = value;
                                        print(value);
                                      });
                                    });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Driving ",
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  Text(
                                    'Off',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                  Switch(
                                    value: isenable,
                                    onChanged: (value) {
                                      setState(() async {
                                        var prefs = await SharedPreferences
                                            .getInstance();
                                        var getusername =
                                            prefs.getString('username');
                                        DocumentSnapshot<Map<String, dynamic>>?
                                            doc = await FirebaseFirestore
                                                .instance
                                                .collection("Drivers")
                                                .doc(getusername.toString())
                                                .get();
                                        if (doc.exists) {
                                          final Map<String, dynamic> data = doc
                                              .data() as Map<String, dynamic>;

                                          // print(data['admin_permission']);
                                          if (data['DrivingAllowed']) {
                                            CollectionReference stops =
                                                FirebaseFirestore.instance
                                                    .collection("Stops");
                                            isenable = value;
                                            await drivercollection
                                                .doc(getusername.toString())
                                                .update({
                                              'IsOn': isenable,
                                            });

                                            await stops
                                                .doc(getusername.toString())
                                                .update({
                                              'IsOn': isenable,
                                            });
                                          }
                                        }
                                        if (isenable == false) {
                                          // await Future.delayed(Duration(seconds: 2));
                                          // _positionStreamSubscription.cancel();
                                          backgroundService.invoke("stopService");
                                          exit(0);
                                        }
                                        // print(value);
                                      });
                                    },
                                    activeColor: Color.fromARGB(255, 255, 255, 255),
                                    thumbColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(10);
                                      }
                                      return Color.fromARGB(255, 255, 255, 255);
                                    }),
                                    focusColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    trackColor:
                                        MaterialStateProperty.resolveWith<
                                            Color>((Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Color.fromARGB(255, 255, 255, 255)
                                            .withOpacity(.48);
                                      }
                                      return Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(.50);
                                    }),
                                  ),
                                  Text(
                                    'On',
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ],
                              ),
                            )),
                      ))
                ]));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.yellow[50],
              shadowColor: Colors.black,
              title: Text(
                'Driver App',
                selectionColor: const Color.fromARGB(255, 0, 0, 0),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () async {
                      // Remove data for the 'counter' key.
                      var prefs = await SharedPreferences.getInstance();
                      await prefs.remove('username');
                      await Future.delayed(Duration(seconds: 3));
                      _positionStreamSubscription.cancel();
                      Navigator.popAndPushNamed(context, '/login');
                    },
                    icon: Icon(
                      Icons.logout_outlined,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ))
              ],
            ),
            body: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(20.5937, 78.9629))),
          );
        });
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    }
}
