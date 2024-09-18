import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static Future<void> initiatePhoneCall(String phone) async {
    final String string = 'tel:+40$phone';
    if (await canLaunchUrlString(string)) {
      await launchUrlString(string);
    } else {
      throw Exception('Could not launch $string');
    }
  }
}
