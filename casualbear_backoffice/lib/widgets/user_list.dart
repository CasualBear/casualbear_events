import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<String> itemList = [];

  void addItemToList() {
    setState(() {
      int itemCount = itemList.length + 1;
      itemList.add('Item $itemCount');
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
            Text('All Users'.toUpperCase(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                    addItemToList();
                  }),
            )
          ]),
          const SizedBox(height: 5),
          itemList.isEmpty
              ? const Text('No Users created, press + to create one')
              : Expanded(
                  child: ListView.builder(
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      String item = itemList[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
