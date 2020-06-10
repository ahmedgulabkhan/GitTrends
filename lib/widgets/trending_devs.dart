import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:git_trends/models/developer.dart';
import 'package:git_trends/shared/loading.dart';
import 'package:github_trending/github_trending.dart';


// Date Range class
class DateRange {
  int id;
  String name;
 
  DateRange(this.id, this.name);
 
  static List<DateRange> getDateRanges() {
    return <DateRange>[
      DateRange(1, 'Today'),
      DateRange(2, 'This week'),
      DateRange(3, 'This month'),
    ];
  }
}


// Trending repos class
class TrendingDevs extends StatefulWidget {

  @override
  _TrendingDevsState createState() => _TrendingDevsState();
}

class _TrendingDevsState extends State<TrendingDevs> {

  List<DateRange> _dateRanges = DateRange.getDateRanges();
  List<DropdownMenuItem<DateRange>> _dropdownMenuDateRanges;
  DateRange _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _dropdownMenuDateRanges = buildDropdownMenuDateRanges(_dateRanges);
    _selectedDateRange = _dropdownMenuDateRanges[0].value;
  }
  
  List<DropdownMenuItem<DateRange>> buildDropdownMenuDateRanges(List dateRanges) {
    List<DropdownMenuItem<DateRange>> dateRangeItems = List();
    for (DateRange dateRange in dateRanges) {
      dateRangeItems.add(
        DropdownMenuItem(
          value: dateRange,
          child: Text(dateRange.name),
        ),
      );
    }
    return dateRangeItems;
  }

  Future<List<Developer>> _getTrendingRepos() async {
    String _apiParameter = 'daily';

    if(_selectedDateRange.name == 'Today' || _selectedDateRange.name == '') {
      _apiParameter = 'daily';
    }
    else if(_selectedDateRange.name == 'This week') {
      _apiParameter = 'weekly';
    }
    else {
      _apiParameter = 'monthly';
    }

    var repoData = await getTrendingDevelopers(since: _apiParameter);

    List<Developer> developers = [];

    for(var d in repoData) {
      dynamic developer = Developer(
        username: d.name, name: d.name, type: d.type, url: d.url, avatarUrl: d.avatar,
        repoName: d.repo.name, repoDescription: d.repo.description, repoUrl: d.repo.url
      );

      developers.add(developer);
    }

    return developers;
  }

  onChangeDropdownDateRange(DateRange selectedDateRange) {
    setState(() {
      _selectedDateRange = selectedDateRange;
    });
    // print(_selectedDateRange.name);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: Text('Explore Trending Developers', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
            )
          ),

          SizedBox(height: 15.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Date Range:  ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)),

              DropdownButton(
                value: _selectedDateRange,
                items: _dropdownMenuDateRanges,
                onChanged: onChangeDropdownDateRange,
              ),
            ],
          ),

          SizedBox(height: 15.0),

          Expanded(
            child: FutureBuilder(
              future: _getTrendingRepos(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.data == null) {
                  return Center(
                    child: Loading()
                  );
                }
                else {
                  return ListView.builder(
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if(index != snapshot.data.length) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black87,
                            )
                          ),
                          margin: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(snapshot.data[index].avatarUrl),
                                  ),

                                  SizedBox(width: 10.0),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data[index].name, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0)),

                                      SizedBox(height: 10.0),

                                      Text(snapshot.data[index].username)
                                    ],
                                  ),
                                ],
                              ),

                              Divider(height: 20.0),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(FontAwesomeIcons.fire, color: Colors.redAccent, size: 20.0),

                                      SizedBox(width: 3.0),

                                      Text('POPULAR REPO', style: TextStyle(fontSize: 14.0)),
                                    ],
                                  ),

                                  SizedBox(height: 10.0),

                                  Text(snapshot.data[index].repoName, style: TextStyle(color: Colors.blue)),

                                  SizedBox(height: 10.0),

                                  Text(snapshot.data[index].repoDescription)
                                ],
                              )
                            ],
                          ),
                        );
                      }

                      else {
                        return Container(
                          height: 100.0,
                          child: Center(
                            child: Text('Copyright © GitTrends', style: TextStyle(color: Colors.black87, letterSpacing: 1.3, fontWeight: FontWeight.bold)),
                          ),
                        );
                      }
                    }
                  );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}