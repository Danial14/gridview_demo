import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TableView extends StatefulWidget {
  const TableView({Key? key}) : super(key: key);

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final List<String> _columns = ["id", "name", "username", "email"];
  var _dataFuture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grid demo"),
      ),
      body: FutureBuilder<List<dynamic>>(future: _dataFuture,
      builder: (ctx, snapshot){
        List<dynamic> columnData = [];
        if(snapshot.hasData){
          List<dynamic> dat = snapshot.data!;
          for(int i = 0; i < dat.length; i++){
            var obj = dat[i];
            for(int j = 0; j < _columns.length; j++){
              columnData.add(obj[_columns[j]]);
            }
          }
          return
              GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,mainAxisSpacing: 0.5,crossAxisSpacing: 0.5,childAspectRatio: 10.3
              ), itemBuilder: (ctx, pos){
                return Container(
                  width: 25,
                  height: 10,
                  child: Text(columnData[pos].toString()),
                  decoration: BoxDecoration(
                    color: Colors.red
                  ),
                );
              },
                itemCount: columnData.length,
              );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      ),
    );
  }
  initState(){
    super.initState();
    Future.delayed(Duration.zero, (){
      _dataFuture = _getData();
    });
  }
  Future<List<dynamic>> _getData() async{
    try{
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      return (jsonDecode(response.body) as List<dynamic>);
    }catch(e){
      print(e);
      throw e;
    }
  }
}
