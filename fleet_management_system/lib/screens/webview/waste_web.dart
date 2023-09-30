import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../helper/setting.dart';

class WasteWeb extends StatefulWidget {
  const WasteWeb({super.key});

  @override
  State<WasteWeb> createState() => _WasteWebState();
}

class _WasteWebState extends State<WasteWeb> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(wasteUrl), //'https://flutter.dev'
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Appbar')),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Stack(
            children: [
              WebViewWidget(
                controller: controller,
              ),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  value: loadingPercentage / 100.0,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
