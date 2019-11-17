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
      child: _buildList(context),
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

  Widget _buildList(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 12.0),
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 2.0, right: 16.0),
              child: Icon(
                Icons.web_asset,
                size: 24.0,
                color: Theme
                    .of(context)
                    .accentColor,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    shorten.shortLink,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.65),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.timelapse,
                        color: Theme
                            .of(context)
                            .accentColor,
                        size: 16.0,
                      ),
                      SizedBox(width: 6.0),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                shorten.link,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black.withOpacity(0.55),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    children: <Widget>[
                      RawMaterialButton(
                        child: Icon(
                          Icons.content_copy,
                          color: Theme
                              .of(context)
                              .accentColor,
                          size: 16.0,
                        ),
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(4.0),
                        onPressed: () => onCopy(),
                      ),
                      SizedBox(width: 6.0),
                      RawMaterialButton(
                        child: Icon(
                          Icons.share,
                          color: Theme
                              .of(context)
                              .accentColor,
                          size: 16.0,
                        ),
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(4.0),
                        onPressed: () => onShare(),
                      ),
                      SizedBox(width: 6.0),
                      RawMaterialButton(
                        child: Icon(
                          shorten.fav ?? false ? Icons.star : Icons.star_border,
                          color: Theme
                              .of(context)
                              .accentColor,
                          size: 16.0,
                        ),
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(4.0),
                        onPressed: () => onToggle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildPopupMenu(),
          ],
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildPopupMenu() {
    return new PopupMenuButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Icon(Icons.more_vert,
            size: 24.0, color: Colors.black.withOpacity(0.65)),
      ),
      onSelected: (selectedDropDownItem) =>
          handlePopUpChanged(selectedDropDownItem),
      itemBuilder: (BuildContext context) => _listTilePopupMenuItems(),
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
    final Map<PopupAction, String> optionMenuItems = {
      PopupAction.OPEN_URL: 'Open',
      PopupAction.SHOW_STATS: 'Show Stats',
    };

    return optionMenuItems.keys
        .map(
          (PopupAction item) =>
          PopupMenuItem(
            value: item,
            child: Text(
              optionMenuItems[item],
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.65),
              ),
            ),
          ),
    )
        .toList();
  }

  void _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
