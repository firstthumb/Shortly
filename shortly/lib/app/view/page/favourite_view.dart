import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';
import 'package:shortly/app/domain/entities/shorten.dart';
import 'package:shortly/app/util/utils.dart';
import 'package:shortly/app/view/bloc/blocs.dart';
import 'package:shortly/app/view/widgets/widgets.dart';
import 'package:shortly/core/util/logger.dart';

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
    BlocProvider.of<FavBloc>(context).add(FavListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return _buildMain();
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
            _buildFavResult(),
            _buildAppBar(),
          ],
        ),
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
                'Bookmarks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavResult() {
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
        ),
      ),
    );
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

    setClipBoardData(shorten.shortLink);

    final snackBar = SnackBar(
      content: Text('Copied to Clipboard'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _shareShorten(Shorten shorten) {
    logger.v("Share : ${shorten.shortLink}");
    Share.share(shorten.shortLink);
  }
}
