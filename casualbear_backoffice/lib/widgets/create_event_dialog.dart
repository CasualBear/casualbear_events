import 'dart:html';
import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/widgets/cubit/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  late File fileToUpload;
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

  handleFileSelection() {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.length == 1) {
        final file = files[0];
        //final filename = file.name; // Get the file name
        fileToUpload = file;
      }
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

  void saveData(BuildContext context) {
    // make API call to save the file with the file path to S3 bucket

    //BlocProvider.of<EventCubit>(context).createFile();

    /*int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    Event event = Event(1, name, description, selectedColor.value, rawUrlFile!, millisecondsSinceEpoch);
    widget.onSave(event);
    Navigator.of(context).pop();*/
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
                  onTap: handleFileSelection,
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
          onPressed: () => saveData(context),
          child: const Text('Save'),
        ),
      ],
    );
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0')}';
  }
}
