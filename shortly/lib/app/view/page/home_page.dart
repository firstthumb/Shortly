import 'package:beauty_navigation/beauty_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/app/view/bloc/blocs.dart';
import 'package:shortly/di/injection_container.dart';

import 'favourite_view.dart';
import 'home_view.dart';
import 'settings_view.dart';

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
      child: BlocBuilder<TabBloc, TabState>(
        builder: (context, activeTab) {
          return Scaffold(
            body: _getTabItem(activeTab.currentTab),
            bottomNavigationBar: _buildNavigation(context),
          );
        },
      ),
    );
  }

  Widget _getTabItem(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return HomeView();
      case AppTab.favourites:
        return FavouriteView();
      case AppTab.settings:
        return SettingsView();
    }

    return HomeView();
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
