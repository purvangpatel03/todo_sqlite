import 'package:flutter/material.dart';
import 'package:todo_sqlite/sqflite_helper.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // TextEditingController is used to control the text field.
  final TextEditingController _controller = TextEditingController();

  //helper is the instance of the SqfliteHelper class.
  SqfliteHelper helper = SqfliteHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Todo App')),
        body: FutureBuilder(
            //helper.getTasks() returns a Future<List<Map<String, dynamic>>>.
            future: helper.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                //snapshot.data is the list of tasks that we get from the database.
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                          leading: Checkbox(
                              //We use 1 for true and 0 for false.
                              value: snapshot.data?[index]['status'] == 1
                                  ? true
                                  : false,
                              onChanged: (value) async {
                                //updateTask method takes the id of the task and the status to be updated.
                                await helper.updateTask(
                                    snapshot.data?[index]['id'], value!);
                                //setState is used to update the UI.
                                setState(() {});
                              }),
                          title: Text(snapshot.data?[index]['title']),
                          trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                //deleteTask method takes the id of the task to be deleted.
                                await helper
                                    .deleteTask(snapshot.data?[index]['id']);
                                //setState is used to update the UI.
                                setState(() {});
                              }));
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              //showDialog is used to show a dialog box, it takes a context and a builder.
              showDialog(
                  context: context,
                  builder: (context) {
                    //AlertDialog is a dialog box with a title, content, and actions.
                    return AlertDialog(
                        title: const Text('Add Task'),
                        content: TextField(
                            //autofocus is used to focus the text field when the dialog box is shown.
                            autofocus: true,
                            //controller is used to control the text field.
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Enter title',
                            )),
                        actions: [
                          TextButton(
                              onPressed: () {
                                //Navigator.pop is used to close the dialog box.
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () async {
                                //insertTask method takes the title of the task and the status.
                                await helper.insertTask(
                                    _controller.text, false);
                                //clear is used to clear the text field.
                                _controller.clear();
                                //here we are checking if the widget is mounted before popping the dialog box.
                                //because we are using context in async functions.
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                                //setState is used to update the UI.
                                setState(() {});
                              },
                              child: const Text('Add'))
                        ]);
                  });
            },
            child: const Icon(Icons.add)));
  }
}
