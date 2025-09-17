import 'package:fan_floating_menu/fan_floating_menu.dart';
import 'package:flutter/material.dart';

class FanFloatingMenuWidget extends StatelessWidget {
  const FanFloatingMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FanFloatingMenu(
      fanMenuDirection: FanMenuDirection.rtl,
      toggleButtonColor:Colors.red,
      menuItems: [
        FanMenuItem(
          onTap: () {},
          
          icon: Icons.edit_rounded,
          menuItemIconColor:Colors.red,
          title: 'Edit Texts',
          menuItemColor:Colors.red,
        ),
        FanMenuItem(
            onTap: () {},
            menuItemIconColor: Theme.of(context).colorScheme.primary,
            menuItemColor: Theme.of(context).colorScheme.primary,
            icon: Icons.save_rounded,
            title: 'Save Notes'),
        FanMenuItem(
            onTap: () {},
            menuItemColor: Theme.of(context).colorScheme.primary,
            menuItemIconColor: Theme.of(context).colorScheme.primary,
            icon: Icons.send_rounded,
            title: 'Send Images'),
      ],
    );
  }
}
