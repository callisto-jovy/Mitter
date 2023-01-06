import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:it_class_frontend/util/connection_util.dart';
import 'package:it_class_frontend/views/chat_view.dart';

import 'home_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  int _selectedChat = 0;

  final PageController _pageController = PageController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SocketInterface>().errors.stream.listen((event) {
        if (_scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'On Snap!',
              message: event,
              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
              contentType: ContentType.failure,
            ),
          ));
        }
      });
    });

    super.initState();
  }

  Widget navigationRail(Size size) => StreamBuilder(
        builder: (context, snapshot) {
          return NavigationRail(
              minWidth: size.width / 10,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;

                  if (index >= 2) {
                    _selectedChat = index - 2;
                    index = 2;
                  }
                  _pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.account_circle_outlined),
                  selectedIcon: Icon(Icons.account_circle_sharp),
                  label: Text('My account'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_sharp),
                  label: Text('Home'),
                ),
                ...?snapshot.data
                    ?.map((e) => NavigationRailDestination(
                          icon: e.partner.profile == "null"
                              ? const Icon(Icons.supervised_user_circle_rounded)
                              : Image(
                                  image: ResizeImage(MemoryImage(base64Decode(e.partner.profile)),
                                      width: 50, height: 50),
                                  fit: BoxFit.contain,
                                ),
                          //    icon: ,
                          label: Text(e.chatName),
                        ))
                    .toList(),
              ]);
        },
        stream: Get.find<SocketInterface>().chatController.stream,
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: <Widget>[
          SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height),
                  child: IntrinsicHeight(child: navigationRail(size)))),
          // This is the main content.
          Expanded(
              child: PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const HomeView(), //TODO: Account
              const HomeView(),
              ChatView(_selectedChat),
            ],
          )),
        ],
      ),
    );
  }
}
