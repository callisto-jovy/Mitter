import 'package:flutter/material.dart';

import '../util/icon_style.dart';

///Taken from: https://github.com/babstrap/babstrap_settings_screen/blob/main/lib/src/babs_component_settings_item.dart and modified (under MIT)
class SettingsItem extends StatelessWidget {
  final IconData icons;
  final IconStyle? iconStyle;
  final String title;
  final TextStyle? titleStyle;
  final String subtitle;
  final TextStyle? subtitleStyle;
  final Widget? trailing;
  final VoidCallback onTap;

  const SettingsItem(
      {super.key,
      required this.icons,
      this.iconStyle,
      required this.title,
      this.titleStyle,
      this.subtitle = "",
      this.subtitleStyle,
      this.trailing,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: (iconStyle != null && iconStyle!.withBackground!)
          ? Container(
              decoration: BoxDecoration(
                color: iconStyle!.backgroundColor,
                borderRadius: BorderRadius.circular(iconStyle!.borderRadius!),
              ),
              padding: const EdgeInsets.all(5),
              child: Icon(
                icons,
                color: iconStyle!.iconsColor,
              ),
            )
          : Icon(
              icons,
            ),
      title: Text(
        title,
        style: titleStyle ?? const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
      ),
      subtitle: Text(
        subtitle,
        style: subtitleStyle ?? const TextStyle(color: Colors.grey),
        maxLines: 1,
      ),
      trailing: (trailing != null) ? trailing : const Icon(Icons.arrow_forward_ios_rounded),
    );
  }
}
