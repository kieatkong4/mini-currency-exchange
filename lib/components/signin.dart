import 'package:final_flutter/components/Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final_flutter/components/home.dart';
import 'package:final_flutter/service/dialog.dart';

class Signin extends StatefulWidget {
  Signin({Key key}) : super(key: key);
  @override
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Signin> {
  double screenWidth, screenHeight;
  String email, password;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Text("Currency", style: TextStyle(color: Colors.white)),
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
                  margin: EdgeInsets.all(29),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(""),
                      Text(
                        "Sign in",
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
                      buildButtonSignIn(context),
                      buildButtonRegister(context),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      )
                    ],
                  )),
            )));
  }

  Container buildButtonSignIn(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(width: 300, height: 50),
        child: InkWell(
          child: Text("Sign in",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          onTap: () {
            if ((email?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
              aDialog(context, "Have some Space.", 'Please Fill it at all.');
            } else {
              checkAuthentication(context);
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

  Future<Null> checkAuthentication(BuildContext context) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Route route = MaterialPageRoute(
          builder: (context) => MaterialApp(home: Scaffold(body: Home())));
      Navigator.push(context, route);
    }).catchError((value) =>
        aDialog(context, "Wrong email or password.", 'Please Try Again.'));
  }

  Container buildButtonRegister(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(width: 300, height: 50),
        child: InkWell(
          child: Text("Register",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          onTap: () {
            Route route = MaterialPageRoute(
                builder: (context) =>
                    MaterialApp(home: Scaffold(body: Register())));
            Navigator.push(context, route);
          },
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.purple[700],
            gradient: new LinearGradient(
                colors: [Colors.orange[900], Colors.brown[800]],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft)),
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(12));
  }
}
