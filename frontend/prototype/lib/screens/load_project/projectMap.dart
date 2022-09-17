import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:prototype/components/input_field_address.dart';

/// das KartenWidget erhält als Eingabe die Adresswerte die du auf dem Handy in "Projekt erstellen" bzw in "Projekt bearbeiten"
/// einfügst. Anschauen kannst du dir die Karte bei der Ansicht "Projekt laden".
/// Google bietet sehr gute Map APIs an, über nur für ein kostenpflichtiges Abo-Modell, deshalb müssen
/// wir einen umständlichen Workarround schaffen
/// Für den Protoyp bin ich ziemlich genau diesem Tutorial gefolgt: https://www.youtube.com/watch?v=otWy4QhMJMo
/// bitte committe nicht auf den main branch, sondern erstelle einen neuen, gerade bei diesem Widget kann
/// recht viel schief gehen, da es viele verschiedene packages braucht. Einige Packages habe ich allerdings schon installiert
/// im pubspec.yaml file unter "# adding georgraphic map component".
/// Eine Kartenkomponente würde die App bei der Präsentation denke ich deutlich aufwerten (Franzi hat ja auch in ihrem Dashboard
/// so Kartenkurzansichten geplant) ist aber ziemliches Neuland für mich.
/// Ich wünsch dir auf jeden Fall viel Erfolg und bin gespannt ob das was rausfindest :) !
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
