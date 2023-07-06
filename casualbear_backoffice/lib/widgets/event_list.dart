import 'package:casualbear_backoffice/network/models/event.dart';
import 'package:casualbear_backoffice/widgets/create_event_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cubit/event_cubit.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  void initState() {
    BlocProvider.of<EventCubit>(context).getEvents();
    super.initState();
  }

  void addOrEditItemToList(Event? event) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CreateEventDialog(
            event: event,
            onSaveCompleted: () {
              Navigator.pop(context);
              BlocProvider.of<EventCubit>(context).getEvents();
            },
          );
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
          BlocConsumer<EventCubit, EventState>(
            buildWhen: (previous, current) =>
                current is EventGetLoading || current is EventGetLoaded || current is EventGetError,
            listenWhen: (previous, current) => current is EventGetError,
            listener: (context, state) {
              if (state is EventGetError) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Error while getting the events, try again!"),
                ));
              }
            },
            builder: (context, state) {
              if (state is EventGetLoading) {
                return const CircularProgressIndicator();
              } else if (state is EventGetLoaded) {
                return state.events.isEmpty
                    ? const Text('No events created, press + to create one')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: state.events.length,
                          itemBuilder: (context, index) {
                            Event event = state.events[index];
                            return _buildListItem(event);
                          },
                        ),
                      );
              }

              return Container();
            },
          )
        ],
      ),
    );
  }

  _buildListItem(Event event) {
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
                event.name,
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
                event.description,
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
                event.createdAt.toString(),
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
                    text: 'https://cblandingpage.web.app#eventId=${event.id}',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://cblandingpage.web.app#eventId=${event.id}'); // Open the URL when tapped
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: Color(getColor(event.selectedColor))),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                'Icon : ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.network(event.rawUrl ?? '', width: 100, height: 100)
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  addOrEditItemToList(event);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text(
                        'Editar'.toUpperCase(),
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.edit, color: Theme.of(context).primaryColor)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<EventCubit>(context).deleteEvent(event.id.toString());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      BlocConsumer<EventCubit, EventState>(
                        listenWhen: (previous, current) => current is EventDeleteError || current is EventDeleteLoaded,
                        buildWhen: (previous, current) =>
                            current is EventDeleteError ||
                            current is EventDeleteLoading ||
                            current is EventDeleteLoaded,
                        listener: (context, state) {
                          if (state is EventDeleteError) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Error while deleting event, try again!"),
                            ));
                          } else if (state is EventDeleteLoaded) {
                            BlocProvider.of<EventCubit>(context).getEvents();
                          }
                        },
                        builder: (context, state) {
                          if (state is EventDeleteLoading) {
                            return const CircularProgressIndicator();
                          }
                          return Text(
                            'Delete Event'.toUpperCase(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                          );
                        },
                      ),
                      const Icon(Icons.delete, color: Colors.red)
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  int getColor(int color) {
    int result = (0xff << 24) | color;
    return result;
  }
}
