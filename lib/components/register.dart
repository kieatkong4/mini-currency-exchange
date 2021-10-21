import 'package:final_flutter/components/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final_flutter/components/signin.dart';
import 'package:final_flutter/service/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email, password;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signin()),
            );
            onClickBack();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
          backgroundColor: Colors.red[900],
          title: Text("Register", style: TextStyle(color: Colors.white)),
        ),
        body: Container(
            decoration: BoxDecoration(
               image: DecorationImage(
                        image: AssetImage('assets/money.jpg'),
                        fit: BoxFit.cover,
                        ),
            ),
            child: Center(
              child: Container(
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.red,
                              blurRadius: 8.0,
                              offset: Offset(3.0, 3.0),
                            ),
                          ],
                        ),
                      ),
                      Text(""),
                      buildTextFieldEmail(),
                      buildTextFieldPassword(),
                      buildButtonRegister(context),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom,)
                    ],
                  )),
            )));
  }


  Container buildButtonRegister(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(width: 300, height: 50),
        child: InkWell(
          child: Text("Register",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          onTap: () {
            if ((email?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
              aDialog(
                  context, "Have some Space.", 'Please Fill it at all.');
            } else {
              checkRegister(context);
            }
          },
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.purple[700],
            gradient: new LinearGradient(
                colors: [Colors.brown[800], Colors.orange[900]],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft)),
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(12));
  }

  Container buildTextFieldEmail() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value.trim(),
            decoration: InputDecoration.collapsed(hintText: "Email"),
            style: TextStyle(fontSize: 18)));
  }

  Container buildTextFieldPassword() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: TextField(
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) => password = value.trim(),
            obscureText: true,
            decoration: InputDecoration.collapsed(hintText: "Password"),
            style: TextStyle(fontSize: 18)));
  }

  Future<Null> checkRegister(BuildContext context) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final FirebaseAuth auth = FirebaseAuth.instance;
      final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      final User user = auth.currentUser;
      final uid = user.uid;
      users
      .doc(uid)
        .set({})
        .then((value) => aDialog(context, "REGISTER SUCCESSFUL.", 'now you can login.'))
        .catchError((e) =>
            aDialog(context, "ADD DATA FAIL.", 'Please Try Again.')) ;
      await FirebaseAuth.instance.signOut();
      Route route = MaterialPageRoute(
          builder: (context) =>
              MaterialApp(home: Scaffold(body: Signin())));
      Navigator.push(context, route);
    }).catchError((value) =>
        aDialog(context, "Register Error.", 'Please Try Again.'));
  }
  
  void onClickBack() async {
    Route route = MaterialPageRoute(
          builder: (context) =>
              MaterialApp(home: Scaffold(body: Signin())));
      Navigator.push(context, route);
  }
}
