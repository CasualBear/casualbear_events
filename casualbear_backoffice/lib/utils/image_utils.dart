import 'dart:async';
import 'dart:html';
import 'package:casualbear_backoffice/models/event.dart' as event;
import 'dart:typed_data';

import 'package:flutter/material.dart';

int getColor(int color) {
  int result = (0xff << 24) | color;
  return result;
}

Widget buildImage(File image) {
  return FutureBuilder<Uint8List>(
    future: convertFileToUint8List(image),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasData) {
        return Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(snapshot.data!),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return const Text('Image not available');
      }
    },
  );
}

Future<Uint8List> convertFileToUint8List(File file) async {
  final completer = Completer<Uint8List>();
  final reader = FileReader();

  reader.onLoadEnd.listen((event) {
    if (reader.readyState == FileReader.DONE) {
      final uint8List = Uint8List.fromList(reader.result as List<int>);
      completer.complete(uint8List);
    }
  });

  reader.readAsArrayBuffer(file);

  return completer.future;
}

convertObjecttoFormData(event.Event event) {
  final formData = FormData();

  // Add event data to the form data
  formData.append('name', event.name);
  formData.append('description', event.description);
  formData.append('selectedColor', event.selectedColor.toString());
  formData.appendBlob('iconFile', event.iconFile, 'icon.png');
}
