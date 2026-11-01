import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/constant.dart';

class DTMapViewer extends StatefulWidget {
  final String title;
  final int zone;
  final int circle;
  final int snd;
  final int substationId;
  final int feederlineId;
  final int dtId;

  const DTMapViewer({super.key, required this.title, required this.zone, required this.circle, required this.snd, required this.substationId, required this.feederlineId, required this.dtId});

  @override
  State<DTMapViewer> createState() => _DTMapViewerState();
}

class _DTMapViewerState extends State<DTMapViewer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('$myAPILink/NewMapViewer/GenericMapView?zzoneId=${widget.zone}&circleId=${widget.circle}&sndId=${widget.snd}&substationId=${widget.substationId}&feederLineId=${widget.feederlineId}&dtId=${widget.dtId}&mapViewActionFlag=SearchMap&cai=map_01'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.title,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )
          ),
        backgroundColor: const Color.fromARGB(255, 3, 89, 100),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}