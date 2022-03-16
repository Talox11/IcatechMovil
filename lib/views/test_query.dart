import 'package:flutter/material.dart';

import 'package:flutter_banking_app/models/grupoJson.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';

import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TestQuery extends StatefulWidget {
  const TestQuery({Key? key}) : super(key: key);

  @override
  _TestQueryState createState() => _TestQueryState();
}

class _TestQueryState extends State<TestQuery> {
  late List _futureGrupo;
  late List _listAlumnos = [];
  Future<List> _getInfoGrupo() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/list/grupo'));

    if (response.statusCode == 201) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      // final data = GrupoJson.fromJson(jsonData);

      return jsonDecode(body);
    } else {
      throw Exception('Failed to create album.');
    }
  }

  @override
  void initState() {
    super.initState();
    _getInfoGrupo();
    // testQuery();
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(
          title: 'TEST QUERY',
          implyLeading: false,
          context: context,
          hasAction: true),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: <Widget>[
          const Gap(20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Repository.accentColor2(context),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Repository.accentColor(context))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    print('hacer query');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    width: size.width * 0.44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Repository.headerColor(context)),
                    child: const Text('Income',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    testQuery2();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    width: size.width * 0.44,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.transparent),
                    child: Text('Expenses',
                        style: TextStyle(
                            color: Repository.titleColor(context),
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void testQuery() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');

// open the database

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  });

  await database.transaction((txn) async {
    int id1 = await txn.rawInsert(
        'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
    print('inserted1: $id1');
    int id2 = await txn.rawInsert(
        'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
        ['another name', 12345678, 3.1416]);
    print('inserted2: $id2');
  });

  List<Map> list = await database.rawQuery('SELECT * FROM Test');
  print(list);
}

void testQuery2() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'demo.db');

// open the database

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE IF DONT EXIST Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  });

  List<Map> list = await database.rawQuery('SELECT * FROM Test');
  print(list);
}