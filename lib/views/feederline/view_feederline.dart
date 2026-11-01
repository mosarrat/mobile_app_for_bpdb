import 'package:flutter/material.dart';
import '../../api/feederline_api.dart';
import '../../constants/constant.dart';
import '../../models/Login/login.dart';
import '../../models/feederlines_lookup/feederline.dart';
import 'details_feederline.dart';
import 'update_feederline_exp.dart';


class ViewFeederlines extends StatefulWidget {
  final int sndId;
  const ViewFeederlines({
    super.key,
    required this.sndId
  });
  @override
  _ViewFeederlinesState createState() => _ViewFeederlinesState();
}

class _ViewFeederlinesState extends State<ViewFeederlines> {
  final CallApiService apiService = CallApiService();
  late Future<List<FeederLines>> _futureFeederLines;
  bool isLoading = false;

  String _textValue = 'Initial Value';

  @override
  void initState() {
    super.initState();
    _futureFeederLines = _fetchFeederLines();
  }

  void _loadData() {
    setState(() {
      _futureFeederLines = apiService.fetchFeederLines(widget.sndId);
    });
  }

  Future<List<FeederLines>> _fetchFeederLines() async {
    return CallApiService().fetchFeederLines(widget.sndId);
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    User? user = globalUser;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          'Feeder Line Info',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<FeederLines>>(
        future: _futureFeederLines,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Feeder Line available!'));
          } else {
            // Filter the list based on search query

            List<FeederLines> feederliness = snapshot.data!;

            return ListView.builder(
              itemCount: feederliness.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Static card at the top
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total Feeder Lines: ${feederliness.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }
                FeederLines item = feederliness[index - 1];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    title: Text(
                      "${item.feederlineName}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Feeder Line Type: ${item.feederLineTypeName}\n${item.operatingSndName ??''}',
                      style: const TextStyle(height: 1.5),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Edit',
                          child: Container(
                            height: 27,
                            width: 27,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              iconSize: 12,
                              icon: const Icon(
                                Icons.edit_square,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showEditForm(
                                     context, apiService, item, _loadData);
                              },
                            ),
                          ),
                        ),
                        //const SizedBox(height: 2),
                        const SizedBox(width: 2),
                        Tooltip(
                          message: 'View Details',
                          child: Container(
                            height: 27,
                            width: 27,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              iconSize: 12,
                              icon: const Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDetailDialog(context, apiService, item);
                              },
                            ),
                          ),
                        ),
                        //////
                        //const SizedBox(height: 2),
                        const SizedBox(width: 2),
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
