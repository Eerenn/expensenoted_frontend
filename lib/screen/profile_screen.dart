import 'package:expensenoted/constant.dart';
import 'package:expensenoted/providers/auth_provider.dart';
import 'package:expensenoted/screen/loading_screen.dart';
import 'package:expensenoted/widget/btn_nav_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/profile';

  final _selectedIndex = 2;

  void _launchURL() async {
    const _url = 'https://github.com/Eerenn/expensenoted_frontend';
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BtmNavBar(selectedIndex: _selectedIndex),
      body: Ink(
        color: Theme.of(context).colorScheme.onBackground,
        child: SafeArea(
          child: Flex(
            direction: Axis.vertical,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: deviceSize.height * 0.1,
                ),
                child: user.getPhotoUrl.isNotEmpty && user.getPhotoUrl != 'null'
                    ? ClipOval(
                        child: Image(
                          image: NetworkImage(user.getPhotoUrl),
                          height: deviceSize.height * 0.17,
                        ),
                      )
                    : SizedBox(
                        height: deviceSize.height * 0.17,
                        child: const Center(
                          child: Text('No Image displayed'),
                        ),
                      ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.email_outlined,
                ),
                title: Text(user.getEmail),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.account_box_rounded,
                ),
                title: Text(user.getDisplayName),
              ),
              const Divider(),
              InkWell(
                onTap: _launchURL,
                child: const ListTile(
                  leading: Icon(
                    Icons.notes_outlined,
                  ),
                  title: Text('Privacy & Policy'),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  user.googleLogOut();
                  Navigator.of(context)
                      .pushReplacementNamed(LoadingScreen.routeName);
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: colorBar1,
                  ),
                  title: Text(
                    'Sign out',
                    style: TextStyle(color: colorBar1),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
