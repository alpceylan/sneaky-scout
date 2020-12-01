import 'package:url_launcher/url_launcher.dart';

class BlueAllianceService {
  Future<void> goTeamPage(int teamNumber) async {
    var url = "https://www.thebluealliance.com/team/$teamNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
