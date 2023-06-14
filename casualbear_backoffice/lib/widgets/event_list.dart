import 'package:casualbear_backoffice/models/event.dart';
import 'package:casualbear_backoffice/utils/date_utils.dart';
import 'package:casualbear_backoffice/utils/image_utils.dart';
import 'package:casualbear_backoffice/widgets/create_event_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<Event> eventList = [];

  void addOrEditItemToList(Event? event) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateEventDialog(
              event: event,
              onSave: (event) {
                setState(() {
                  eventList.add(Event(
                      event.id, event.name, event.description, event.selectedColor, event.iconFile, event.createdAt));
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('All Events'.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            SizedBox(
              height: 30,
              child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Text(
                    '+',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    addOrEditItemToList(null);
                  }),
            )
          ]),
          const SizedBox(height: 5),
          eventList.isEmpty
              ? const Text('No events created, press + to create one')
              : Expanded(
                  child: ListView.builder(
                    itemCount: eventList.length,
                    itemBuilder: (context, index) {
                      Event item = eventList[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xffe1e3e1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Text(
                                  'Name: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Text(
                                  'Description: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Text(
                                  'Date of Creation: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  convertMillisecondsToDate(item.createdAt),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Website ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'www.abola.pt',
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          launch('www.abola.pt'); // Open the URL when tapped
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Text(
                                  'Color ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle, color: Color(getColor(item.selectedColor))),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                const Text(
                                  'Icon ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                buildImage(item.iconFile)
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    addOrEditItemToList(item);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Editar'.toUpperCase(),
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).primaryColor),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(Icons.edit, color: Theme.of(context).primaryColor)
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Delete Event'.toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      const Icon(Icons.delete, color: Colors.red)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
