import 'package:recase/recase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_player_stats/screens/details_screen.dart';
import 'package:page_transition/page_transition.dart';

class SearchResultScreen extends StatefulWidget {
  final List searchResults;
  const SearchResultScreen({Key? key, required this.searchResults})
      : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    //print(widget.searchResults);
    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: const Color.fromARGB(255, 239, 238, 238),
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? 300
          : 700,
      height: 200,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: widget.searchResults.length > 3 ? true : false,
        child: ListView.builder(
            controller: scrollController,
            itemCount: widget.searchResults.length,
            itemBuilder: (context, index) {
              //print(widget.searchResults[index]);
              String start = '">';
              String end = '</a>';
              var startIndex;
              var endIndex;
              if (widget.searchResults[index] != "") {
                startIndex =
                    widget.searchResults[index].toString().indexOf(start);
                endIndex = widget.searchResults[index].toString().indexOf(
                      end,
                    );
              }

              if (widget.searchResults[index] == "") {
                return const SizedBox.shrink();
              }

              return ListTile(
                  title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                child: DetailsScreen(
                                  searchResults: widget.searchResults[index],
                                )));
                      },
                      child: (startIndex != null &&
                              endIndex != null &&
                              startIndex >= 0 &&
                              endIndex >= 0)
                          ? Text(
                              ReCase(widget.searchResults[index]
                                      .toString()
                                      .substring(
                                          startIndex + start.length, endIndex))
                                  .titleCase,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            )
                          : null));
            }),
      ),
    );
  }
}
