import 'package:flutter/material.dart';
import 'package:git_trends/pages/home_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('GitTrends', style: TextStyle(color: Colors.white, fontSize: 24.0)),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(
            padding: EdgeInsets.only(top: 50.0),
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Home', style: TextStyle(color: Colors.white, fontSize: 16.0)),
              ),
              ListTile(
                selected: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                leading: Icon(Icons.search),
                title: Text('About', style: TextStyle(fontSize: 16.0)),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Text('About', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
            ),

            SizedBox(height: 30.0),

            Text('GitHub does not offer any official API in order to get the details of the trending repositories and developers for a certain time frame. In order to tackle this problem, GitTrends was created. GitTrends is a small app made using Flutter and has a simple UI. You can contribute to this project by starring the repository on GitHub.', style: TextStyle(fontSize: 15.0)),
          
            SizedBox(height: 50.0),

             Container(
              height: 100.0,
                child: Center(
                  child: Text('Copyright © GitTrends', style: TextStyle(color: Colors.black87, letterSpacing: 1.3, fontWeight: FontWeight.bold)),
                ),
              )
          ],
        )
      ),
    );
  }
}