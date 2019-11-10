import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:shortly/app/view/bloc/fav/fav_bloc.dart';
import 'package:shortly/app/view/bloc/fav/fav_event.dart';
import 'package:shortly/app/view/bloc/fav/fav_state.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_event.dart';
import 'package:shortly/app/view/widgets/loading_widget.dart';
import 'package:shortly/app/view/widgets/shorten_item.dart';
import 'package:shortly/core/util/logger.dart';

import '../../domain/entities/shorten.dart';
import '../bloc/blocs.dart';
import '../bloc/shorten/shorten_bloc.dart';

class FavouriteView extends StatefulWidget {
  @override
  _FavouriteViewState createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  final logger = getLogger('FavouriteViewState');

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();


  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavBloc>(context)
        .add(FavListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: BlocBuilder<FavBloc, FavState>(
                builder: (context, state) {
                  if (state is FavEmpty) {
                    return Container();
                  } else if (state is FavLoading) {
                    return LoadingWidget();
                  } else if (state is FavLoaded) {
                    return _buildList(context, state.shortens);
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildList(BuildContext context, List<Shorten> shortens) {
    return AnimatedList(
      key: listKey,
      initialItemCount: shortens.length,
      itemBuilder: (context, index, animation) {
        return _buildItem(context, index, shortens, animation);
      },
    );
  }

  Widget _buildItem(BuildContext context, index, List<Shorten> shortens,
      Animation<double> animation) {
    final shorten = shortens[index];

    return ShortenItem(
      shorten: shorten,
      onToggle: () => _toggleFavShorten(shorten),
      onCopy: () => _copyUrl(shorten),
      onShare: () => _shareShorten(shorten),
    );
  }

  void _toggleFavShorten(Shorten shorten) {
    logger.v("Toggle : ${shorten.shortLink}");
    BlocProvider.of<ShortenBloc>(context)
        .add(ToggleFavShortenEvent(id: shorten.id));
  }

  void _copyUrl(Shorten shorten) {
    logger.v("Copied to clipboard : ${shorten.shortLink}");
    ClipboardManager.copyToClipBoard(shorten.shortLink).then((result) {
      final snackBar = SnackBar(
        content: Text('Copied to Clipboard'),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void _shareShorten(Shorten shorten) {
    logger.v("Share : ${shorten.shortLink}");
    Share.share(shorten.shortLink);
  }
}
