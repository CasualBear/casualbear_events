import 'package:casualbear_backoffice/network/services/api_service.dart';
import 'package:casualbear_backoffice/repositories/event_repository.dart';
import 'package:casualbear_backoffice/screens/events/cubit/event_cubit.dart';
import 'package:casualbear_backoffice/screens/events/event_screen.dart';
import 'package:casualbear_backoffice/screens/user_screen.dart';
import 'package:casualbear_backoffice/widgets/menu_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/authentication/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventCubit>(
          create: (context) => EventCubit(EventRepository(ApiService.shared)),
        ),
      ],
      child: MaterialApp(
          debugShowMaterialGrid: false,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xff13335d),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: LoginPage()),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Backoffice'.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Column(children: [
          MenuList(
            onSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          currentIndex == 0 ? const Expanded(child: EventScreen()) : const Expanded(child: UserScreen())
        ]));
  }
}
