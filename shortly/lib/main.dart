import 'package:beauty_navigation/beauty_navigation.dart';
import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BeautyTextfield(
                  width: double.maxFinite,
                  height: 60,
                  duration: Duration(milliseconds: 300),
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                  ),
                  placeholder: "With Suffic Icon",
                  onTap: () {
                    print('Click');
                  },
                  onChanged: (t) {
                    print(t);
                  },
                  onSubmitted: (d) {
                    print(d.length);
                  },
                  suffixIcon: Icon(Icons.remove_red_eye),
                ),
                BeautyTextfield(
                  width: double.maxFinite,
                  height: 60,
                  duration: Duration(milliseconds: 300),
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                  ),
                  placeholder: "Without Suffic Icon",
                  onTap: () {
                    print('Click');
                  },
                  onChanged: (t) {
                    print(t);
                  },
                  onSubmitted: (d) {
                    print(d.length);
                  },
                ),
              ],
            )),
        bottomNavigationBar: BeautyNavigation(
          items: <Items>[
            Items(
              icon: Icon(Icons.airline_seat_flat),
              tabName: 'Sleep',
              onClick: () {
                print('Sleep');
              },
            ),
            Items(
              icon: Icon(Icons.wifi_tethering),
              tabName: 'Wifi',
              onClick: () {
                print('Wifi');
              },
            ),
            Items(
              icon: Icon(Icons.adjust),
              tabName: 'Adjust',
              onClick: () {
                print('Adjust');
              },
            ),
            Items(
              icon: Icon(Icons.cake),
              tabName: 'Cake',
              onClick: () {
                print('Cake');
              },
            )
          ],
        ));
  }
}
