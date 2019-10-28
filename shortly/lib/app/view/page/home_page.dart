import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortly/app/view/bloc/shorten/shorten_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  BlocProvider<ShortenBloc> _buildBody(BuildContext context) {
    return BlocProvider<ShortenBloc>(
        builder: (_) => sl<ShortenBloc>()
//        ..dispatch(GetShortenListEvent()),
        child: HomeView(),);
  }
}
