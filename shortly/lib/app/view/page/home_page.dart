import 'package:beauty_navigation/beauty_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_bloc.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_event.dart';
import 'package:shortly/di/injection_container.dart';

import 'home_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: _buildNavigation(context),
    );
  }

  BlocProvider<ShortenBloc> _buildBody(BuildContext context) {
    return BlocProvider<ShortenBloc>(
      builder: (_) =>
      sl<ShortenBloc>()
        ..dispatch(GetShortenListEvent()),
      child: HomeView(),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return BeautyNavigation(
      items: <Items>[
        Items(
          icon: Icon(Icons.home),
          tabName: 'Home',
          onClick: () {
            print('Home');
          },
        ),
        Items(
          icon: Icon(Icons.favorite),
          tabName: 'Favorite',
          onClick: () {
            print('Favorite');
          },
        ),
        Items(
          icon: Icon(Icons.settings),
          tabName: 'Settings',
          onClick: () {
            print('Settings');
          },
        ),
      ],
    );
  }
}
