import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/constant.dart';

class MapWebView extends StatefulWidget {
  final String title;
  const MapWebView({super.key, required this.title});

  @override
  State<MapWebView> createState() => _MapWebViewState();
}

class _MapWebViewState extends State<MapWebView> {
  late final WebViewController _controller;
  final String mapLink = '$myAPILink/NewMapViewer/GenericMapView?mapViewActionFlag=MapView';
  @override
  void initState() {
    super.initState();
    //print('Map Link: $mapLink');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('$myAPILink/NewMapViewer/GenericMapView?mapViewActionFlag=MapView'));
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