import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:git_trends/models/repository.dart';
import 'package:git_trends/shared/loading.dart';
import 'package:github_trending/github_trending.dart';

// HexColor class to get the hexcolor
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    
    if(hexColor == null) return int.parse("FF000000", radix: 16);

    else {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF" + hexColor;
      }
      return int.parse(hexColor, radix: 16);
    }
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

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
class TrendingRepos extends StatefulWidget {

  @override
  _TrendingReposState createState() => _TrendingReposState();
}

class _TrendingReposState extends State<TrendingRepos> {

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

  Future<List<Repository>> _getTrendingRepos() async {
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

    var repoData = await getTrendingRepositories(since: _apiParameter);

    List<Repository> repositories = [];

    for(var r in repoData) {
      dynamic repository = Repository(
        author: r.author, repoName: r.name, avatarUrl: r.avatar, repoUrl: r.url,
        description: r.description, language: r.language, languageColor: r.languageColor,
        stars: r.stars, forks: r.forks, currentPeriodStars: r.currentPeriodStars
      );

      repositories.add(repository);
    }

    return repositories;
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
              child: Text('Explore Trending Repositories', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text("${snapshot.data[index].author}/${snapshot.data[index].repoName}", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.blue)),
                              
                              SizedBox(height: 10.0),
                              
                              snapshot.data[index].description == '' ? Text("- - -") : Text(snapshot.data[index].description),

                              SizedBox(height: 10.0),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 6.0,
                                            backgroundColor: HexColor(snapshot.data[index].languageColor)
                                          ),

                                          "${snapshot.data[index].language}" == 'null' ? Text(' NA    ') : Text(" ${snapshot.data[index].language}    "),

                                          Icon(Icons.star_border, color: Colors.black87, size: 20.0),

                                          "${snapshot.data[index].stars}" == 'null' ? Text(' NA    ') : Text("${snapshot.data[index].stars}    "),

                                          Icon(FontAwesomeIcons.codeBranch, size: 15.0),

                                          "${snapshot.data[index].forks}" == 'null' ? Text(' NA') : Text("${snapshot.data[index].forks}")
                                        ],
                                      ),
                                    ),

                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(Icons.star_border, color: Colors.black87, size: 20.0),
                                          "${snapshot.data[index].currentPeriodStars}" == 'null' 
                                          ? 
                                          Text(' NA') 
                                          : 
                                          Text("${snapshot.data[index].currentPeriodStars} ${_selectedDateRange.name.toLowerCase()}")
                                        ],
                                      )
                                    ),
                                  ],
                                ),
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