
// //New code and it's working right now without model class
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Scroll Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InfiniteScrollDemo(),
    );
  }
}

class InfiniteScrollDemo extends StatefulWidget {
  @override
  _InfiniteScrollDemoState createState() => _InfiniteScrollDemoState();
}

class _InfiniteScrollDemoState extends State<InfiniteScrollDemo> {
  late BehaviorSubject<List<String>> _dataSubject;
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  bool _loading = false;
  int _offset = 0;
  final int _limit = 15;
  List<String> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _dataSubject = BehaviorSubject<List<String>>.seeded([]);
    _scrollController = ScrollController()..addListener(_scrollListener);
    _searchController = TextEditingController();
    _searchController.addListener(_filterData);
    _fetchData();
  }

  @override
  void dispose() {
    _dataSubject.close();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchData() async {
    setState(() {
      _loading = true;
    });

    final responses = await Future.wait([
      _fetchFromSource1(_offset),
      _fetchFromSource2(_offset),
      _fetchFromSource3(_offset),
      _fetchFromSource4(_offset),
    ]);

    List<String> newData = [];
    responses.forEach((response) {
      if (response is List) {
        newData.addAll(response);
      }
    });

    // Combine and sort data by 'name'
    List<String> combinedData = _dataSubject.value + newData;
    combinedData.sort((a, b) => a.compareTo(b));

    _dataSubject.value = combinedData;
    _filterData();  // Filter data after fetching new data
    setState(() {
      _loading = false;
      _offset += _limit;
    });
  }

  Future<List<String>> _fetchFromSource1(int offset) async {
    var response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$_limit"));
    var data = json.decode(response.body);
    return (data['results'] as List).map((item) => item['name'] as String).toList();
  }

  Future<List<String>> _fetchFromSource2(int offset) async {
    var response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$_limit"));
    var data = json.decode(response.body);
    return (data['results'] as List).map((item) => item['name'] as String).toList();
  }

  Future<List<String>> _fetchFromSource3(int offset) async {
    var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    var data = json.decode(response.body);
    return (data as List).map((item) => item['name'] as String).toList();
  }

  Future<List<String>> _fetchFromSource4(int offset) async {
    var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));
    var data = json.decode(response.body);
    return (data as List).map((item) => item['name'] as String).toList();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredData = _dataSubject.value;
    } else {
      _filteredData = _dataSubject.value.where((item) {
        return item.toLowerCase().contains(query);
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infinite Scroll Demo"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<String>>(
        stream: _dataSubject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: _filteredData.length + 1,
              itemBuilder: (context, index) {
                if (index < _filteredData.length) {
                  return ListTile(
                    title: Text(_filteredData[index]),
                  );
                } else {
                  return _loading
                      ? Center(child: CircularProgressIndicator())
                      : Container();
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


