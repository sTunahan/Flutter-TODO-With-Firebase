import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpSceen extends StatefulWidget {
  const SignUpSceen({Key? key}) : super(key: key);

  @override
  _SignUpSceenState createState() => _SignUpSceenState();
}

// kayıt durumu
bool registrationStatus = false;
//Tutulacak Kullanıcı Bilgileri
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
                          return receivedUserName!
                                  .isEmpty // isEmpty Boş ise demek
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
                        // Firebase e Kayıt etme Fonksıyonu
                        SignUp();
                      },
                      child:
                          registrationStatus ? Text("Logın") : Text("SignUp"),
                    ),
                    TextButton(
                      onPressed: () {
                        // burada ekran gecıslerını saglamak ıcın kullanacagız.
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

// Bilgileri Firebase e yollama fonksıyonu

sendToFirebase(String userName, String email, String password) async {
  final authority = FirebaseAuth.instance; // yetkiyi aldırıyorum
  UserCredential
      resultOfAuthorization; // yetkiye göre sonuç aldırıyorum (resultOfAuthorization=YETKİ SONUCU)

  // kayıt durumu true ise giriş yap

  if (registrationStatus) {
    //bu işlemle girilen  email ve password ile giriş yaptırıyoruz.
    resultOfAuthorization = await authority.signInWithEmailAndPassword(
        email: email, password: password);
  }
  // KayıtOL
  else {
    // Kayıt Oluşturma işlemi  bu işlem ile email ve password bilgileri firebase e kayıt ediliyor.
    resultOfAuthorization = await authority.createUserWithEmailAndPassword(
        email: email, password: password);

    String uidHolder = resultOfAuthorization.user!
        .uid; // ilgili kullanıcının uid sini alıp bir değişkene atıyoruz. Bununlada Her kullanıcıya aid verileri tutacagız.

    await FirebaseFirestore.instance.collection("Users").doc(uidHolder).set({
      "Name:": userName,
      "Email": email
    }); //set ile verileri firebase e yolladık
  }
}
