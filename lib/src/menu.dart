import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  navigationDelegate,
  newmenuoption,
  jsoption,
  javascriptChannel,
}

class Menu extends StatelessWidget {
  const Menu({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.navigationDelegate:
            await controller.loadRequest(Uri.parse('https://youtube.com'));
            break;
          case _MenuOptions.newmenuoption:
            await controller.loadRequest(Uri.parse('https://google.com'));
            break;
          case _MenuOptions.jsoption:
            final userAgent = await controller
                .runJavaScriptReturningResult('navigator.userAgent');

            // if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$userAgent'),
            ));

            break;
          case _MenuOptions.javascriptChannel:
            await controller.runJavaScript('''
            jslogin("s3","123");
            ''');
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text('Navigate to YouTube'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.newmenuoption,
          child: Text('Google'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.jsoption,
          child: Text('JavaScript'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.javascriptChannel,
          child: Text('JavaScript Channel'),
        ),
      ],
    );
  }
}
