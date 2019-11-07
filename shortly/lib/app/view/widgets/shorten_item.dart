import 'package:flutter/material.dart';
import 'package:shortly/app/domain/entities/shorten.dart';

class ShortenItem extends StatelessWidget {
//  final DismissDirectionCallback onDismissed;
  final VoidCallback onDelete;
  final GestureTapCallback onTap;
  final VoidCallback onToggle;
  final Shorten shorten;

  const ShortenItem(
      {Key key, this.onDelete, this.onTap, this.shorten, this.onToggle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("KEY : ShortenItem__${shorten.id}");
    return Dismissible(
      key: Key('ShortenItem__${shorten.id}'),
      direction: DismissDirection.endToStart,
      background: _slideLeftBackground(),
      onDismissed: onDismissed,
      child: _c(),
    );
  }

  void onDismissed(direction) {
    if (direction == DismissDirection.endToStart) {
      onDelete();
    }
  }

  Widget _c() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text("${shorten.link}"),
            subtitle: Text("${shorten.shortLink}"),
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
                  child:
                      shorten.fav ? Icon(Icons.star) : Icon(Icons.star_border),
                  onPressed: () => onToggle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
