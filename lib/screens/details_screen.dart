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
  void getData() async {
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
        extractedDetails.add(getLastName(playerDetails.toString()));
        extractedDetails.add(getNationality(playerDetails.toString()));
        extractedDetails.add(getDoB(playerDetails.toString()));
        extractedDetails.add(getCoB(playerDetails.toString()));
        extractedDetails.add(getAge(playerDetails.toString()));
        extractedDetails.add(getPoB(playerDetails.toString()));
        extractedDetails.add(getPosition(playerDetails.toString()));
        extractedDetails.add(getHeight(playerDetails.toString()));
      } catch (err) {
        imgUrl =
            "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg";
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
        body: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: imgUrl != null
                      ? CircleAvatar(
                          radius: 64,
                          child: Image.network(
                            imgUrl!,
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: DetailsGrid(extractedDetails: extractedDetails)),
              ),
            ]));
  }
}
