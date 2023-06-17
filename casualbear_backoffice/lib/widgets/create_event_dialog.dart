import 'dart:async';
import 'dart:html';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:casualbear_backoffice/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/foundation.dart';

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
  String? rawUrlFile;
  String? filePath;
  bool isImageProcessing = false;

  @override
  void initState() {
    if (widget.event != null) {
      name = widget.event!.name;
      selectedColor = Color(widget.event!.selectedColor);
      description = widget.event!.description;
      rawUrlFile = widget.event!.rawUrlFile;
    }
    super.initState();
  }

  Future<void> openImagePicker() async {
    final FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final file = uploadInput.files!.first;
      String path = file.relativePath!;
      filePath = path;
    });
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
    // make API call to save the file with the file path to S3 bucket
    AwsS3.uploadFile(
        accessKey: "AKxxxxxxxxxxxxx",
        secretKey: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
        file:  Blob([fileData]),,
        bucket: "bucket_name",
        region: "us-east-2",
        metadata: {"test": "test"} // optional
        );

    int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    Event event = Event(1, name, description, selectedColor.value, rawUrlFile!, millisecondsSinceEpoch);
    widget.onSave(event);
    Navigator.of(context).pop();
  }

  void uploadFileToS3(String filePath) {
  final file = FileUploadInputElement().files?.first;
  
  final reader = FileReader();
  
  reader.onLoadEnd.listen((e) {
    final Uint8List fileData = reader.result as Uint8List;
    
    final fileBlob = Blob([fileData]);
    final convertedFile = File([fileBlob], file?.name ?? 'file.txt');
    
    // Pass convertedFile as a File to the upload function
    AwsS3.uploadFile(
      accessKey: "AKxxxxxxxxxxxxx",
      secretKey: "xxxxxxxxxxxxxxxxxxxxxxxxxx",
      file: convertedFile,
      bucket: "bucket_name",
      region: "us-east-2",
      metadata: {"test": "test"} // optional
    );
  });
  
  reader.readAsArrayBuffer(file);
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
                if (rawUrlFile != null) Image.network(rawUrlFile!),
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
