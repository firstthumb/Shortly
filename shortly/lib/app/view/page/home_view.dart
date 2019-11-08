import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share/share.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_event.dart';
import 'package:shortly/app/view/widgets/beauty_textfield.dart';
import 'package:shortly/app/view/widgets/loading_widget.dart';
import 'package:shortly/app/view/widgets/shorten_item.dart';
import 'package:shortly/core/util/logger.dart';
import 'package:toast/toast.dart';

import '../../domain/entities/shorten.dart';
import '../bloc/blocs.dart';
import '../bloc/shorten/shorten_bloc.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final logger = getLogger('HomeViewState');

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();

    ReceiveSharingIntent.getInitialText().then((String value) {
      if (value == null || !Uri
          .parse(value)
          .isAbsolute) {
        return;
      }

      logger.v("Shared Text : $value");
      _shortenUrlAndCopyClipBoard(value);
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            BeautyTextField(
              controller: _controller,
              width: double.maxFinite,
              height: 60,
              duration: Duration(milliseconds: 300),
              inputType: TextInputType.text,
              prefixIcon: Icon(
                Icons.link,
              ),
              placeholder: "Write your URL",
              onTap: () {
                print('Click');
              },
              onChanged: (t) {

              },
              onSubmitted: (inputUrl) {
                BlocProvider.of<ShortenBloc>(context)
                    .add(CreateShortenEvent(link: inputUrl));
                _controller.clear();
              },
            ),
            Expanded(
              child: BlocBuilder<ShortenBloc, ShortenState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return Container();
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return _buildList(context, state.shortens);
                  } else if (state is Created && state.sharedIntent) {
                    _copyUrl(state.shorten);
                    Toast.show("Copied to clipboard", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    return null;
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
      onDelete: () => _deleteShorten(index, shorten),
      onToggle: () => _toggleFavShorten(shorten),
      onCopy: () => _copyUrl(shorten),
      onShare: () => _shareShorten(shorten),
    );
  }

  Widget _buildRemovedItem(BuildContext context, Shorten shorten,
      Animation<double> animation) {
    return SizeTransition(
      key: ValueKey<Shorten>(shorten),
      axis: Axis.vertical,
      sizeFactor: animation,
      child: ShortenItem(
        shorten: Shorten(
          link: shorten.link,
          shortLink: shorten.shortLink,
          fav: shorten.fav,
          createdAt: DateTime.now(),
        ),
      ),
    );
  }

  void _deleteShorten(int index, Shorten shorten) {
    BlocProvider.of<ShortenBloc>(context)
        .add(DeleteShortenEvent(id: shorten.id));

    listKey.currentState.removeItem(
      index,
          (context, animation) =>
          _buildRemovedItem(context, shorten, animation),
      duration: Duration.zero,
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

  void _shortenUrlAndCopyClipBoard(String inputUrl) {
    BlocProvider.of<ShortenBloc>(context)
        .add(CreateShortenEvent(link: inputUrl));
  }
}
