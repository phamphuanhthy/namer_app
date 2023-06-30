import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/src/menu1.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:http/http.dart' as http;

import 'src/menu.dart';
import 'src/navigation_controls.dart';

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse(
      'https://logi-path.com/nodejs/selectdb/SELECT * FROM public.shipper'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    print(response.body.toString());
    final List<dynamic> dataList = jsonDecode(response.body);

    //return Album.fromJson(jsonDecode(response.body));
    return Album.fromJson(dataList[1]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int idshipper;
  final String tenshipper;
  final String username;

  const Album({
    required this.idshipper,
    required this.tenshipper,
    required this.username,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      idshipper: json['idshipper'],
      tenshipper: json['tenshipper'],
      username: json['username'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  bool showLeading = false;
  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

// ↓ Add the code below.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // ← Add this property.

  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return HomeScreen();
    });

    // ...

    // Widget page;
    // switch (selectedIndex) {
    //   case 0:
    //     page = GeneratorPage();
    //     break;
    //   case 1:
    //     page = FavoritesPage();
    //     break;
    //   case 2:
    //     page = WebViewApp();
    //     //webPage();
    //     break;
    //   case 3:
    //     page = GeneratorPage1();
    //     break;

    //   default:
    //     throw UnimplementedError('no widget for $selectedIndex');
    // }

// ...

    //   return LayoutBuilder(builder: (context, constraints) {
    //     return Scaffold(
    //       body: Row(
    //         children: [
    //           SafeArea(
    //             child: NavigationRail(
    //               extended: constraints.maxWidth >= 800, // ← Here.
    //               // extended: false,

    //               leading: MyAppState().showLeading
    //                   ? FloatingActionButton(
    //                       elevation: 0,
    //                       onPressed: () {
    //                         // Add your onPressed code here!
    //                       },
    //                       child: const Icon(Icons.add),
    //                     )
    //                   : const SizedBox(),

    //               destinations: [
    //                 NavigationRailDestination(
    //                   icon: Icon(Icons.home),
    //                   label: Text('Home'),
    //                 ),
    //                 NavigationRailDestination(
    //                   icon: Icon(Icons.favorite),
    //                   label: Text('Favorites'),
    //                 ),
    //                 NavigationRailDestination(
    //                   icon: Icon(Icons.favorite),
    //                   label: Text('webpage'),
    //                 ),
    //                 NavigationRailDestination(
    //                   icon: Icon(Icons.home),
    //                   label: Text('new Home'),
    //                 ),
    //               ],
    //               // selectedIndex: 0,
    //               // onDestinationSelected: (value) {
    //               //   print('selected: $value');
    //               // },

    //               selectedIndex: selectedIndex, // ← Change to this.
    //               onDestinationSelected: (value) {
    //                 // ↓ Replace print with this.
    //                 setState(() {
    //                   selectedIndex = value;
    //                 });
    //               },
    //             ),
    //           ),
    //           Expanded(
    //             child: Container(
    //               color: Theme.of(context).colorScheme.primaryContainer,
    //               //child: GeneratorPage(),
    //               child: page, // ← Here.
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //   });
  }
}

// ...

class FavoritesPage extends StatelessWidget {
  //late Future<Album> futureAlbum;

  final Future<Album> futureAlbum = fetchAlbum();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.tenshipper); //snapshot.data!.tenshipper
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );

    // if (appState.favorites.isEmpty) {
    //   return Center(
    //     child: Text('No favorites yet.'),
    //   );
    // }

    // return ListView(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.all(20),
    //       child: Text('You have '
    //           '${appState.favorites.length} favorites:'),
    //     ),
    //     for (var pair in appState.favorites)
    //       ListTile(
    //         leading: Icon(Icons.favorite),
    //         title: Text(pair.asLowerCase),
    //       ),
    //   ],
    // );
  }
}

// ...

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like...'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

// ...

class GeneratorPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter '),
          actions: [
            Menu1(), // ADD
          ],
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(children: [
            Image.asset('assets/images/phongchong.png'),
            ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: Text('Like'),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: Text('unLike'),
            ),
          ]),
          SizedBox(height: 10),
          Row(children: [
            ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: Text('Like'),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () {
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: Text('unLike'),
            ),
          ]),
        ]))
    );
  }
}

// ...

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//       // ↓ Add this.
//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//   //   return Scaffold(
//   //     body: Column(
//   //       children: [
//   //         Text('A random idea:'),
//   //         Text(appState.current.asLowerCase),
//   //       ],
//   //     ),
//   //   );
//   // }

//   // ...

//     // return Scaffold(
//     //   body: Column(
//     //     children: [
//     //       Text('A random AWESOME idea:'),  // ← Example change.
//     //       Text(appState.current.asLowerCase),
//     //     ],
//     //   ),
//     // );

// // ...

//     return Scaffold(
//       body: Center(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,  // ← Add this.
//           children: [

//             BigCard(pair: pair),
//         SizedBox(height: 10),
//             // ↓ Add this.
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [

//                    // ↓ And this.
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     appState.toggleFavorite();
//                   },
//                   icon: Icon(icon),
//                   label: Text('Like'),
//                 ),

//                 ElevatedButton(
//                   onPressed: () {
//                      appState.getNext();  // ← This instead of print().
//                     //print('button pressed!');
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             ),

//           ],
//         ),
//       ),
//     );

// }
// }

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      child: Text(
        pair.asLowerCase,
        style: style,
        semanticsLabel: "${pair.first} ${pair.second}",
      ),
    );
  }
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(
        Uri.parse('https://futter.dev'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView 111'),
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller), // ADD
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String appBarTitle = "Title1";

  final List<String> titles = ["Home", "Pg1", "Pg2", "Pg3"];

  void changeTitle(int id) {
    setState(() {
      appBarTitle = titles[id];
    });
  }

  // The contents of views
  // Only the content associated with the selected tab is displayed on the screen
  final List<Widget> _mainContents = [
    // Content for Home tab
    Container(
        color: Colors.yellow.shade100,
        alignment: Alignment.center,
        child: Center(

            child: ElevatedButton(
          child: Text("Open Web Page"),
          onPressed: () async {
            Uri url = Uri.https("logi-path.com");
            //url.
            //String url = "https://www.fluttercampus.com";
            var urllaunchable = await canLaunchUrl(
                url); //canLaunch is from url_launcher package
            if (urllaunchable) {
              await launchUrl(
                  url); //launch is from url_launcher package to launch URL
            } else {
              print("URL can't be launched.");
            }
          },
        ))),

    // Content for Feed tab
    Container(
      color: Colors.purple.shade100,
      alignment: Alignment.center,
       child: Column(
          children: const [


            Text("Avatar"),

            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 20,
              child: Icon(Icons.person),
            ),
            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 30,
              child: Icon(Icons.person),
            ),

            SizedBox(
              height: 50,
            ),
            CircleAvatar(
              radius: 60,
              child: Icon(Icons.person),
            ),
         Image(image: AssetImage('assets/images/phongchong.png')),

          ],
        ),



      ),

    // Content for Favorites tab
    Container(
      color: Colors.red.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Favorites',
        style: TextStyle(fontSize: 40),


      ),
    ),
    // Content for Settings tab
    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings 123',
        style: TextStyle(fontSize: 40),
      ),
    )
  ];

  // The index of the selected tab
  // In the beginning, the Home tab is selected
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle), // <-- add this
        actions: [
          Menu1(), // ADD
        ],
      ),
      // Show the bottom tab bar if screen width < 640
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Colors.indigoAccent,
              // called when one tab is selected
              onTap: (int index) {
                changeTitle(index);
                setState(() {
                  _selectedIndex = index;
                });
              },
              // bottom tab items
              items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.feed), label: 'Feed'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite), label: 'Favorites'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'Settings')
                ])
          : null,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Show the navigaiton rail if screen width >= 640
          if (MediaQuery.of(context).size.width >= 640)
            NavigationRail(
              minWidth: 55.0,
              selectedIndex: _selectedIndex,
              // Called when one tab is selected
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: const TextStyle(
                color: Colors.amber,
              ),
              leading: Column(
                children: const [
                  SizedBox(
                    height: 8,
                  ),
                  CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  ),
                ],
              ),
              unselectedLabelTextStyle: const TextStyle(),
              // navigation rail items
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.feed), label: Text('Feed')),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite), label: Text('Favorites')),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text('Settings')),
              ],
            ),

          // Main content
          // This part is always shown
          // You will see it on both small and wide screen
          Expanded(child: _mainContents[_selectedIndex]),
        ],
      ),
    );
  }
}
