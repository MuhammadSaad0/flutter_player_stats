import 'package:flutter/material.dart';

class DetailsGrid extends StatelessWidget {
  List extractedDetails;
  DetailsGrid({Key? key, required this.extractedDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 210, 220, 206),
      ),
      // color: const Color.fromARGB(255, 199, 198, 198),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < extractedDetails.length; i++)
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  i == 0
                      ? "First Name:"
                      : i == 1
                          ? "Last Name:"
                          : i == 2
                              ? "Nationality:"
                              : i == 3
                                  ? "Date of Birth:"
                                  : i == 4
                                      ? "Country of Birth:"
                                      : i == 5
                                          ? "Age:"
                                          : (i == 6 &&
                                                  extractedDetails[i] !=
                                                      "Attacker" &&
                                                  extractedDetails[i] !=
                                                      "Midfielder" &&
                                                  extractedDetails[i] !=
                                                      "Defender" &&
                                                  extractedDetails[i] !=
                                                      "Goalkeeper")
                                              ? "Place of Birth:"
                                              : (i == 6 &&
                                                          extractedDetails[i] ==
                                                              "Attacker" ||
                                                      extractedDetails[i] ==
                                                          "Midfielder" ||
                                                      extractedDetails[i] ==
                                                          "Defender" ||
                                                      extractedDetails[i] ==
                                                          "Goalkeeper")
                                                  ? "Position:"
                                                  : (i ==
                                                                  7 &&
                                                              extractedDetails[
                                                                      i] ==
                                                                  "Attacker" ||
                                                          extractedDetails[i] ==
                                                              "Midfielder" ||
                                                          extractedDetails[i] ==
                                                              "Defender" ||
                                                          extractedDetails[i] ==
                                                              "Goalkeeper")
                                                      ? "Position:"
                                                      : (i ==
                                                                  7 &&
                                                              extractedDetails[
                                                                      i] !=
                                                                  "Attacker" &&
                                                              extractedDetails[
                                                                      i] !=
                                                                  "Midfielder" &&
                                                              extractedDetails[
                                                                      i] !=
                                                                  "Defender" &&
                                                              extractedDetails[
                                                                      i] !=
                                                                  "Goalkeeper")
                                                          ? "Height:"
                                                          : i == 8
                                                              ? "Height:"
                                                              : "",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  (extractedDetails[i] != "") ? extractedDetails[i] : "Unknown",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
        ],
      ),
    );
  }
}
