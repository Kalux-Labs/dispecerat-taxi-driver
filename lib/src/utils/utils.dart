import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static Future<void> initiatePhoneCall(String phone) async {
    final string = 'tel:+40$phone';
    if(await canLaunchUrlString(string)) {
      await launchUrlString(string);
    } else {
      throw 'Could not launch $string';
    }
  }
}