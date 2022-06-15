import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'newPhotoScreen.dart';

class AddPhotoButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPhotoButtonState();
  }
}

class _AddPhotoButtonState extends State<AddPhotoButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await availableCameras().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraPage(cameras: value)),
              ));
        },
        child: const Text('Photo hinzufügen'),
      ),
    );
  }
}
