<<<<<<< HEAD

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
=======
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
>>>>>>> fork/main
    );
  }
}

<<<<<<< HEAD
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
=======
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BehaviorSubject<List<int>> _dataSubject;
  late ScrollController _scrollController;
  final int _perPage = 10;
  int _counter = 0;
>>>>>>> fork/main

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _dataSubject = BehaviorSubject<List<String>>.seeded([]);
    _scrollController = ScrollController()..addListener(_scrollListener);
    _searchController = TextEditingController();
    _searchController.addListener(_filterData);
    _fetchData();
=======
    _dataSubject = BehaviorSubject<List<int>>();
    _scrollController = ScrollController()..addListener(_scrollListener);
    loadData();
>>>>>>> fork/main
  }

  @override
  void dispose() {
    _dataSubject.close();
    _scrollController.dispose();
<<<<<<< HEAD
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

=======
    super.dispose();
  }

  void loadData() {
    // Simulating loading data asynchronously
    Future.delayed(const Duration(seconds: 2), () {
      final newData = List.generate(_perPage, (index) => _counter * _perPage + index + 1);
      _dataSubject.add(newData);
      _counter++; // Increment counter for pagination
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Reached the end, load more data
      loadData();
    }
  }

>>>>>>> fork/main
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
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
=======
        title: const Text('Infinite Scroll Example'),
      ),
      body: StreamBuilder<List<int>>(
        stream: _dataSubject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              controller: _scrollController,
              itemCount: data.length + 1, // +1 for loading indicator
              itemBuilder: (context, index) {
                if (index < data.length) {
                  return ListTile(
                    title: Text('Item ${data[index]}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
>>>>>>> fork/main
                }
              },
            );
          } else {
<<<<<<< HEAD
            return Center(child: CircularProgressIndicator());
=======
            return const Center(
              child: CircularProgressIndicator(),
            );
>>>>>>> fork/main
          }
        },
      ),
    );
  }
}
<<<<<<< HEAD


=======
>>>>>>> fork/main
