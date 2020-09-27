import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Navigation error'),
        content: Text('Could not launch $url'),
        actions: [
          FlatButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
