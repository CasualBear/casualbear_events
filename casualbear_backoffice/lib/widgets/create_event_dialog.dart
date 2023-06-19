import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'cubit/event_cubit.dart';
import 'dart:html' as html;
import 'dart:convert';

// ignore: must_be_immutable
class CreateEventDialog extends StatefulWidget {
  Event? event;
  Function onSaveCompleted;
  CreateEventDialog({Key? key, this.event, required this.onSaveCompleted}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateEventDialogState createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  String? name;
  Color selectedColor = Colors.blue;
  String? description;
  String? rawUrlFile;

  List<int>? selectedFile;
  Uint8List? _bytesData;

  @override
  void initState() {
    if (widget.event != null) {
      name = widget.event!.name;
      selectedColor = Color(widget.event!.selectedColor);
      description = widget.event!.description;
      rawUrlFile = widget.event!.rawUrl;
    }
    super.initState();
  }

  void pickFiles() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        setState(() {
          _bytesData = const Base64Decoder().convert(reader.result.toString().split(",").last);
          selectedFile = _bytesData;
        });
      });
      reader.readAsDataUrl(file);
    });

    setState(() {});
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

  Future saveData(BuildContext context) async {
    if (name != null && description != null && selectedFile != null) {
      if (widget.event != null) {
        BlocProvider.of<EventCubit>(context).updateEvent(
            selectedFile!, name!, description!, selectedColor.value.toString(), widget.event!.id.toString());
      } else {
        BlocProvider.of<EventCubit>(context)
            .createEvent(selectedFile!, name!, description!, selectedColor.value.toString());
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill all the required data"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Event Details'),
      content: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
            controller: TextEditingController()..text = name ?? '',
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
                onTap: pickFiles,
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
              if (rawUrlFile != null || _bytesData != null)
                const Text('Imagem anexada', style: TextStyle(color: Colors.black)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController()..text = description ?? '',
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
      )),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        BlocConsumer<EventCubit, EventState>(
          buildWhen: (previous, current) =>
              current is EventCreationLoading || current is EventCreationLoaded || current is EventCreationError,
          listenWhen: (previous, current) =>
              current is EventCreationLoading || current is EventCreationLoaded || current is EventCreationError,
          listener: (context, state) {
            if (state is EventCreationLoaded) {
              widget.onSaveCompleted();
            } else if (state is EventCreationError) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Error while creating event, try again!"),
              ));
            }
          },
          builder: (context, state) {
            if (state is EventCreationLoading) {
              return const CircularProgressIndicator();
            }
            return TextButton(
              onPressed: () => saveData(context),
              child: const Text('Save'),
            );
          },
        ),
      ],
    );
  }
}
