import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:law_app/screens/drawer.dart';

class ParliamentCalendarScreen extends StatefulWidget {
  _ParliamentCalendarScreenState createState() => _ParliamentCalendarScreenState();
}

class _ParliamentCalendarScreenState extends State<ParliamentCalendarScreen> {

  bool isLoading = true;
  List items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    final String baseUrl = '${GlobalConfiguration().getString('api_base_url')}';
    final String url = baseUrl + 'parliamentCalendar';
    final client = new http.Client();
    final response = await client.get(url);

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body)['data'];
        isLoading = false;
      });
      print('parliamentCalendar: ${items.toString()}');
    }
  }

  Widget getItemList(String title, String date) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    return Container(
      padding: EdgeInsets.only(bottom: 6),
      child: Container(
        height: 45,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black45
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              height: 45,
              width: 60,
              color: Colors.black12,
              alignment: Alignment.center,
              child: Text(date, style: TextStyle(
                color: Colors.blue,
                fontSize: 11
              ), textAlign: TextAlign.center,),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: 45,
              width: width-100,
              alignment: Alignment.center,
              child: Text(title, style: TextStyle(
                fontSize: 11
              ),),
            ),
          ],
        ),
      ),
    );
  }  

   @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Scaffold(
      appBar: AppBar(title: Text('PARLIAMENT'),),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Header part
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: width,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black26)
                    )
                  ),
                  child: Row(
                    children: [
                      Text('Parliament Calendar', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                )
              ),
              isLoading ? Container(
                height: height,
                child: Center(child: CircularProgressIndicator()),
              )
              : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: items.length,
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return getItemList(items[index]['title'], items[index]['date']);
                },
              )
            ],
          ),
        ),
      )
    );
  }
}
