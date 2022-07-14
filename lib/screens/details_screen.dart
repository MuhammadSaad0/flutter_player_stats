import 'package:flutter/material.dart';
import 'package:flutter_player_stats/utils/player_details_extractor.dart';
import 'package:flutter_player_stats/widgets/details_grid.dart';
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
  int errorCatcher = 0;
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

        extractedDetails.add(getFirstName(playerDetails.toString()));
        errorCatcher = 1;
        extractedDetails.add(getLastName(playerDetails.toString()));
        errorCatcher = 2;
        extractedDetails.add(getNationality(playerDetails.toString()));
        errorCatcher = 3;
        extractedDetails.add(getDoB(playerDetails.toString()));
        errorCatcher = 4;
        extractedDetails.add(getCoB(playerDetails.toString()));
        errorCatcher = 5;
        extractedDetails.add(getAge(playerDetails.toString()));
        errorCatcher = 6;
        extractedDetails.add(getPoB(playerDetails.toString()));
        errorCatcher = 7;
        extractedDetails.add(getPosition(playerDetails.toString()));
        errorCatcher = 8;
        extractedDetails.add(getHeight(playerDetails.toString()));

        print(extractedDetails.isEmpty);
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
        body: ListView(children: [
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
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: imgUrl != null
                    ? DetailsGrid(extractedDetails: extractedDetails)
                    : null),
          ),
          //BioDataScreen()
        ]));
  }
}
