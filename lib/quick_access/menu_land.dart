import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../models/Login/login.dart';
import '../views/consumers/filter_consumers.dart';
import '../views/consumers/new_consumer_exp.dart';
import '../views/dt/add_dt.dart';
import '../views/dt/filter_dt.dart';
import '../views/feederline/feederline_filter.dart';
import '../views/proposed_pole/add_proposed_pole.dart';
import '../views/proposed_pole/view_proposed_pole_list.dart';
import '../views/regions/circle_filter.dart';
import '../views/regions/esu_filter.dart';
import '../views/pole/filter_pole_detail.dart';
import '../views/regions/snd_filter.dart';
import '../views/regions/substation_filter.dart';
import '../views/regions/zone_view.dart';
import '../views/map/web_view_map.dart';

class ToggleRowVisibility_land extends StatefulWidget {
  const ToggleRowVisibility_land({Key? key}) : super(key: key);

  @override
  State<ToggleRowVisibility_land> createState() =>
      _ToggleRowVisibility_landState();
}

class _ToggleRowVisibility_landState extends State<ToggleRowVisibility_land> {
  bool _isRegionClicked = false; // Track if Region is clicked
  bool _isViewMoreClicked = false; // Track if View More is clicked
  double _containerHeight = 150; // Default container height
  User? user = globalUser;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //print(height);
    return SingleChildScrollView(
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            //color: Colors.red,
            width: double.infinity,
            height: _containerHeight, // Dynamically adjust container height
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ----- Row-1----- //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width / 17),
                      buildClickableIconWithTextUsingIcon(
                        Icons.add,
                        'Add Proposed Pole',
                        () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddProposedPole(),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: width / 13),
                      buildClickableIconWithTextUsingIcon(
                        Icons.add,
                        'Add Pole',
                        () => _showMessage(context, 'Add Pole clicked'),
                      ),
                      SizedBox(width: width / 13),
                      buildClickableIconWithTextUsingIcon(
                        Icons.add_home,
                        'Add Consumer',
                        () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewConsumerExp(),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(width: width / 13),
                      buildClickableIconWithTextUsingIcon(
                        Icons.add,
                        'Add DT',
                        () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddDTInfo(),
                            ),
                          );
                        },
                      ),
                              
                      SizedBox(width: width / 13),
                      buildClickableIconWithText(
                        'assets/images/new_icons/new_substation.png',
                        'Substation',
                        () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => const ViewSubstation(),
                              builder: (context) => const  SubstationFilterPage (),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: width / 13),
                    ],
                  ),
                  SizedBox(height: height / 60),

                  // ----- Row for "Region" (Zone, Circle, SND, ESU) ----- //
                  if (_isRegionClicked)
                  const Divider(color: Colors.grey),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstChild: Container(),
                      secondChild: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: width / 11),
                              buildClickableIconWithText(
                                'assets/map_legend/zone.png',
                                'Zones',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ViewZone(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: width / 9),
                              buildClickableIconWithText(
                                'assets/map_legend/circle.png',
                                'Circles',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // builder: (context) => const ViewCircles(),
                                      builder: (context) => CircleFilterPage(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: width / 9),
                              buildClickableIconWithText(
                                'assets/map_legend/snd.png',
                                'SnD',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // builder: (context) => const ViewSnd(),
                                       builder: (context) => SndFilterPage(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: width /10),
                              buildClickableIconWithText(
                                'assets/map_legend/esu.png',
                                'Esu',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      // builder: (context) => const ViewEsu(),
                                      builder: (context) => ESUFilterPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      crossFadeState: _isRegionClicked
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),

                  // ----- Row for "View More" (Add Pole, Add DT, Add Consumer) ----- //
                  if (!_isRegionClicked)
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstChild: Container(),
                      secondChild: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: width / 18),
                              buildClickableIconWithTextUsingIcon(
                                Icons.view_agenda,
                                'View Proposed Poles',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ViewProposedPole(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: width / 15),
                              buildClickableIconWithText(
                                'assets/icons/power-line.png',
                                'Pole',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FilterPoleDetails(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: width / 11.5),
                              
                              buildClickableIconWithText(
                                'assets/images/new_icons/new_consumer.png',
                                'Consumer',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FilterConsumers(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: width / 10),
                              buildClickableIconWithText(
                                'assets/icons/transformer.png',
                                'DT',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FilterDTDetails(),
                                    ),
                                  );
                                },
                              ),
                              
                              ...(user?.SndId != null || user?.EsuId != null
                              ? [
                              SizedBox(width: width / 13),
                              buildClickableIconWithText(
                                'assets/icons/feederline_2.png',
                                'Feeder Line',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FeederLineFilter(),
                                      // builder: (context) => const FilterFeederline(),
                                    ),
                                  );
                                },
                              ),
                              ]
                             : []),
                            ],
                          ),
                          ...(user?.SndId != null || user?.EsuId != null
                              ? [
                          SizedBox(height: height / 55),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: width / 10),
                              buildClickableIconWithText(
                                'assets/icons/worldwide.png',
                                'Region',
                                () {
                                  setState(() {
                                    _isRegionClicked =
                                        !_isRegionClicked; // Toggle region row
                                    _isViewMoreClicked =
                                        false; // Close View More row when Region is clicked
                                    _containerHeight =
                                        _isRegionClicked ? 250 : 158; // Adjust height
                                  });
                                },
                              ),
                              SizedBox(width: width / 10),
                              buildClickableIconWithTextUsingIcon(
                                Icons.map,
                                'Map Viewer',
                                () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MapWebView(
                                        title: 'Map Viewer',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: width / 2),
                            ],
                          ),
                          ]
                        : []),
                        ],
                      ),
                      crossFadeState: _isViewMoreClicked
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),

                  SizedBox(height: height / 690),
                ],
              ),
            ),
          ),
          Positioned(
            //top: buttonpos,
            bottom: -10,
            left: 115,
            right: 115,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isViewMoreClicked = !_isViewMoreClicked;
                  _containerHeight = _isViewMoreClicked ? 350 : 150;
                  _isRegionClicked = false;
                });
              },
              style: ElevatedButton.styleFrom(
                //backgroundColor: Colors.white,
                elevation: 0,
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isViewMoreClicked ? "View Less" : "View More",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 3, 89, 100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //const SizedBox(height: 0.05),
                  Icon(
                    _isViewMoreClicked
                        ? Icons.arrow_drop_up_sharp
                        : Icons.arrow_drop_down_sharp,
                    color: const Color.fromARGB(255, 3, 89, 100),
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build an icon with label
  Widget buildClickableIconWithText(
      String assetPath, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            child: Image.asset(
              assetPath,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // Function to build an icon using IconData
  Widget buildClickableIconWithTextUsingIcon(
      IconData iconData, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            child: Icon(
              iconData,
              size: 40,
              color: const Color.fromARGB(255, 3, 89, 100),
            ),
          ),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // Show message in SnackBar
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
