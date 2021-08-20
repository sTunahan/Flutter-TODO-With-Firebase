import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskSceen extends StatefulWidget {
  const TaskSceen({Key? key}) : super(key: key);

  @override
  _TaskSceenState createState() => _TaskSceenState();
}

class _TaskSceenState extends State<TaskSceen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task Add"),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "Task Name", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: deadlineController,
              decoration: InputDecoration(
                  labelText: "Deadline", border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                addData();
                Fluttertoast.showToast(msg: "Registration Successful");
              },
              child: Text("Task Add"),
            ),
          ],
        ),
      ),
    );
  }

  void addData() async {
    FirebaseAuth authority = FirebaseAuth.instance;

    User currentUser = await authority.currentUser!;

    String uidHolder = currentUser.uid;

    var TimeHolder = DateTime.now();

    FirebaseFirestore.instance
        .collection("Tasks")
        .doc(uidHolder)
        .collection("Task")
        .doc(TimeHolder.toString())
        .set({
      "name": nameController.text,
      "DeadLine": deadlineController.text,
      "Time": TimeHolder.toString(),
      "Full Time": TimeHolder
    });
  }
}
