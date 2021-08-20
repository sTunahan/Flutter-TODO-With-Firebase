import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notebooktwo/tasksceen.dart';

class ToDoSceen extends StatefulWidget {
  const ToDoSceen({Key? key}) : super(key: key);

  @override
  _ToDoSceenState createState() => _ToDoSceenState();
}

class _ToDoSceenState extends State<ToDoSceen> {
  late String currentUserUidHolder;

// WHEN THE FIRST PAGE IS OPENED
  @override
  void initState() {
    // TODO: implement initState
    currentUserHolder();
    super.initState();
  }

  currentUserHolder() async {
    FirebaseAuth authhority = FirebaseAuth.instance;

    User currentUser = await authhority.currentUser!; // get the current user

    setState(() {
      currentUserUidHolder = currentUser.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("TO DO List "),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Tasks")
                .doc(currentUserUidHolder)
                .collection("Task")
                .snapshots(),
            builder: (context, AsyncSnapshot myData) {
              if (myData.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final receivedData = myData.data!.docs;

                return ListView.builder(
                  itemCount: receivedData.length,
                  // If the received data is how many rows, that's the number of rows
                  itemBuilder: (context, index) {
                    // will build a special row for each index

                    // Insert time holder
                    var addTimeReceived =
                        (receivedData[index]["Full Time"] as Timestamp)
                            .toDate();

                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  receivedData[index]["name"],
                                ),
                                Text(DateFormat.yMd()
                                    .add_jm()
                                    .format(addTimeReceived))
                              ],
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            Text(receivedData[index]["DeadLine"]),
                            IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection("Tasks")
                                    .doc(currentUserUidHolder)
                                    .collection("Task")
                                    .doc(receivedData[index]["Time"])
                                    .delete();
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TaskSceen()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
