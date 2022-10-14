

/// Prototyp für Kartenwidget, dieses sollte ohne GoogleMaps auskommen, leider war
/// der Prototyp nur Android-fähig und auch da sehr verbuggt
/// 
/// 
/// 
/// 
/// 
/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:prototype/components/input_field_address.dart';


class ProjectMap extends StatelessWidget {
  // Konstruktor (die Adresse wird vom Ladebildschirm aus übergeben)
  Adress adress;
  ProjectMap({required this.adress});

  // Definition der Adress Variablen
  String street = "";
  String houseNumber = "";
  String zip = "";
  String city = "";
  // Standort variable
  LatLng point = LatLng(50.84663439904274, 6.085464547889987);

  // zuordnen der Übergabeparameter zu den Adress Variablen
  @override
  void initState() {
    // TODO: implement initState
    street = adress.street;
    houseNumber = adress.houseNumber;
    zip = adress.zip;
    city = adress.city;
  }

  // in der buildmthode werden die UI Parameter definiert
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Container(),

// Abgestellt da nicht Apple kompatibel

          /*
          child: FlutterMap(
            options: MapOptions(center: point, zoom: 16),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(markers: [
                Marker(
                    point: point,
                    builder: (ctx) => Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ))
              ])
            ],
          ),
          */
          width: 350,
          height: 200,
        ),
      ),
    );
  }
}
*/