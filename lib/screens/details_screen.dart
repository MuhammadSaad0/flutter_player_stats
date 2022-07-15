import 'package:flutter/material.dart';
import 'package:flutter_player_stats/utils/extraction_logic.dart';
import 'package:flutter_player_stats/utils/player_details_extractor.dart';
import 'package:flutter_player_stats/widgets/details_grid.dart';
import 'package:flutter_player_stats/widgets/stats_bar.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String? logoUrl;
  List latestVal = [];
  dom.Document? teamhtml;
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

    List teamUrlList = (html
        .querySelectorAll('td.team > a')
        .map((e) => e.attributes['href'])
        .toList());
    if (teamUrlList.isNotEmpty) {
      final team = Uri.parse("https://int.soccerway.com/${teamUrlList[0]}");
      final teamresponse = await http.get(team);
      teamhtml = dom.Document.html(teamresponse.body);
    }
    setState(() {
      try {
        if (teamhtml != null) {
          logoUrl = (teamhtml!
              .querySelectorAll('div > div.logo > img')
              .map((e) => e.attributes['src'])
              .toList()[0]);
        }
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
        latestVal = (html
            .querySelectorAll('table > tbody > tr > td.type')
            .map((e) => e.innerHtml.trim())
            .toList());

        latestVal.sort();
        print(latestVal);
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
      appBar: AppBar(
        actions: [
          Stack(children: [
            const Positioned(
              left: 12,
              top: 12,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(
                FontAwesome.github,
                size: 28,
                color: Colors.black,
              ),
              onPressed: () async {
                await launchUrl(Uri.parse(
                    'https://github.com/MuhammadSaad0/flutter_player_stats'));
              },
            ),
          ]),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height / 1.1,
        width: MediaQuery.of(context).size.width / 1.001,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: imgUrl != null
                    ? Stack(clipBehavior: Clip.none, children: [
                        ClipRRect(
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
                        ),
                        if (logoUrl != null)
                          CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(0, 255, 255, 255),
                            child: Image.network(logoUrl!),
                          ),
                        if (latestVal.isNotEmpty)
                          Positioned(
                              left: latestVal.last == "N/A" ||
                                      latestVal.last == "Free"
                                  ? MediaQuery.of(context).size.width / 6.6
                                  : MediaQuery.of(context).size.width / 8,
                              top: MediaQuery.of(context).size.height / 5.5,
                              child: Text(
                                latestVal.last,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                      ])
                    : const CircularProgressIndicator(),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: imgUrl != null
                    ? DetailsGrid(extractedDetails: extractedDetails)
                    : null),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 10,
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                height: 220,
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: imgUrl != null
                          ? const Color.fromARGB(255, 151, 179, 152)
                          : Colors.white),
                  child: Column(children: [
                    SizedBox(
                      height: 180,
                      width: double.infinity,
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
                    if (imgUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 15, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              '🟩',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              '⚽',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              '🟨',
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              '🟥',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      )
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
