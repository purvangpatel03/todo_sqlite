import 'package:flutter/material.dart';
import 'package:todo_sqlite/sqflite_helper.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {

  final TextEditingController _controller = TextEditingController();
  SqfliteHelper helper = SqfliteHelper();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: FutureBuilder(
        future: helper.getTasks(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount:  snapshot.data?.length ?? 0,
              itemBuilder: (context, index){
            return ListTile(
              leading: Checkbox(
                value: snapshot.data?[index]['status'] == 1 ? true : false,
                onChanged:(value) async{
                  await helper.updateTask(snapshot.data?[index]['id'], value!);
                  setState(() {

                  });
                }
              ),
              title: Text(snapshot.data?[index]['title']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async{
                  await helper.deleteTask(snapshot.data?[index]['id']);
                  setState(() {

                  });
                },
              ),
            );
          });
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Task'),
                  content: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter title',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        helper.insertTask(_controller.text, false);
                        _controller.clear();
                        Navigator.pop(context);
                        setState(() {

                        });
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
