import 'package:flutter/material.dart';
import 'package:flutter_player_stats/screens/search_result_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:link_text/link_text.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

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
        primarySwatch: Colors.green,
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
  bool resultFound = false;
  List searchResults = [];

  void searchQuery() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isSearching = true;
      resultFound = false;
    });
    final url = Uri.parse(
        "https://int.soccerway.com/search/players/?q=${searchController.text}");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

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
      resultFound = true;
    });

    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) =>
    //         SearchResultScreen(searchResults: searchResults)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Player Stats Finder"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 4.5,
              horizontal: 30),
          child: Column(
            children: [
              Center(
                  child: Stack(
                children: [
                  TextField(
                    controller: searchController,
                    onSubmitted: (value) {
                      setState(() {
                        toSearch = value;
                      });
                    },
                  ),
                  Positioned(
                    left: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.width / 1.4
                        : MediaQuery.of(context).size.width / 1.2,
                    child: IconButton(
                        onPressed: searchQuery, icon: const Icon(Icons.search)),
                  ),
                ],
              )),
              const SizedBox(
                height: 10,
              ),
              if (resultFound && !isSearching)
                SearchResultScreen(searchResults: searchResults)
              else if (isSearching)
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).orientation == Orientation.portrait
                ? 50
                : 220,
            bottom: 10),
        child: Row(
          children: [
            Text("Powered by "),
            InkWell(
              onTap: () async {
                await launchUrl(Uri.parse('https://int.soccerway.com/'));
              },
              child: const Text(
                "https://int.soccerway.com/",
                textAlign: TextAlign.center,
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
