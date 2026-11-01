import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/constant.dart';

class ConsumerMapViewer extends StatefulWidget {
  final String title;
  final String consumerNo;

  const ConsumerMapViewer({super.key, required this.consumerNo, required this.title});

  @override
  State<ConsumerMapViewer> createState() => _ConsumerMapViewerState();
}

class _ConsumerMapViewerState extends State<ConsumerMapViewer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('$myAPILink/NewMapViewer/GenericMapView?consumerNo=${widget.consumerNo}&mapViewActionFlag=SearchMap&cai=map_01'));
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