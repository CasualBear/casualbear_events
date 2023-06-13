import 'package:flutter/material.dart';

class MenuItems {
  String name;

  MenuItems(this.name);
}

class MenuList extends StatefulWidget {
  final Function(int index) onSelected;
  const MenuList({super.key, required this.onSelected});

  @override
  // ignore: library_private_types_in_public_api
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  int selectedIndex = 0; // Initially no item selected
  List<MenuItems> menuItems = [MenuItems('Events'), MenuItems('Users')];

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          Color backgroundColor = isSelected ? const Color(0xff13335d) : Colors.grey;
          Color textColor = isSelected ? Colors.white : Colors.white;

          return GestureDetector(
            onTap: () {
              selectItem(index);
            },
            child: Container(
              margin: const EdgeInsets.all(8.0),
              width: 100,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  menuItems[index].name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
