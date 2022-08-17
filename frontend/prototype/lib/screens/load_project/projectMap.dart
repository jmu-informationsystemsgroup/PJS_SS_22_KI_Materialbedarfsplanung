import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ProjectMap extends StatelessWidget {
  LatLng point = LatLng(50.84663439904274, 6.085464547889987);
  //50.84663439904274, 6.085464547889987
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        child: Container(
          margin: const EdgeInsets.all(10.0),
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
          width: 350,
          height: 200,
        ),
      ),
    );
  }
}
