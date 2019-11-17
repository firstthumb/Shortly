import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share/share.dart';
import 'package:shortly/app/view/bloc/blocs.dart';
import 'package:shortly/app/view/widgets/loading_widget.dart';
import 'package:shortly/app/view/widgets/shorten_item.dart';
import 'package:shortly/core/util/logger.dart';
import 'package:shortly/di/injection_container.dart';
import 'package:toast/toast.dart';

import '../../domain/entities/shorten.dart';

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

      // Don't call the callback again
      ReceiveSharingIntent.reset();

      logger.v("Shared Text : $value");
      _shortenUrlAndCopyClipBoard(value);

      Toast.show("Copied to clipboard", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMain() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Stack(
          children: <Widget>[
            _buildSearchResult(),
            _buildAppBar(),
            _buildSearchField(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 90.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              child: TextField(
                controller: _controller,
                cursorColor: Colors.black.withOpacity(0.65),
                style: TextStyle(
                    color: Colors.black.withOpacity(0.65),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
                  hintText: 'Write your URL',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                  prefixIcon: Material(
                    elevation: 0.0,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    child: Icon(
                      Icons.search,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                  ),
                ),
                onChanged: (value) {},
                onSubmitted: (value) {
                  BlocProvider.of<ShortenBloc>(context)
                      .add(CreateShortenEvent(link: value));
                  _controller.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 120.0,
      width: double.infinity,
      decoration: BoxDecoration(color: Theme
          .of(context)
          .primaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                'Shortly',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          RawMaterialButton(
            child: Icon(
              Icons.web,
              color: Colors.white,
              size: 32.0,
            ),
            shape: CircleBorder(),
            padding: const EdgeInsets.all(4.0),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResult() {
    return Container(
      padding: EdgeInsets.only(top: 120.0),
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey[200],
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Theme
              .of(context)
              .accentColor,
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: BlocBuilder<ShortenBloc, ShortenState>(
              builder: (context, state) {
                if (state is Empty) {
                  return Container();
                } else if (state is Loading) {
                  return LoadingWidget();
                } else if (state is Loaded) {
                  return _buildList(context, state.shortens);
                } else if (state is Synced) {
                  return _buildList(context, state.shortens);
                } else if (state is Created) {
                  if (state.sharedIntent) {
                    _copyUrl(state.shorten);
                  }
                  _sync();
                  return null;
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMain();
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
        duration: Duration(seconds: 2),
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

  void _sync() {
    final currentUser = sl<GoogleSignIn>().currentUser;
    if (currentUser != null) {
      logger.v("Logged User : $currentUser");
      BlocProvider.of<ShortenBloc>(context)
          .add(SyncShortenEvent(userId: currentUser.id));
    } else {
      logger.v("Not logged in yet...");
    }
  }
}
