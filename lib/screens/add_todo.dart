import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:todo/models/todo.dart';

class AddTodo extends StatefulWidget {
  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  var titleController = new TextEditingController();
  var itemNameController = new TextEditingController();
  var items = <String>[];
  ValueNotifier<String> item = new ValueNotifier("");

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(19, 31, 37, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(32, 51, 60, 1),
        title: Text('Add item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                maxLength: 15,
                maxLengthEnforced: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      letterSpacing: 1,
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: itemNameController,
                      decoration: InputDecoration(
                          hintText: 'Item',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            letterSpacing: 1.2,
                          )),
                    ),
                  ),
                  FlatButton(
                    color: Color.fromRGBO(52, 93, 129, 1),
                    onPressed: () {
                      var myGravity =
                          MediaQuery.of(context).viewInsets.bottom == 0
                              ? Toast.BOTTOM
                              : Toast.CENTER;
                      if (itemNameController.text.isNotEmpty) {
                        if (!items.contains(itemNameController.text)) {
                          item.value = itemNameController.text;
                          items.add(itemNameController.text);
                        }
                        itemNameController.clear();
                      } else {
                        showToast("Item should not be empty...",
                            duration: 3, gravity: myGravity);
                      }
                    },
                    child: Text(
                      "Add item",
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Object>(
                  valueListenable: item,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text(items[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.cyanAccent[200])),
                        );
                      },
                      itemCount: items.length,
                    );
                  }),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RaisedButton(
                  color: Color.fromRGBO(52, 93, 129, 1),
                  onPressed: () {
                    // check whether keyboard is open or not
                    var myGravity =
                        MediaQuery.of(context).viewInsets.bottom == 0
                            ? Toast.BOTTOM
                            : Toast.CENTER;

                    if (titleController.text.isEmpty) {
                      showToast("Enter title.",
                          duration: 5, gravity: myGravity);
                    } else if (items.isEmpty) {
                      showToast("Add some items to the list.",
                          duration: 5, gravity: myGravity);
                    } else if (titleController.text.length > 15) {
                      showToast("Title should be  under 16 character length",
                          duration: 5, gravity: myGravity);
                    } else {
                      Navigator.pop(
                          context,
                          Todo(
                              title: titleController.text.toUpperCase(),
                              items: items));
                    }
                  },
                  child: Text('Save',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
