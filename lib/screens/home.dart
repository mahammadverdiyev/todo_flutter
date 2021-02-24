import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/add_todo.dart';
import 'package:todo/utils/file_util.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoStorage storage = new TodoStorage();

  List<Todo> todos;

  @override
  void initState() {
    readData();
    super.initState();
  }

  void readData() async {
    todos = [];
    await storage.readTodoList().then((todoList) {
      todos = todoList;
    });

    // List<Todo> _fetchedItems = await storage.readTodoList();

    for (int i = 0; i < todos.length; i++) {
      listKey.currentState.insertItem(i, duration: Duration(milliseconds: 800));
    }

    // for (var item in _fetchedItems) {
    //   await Future.delayed(Duration(milliseconds: 300));
    //   // todos.add(item);
    //   todos.insert(0, item);
    //   listKey.currentState.insertItem(0);
    // }
  }

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  var isPressed = false;

  Route _createRoute() {
    return PageRouteBuilder<Todo>(
      pageBuilder: (context, animation, secondaryAnimation) => AddTodo(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOutQuint;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(19, 31, 37, 1),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(
                            color: Color.fromRGBO(52, 93, 129, 1),
                            style: BorderStyle.solid,
                          ),
                        ),
                        onPressed: () async {
                          Todo addedItem =
                              await Navigator.push(context, _createRoute());

                          if (addedItem != null) {
                            for (int i = 0; i < todos.length; i++) {
                              if (addedItem.title == todos[i].title) {
                                Set<String> set = new Set();
                                set.addAll(addedItem.items as List<String>);
                                set.addAll(todos[i].items as List<String>);

                                addedItem.items = set.toList();
                                listKey.currentState.removeItem(
                                    i,
                                    (_, animation) =>
                                        slideIt(context, 0, animation),
                                    duration:
                                        const Duration(milliseconds: 500));
                                todos.removeAt(i);
                                break;
                              }
                            }

                            listKey.currentState.insertItem(0,
                                duration: const Duration(milliseconds: 500));

                            todos.insert(0, addedItem);

                            storage.writeTodo(todos);
                          }
                        },
                        padding: EdgeInsets.all(10.0),
                        color: Color.fromRGBO(52, 93, 129, 1),
                        textColor: Colors.white,
                        child: Icon(
                          Icons.add,
                          size: 30,
                        )),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                // child: _buildTodoContainer(),
                child: AnimatedList(
                  scrollDirection: Axis.horizontal,
                  key: listKey,
                  initialItemCount: todos.length,
                  itemBuilder: (context, index, animation) {
                    return slideIt(context, index, animation);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget slideIt(BuildContext context, int index, Animation<double> animation) {
    //SlideTransition

    return SlideTransition(
      position: Tween<Offset>(
        // begin: const Offset(0, -1),
        // end: Offset(0, 0),
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(CurvedAnimation(
        // curve: Curves.easeOut,
        curve: Curves.easeInOutQuint,
        parent: animation,

        // reverseCurve: Curves.bounceOut,
      )),
      // you can  wrap this widget with RotationTransition

      child: SizeTransition(
        axis: Axis.horizontal,
        sizeFactor: animation,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(32, 51, 60, 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                height: double.infinity,
                width: MediaQuery.of(context).size.width * 0.55,
                child: Column(
                  children: [
                    Text(todos[index].title,
                        style: TextStyle(
                          color: Color.fromRGBO(84, 156, 215, 1),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        )),
                    SizedBox(height: 5),
                    Expanded(
                        child: ListView.builder(
                      itemCount: todos[index].items.length,
                      itemBuilder: (_, index2) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${index2 + 1}.  ",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white54,
                                  fontWeight: FontWeight.bold,
                                )),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 6),
                                child: Text(
                                  todos[index].items[index2],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    letterSpacing: 0.5,
                                    fontFamily: 'Roboto',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  softWrap: false,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ))
                  ],
                ),
              ),
            ),
            FloatingActionButton(
              backgroundColor: Color.fromRGBO(52, 93, 129, 1),
              heroTag: null,
              onPressed: () async {
                try {
                  if (!isPressed) {
                    isPressed = true;

                    Timer(Duration(milliseconds: 100), () async {
                      listKey.currentState.removeItem(index,
                          (_, animation) => slideIt(context, 0, animation),
                          duration: const Duration(milliseconds: 500));

                      await Future.delayed(Duration(milliseconds: 400));

                      todos.removeAt(index);
                      await storage.writeTodo(todos);

                      isPressed = false;
                    });
                  }
                } catch (e) {
                  print('INDEX ERROR');
                }
              },
              child: Icon(
                Icons.close,
                // color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
