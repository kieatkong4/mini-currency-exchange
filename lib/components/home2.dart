import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_flutter/components/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_flutter/service/dialog.dart';
import 'package:final_flutter/components/user.dart';
import 'package:final_flutter/components/signin.dart';
import 'package:final_flutter/components/home2.dart';

 
class Home2 extends StatefulWidget {
 
  Home2({Key key}) : super(key: key);
 
  @override
  _Home2State createState() => _Home2State();
}
 
class _Home2State extends State<Home2> {
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
            color: Colors.amber[100],
            child: Center(
              child: Container(
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Dollar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.grey[850],
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.red[400],
                              blurRadius: 8.0,
                              offset: Offset(3.0, 3.0),
                            ),
                          ],
                        ),
                      ),
                      Text(""),
                      Text(""),
                      Text(""),

                      buildTextFieldOutput(),
                      Text(""),
                      Text(""),
                      Text(""),
                      buildTextFieldBaht(),
                      Text(""),
                      buildTextFieldDollar(),
                      Text(""),
                      buildButtonConvert(context),
                      Text(""),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom,)
                    ],
                  )),
            )));
  }

  Container buildButtonConvert(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(width: 300, height: 50),
        child: InkWell(
          child: Text("Convert",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          onTap: () {
            if ((dollar != null) && (baht != null)) {
              aDialog(
                  context, "Error", "Please enter only one field.");
                  refresh();
            }else if ((baht == null) && (dollar == null)) {
              aDialog(
                  context, "Don't fill ", "Please fill in completely.");
                  refresh();
            } if ((baht!= null) && (dollar == null)) {
                thb = double.parse(baht);
                exchange_rate = 0.03; 
                sum = thb * exchange_rate;
                status = "dollar";
                buildNewStatus();
                refresh();
            }else if ((baht == null) && (dollar != null)) {
                usd = double.parse(dollar);
                exchange_rate = 31; 
                sum = usd * exchange_rate;
                status = "baht";
                buildNewStatus();
                refresh();
              }
            },
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
  

  Container buildTextFieldBaht() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => baht = value.trim(),
            decoration: InputDecoration.collapsed(hintText: "baht"),
            style: TextStyle(fontSize: 18)));
  }

  Container buildTextFieldDollar() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => dollar = value.trim(),
            decoration: InputDecoration.collapsed(hintText: "dollar"),
            style: TextStyle(fontSize: 18)));
  }

  Container buildTextFieldOutput() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final User user = auth.currentUser;
    final uid = user.uid;    
        return Container(
          child: StreamBuilder(
          stream: users.doc(uid).snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Text('loading...');
            }
            print(snap.data.data());
            String data = UserInf.fromJson(snap.data.data()).toString(); 
            return Text(data ,style: TextStyle(fontSize: 25, color: Colors.black));
          }),
        );
  }
  void refresh() async {
    Route route = MaterialPageRoute(
          builder: (context) =>
              MaterialApp(home: Scaffold(body: Home2())));
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
              MaterialApp(home: Scaffold(body: Home())));
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
        .update({'currency': '$status', 'money': '$sum'})
        .then((value) => aDialog(context, "ADD DATA SUCCESSFUL.", ''))
        .catchError((e) =>
    users
        .doc(uid)
        .set({'currency': '$status', 'money': '$sum'})
        .then((value) => aDialog(context, "ADD DATA SUCCESSFUL.", ''))
        .catchError((e) =>
            aDialog(context, "ADD DATA FAIL.", 'Please Try Again.')) );  
  }
}