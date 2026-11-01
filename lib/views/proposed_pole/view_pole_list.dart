import 'package:flutter/material.dart';
import '../../api/proposed_pole_api.dart';
import '../../models/proposed_pole/proposed_pole_info.dart';
import 'delete_pp.dart';

class ViewSectionProposedPole extends StatefulWidget {
  final int? sec_id;

  const ViewSectionProposedPole({
    super.key,
    required this.sec_id,
  });

  @override
  State<ViewSectionProposedPole> createState() =>
      _ViewSectionProposedPoleState();
}

class _ViewSectionProposedPoleState extends State<ViewSectionProposedPole> {
  final CallProposedPoleApi apiService = CallProposedPoleApi();
  // late Future<List<PoleSection>> _futurePoleSections;
  Future<List<PoposedPoleIListnfo>>? _futurePoleSections;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _futurePoleSections = _fetchPoleSection();
  }

  Future<List<PoposedPoleIListnfo>> _fetchPoleSection() async {
    return CallProposedPoleApi()
        .fetchProposedPolesBySectionId(widget.sec_id ?? 0);
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  void _showPoleDetails(PoposedPoleIListnfo pole) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          contentPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 30),
          backgroundColor: const Color.fromARGB(255, 5, 161, 182),
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Column(
              children: [
                Text(
                  "Proposed Pole Details",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Card(
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 0),
                     detailContainer(label: 'Pole No', value: pole.poleNo.toString(), isAlternate: true),
                    //  const Divider(height: 0),
                    //  detailContainer(label: 'Pole Name', value:pole.poleName.toString(), isAlternate: false),
                    //  const Divider(height: 0),
                    //  detailContainer(label: 'Section Name', value: pole.sectionName.toString(), isAlternate: true),
                     const Divider(height: 0),
                     detailContainer(label: 'Pole Height', value: pole.poleHeight.toString(), isAlternate: false),
                    //  const Divider(height: 0),
                    //  detailContainer(label: 'Pole Type', value: pole.poleTypeName.toString(), isAlternate: true),
                     const Divider(height: 0),
                     detailContainer(label: 'Area Name', value: pole.areaName ?? '', isAlternate: false),
                     const Divider(height: 0),
                     detailContainer(label: 'Latitude', value: pole.latitude!.toStringAsFixed(6), isAlternate: true),
                     const Divider(height: 0),
                     detailContainer(label: 'Longitude', value: pole.longitude?.toStringAsFixed(6) ?? "N/A", isAlternate: false),
                     const Divider(height: 0),
                     detailContainer(label: 'Remarks', value: pole.remarks.toString(), isAlternate: true),
                     const Divider(height: 0),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 5, 161, 182),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget detailContainer({required String label, required String value, bool isAlternate = false}) {
  return Container(
    width: double.infinity,
    height: 40,
    color: isAlternate
        ? const Color.fromARGB(255, 223, 240, 243)
        : const Color.fromARGB(255, 241, 245, 245),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '$label: $value',
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          'Proposed Pole List',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: FutureBuilder<List<PoposedPoleIListnfo>>(
        future: _futurePoleSections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Feeder Line available!'));
          } else {
            // Filter the list based on search query

            List<PoposedPoleIListnfo> proposedPoles = snapshot.data!;

            return ListView.builder(
              itemCount: proposedPoles.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Static card at the top
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total Proposed Poles: ${proposedPoles.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }
                PoposedPoleIListnfo item = proposedPoles[index-1];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      "Pole No: ${item.poleNo}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Latitude: ${item.latitude.toString()}\n'
                      'Longitude: ${item.longitude.toString()}\n',
                      style: const TextStyle(height: 1.5),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                      _showPoleDetails(item);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Tooltip(
                                message: 'Delete Pole',
                                child: Container(
                                  height: 27,
                                  width: 27,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 240, 6, 6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    iconSize: 12,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      bool? confirmDelete =
                                          await showDeleteConfirmationDialog(context);
                                      if (confirmDelete == true) {
                                        try{
                                          setLoading(true);
                                          await apiService.deleteProposedPole(item.poleId);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Proposed Pole deleted successfully')),
                                          );
                                          // Refresh the list after deletion
                                          setState(() {
                                            _futurePoleSections = _fetchPoleSection();
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Failed to delete Proposed Pole: $e')),
                                          );
                                        } finally {
                                          setLoading(false);
                                        }
                                      }

                                    },
                                  ),
                                ),
                              ),
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

