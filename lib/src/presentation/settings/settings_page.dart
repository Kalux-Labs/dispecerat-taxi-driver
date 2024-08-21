import 'package:driver/src/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setari'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Termeni si conditii"),
            onTap: () async {
              await _launchUrl(AppConstants.termsAndConditions);
            },
          ),
          ListTile(
            title: const Text("Politica de confidentialitate"),
            onTap: () async {
              await _launchUrl(AppConstants.privacyPolicy);
            },
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if(!await launchUrl(Uri.parse(url))) {
      debugPrint("Could not launch $url");
    }
  }
}
