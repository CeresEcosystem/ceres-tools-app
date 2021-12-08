import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartView extends StatefulWidget {
  const ChartView({ Key? key }) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WebView(
       initialUrl: 'https://tools.cerestoken.io/charts',
       javascriptMode: JavascriptMode.unrestricted,
     ),
    );
  }
}