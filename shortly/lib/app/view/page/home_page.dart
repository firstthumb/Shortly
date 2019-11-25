import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/app/view/bloc/blocs.dart';
import 'package:shortly/di/injection_container.dart';

import 'home_view.dart';
import 'settings_view.dart';

class HomePage extends StatelessWidget {
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

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
            body: _getTabItems(context, activeTab.currentTab),
            bottomNavigationBar: _buildNavigation(
                context, activeTab.currentTab),
          );
        },
      ),
    );
  }

  Widget _getTabItems(BuildContext context, AppTab tab) {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        if (index == 0) {
          BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.home));
        } else if (index == 1) {
          BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.settings));
        }
      },
      children: <Widget>[
        HomeView(),
        SettingsView(),
      ],
    );
  }

  int _getTabIndex(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return 0;
      case AppTab.settings:
        return 1;
    }

    return 0;
  }

  Widget _buildNavigation(BuildContext context, AppTab tab) {
    return BottomNavyBar(
      selectedIndex: _getTabIndex(tab),
      showElevation: true,
      onItemSelected: (index) => _onNavigationChanged(context, index),
      items: [
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
          activeColor: Colors.red,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
    );
  }

  void _onNavigationChanged(BuildContext context, int index) {
    if (index == 0) {
      BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.home));
    } else if (index == 1) {
      BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.settings));
    }

    pageController.animateToPage(
        index, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }
}
