import 'package:flutter/material.dart';
import 'package:flutter_player_stats/screens/search_result_screen.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  String? toSearch;
  bool isSearching = false;

  void searchQuery() async {
    setState(() {
      isSearching = true;
    });
    final url = Uri.parse(
        "https://int.soccerway.com/search/players/?q=${searchController.text}");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    List searchResults = [];
    setState(() {
      searchResults = html
          .querySelectorAll("td.player")
          .map((e) => e.innerHtml.trim())
          .toString()
          .replaceAll("...", "")
          .replaceAll(" ", "")
          .replaceAll("  ", "")
          .split(",")
          .toList();
      isSearching = false;
    });
    print(searchResults);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            SearchResultScreen(searchResults: searchResults)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: isSearching
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    TextField(
                      controller: searchController,
                      onSubmitted: (value) {
                        setState(() {
                          toSearch = value;
                        });
                      },
                    ),
                    IconButton(
                        onPressed: searchQuery, icon: const Icon(Icons.search)),
                  ],
                )),
    );
  }
}
