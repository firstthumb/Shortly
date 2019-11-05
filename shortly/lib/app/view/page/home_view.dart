import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_event.dart';
import 'package:shortly/app/view/widgets/loading_widget.dart';

import '../../domain/entities/shorten.dart';
import '../bloc/blocs.dart';
import '../bloc/shorten/shorten_bloc.dart';

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

                BlocProvider.of<ShortenBloc>(context)
                    .dispatch(CreateShortenEvent(link: d));
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
                  } else {
                    return Container();
                  }
                },
              ),
//              child: _buildList(context),
            ),
          ],
        ));
  }

  Widget _buildList(BuildContext context, List<Shorten> shortens) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: shortens.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.arrow_right),
                  title: Text("${shortens[index].link}"),
                  subtitle: Text("${shortens[index].shortLink}"),
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
