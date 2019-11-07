import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_event.dart';
import 'package:shortly/app/view/widgets/loading_widget.dart';
import 'package:shortly/app/view/widgets/shorten_item.dart';

import '../../domain/entities/shorten.dart';
import '../bloc/blocs.dart';
import '../bloc/shorten/shorten_bloc.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

//  double _scrollPixel;
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

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

                BlocProvider.of<ShortenBloc>(context)
                    .add(CreateShortenEvent(link: d));
              },
            ),
            Expanded(
              child: BlocBuilder<ShortenBloc, ShortenState>(
                builder: (context, state) {
                  print("STATE : $state");

                  if (state is Empty) {
                    return Container();
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return _buildList(context, state.shortens);
                  } else if (state is Toggled) {
//                    _controller.jumpTo(_scrollPixel);
                    return Container();
                  } else {
                    return Container();
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
        print("Building item....");
        return _buildItem(context, index, shortens, animation);
      },
    );
//    return ListView.builder(
//        controller: _controller,
//        shrinkWrap: true,
//        itemCount: shortens.length,
//        itemBuilder: (context, index) {
//          return ShortenItem(
//            shorten: shortens[index],
//            onToggle: () => _toggleFavShorten(context, shortens[index]),
//          );
//        });
  }

  Widget _buildItem(BuildContext context, index, List<Shorten> shortens,
      Animation<double> animation) {
    print("Creating SizeTransition");

    final shorten = shortens[index];

    return SizeTransition(
      key: ValueKey<Shorten>(shorten),
      axis: Axis.vertical,
      sizeFactor: animation,
      child: ShortenItem(
        shorten: shorten,
        onDelete: () => _deleteShorten(index, shortens),
        onToggle: () => _toggleFavShorten(context, shorten),
      ),
    );
  }

  void _deleteShorten(int index, List<Shorten> shortens) {
    var shorten = shortens.removeAt(index);

    listKey.currentState.removeItem(
      index,
          (context, animation) => _buildItem(context, 0, [shorten], animation),
      duration: Duration(microseconds: 6000),
    );
  }

  void _toggleFavShorten(BuildContext context, Shorten shorten) {
    BlocProvider.of<ShortenBloc>(context)
        .add(ToggleFavShortenEvent(id: shorten.id));
  }
}
