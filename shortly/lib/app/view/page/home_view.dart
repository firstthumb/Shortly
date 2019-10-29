import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BeautyTextfield(
              width: double.maxFinite,
              height: 60,
              duration: Duration(milliseconds: 300),
              inputType: TextInputType.text,
              prefixIcon: Icon(
                Icons.link,
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
            Expanded(
              child: _buildList(context),
            ),
          ],
        ));
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.arrow_right),
                  title: Text('www.google.com'),
                  subtitle: Text('www.tikitok.kt/Wedr2'),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.content_copy),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Icon(Icons.share),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Icon(Icons.star_border),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
