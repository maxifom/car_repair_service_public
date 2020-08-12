import 'dart:async';

import 'package:car_repair_service/mazda_pro_icons_icons.dart';
import 'package:car_repair_service/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoPage extends StatefulWidget {
  InfoPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Completer<GoogleMapController> _controller = Completer();
  static final String phone = 'tel:+79222222222';
  static final String whatsapp = 'https://chat.whatsapp.com/H3sGhnSh5KzFw7tyWZxL3d';
  static final String telegram = 'https://t.me/fominykh_maxim';
  static final CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(56.839051, 60.605815),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Информация',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _defaultPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: {
                            Marker(
                              position: const LatLng(56.839051, 60.605815),
                              markerId: MarkerId("MARKER_1"),
                              visible: true,
                              infoWindow: InfoWindow(
                                title: 'Mazda Pro Service',
                                snippet: '07:00-23:00',
                              ),
                            )
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          key: Key("Phone"),
                          icon: Icon(Icons.phone),
                          color: Color.fromRGBO(71, 151, 244, 1),
                          iconSize: 75,
                          onPressed: () async {
                            await launchURL(phone);
                          },
                        ),
                        Spacer(),
                        IconButton(
                          key: Key("Whatapp"),
                          icon: Icon(MazdaProIcons.whatsapp),
                          iconSize: 75,
                          color: Color(0xFF54CC62),
                          onPressed: () async {
                            await launchURL(whatsapp);
                          },
                        ),
                        Spacer(),
                        IconButton(
                          key: Key("Telegram"),
                          icon: Icon(MazdaProIcons.paper_plane),
                          iconSize: 75,
                          color: Color(0xFF35ACE1),
                          onPressed: () async {
                            await launchURL(telegram);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
