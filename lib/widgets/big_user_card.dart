import 'package:flutter/material.dart';

/// Taken from https://github.com/babstrap/babstrap_settings_screen/blob/main/lib/src/babs_component_big_user_card.dart and modified (under MIT)
class BigUserCard extends StatelessWidget {
  final Color cardColor;
  final double cardRadius;
  final Color backgroundMotifColor;
  final Widget? cardActionWidget;
  final String userName;
  final Widget? userMoreInfo;
  final Widget userProfilePic;

  const BigUserCard({
    super.key,
    required this.cardColor,
    this.cardRadius = 30,
    required this.userName,
    this.backgroundMotifColor = Colors.white,
    this.cardActionWidget,
    this.userMoreInfo,
    required this.userProfilePic,
  });

  @override
  Widget build(BuildContext context) {
    double mediaQueryHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(double.parse(cardRadius.toString())),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: backgroundMotifColor.withOpacity(.1),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: (cardActionWidget != null)
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // User profile
                    Expanded(
                      child: Material(
                        elevation: 0,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: userProfilePic,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQueryHeight / 30,
                              color: Colors.white,
                            ),
                          ),
                          userMoreInfo ?? Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mediaQueryHeight * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: (cardActionWidget != null) ? cardActionWidget : Container(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
