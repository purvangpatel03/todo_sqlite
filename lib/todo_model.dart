// import 'package:todo_sqlite/sqflite_helper.dart';
//
// class Task{
//   final int? id;
//   final String? title;
//   bool? status;
//
//   Task({
//     this.id,
//     this.title,
//     this.status,
//   });
//
//   SqfliteHelper helper = SqfliteHelper();
//
//   List<Task> tasks = [];
//
//   createTask(Task task) async{
//     await helper.insertTask(task);
//     tasks.clear();
//     await getTasks();
//   }
//
//   deleteTask(Task task) async{
//     final index = tasks.indexOf(task);
//     tasks.removeAt(index);
//     await helper.deleteTask(task.id!);
//   }
//
//   toggleTask(Task task) async{
//     final index = tasks.indexOf(task);
//     tasks[index].status = !tasks[index].status!;
//     await helper.updateTask(tasks[index]);
//   }
//
//   getTasks() async{
//     tasks = await helper.getTasks();
//   }
//
//
//   Task fromMap(Map<String, dynamic> map){
//     return Task(
//       id: map['id'],
//       title: map['title'],
//       status: map['status'] == 1 ? true : false,
//     );
//   }
//
//   Map<String, dynamic> toMap(){
//     return {
//       'id': id,
//       'title': title,
//       'status': status! ? 1 : 0,
//     };
//   }
// }