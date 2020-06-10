import 'package:flutter/material.dart';
import 'package:git_trends/pages/about_page.dart';
import 'package:git_trends/widgets/trending_devs.dart';
import 'package:git_trends/widgets/trending_repos.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

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
                selected: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                leading: Icon(Icons.home),
                title: Text('Home', style: TextStyle(fontSize: 16.0)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AboutPage()));
                },
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                leading: Icon(Icons.search, color: Colors.white),
                title: Text('About', style: TextStyle(color: Colors.white, fontSize: 16.0)),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        //padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0 ? Colors.black87 : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.black87),
                      ),
                      child: Text(
                        'Trending Repositories',
                        style: TextStyle(
                          color: _selectedIndex == 0 ? Colors.white : Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1 ? Colors.black87 : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.black87),
                      ),
                      child: Text(
                        'Trending Developers',
                        style: TextStyle(
                          color: _selectedIndex == 1 ? Colors.white : Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Divider(
              indent: 25.0,
              endIndent: 25.0,
              height: 20.0,
              color: Colors.black,
            ),

            _selectedIndex == 0 ? TrendingRepos() : TrendingDevs(),

          ],
        ),
      ),
    );
  }
}