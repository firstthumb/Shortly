import 'package:flutter/material.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopupAction { OPEN_URL, SHOW_STATS }

class ShortenItem extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onToggle;
  final VoidCallback onStats;
  final Shorten shorten;
  final PopupAction popupAction;

  const ShortenItem({
    Key key,
    this.onDelete,
    this.shorten,
    this.onToggle,
    this.onCopy,
    this.onShare,
    this.popupAction,
    this.onStats,
  }) : super(key: key);

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

  void handlePopUpChanged(PopupAction value) {
    switch (value) {
      case PopupAction.OPEN_URL:
        _openUrl(shorten.shortLink);
        break;
      case PopupAction.SHOW_STATS:
        onStats();
        break;
    }
  }

  Widget _buildItem() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text(
              "${shorten.link}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text("${shorten.shortLink}"),
            trailing: new PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (selectedDropDownItem) =>
                  handlePopUpChanged(selectedDropDownItem),
              itemBuilder: (BuildContext context) => _listTilePopupMenuItems(),
            ),
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
                  shorten.fav ?? false ? Icon(Icons.star) : Icon(
                      Icons.star_border),
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

  List<PopupMenuItem> _listTilePopupMenuItems() {
    return [
      PopupMenuItem(
        child: Text("Open"),
        value: PopupAction.OPEN_URL,
      ),
      PopupMenuItem(
        child: Text("Show Stats"),
        value: PopupAction.SHOW_STATS,
      ),
    ];
  }

  void _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
