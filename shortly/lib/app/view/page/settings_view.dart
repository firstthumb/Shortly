import 'package:flutter/material.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';
import 'package:shortly/core/util/logger.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final logger = getLogger('SettingsViewState');

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
                  '0': 'www.tikitok.tk',
                  '1': 'www.share.tk',
                },
                defaultKey: "0",
              ),
            ],
          ),
          SettingsTileGroup(
            title: "Sync",
            children: [
              Text("Login with Google"),
              FlatButton(
                child: Text("Google Login"),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
