import 'dart:convert';

import "package:carousel_slider/carousel_slider.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:bpdb_gis_app/widgets/chart/bar_chart_view.dart';
import 'api/api.dart';
import 'main.dart';
import 'quick_access/menu.dart';
import 'quick_access/menu_land.dart';
import 'quick_access/menu_tab.dart';
import 'quick_access/menu_tab_land.dart';
import 'views/FieldMonitoring/add_data.dart';
import 'views/FieldMonitoring/view_data.dart';
import 'views/consumers/filter_consumers.dart';
import 'views/consumers/new_consumer_exp.dart';

import 'views/dt/filter_dt.dart';
import 'views/feederline/feederline_filter.dart';

import 'views/help_popup.dart';
import 'views/map/arc_gis_map.dart';
import 'views/map/web_view_map.dart';

import 'views/pole/filter_pole_by_snd.dart';
import 'views/profile/profile_page.dart';
import 'views/proposed_pole/add_proposed_pole.dart';

import 'views/proposed_pole/view_proposed_pole_list.dart';
import 'views/regions/circle_filter.dart';
import 'views/regions/esu_filter.dart';
import 'views/pole/filter_pole_detail.dart';
import 'views/regions/snd_filter.dart';
import 'views/regions/substation_filter.dart';
import 'views/regions/zone_view.dart';
import 'widgets/chart/pie_chart_view.dart';
import 'widgets/login/signin.dart';
import 'widgets/menu/bottom_menu_bar.dart';
import 'models/Login/login.dart';
import 'constants/constant.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //bool _isExpanded = false;
  //User? user = globalUser;
  UniqueKey region = UniqueKey();
  UniqueKey feederline = UniqueKey();
  UniqueKey pole = UniqueKey();
  UniqueKey consumer = UniqueKey();
  UniqueKey profile = UniqueKey();
  UniqueKey dt = UniqueKey();
  UniqueKey fm = UniqueKey();

  final List<Map<String, String>> _carouselItems = [
    {
      'imagePath': 'assets/images/carousel/barabkunda_ss.png',
      'title': 'Barabkunda Substation',
    },
    {
      'imagePath': 'assets/images/carousel/bpdb_dt.jpg',
      'title': 'BPDB Distribution Transformer',
    },
    {'imagePath': 'assets/images/carousel/bpdb_pole.jpg', 'title': 'BPDB Pole'},
    {
      'imagePath': 'assets/images/carousel/bpdb_pole_2.jpg',
      'title': 'BPDB Pole 2',
    },
    {
      'imagePath': 'assets/images/carousel/bpdb_substation.jpg',
      'title': 'BPDB Substation',
    },
    {
      'imagePath': 'assets/images/carousel/bpdb_substation_2.jpg',
      'title': 'BPDB Substation 2',
    },
  ];

  // final List<Map<String, String>> _textCarouselItems = [
  //   {'title': 'Feeders', 'value': '1,740'},
  //   {'title': 'D/T', 'value': '23,883'},
  //   {'title': 'Poles', 'value': '5,76,400'},
  //   {'title': 'Consumers', 'value': '9,38,855'},
  //   {'title': 'Service Points', 'value': '1,47,897'},
  //   {'title': 'Substations', 'value': '151'},
  // ];

  final List<Map<String, String>> _textCarouselItems = [
    {'title': 'Feeders', 'value': '0'},
    {'title': 'D/T', 'value': '0'},
    {'title': 'Shared Poles', 'value': '0'},
    {'title': 'Poles', 'value': '0'},
    {'title': 'Consumers', 'value': '0'},
    {'title': 'Service Points', 'value': '0'},
    {'title': 'Substations', 'value': '0'},
  ];

  int _currentSlide = 0;
  late List<bool> _buttonStates;

  @override
  void initState() {
    super.initState();
    getDashboardCounting();
    _buttonStates = List.generate(5, (index) => false);
    _pieController.text = pieDropdown.first['value'].toString();
    _barController.text = barDropdown.first['value'].toString();
    selectedData = pieDropdown[0]["value"];
    selectedBarData = barDropdown[0]["value"];
  }

  void getDashboardCounting() async {
    try {
      // Map<String, dynamic> consumerCount =
      //     await CallApi().fetchDashboardCounting();
      String consumerCount = await CallApi().fetchDashboardCounting();
      Map<String, dynamic> consumerCountMap = jsonDecode(consumerCount);
      setState(() {
        _textCarouselItems[0]['value'] = consumerCountMap['feederline']
            .toString();
        _textCarouselItems[1]['value'] = consumerCountMap['dt'].toString();
        _textCarouselItems[2]['value'] = consumerCountMap['detailPole']
            .toString();
        _textCarouselItems[3]['value'] = consumerCountMap['uniquePole']
            .toString();

        _textCarouselItems[4]['value'] = consumerCountMap['consumer']
            .toString();
        _textCarouselItems[5]['value'] = consumerCountMap['servicePoint']
            .toString();
        _textCarouselItems[6]['value'] = consumerCountMap['substation']
            .toString();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }

      _textCarouselItems[0]['value'] = "0";
      _textCarouselItems[1]['value'] = "0";
      _textCarouselItems[2]['value'] = "0";
      _textCarouselItems[3]['value'] = "0";
      _textCarouselItems[4]['value'] = "0";
      _textCarouselItems[5]['value'] = "0";
      _textCarouselItems[6]['value'] = "0";
    }
  }

  //////////////////// -----Chart ----- /////////////////////
  String? selectedData;
  String? selectedBarData;
  String PieChartheading = "Wise Consumer Count";
  String BarChartHeading = "Wise Consumer Info Report";
  final _pieController = TextEditingController();
  final _barController = TextEditingController();
  final List<Map<String, dynamic>> pieDropdown = [
    {"value": "1", "text": "Consumer"},
    {"value": "2", "text": "Pole"},
  ];
  final List<Map<String, dynamic>> barDropdown = [
    {"value": "1", "text": "Consumer"},
    {"value": "2", "text": "Pole"},
  ];
  void _onDropdownChanged(String? newValue) {
    setState(() {
      selectedData = newValue;
      PieChartheading = selectedData == "1"
          ? "Wise Consumer Count"
          : "Wise Pole Count";
    });
  }

  void _onBarDropdownChanged(String? newValue) {
    setState(() {
      selectedBarData = newValue;
      BarChartHeading = selectedBarData == "1"
          ? "Wise Consumer Info Report"
          : "Wise Pole Info Report";
    });
  }

  //////////////////// -----Chart ----- /////////////////////
  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //print("height and width: $height and $width");
    User? user = globalUser;
    int? group_id = user?.GroupId;
    String heading = "Zone";
    // Fluttertoast.showToast(
    //     msg: globalToken!,
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    double carouselheight;
    double imgheight;
    double pieheight;
    double barheight;
    double regionheight;
    double feederlineheight;
    double consumerheight;
    double countboxheight;
    double sliderheight;
    double topperheight;
    double carouselContainerHeight;
    double pplineheight;
    int expandRange;

    if (height < 1300 && height > 900) {
      // print(height);
      //print("1");
      pieheight = height / 2.6;
      barheight = height / 2;
      regionheight = height * 0.24;
      feederlineheight = height * 0.05;
      consumerheight = height * 0.1;
      carouselheight = height / 3;
      carouselContainerHeight = height / 2.9;
      imgheight = height / 4;
      countboxheight = height / 9.5;
      sliderheight = height / 3.9;
      topperheight = height / 6;
      pplineheight = height / 10;
    } else if (height < 900 && height > 600) {
      // print(height);
      //print("2");
      pieheight = height * 0.48;
      barheight = height * 0.55;
      regionheight = height * 0.22;
      feederlineheight = height / 16;
      consumerheight = height * 0.09;
      //carouselheight = height / 3;
      carouselheight = height / 4;
      // carouselContainerHeight = height / 2.5;
      carouselContainerHeight = height / 4;
      //imgheight = height / 3.5;
      imgheight = height / 5;
      countboxheight = height / 8.5;
      sliderheight = height / 7;
      topperheight = height / 5;
      pplineheight = height / 8;
    } else if (height < 450 && height > 400) {
      //print("Iphone 17");
      //print("6");
      pieheight = height * 0.75;
      barheight = height * 0.75;
      regionheight = height * 0.35;
      feederlineheight = height * 0.1;
      consumerheight = height * 0.15;
      carouselheight = height / 3;
      carouselContainerHeight = height / 2.5;
      imgheight = height / 3.5;
      countboxheight = height / 4.5;
      sliderheight = height / 5;
      topperheight = height / 4.5;
      pplineheight = height / 10;
    } else if (height < 600 && height > 400) {
      // print(height);
      // print("3");
      pieheight = height * 0.6;
      barheight = height * 0.7;
      regionheight = height * 0.39;
      feederlineheight = height * 0.09;
      consumerheight = height * 0.15;
      carouselheight = height / 3;
      carouselContainerHeight = height / 2.5;
      imgheight = height / 3.5;
      countboxheight = height / 8.5;
      sliderheight = height / 7;
      topperheight = height / 4.5;
      pplineheight = height / 6;
    } else if (height < 400 && height > 200) {
      // print(height);
      // print("4");
      pieheight = height * 0.9;
      barheight = height * 1.2;
      regionheight = height * 0.5;
      feederlineheight = height / 8;
      consumerheight = height * 0.2;
      carouselheight = height / 2.8;
      carouselContainerHeight = height / 2.5;
      imgheight = height / 3.8;
      countboxheight = height / 5;
      sliderheight = height / 4;
      topperheight = height / 3.2;
      pplineheight = height / 4;
    } else {
      // print(height);
      // print("5");
      pieheight = height * 0.54;
      barheight = height * 0.89;
      regionheight = height * 0.40;
      feederlineheight = height * 0.14;
      consumerheight = height * 0.14;
      carouselheight = height / 3;
      carouselContainerHeight = height / 2.5;
      imgheight = height / 3.5;
      countboxheight = height / 8.5;
      sliderheight = height / 7;
      topperheight = height / 4.5;
      pplineheight = height / 12;
    }
    //print(width);
    if (width >= 900) {
      expandRange = 6;
    } else if (width >= 700) {
      expandRange = 5;
    } else if (width >= 600) {
      expandRange = 4;
    } else {
      expandRange = 3;
    }

    if (group_id == 1) {
      heading = "Zone";
    } else if (group_id == 5) {
      heading = "Circle";
    } else if (group_id == 6) {
      heading = "Snd";
    } else if (group_id == 7) {
      heading = "Substation";
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Stack(
          children: [Container(color: Color.fromARGB(255, 3, 89, 100))],
        ),
        automaticallyImplyLeading: false, // Disable the default leading icon
        title: Text(
          "BPDB GIS APP",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: deviceFontSize + 6,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // if (kDebugMode) {
              //   print('EndDrawer icon tapped');
              // }
              _scaffoldKey.currentState?.openEndDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/new_icons/new_drawer.png',
                fit: BoxFit.contain,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),

      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.78,
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: topperheight,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 3, 89, 100),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(
                        'assets/images/bpdb_logo.png',
                      ),
                      radius: 35,
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "User Name: \n${user?.UserName}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 13.5,
                          ),
                        ),
                        Divider(
                          color: Colors.white,
                          height: 0.1,
                          thickness: 1,
                        ),
                        Text(
                          'Login Date and Time:\n$LoginTime',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Color.fromARGB(255, 3, 89, 100)),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            ///////////////-----Regions Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: region,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      feederline = UniqueKey();
                      pole = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  'assets/icons/worldwide.png',
                  width: 24,
                  height: 24,
                ),
                title: const Text('Regions'),
                children: [
                  Container(
                    height: regionheight,
                    //child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 13),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewZone(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/map_legend/zone.png',
                                  width: 24,
                                  height: 24,
                                  colorBlendMode: BlendMode.multiply,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text(
                                    'Zone',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 13),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => ViewCircles(),
                                  builder: (context) => CircleFilterPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/map_legend/circle.png',
                                  width: 24,
                                  height: 24,
                                  colorBlendMode: BlendMode.multiply,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text(
                                    'Circle',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 13),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => ViewSnd(),
                                  builder: (context) => SndFilterPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/map_legend/snd.png',
                                  width: 24,
                                  height: 24,
                                  colorBlendMode: BlendMode.multiply,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text(
                                    'SnD',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 13),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => ViewEsu(),
                                  builder: (context) => ESUFilterPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/map_legend/esu.png',
                                  width: 24,
                                  height: 24,
                                  colorBlendMode: BlendMode.multiply,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text(
                                    'Esu',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 13),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => ViewSubstation(),
                                  builder: (context) => SubstationFilterPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/map_legend/substation_map.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text(
                                    'Substation',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///////////////-----Regions Menu-----////////////////
            ///////////////-----Feeder Line Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: feederline,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      pole = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  'assets/icons/feederline_2.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('Feeder Line'),
                children: [
                  Container(
                    //height: 120,
                    height: feederlineheight,
                    //child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 30.0, top: 8),
                        //   child: GestureDetector(
                        //     onTap: () async {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => NewFedderLineExp(),
                        //         ),
                        //       );
                        //     },
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.add,
                        //           color: Color.fromARGB(255, 7, 105, 185),
                        //         ),
                        //         SizedBox(width: 8),
                        //         Container(
                        //           width: width * 0.5,
                        //           child: Text(
                        //             'New Feeder Line',
                        //             style: TextStyle(fontSize: 16),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // -- Old Feederline View Button -- //
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 18),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeederLineFilter(),
                                  // builder: (context) => ViewFeederlines(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.view_agenda,
                                  color: Color.fromARGB(255, 124, 173, 7),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text(
                                    'View Feeder Line',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // -- Old Feederline View Button -- //

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 16.0),
                        //   child: ListTile(
                        //     //minTileHeight: 40,
                        //     leading: const Icon(
                        //       Icons.table_chart,
                        //       color: Color.fromARGB(255, 241, 59, 59),
                        //     ),
                        //     title: const Text('View Feeder Line'),
                        //     onTap: () async {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ViewFeederlinesTable(),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    //),
                  ),
                ],
              ),
            ),
            ///////////////-----Feeder Line Menu-----////////////////
            ///////////////-----Pole Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: pole,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      feederline = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  // 'assets/icons/pole.png',
                  'assets/icons/power-line.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('Pole'),
                children: [
                  Container(
                    //height: 90,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListTile(
                              //minTileHeight: 40,
                              leading: const Icon(
                                Icons.view_stream,
                                color: Color.fromARGB(255, 35, 159, 216),
                              ),
                              title: const Text('View Pole Details'),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterPoleDetails(),
                                  ),
                                );
                              },
                            ),
                          ),

                          //Pole List//
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListTile(
                              //minTileHeight: 40,
                              leading: const Icon(
                                Icons.view_stream,
                                color: Color.fromARGB(255, 35, 216, 35),
                              ),
                              title: const Text('View Poles'),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterPoleBySnd(),
                                  ),
                                );
                              },
                            ),
                          ),
                          //Pole List//
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ///////////////-----Pole Menu-----////////////////
            ///////////////-----DT Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: dt,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      pole = UniqueKey();
                      region = UniqueKey();
                      feederline = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  'assets/icons/transformer.png',
                  width: 24,
                  height: 24,
                  // color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('DT'),
                children: [
                  Container(
                    //height: 90,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListTile(
                              //minTileHeight: 40,
                              leading: const Icon(
                                Icons.view_stream,
                                color: Color.fromARGB(255, 35, 159, 216),
                              ),
                              title: const Text('View DT Details'),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilterDTDetails(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ///////////////-----DT Menu-----////////////////

            ///////////////-----Consumer Menu-----///////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: consumer,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      feederline = UniqueKey();
                      pole = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: const Icon(
                  Icons.group,
                  color: Color.fromARGB(255, 233, 13, 134),
                ),
                title: const Text('Consumer'),
                children: [
                  Container(
                    //height: 144,
                    height: consumerheight,
                    //child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 8),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewConsumerExp(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.group_add,
                                  color: Color.fromARGB(255, 7, 105, 185),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text(
                                    'New Consumer',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 18),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilterConsumers(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.groups_2_outlined,
                                  color: Color.fromARGB(255, 124, 173, 7),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: width * 0.5,
                                  child: Text(
                                    'View Consumers',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 16.0),
                        //   child: ListTile(
                        //     //minTileHeight: 40,
                        //     leading: const Icon(
                        //       Icons.groups_2_outlined,
                        //       color: Color.fromARGB(255, 124, 173, 7),
                        //     ),
                        //     title: const Text('View Tariff Sub-Categories'),
                        //     onTap: () async {
                        //       //List<String> roadLinkNumbers = await dbHelper.getRoadLinkNumbers();

                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ViewTariffSubCategory(),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    //),
                  ),
                ],
              ),
            ),

            // ListTile(
            //   //minTileHeight: 40,
            //   leading: Icon(
            //     Icons.map_rounded,
            //     color: const Color.fromARGB(255, 127, 83, 134),
            //   ),
            //   title: const Text('Map Viewer'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => MapViewer(title: 'Map Viewer'),
            //       ),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(
            //     Icons.map_rounded,
            //     color: const Color.fromARGB(255, 127, 83, 134),
            //   ),
            //   title: const Text('Web Map Viewer'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const MapWebView(
            //           title: 'Map Viewer'
            //           ),
            //       ),
            //     );
            //   },
            // ),
            //-- New Map Viewer  - (08-05-25) -- //
            ListTile(
              //minTileHeight: 40,
              leading: Icon(
                Icons.map_rounded,
                color: const Color.fromARGB(255, 127, 83, 134),
              ),
              title: const Text('Map Viewer'),
              onTap: () {
                // -- AECGIS ISSUE -- //
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapWebView(
                      title: 'Map Viewer',
                    ),
                  ),
                );
              
                // -- AECGIS ISSUE -- //
              },
            ),
            //-- New Map Viewer  - (08-05-25) -- //
            //-- Proposed Pole - (15-07-25) -- //
            // ListTile(
            //   //minTileHeight: 40,
            //   leading: Icon(
            //     Icons.electric_meter,
            //     color: const Color.fromARGB(255, 98, 83, 134),
            //   ),
            //   title: const Text('Proposed Pole'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ProposedPoleViewer(
            //           title: 'Proposed Pole',
            //         ),
            //         //builder: (context) => MyMap(),
            //       ),
            //     );
            //   },
            // ),
            if (user?.SndId != null || user?.EsuId != null)
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  //minTileHeight: 40,
                  key: feederline,
                  onExpansionChanged: (expanded) {
                    if (expanded = true) {
                      setState(() {
                        region = UniqueKey();
                        pole = UniqueKey();
                        consumer = UniqueKey();
                        profile = UniqueKey();
                        dt = UniqueKey();
                      });
                    }
                  },
                  leading: Image.asset(
                    'assets/icons/feederline.png',
                    width: 24,
                    height: 24,
                    // color: Color.fromARGB(255, 3, 89, 100),
                  ),
                  title: const Text('Proposed Pole'),
                  children: [
                    Container(
                      //height: 120,
                      height: pplineheight,
                      //child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0, top: 18),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewProposedPole(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.view_agenda,
                                    color: Color.fromARGB(255, 7, 173, 7),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    width: width * 0.5,
                                    child: Text(
                                      'View Proposed Poles',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0, top: 18),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddProposedPole(),
                                    // builder: (context) => ViewFeederlines(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Color.fromARGB(255, 3, 180, 3),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    width: width * 0.5,
                                    child: Text(
                                      'Add Proposed Poles',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      //),
                    ),
                  ],
                ),
              ),

            //-- Proposed Pole - (15-07-25) -- //

            //-- Field Monitoring - (05-04-26) -- //
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: fm,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      feederline = UniqueKey();
                      consumer = UniqueKey();
                      profile = UniqueKey();
                      dt = UniqueKey();
                      pole = UniqueKey();
                    });
                  }
                },
                leading: Icon(
                  Icons.track_changes,
                  color: const Color.fromARGB(255, 127, 83, 134),
                ),
                title: const Text('Field Monitoring'),
                children: [
                  Container(
                    //height: 90,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListTile(
                              //minTileHeight: 40,
                              leading: const Icon(
                                Icons.view_stream,
                                color: Color.fromARGB(255, 35, 159, 216),
                              ),
                              title: const Text('View Field Monitoring Details'),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewFieldMonitoringData(),
                                  ),
                                );
                              },
                            ),
                          ),

                          //Pole List//
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ListTile(
                              //minTileHeight: 40,
                              leading: const Icon(
                                Icons.add_box,
                                color: Color.fromARGB(255, 35, 216, 35),
                              ),
                              title: const Text('Add Field Monitoring Data'),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FieldMonitoring(),
                                  ),
                                );
                              },
                            ),
                          ),
                          //Pole List//
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //-- Field Monitoring - (05-04-26) -- //
            Divider(),
            ///////////////-----Profile Menu-----////////////////
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                //minTileHeight: 40,
                key: profile,
                onExpansionChanged: (expanded) {
                  if (expanded = true) {
                    setState(() {
                      region = UniqueKey();
                      feederline = UniqueKey();
                      pole = UniqueKey();
                      consumer = UniqueKey();
                      dt = UniqueKey();
                    });
                  }
                },
                leading: Image.asset(
                  'assets/icons/profile_main.png',
                  width: 24,
                  height: 24,
                  color: Color.fromARGB(255, 3, 89, 100),
                ),
                title: const Text('Profile'),
                children: [
                  Container(
                    //height: height * 0.13,
                    //child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 0),
                          child: ListTile(
                            //minTileHeight: 40,
                            leading: Image.asset(
                              'assets/icons/profile_summary.png',
                              width: 24,
                              height: 24,
                            ),
                            title: const Text('View Profile'),
                            onTap: () async {
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return const ViewProfile();

                              //   },
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            },
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 16.0),
                        //   child: ListTile(
                        //     //minTileHeight: 40,
                        //     leading: Image.asset(
                        //       'assets/icons/profile_settings.png',
                        //       width: 24,
                        //       height: 24,
                        //     ),
                        //     title: const Text('Manage Profile'),
                        //     onTap: () async {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ManageProfile(),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    //),
                  ),
                ],
              ),
            ),
            ///////////////-----Profile Menu-----////////////////
            ListTile(
              //minTileHeight: 40,
              leading: Icon(Icons.logout, color: Colors.amber[600]),
              title: const Text('Sign out'),
              onTap: () async {
                Username.clear();
                Password.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Signed out successfully!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
                await Future.delayed(Duration(seconds: 2));
              },
            ),
          ],
        ),
      ),
      ///////////////////////////////////////////////////////////////////////////////////////////////
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  if (expandRange == 3)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.02,
                        bottom: 4,
                        left: 8,
                        right: 8,
                      ),
                      child: Card(
                        // color: Colors.white,
                        // shadowColor: Colors.teal,
                        child: ToggleRowVisibility(),
                      ),
                    ),

                  if (expandRange == 4)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.02,
                        bottom: 4,
                        left: 8,
                        right: 8,
                      ),
                      child: Card(
                        //color: Colors.white,
                        child: ToggleRowVisibilityTab(),
                      ),
                    ),

                  if (expandRange == 5)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.02,
                        bottom: 4,
                        left: 8,
                        right: 8,
                      ),
                      child: Card(
                        //color: Colors.white,
                        child: ToggleRowVisibility_land(),
                      ),
                    ),

                  if (expandRange == 6)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 0.02,
                        bottom: 4,
                        left: 8,
                        right: 8,
                      ),
                      child: Card(
                        //color: Colors.white,
                        child: ToggleRowVisibilityTab_land(),
                      ),
                    ),

                  //ToggleRowVisibility(),
                  const SizedBox(height: 5),
                  // Container(
                  //   width: width,
                  //   height: carouselContainerHeight,
                  //   decoration: const BoxDecoration(
                  //     //color: Colors.amber,
                  //     color: Colors.white,
                  //   ),
                  //   margin: EdgeInsets.all(0),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(
                  //       top: 0.0,
                  //     ),
                  //     child: Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           CarouselSlider.builder(
                  //             itemCount: _carouselItems.length,
                  //             options: CarouselOptions(
                  //               height: carouselheight,
                  //               enlargeCenterPage: false,
                  //               autoPlay: true,
                  //               aspectRatio: 16 / 9,
                  //               autoPlayCurve: Curves.fastOutSlowIn,
                  //               enableInfiniteScroll: true,
                  //               autoPlayAnimationDuration:
                  //                   const Duration(milliseconds: 800),
                  //               viewportFraction: 0.85,
                  //               onPageChanged: (index, _) {
                  //                 setState(() {
                  //                   _currentSlide = index;
                  //                 });
                  //               },
                  //             ),
                  //             itemBuilder: (context, index, realIndex) {
                  //               final item = _carouselItems[index];

                  //               return Column(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: [
                  //                   Container(
                  //                     width: width,
                  //                     margin: const EdgeInsets.symmetric(
                  //                         horizontal: 10.0),
                  //                     child: ClipRRect(
                  //                       borderRadius:
                  //                           BorderRadius.circular(10.0),
                  //                       child: Image.asset(
                  //                         item['imagePath']!,
                  //                         //fit: BoxFit.cover,
                  //                         fit: BoxFit.fill,
                  //                         height: imgheight,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: height * 0.005),
                  //                   Text(
                  //                     item['title']!,
                  //                     style: const TextStyle(
                  //                       color: Colors.black,
                  //                       fontSize: 16,
                  //                       fontWeight: FontWeight.bold,
                  //                       decoration: TextDecoration.none,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: countboxheight,
                    child: CarouselSlider.builder(
                      itemCount: _textCarouselItems.length,
                      options: CarouselOptions(
                        height: sliderheight,
                        enlargeCenterPage: false,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 800,
                        ),
                        viewportFraction: 0.45,
                        onPageChanged: (index, _) {
                          setState(() {
                            _currentSlide = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        final item = _textCarouselItems[index];

                        return Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          width: MediaQuery.of(context).size.width * 0.9 - 20,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item['title']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item['value']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  /////////// Pie Chart Container //////////
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 0,
                      left: 8,
                      right: 8,
                    ),
                    width: MediaQuery.of(context).size.width,
                    //height: 273,
                    height: pieheight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 220, 240, 243),
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "$heading $PieChartheading",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        DropdownButtonFormField<String>(
                          menuMaxHeight: 140,
                          padding: EdgeInsets.zero,
                          value: selectedData,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: pieDropdown.map((option) {
                            return DropdownMenuItem<String>(
                              value: option['value'].toString(),
                              child: Text(option['text'].toString()),
                            );
                          }).toList(),
                          onChanged: _onDropdownChanged,
                        ),
                        Padding(padding: EdgeInsets.only(top: 5)),
                        if (selectedData != null)
                          PieChartView(selectedData: selectedData),
                        /////////// Pie Chart Container //////////
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  /////////// Bar Chart Container //////////
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 2,
                      left: 8,
                      right: 8,
                    ),
                    width: MediaQuery.of(context).size.width,
                    //height: 273,
                    height: barheight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 220, 240, 243),
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "$heading $BarChartHeading",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          menuMaxHeight: 140,
                          padding: EdgeInsets.zero,
                          value: selectedBarData,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: barDropdown.map((option) {
                            return DropdownMenuItem<String>(
                              value: option['value'].toString(),
                              child: Text(option['text'].toString()),
                            );
                          }).toList(),
                          onChanged: _onBarDropdownChanged,
                        ),
                        Padding(padding: EdgeInsets.only(top: 8)),
                        if (selectedBarData != null)
                          //BarChartView(),
                          BarChartView(selectedBarData: selectedBarData),
                        /////////// Bar Chart Container //////////
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 50)),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 3; i++)
                    BottomMenuBar(
                      icon: _getButtonIcon(i),
                      label: _getButtonLabel(i),
                      isSelected: _buttonStates[i],
                      onPressed: (isSelected) {
                        _updateButtonStates(i);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getButtonIcon(int index) {
    switch (index) {
      case 0:
        return Icons.map_rounded;
      case 1:
        return Icons.home;
      case 2:
        return Icons.help;
      default:
        return Icons.error;
    }
  }

  String _getButtonLabel(int index) {
    switch (index) {
      case 0:
        return 'Map';
      case 1:
        return 'Home';
      case 2:
        return 'Help';
      default:
        return 'Unknown';
    }
  }

  void _updateButtonStates(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _buttonStates.length; i++) {
        _buttonStates[i] = (i == selectedIndex);
      }

      switch (selectedIndex) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapWebView(
                title: 'Map Viewer',
              ),
            ),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
          break;
        case 2:
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const HelpPopup();
            },
          );
          break;
      }
    });
  }
}
