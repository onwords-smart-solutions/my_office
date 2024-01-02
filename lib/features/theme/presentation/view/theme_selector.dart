import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme/presentation/provider/theme_provider.dart';
import '../util/theme_type.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (ctx, themeProvider, child) {
        return ListTile(
          onTap: () => _showThemeSheet(context, themeProvider.theme),
          leading: Icon(
            Icons.wb_sunny_rounded,
            color: Theme.of(context).primaryColor,
          ),
          title: const Text('Change theme'),
          trailing: Text(
            themeProvider.theme,
            style: const TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
        );
      },
    );
  }

  _showThemeSheet(BuildContext context, String currentTheme) {
    List<String> themes = [
      ThemeType.system,
      ThemeType.auto,
      ThemeType.light,
      ThemeType.dark,
    ];
    List<String> description = [
      'Apply your system theme',
      'Change theme automatically based on time',
      '',
      '',
    ];
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      context: context,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //heading
                ListTile(
                  title: const Text(
                    'Choose Theme',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  subtitle: const Text(
                    'Update your theme for app',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: IconButton.styleFrom(foregroundColor: Colors.grey),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(.3),
                  height: 0.0,
                  thickness: .5,
                ),
                //body
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      themes.length,
                          (index) => ListTile(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          Provider.of<ThemeProvider>(
                            context,
                            listen: false,
                          ).updateAppTheme(themes[index]);
                        },
                        shape: index == themes.length - 1
                            ? const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20.0),
                          ),
                        )
                            : null,
                        title: Text(themes[index]),
                        subtitle: Text(
                          description[index],
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
