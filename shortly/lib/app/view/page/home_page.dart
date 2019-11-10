import 'package:beauty_navigation/beauty_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/app/view/bloc/fav/fav_bloc.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_bloc.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_event.dart';
import 'package:shortly/app/view/bloc/tab/tab.dart';
import 'package:shortly/app/view/models/app_tab.dart';
import 'package:shortly/app/view/page/settings_view.dart';
import 'package:shortly/di/injection_container.dart';

import 'favourite_view.dart';
import 'home_view.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShortenBloc>(
          builder: (_) =>
          sl<ShortenBloc>()
            ..add(GetShortenListEvent()),
        ),
        BlocProvider<FavBloc>(
          builder: (_) => sl<FavBloc>(),
        ),
        BlocProvider<TabBloc>(
          builder: (_) => sl<TabBloc>(),
        ),
      ],
      child: BlocBuilder<TabBloc, AppTab>(
        builder: (context, activeTab) {
          return Scaffold(
            body: activeTab == AppTab.home ? HomeView() : (activeTab ==
                AppTab.favourites ? FavouriteView() : SettingsView()),
            bottomNavigationBar: _buildNavigation(context),
          );
        },
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return BeautyNavigation(
      items: <Items>[
        Items(
          icon: Icon(Icons.home),
          tabName: 'Home',
          onClick: () {
            BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.home));
          },
        ),
        Items(
          icon: Icon(Icons.favorite),
          tabName: 'Favorite',
          onClick: () {
            BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.favourites));
          },
        ),
        Items(
          icon: Icon(Icons.settings),
          tabName: 'Settings',
          onClick: () {
            BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.settings));
          },
        ),
      ],
    );
  }
}
