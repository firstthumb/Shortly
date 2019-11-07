import 'package:flutter/material.dart';
import 'package:shortly/app/domain/entities/shorten.dart';

const int URL_LENGTH = 40;

class ShortenItem extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onToggle;
  final Shorten shorten;

  const ShortenItem({Key key,
    this.onDelete,
    this.shorten,
    this.onToggle,
    this.onCopy,
    this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('ShortenItem__${shorten.id}'),
      direction: DismissDirection.endToStart,
      background: _slideLeftBackground(),
      onDismissed: onDismissed,
      child: _buildItem(),
    );
  }

  void onDismissed(direction) {
    if (direction == DismissDirection.endToStart) {
      onDelete();
    }
  }

  Widget _buildItem() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text(
              "${_getLink(shorten.link)}",
              maxLines: 1,
            ),
            subtitle: Text("${shorten.shortLink}"),
            onTap: () => onCopy(),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.content_copy),
                  onPressed: () => onCopy(),
                ),
                FlatButton(
                  child: Icon(Icons.share),
                  onPressed: () => onShare(),
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

  String _getLink(String link) {
    if (link.length > URL_LENGTH) {
      return link.substring(0, URL_LENGTH) + "...";
    }

    return link;
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
