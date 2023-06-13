import 'package:casualbear_backoffice/screens/event_screen.dart';
import 'package:casualbear_backoffice/screens/user_screen.dart';
import 'package:casualbear_backoffice/widgets/menu_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowMaterialGrid: false,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xff13335d),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen());
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
