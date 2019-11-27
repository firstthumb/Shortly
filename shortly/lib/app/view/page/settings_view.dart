import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';
import 'package:shortly/core/util/logger.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final logger = getLogger('SettingsViewState');

  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();

    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: SettingsScreen(
        title: 'Settings',
        children: [
          SettingsTileGroup(
            title: "General",
            children: [
              RadioPickerSettingsTile(
                settingKey: 'provider',
                title: 'Select Provider',
                values: {
                  '1': 'tikitok.tk',
                  '2': 'shortli.tk',
                },
                defaultKey: "1",
              ),
            ],
          ),
          SettingsTileGroup(
            title: "Sync",
            children: [
              _getGoogleWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getGoogleWidget() {
    if (_currentUser == null) {
      return GoogleSignInButton(
        onPressed: () async {
          await _handleSignIn();
        },
        borderRadius: 10.0,
      );
    } else {
      return Column(
        children: <Widget>[
          Text("Logged as ${_currentUser.displayName}"),
          GoogleSignInButton(
            text: "Logout",
            onPressed: () async {
              await _handleSignOut();
            },
            borderRadius: 10.0,
          )
        ],
      );
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }
}
