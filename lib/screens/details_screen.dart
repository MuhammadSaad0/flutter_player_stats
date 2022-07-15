import 'package:flutter/material.dart';
import 'package:flutter_player_stats/utils/extraction_logic.dart';
import 'package:flutter_player_stats/utils/player_details_extractor.dart';
import 'package:flutter_player_stats/widgets/details_grid.dart';
import 'package:flutter_player_stats/widgets/stats_bar.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class DetailsScreen extends StatefulWidget {
  final String searchResults;
  const DetailsScreen({Key? key, required this.searchResults})
      : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String? imgUrl;
  List playerDetails = [];
  List extractedDetails = [];
  List statDetails = [];
  List stats = [];
  int errorCatcher =
      0; // helps in checking how many "Unknown fields to add if an error is caught"
  void getData() async {
    errorCatcher = 0;
    String start = 'href="';
    String end = '/"';
    final startIndex = widget.searchResults.toString().indexOf(start);
    final endIndex = widget.searchResults.toString().indexOf(
          end,
        );
    String urlToParse = widget.searchResults
        .toString()
        .substring(startIndex + start.length, endIndex)
        .trim();

    final url = Uri.parse("https://int.soccerway.com/$urlToParse");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    setState(() {
      try {
        imgUrl = (html
            .querySelectorAll('div > div > img')
            .map((e) => e.attributes['src'])
            .toList())[0];
        playerDetails = (html
            .querySelectorAll('div > div > div > dl')
            .map((e) => e.innerHtml.trim())
            .toList());
        statDetails = html
            .querySelectorAll('tfoot > tr')
            .map((e) => e.innerHtml.trim())
            .toList();
        stats = getStats(statDetails);

        var returnedList =
            getDetailsLogic(playerDetails, extractedDetails, errorCatcher);
        playerDetails = returnedList[0];
        extractedDetails = returnedList[1];
        errorCatcher = returnedList[2];
        for (int i = 0; i < 8 - errorCatcher; i++) {
          extractedDetails.add("Unkown");
        }
      } catch (err) {
        imgUrl =
            "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg";
        for (int i = 0; i < 8 - errorCatcher; i++) {
          extractedDetails.add("Unkown");
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 1.1,
        width: MediaQuery.of(context).size.width / 1.001,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: imgUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 68,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 64,
                              child: Image.network(
                                imgUrl!,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: imgUrl != null
                    ? DetailsGrid(extractedDetails: extractedDetails)
                    : null),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                height: 200,
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: imgUrl != null
                          ? const Color.fromARGB(255, 151, 179, 152)
                          : Colors.white),
                  child: StatsBar(
                    stats: [
                      stats.isNotEmpty ? double.parse(stats[0]) : 0,
                      stats.isNotEmpty ? double.parse(stats[1]) : 0,
                      stats.isNotEmpty ? double.parse(stats[2]) : 0,
                      stats.isNotEmpty ? double.parse(stats[3]) : 0,
                    ],
                    imgUrl: imgUrl,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
