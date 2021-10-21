import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_flutter/components/home2.dart';
import 'package:final_flutter/components/home3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_flutter/service/dialog.dart';
import 'package:final_flutter/components/user.dart';
import 'package:final_flutter/components/signin.dart';
import 'package:final_flutter/components/home.dart';

 
class Home extends StatefulWidget {
 
  Home({Key key}) : super(key: key);
 
  @override
  _HomeState createState() => _HomeState();
}
 
class _HomeState extends State<Home> {
  String status, dollar, baht;
  double sum, thb, usd ,exchange_rate;

  @override
  initState() {
    super.initState();
  }
  
  @override
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
          title: Text("Currency", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.logout,
            color: Colors.white),
            label: Text("Sign Out", 
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,)
                ),
            onPressed: () {
              onClickSignOut();
            },
          )
        ],
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
                        "Currency",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.purple,
                              blurRadius: 8.0,
                              offset: Offset(3.0, 3.0),
                            ),
                            Shadow(
                              color: Colors.orange[300],
                              blurRadius: 8.0,
                              offset: Offset(-3.0, 3.0),
                            ),
                          ],
                        ),
                      ),
                      Text(""),
                      Text(""),
                      buildButton(context),
                      Text(""),
                      buildButton2(context),
                      Text(""),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom,)
                    ],
                  )),
            )));
  }

  Container buildButton(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(width: 300, height: 50),
        child: InkWell(
          child: Text("USD",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          onTap: () {
                rehome2();
            }
        ),
       decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.red[700],
            gradient: new LinearGradient(
                colors: [Colors.brown[800], Colors.orange[900]],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(12));
  }

  Container buildButton2(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(width: 300, height: 50),
        child: InkWell(
          child: Text("EUR",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          onTap: () {
                rehome3();
            }
        ),
       decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.red[700],
            gradient: new LinearGradient(
                colors: [Colors.brown[800], Colors.orange[900]],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight)),
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(12));
  }

  void rehome2() async {
    Route route = MaterialPageRoute(
          builder: (context) =>
              MaterialApp(home: Scaffold(body: Home2())));
      Navigator.push(context, route);
  }
  void rehome3() async {
    Route route = MaterialPageRoute(
          builder: (context) =>
              MaterialApp(home: Scaffold(body: Home3())));
      Navigator.push(context, route);
  }

  void onClickSignOut() async {
    await FirebaseAuth.instance.signOut();
    aDialog(context, "Sign Out", '');
    Route route = MaterialPageRoute(
          builder: (context) =>
              MaterialApp(home: Scaffold(body: Signin())));
      Navigator.push(context, route);
  }
  
  void onClickBack() async {
    Route route = MaterialPageRoute(
          builder: (context) =>
              MaterialApp(home: Scaffold(body: Signin())));
      Navigator.push(context, route);
  }

  void buildNewStatus() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final User user = auth.currentUser;
    final uid = user.uid;

    users
        .doc(uid)
        .update({'status': '$status', 'currency': '$sum'})
        .then((value) => aDialog(context, "ADD DATA SUCCESSFUL.", ''))
        .catchError((e) =>
    users
        .doc(uid)
        .set({'status': '$status', 'currency': '$sum'})
        .then((value) => aDialog(context, "ADD DATA SUCCESSFUL.", ''))
        .catchError((e) =>
            aDialog(context, "ADD DATA FAIL.", 'Please Try Again.')) );  
  }
}