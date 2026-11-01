// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../models/consumer_lookup/tariff_sub_category.dart';
import '../../widgets/widgets/fieldset_legend.dart';


class ViewTariffSubCategory extends StatefulWidget {
  const ViewTariffSubCategory({super.key});
  @override
  _ViewTariffSubCategoryState createState() => _ViewTariffSubCategoryState();
}

class _ViewTariffSubCategoryState extends State<ViewTariffSubCategory> {

late Future<List<TariffSubCategory>> _futureTariffSubCategories;
bool isLoading = false;
 final TextEditingController _subCategoryId = TextEditingController();
 final TextEditingController _categoryId = TextEditingController();
 final TextEditingController _subCategoryName = TextEditingController();

 String _textValue = 'Initial Value';

  @override
  void initState() {
    super.initState();
    _futureTariffSubCategories = _fetchTariffSubCategories();
  }

    Future<List<TariffSubCategory>> _fetchTariffSubCategories() async {
    return CallApi().fetchTariffSubCategories();
     
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  
  void _showDetailsDialog(TariffSubCategory item) {

    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: const Text('TariffSubCategory Details'),
          content: SingleChildScrollView(
            // Ensure the content spans full width
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set width to screen width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize
                    .min, // Ensure the dialog doesn't exceed screen height
                children: [
                  FieldsetLegend(
                legendText: 'GPS Information',
                children: [
                  _buildTextField(_subCategoryId, 'Sub Category Id',item.subCategoryId.toString()),
                  _buildTextField(_categoryId, 'Category Id',item.categoryId.toString()),
                  _buildTextField(_subCategoryName, 'Sub Category',item.subCategoryName),
                  
                ],
              ),
                  Text(
                    item.categoryId.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  Text('Consumer No.: ${item.subCategoryName}'),
                  const Divider(),
                  Text('Mobile: ${item.subCategoryName ?? 'N/A'}'),
                  const Divider(),               
                ],
              ),
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[900],
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MapViewer(
                  //       title: 'Map View',
                  //       lat: consumer.latitude,
                  //       long: consumer.longitude,
                  //       properties:
                  //           '${consumer.consumerNo}#${consumer.customerName}#${consumer.meterNumber}#${consumer.zoneName}#${consumer.circleName}#${consumer.sndName}',
                  //     ),
                  //   ),
                  // );
                },
                child: const Text(
                  'Open Map View',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[900],
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tariff Sub-Categories'),
      ),
      body: FutureBuilder<List<TariffSubCategory>>(
          future: _futureTariffSubCategories,
          builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No consumers available!'));
                } else {
                  // Filter the list based on search query
                            
              List<TariffSubCategory> subCategories = snapshot.data!;
              
                  return ListView.builder(
                     itemCount: subCategories.length,
                    itemBuilder: (context, index) { 
                       TariffSubCategory item = subCategories[index];                  
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          title: Text(
                            item.subCategoryId.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Consumer #${item.subCategoryName}\r\nMeter #${item.subCategoryName}',
                            style: const TextStyle(height: 1.5),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Tooltip(
                                message: 'View Detail',
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit_square,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      //_showConsumerDetails(consumer.consumerNo);                                   
                                      _showDetailsDialog(item);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle tap on ListTile (navigate to detail screen, etc.)
                          },
                        ),
                      );
                    },
                  );
                }
              },
        ),       
       
    );
  
  }

  Widget _buildTextField(TextEditingController controller, String label, String initialvalue) {
    controller.text=_textValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        //initialValue:subCategoryId,
        decoration: InputDecoration(
          labelText: label,
          //value:value,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );  
  }


}




    








