import 'package:flutter/material.dart';
import 'package:prototype/components/input_field.dart';
import 'package:prototype/screens/create_new_project/_main_view.dart';

class AddressInput extends StatefulWidget {
  Function(Adress) updateAddress;
  Adress adress;
  AddressInput(
      {required this.updateAddress,
      this.adress =
          const Adress(street: "", houseNumber: "", zip: "", city: "")});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddressInputState();
  }
}

class AddressInputState extends State<AddressInput> {
  String street = "";
  String houseNumber = "";
  String city = "";
  String zip = "";

  @override
  void initState() {
    super.initState();
    street = widget.adress.street;
    houseNumber = widget.adress.houseNumber;
    city = widget.adress.city;
    zip = widget.adress.zip;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 206, 206, 206))),
      child: Wrap(
        spacing: 20, // to apply margin in the main axis of the wrap
        runSpacing: 20, // to apply margin in the cross axis of the wrap
        children: <Widget>[
          Text("Adresse"),
          Row(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: InputField(
                  value: widget.adress.street,
                  saveTo: (value) {
                    street = value;
                    widget.updateAddress(Adress(
                        street: street,
                        houseNumber: houseNumber,
                        zip: zip,
                        city: city));
                  },
                  labelText: "Straße",
                ),
              ),
              Expanded(
                flex: 3,
                child: InputField(
                    value: widget.adress.houseNumber,
                    saveTo: (value) {
                      houseNumber = value;
                      widget.updateAddress(Adress(
                          street: street,
                          houseNumber: houseNumber,
                          zip: zip,
                          city: city));
                    },
                    labelText: "Nr."),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: InputField(
                    value: widget.adress.zip,
                    saveTo: (value) {
                      zip = value;
                      widget.updateAddress(Adress(
                          street: street,
                          houseNumber: houseNumber,
                          zip: zip,
                          city: city));
                    },
                    labelText: "Postleitzahl"),
              ),
              Expanded(
                flex: 5,
                child: InputField(
                    value: widget.adress.city,
                    saveTo: (value) {
                      city = value;
                      widget.updateAddress(Adress(
                          street: street,
                          houseNumber: houseNumber,
                          zip: zip,
                          city: city));
                    },
                    labelText: "Stadt"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Adress {
  final String street;
  final String houseNumber;
  final String city;
  final String zip;
  const Adress(
      {required this.street,
      required this.houseNumber,
      required this.zip,
      required this.city});
}
