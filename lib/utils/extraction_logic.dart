import '../utils/player_details_extractor.dart';

List getDetailsLogic(playerDetails, extractedDetails, errorCatcher) {
  try {
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
  } catch (err) {
    return [playerDetails, extractedDetails, errorCatcher];
  }
  return [playerDetails, extractedDetails, errorCatcher];
}
