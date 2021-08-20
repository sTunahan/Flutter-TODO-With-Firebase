import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpSceen extends StatefulWidget {
  const SignUpSceen({Key? key}) : super(key: key);

  @override
  _SignUpSceenState createState() => _SignUpSceenState();
}

// registration status
bool registrationStatus = false;
//User Information to Keep
late String userName, email, password;

class _SignUpSceenState extends State<SignUpSceen> {
  var _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("SignUp Sceen"),
        ),
        body: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    if (!registrationStatus)
                      TextFormField(
                        onChanged: (receivedUserName) {
                          userName = receivedUserName;
                        },
                        validator: (receivedUserName) {
                          return receivedUserName!.isEmpty
                              ? "Boş Bırakılamaz"
                              : null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: ("Name"),
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (receivedEmail) {
                        email = receivedEmail;
                      },
                      validator: (receivedEmail) {
                        return receivedEmail!.contains("@")
                            ? null
                            : "Geçersiz Email";
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: ("Email"),
                          hintText: ("xxxxxx@gmail.com")),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (receivedPassword) {
                        password = receivedPassword;
                      },
                      validator: (receivedPassword) {
                        return receivedPassword!.length >= 6
                            ? null
                            : "Enaz 6 Karakter";
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: ("Password"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        SignUp();
                      },
                      child:
                          registrationStatus ? Text("Logın") : Text("SignUp"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          registrationStatus = !registrationStatus;
                          print("$registrationStatus");
                        });
                      },
                      child: registrationStatus
                          ? Text("Kayıt Ol")
                          : Text("Zaten Hesabım Var"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void SignUp() {
    if (_fromKey.currentState!.validate()) {
      sendToFirebase(userName, email, password);
    }
  }
}

// Function to send information to Firebase

sendToFirebase(String userName, String email, String password) async {
  final authority = FirebaseAuth.instance; // yetkiyi aldırıyorum
  UserCredential resultOfAuthorization;

  if (registrationStatus) {
    resultOfAuthorization = await authority.signInWithEmailAndPassword(
        email: email, password: password);
  }
  // SignUp
  else {
    //Registration Creation process, with this process, email and password information are saved in firebase.
    resultOfAuthorization = await authority.createUserWithEmailAndPassword(
        email: email, password: password);

    String uidHolder = resultOfAuthorization.user!.uid;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(uidHolder)
        .set({"Name:": userName, "Email": email});
  }
}
