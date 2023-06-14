import 'dart:async';
import 'dart:html';
import 'dart:convert';
import 'package:casualbear_backoffice/models/event.dart';
import 'package:casualbear_backoffice/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

// ignore: must_be_immutable
class CreateEventDialog extends StatefulWidget {
  final Function(Event event) onSave;
  Event? event;
  CreateEventDialog({Key? key, required this.onSave, this.event}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateEventDialogState createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  String name = '';
  Color selectedColor = Colors.blue;
  String description = '';
  File? selectedImage;
  bool isImageProcessing = false;

  @override
  void initState() {
    if (widget.event != null) {
      name = widget.event!.name;
      selectedColor = Color(widget.event!.selectedColor);
      description = widget.event!.description;
      selectedImage = widget.event!.iconFile;
    }
    super.initState();
  }

  Future<void> openImagePicker() async {
    final FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final file = uploadInput.files!.first;
      final reader = FileReader();

      reader.readAsDataUrl(file);

      setState(() {
        selectedImage = null;
        isImageProcessing = true;
      });

      await reader.onLoadEnd.first;

      final imageData = reader.result as String;
      final base64Data = imageData.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

      final compressedImage = await compute(compressImage, base64Data);

      setState(() {
        selectedImage = compressedImage;
        isImageProcessing = false;
      });
    });
  }

  Future<File> compressImage(String base64Data) async {
    final decodedBytes = img.decodeImage(base64Decode(base64Data))!;
    final resizedImage = img.copyResize(decodedBytes, width: 500);
    final Uint8List uint8list = img.encodeJpg(resizedImage, quality: 85);

    final blob = Blob([uint8list]);
    final file = File([blob], 'compressed_image.jpg');

    return file;
  }

  void openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void saveData() {
    int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    // TODO this id comes from the backend
    Event event = Event(1, name, description, selectedColor.value, selectedImage!, millisecondsSinceEpoch);
    widget.onSave(event);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Event Details'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: TextEditingController()..text = name,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Color: '),
                GestureDetector(
                  onTap: openColorPicker,
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: selectedColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Event Logo: '),
                GestureDetector(
                  onTap: openImagePicker,
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Icon(Icons.attach_file),
                  ),
                ),
                if (isImageProcessing)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                if (selectedImage != null) buildImage(selectedImage!),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController()..text = description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: saveData,
          child: const Text('Save'),
        ),
      ],
    );
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}
