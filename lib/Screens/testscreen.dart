import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListItem {
  String name;
  bool isChecked;
  String textFieldData;

  ListItem(
      {required this.name,
      required this.isChecked,
      required this.textFieldData});
}

class MyCheckboxListView extends StatefulWidget {
  @override
  _MyCheckboxListViewState createState() => _MyCheckboxListViewState();
}

class _MyCheckboxListViewState extends State<MyCheckboxListView> {
  List<ListItem> itemList = List.generate(
    10,
    (index) =>
        ListItem(name: 'Item $index', isChecked: false, textFieldData: ''),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkbox & TextField ListView Example'),
      ),
      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Checkbox(
                  value: itemList[index].isChecked,
                  onChanged: (value) {
                    setState(() {
                      itemList[index].isChecked = value!;
                    });
                  },
                ),
                SizedBox(width: 8.0),
                Text(itemList[index].name),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    onChanged: (text) {
                      itemList[index].textFieldData = text;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter text',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SelectedItemsPage(selectedItems: getSelectedItems()),
            ),
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }

  List<ListItem> getSelectedItems() {
    return itemList.where((item) => item.isChecked).toList();
  }
}

class SelectedItemsPage extends StatelessWidget {
  final List<ListItem> selectedItems;

  SelectedItemsPage({required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Items'),
      ),
      body: ListView.builder(
        itemCount: selectedItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Name: ${selectedItems[index].name}'),
            subtitle:
                Text('TextField Data: ${selectedItems[index].textFieldData}'),
          );
        },
      ),
    );
  }
}
