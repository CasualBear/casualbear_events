import 'package:casualbear_website/screens/cubit/generic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WelcomeScreen extends StatefulWidget {
  final String eventId;
  const WelcomeScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<User> users = [];
  String teamName = '';

  @override
  void initState() {
    BlocProvider.of<GenericCubit>(context).getEvents(widget.eventId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GenericCubit, GenericState>(
        buildWhen: (previous, current) =>
            current is EventGetLoading || current is EventGetLoaded || current is EventGetError,
        listenWhen: (previous, current) => current is EventGetError,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EventGetLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: Color(state.event.selectedColor),
                  height: 50,
                  child: Center(
                    child: Text(
                      state.event.name,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Event Image:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Image.network(state.event.rawUrl, width: 100, height: 100),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Event Description:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    state.event.description,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Team Name:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        teamName = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter team name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Registered Users:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                if (users.length < 4)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToUserForm(context);
                      },
                      child: const Text('Add User +'),
                    ),
                  ),
                const SizedBox(height: 10),
                if (users.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToUserForm(context);
                      },
                      child: const Text('Submit All Users'),
                    ),
                  ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Card(
                          child: ListTile(
                            minLeadingWidth: 200,
                            title: index == 0
                                ? Text('Capitão: ${users[index].name}')
                                : Text('User ${index}: ${users[index].name}'),
                            subtitle: Text('Name: ${users[index].name}'),
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  users.removeAt(index);
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          } else if (state is EventGetLoading) {
            return const CircularProgressIndicator();
          } else {
            return const Text("Event not found", style: TextStyle(color: Colors.black));
          }
        },
      ),
    );
  }

  void _navigateToUserForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserForm()),
    );
    if (result != null) {
      setState(() {
        users.add(result);
      });
    }
  }
}

// ignore: must_be_immutable
class UserForm extends StatefulWidget {
  UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  DateTime? birthdate;
  late String biCc;
  late String phoneNumber;
  late String address;
  late String email;
  late String numCardNOS;
  String? shirtSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                  ),
                  child: Text(
                    birthdate != null ? DateFormat('yyyy-MM-dd').format(birthdate!) : 'Select a date',
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'BI / CC'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a BI / CC number';
                  }
                  return null;
                },
                onSaved: (value) => biCc = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mobile Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mobile phone number';
                  }
                  return null;
                },
                onSaved: (value) => phoneNumber = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                onSaved: (value) => address = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nº Cartão NOS'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Nº Cartão NOS';
                  }
                  if (!isNumeric(value)) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => numCardNOS = value!,
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'T-Shirt Size'),
                items: ['S', 'M', 'L', 'XL'].map((size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a T-Shirt size';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    shirtSize = value;
                  });
                },
                value: shirtSize,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final user = User(
                      name: name,
                      birthdate: birthdate!,
                      cc: biCc,
                      phoneNumber: phoneNumber,
                      address: address,
                      email: email,
                      numCardNOS: numCardNOS,
                      shirtSize: shirtSize!,
                    );
                    Navigator.pop(context, user);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdate = picked;
      });
    }
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(value);
  }

  bool isNumeric(String value) {
    final numericRegex = RegExp(r'^-?[0-9]+$');
    return numericRegex.hasMatch(value);
  }
}

class User {
  final String name;
  final DateTime birthdate;
  final String cc;
  final String phoneNumber;
  final String address;
  final String email;
  final String numCardNOS;
  final String shirtSize;

  User({
    required this.name,
    required this.birthdate,
    required this.cc,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.numCardNOS,
    required this.shirtSize,
  });
}
