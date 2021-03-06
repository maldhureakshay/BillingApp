import 'package:flutter/material.dart';
import 'package:reciept_generator_app/model/Record.dart';
import 'dart:async';
import 'package:reciept_generator_app/database/dbhelper.dart';


Future<List<DRecord>> fetchEmployeesFromDatabase() async {
  var dbHelper = DBHelper();
  Future<List<DRecord>> records = dbHelper.getRecords();
  return records;
}

class MyRecordList extends StatefulWidget {
  @override
  MyRecordListPageState createState() => new MyRecordListPageState();
}

class MyRecordListPageState extends State<MyRecordList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Record List'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new FutureBuilder<List<DRecord>>(
          future: fetchEmployeesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return new Card(
                      child:  new Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(snapshot.data[index].customerName,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                          new Text(snapshot.data[index].mobileNo,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.0))
                        ],
                        ),
                      ) ,
                    ); 
                  });
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new Container(alignment: AlignmentDirectional.center,child: new CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}