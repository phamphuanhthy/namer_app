import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';

enum _MenuOptions {
  navigationDelegate,
  newmenuoption,
  jsoption,
  javascriptChannel,
}

class Menu1 extends StatelessWidget {
  const Menu1({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          case _MenuOptions.navigationDelegate:

            //   MyHomePage().        showLeading = !showLeading;
            break;
          case _MenuOptions.newmenuoption:
            break;
          case _MenuOptions.jsoption:
            break;
          case _MenuOptions.javascriptChannel:
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text('option1'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.newmenuoption,
          child: Text('option2'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.jsoption,
          child: Text('option3'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.javascriptChannel,
          child: Text('option4'),
        ),
      ],
    );
  }
}
