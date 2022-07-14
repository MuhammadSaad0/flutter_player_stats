import 'package:recase/recase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_player_stats/screens/details_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final List searchResults;
  const SearchResultScreen({Key? key, required this.searchResults})
      : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      color: const Color.fromARGB(255, 239, 238, 238),
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? 300
          : 700,
      height: 200,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: false,
          itemCount:
              widget.searchResults.length > 6 ? 3 : widget.searchResults.length,
          itemBuilder: (context, index) {
            String start = '">';
            String end = '</a>';
            final startIndex =
                widget.searchResults[index].toString().indexOf(start);
            final endIndex = widget.searchResults[index].toString().indexOf(
                  end,
                );

            return ListTile(
                title: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                                searchResults: widget.searchResults[index],
                              )));
                    },
                    child: (startIndex >= 0 && endIndex >= 0)
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
    );
  }
}
