// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.label,
    this.prefix,
    this.suffix,
    this.onTap,
  });

  final String label;
  final Widget? prefix;
  final Widget? suffix;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: prefix,
      trailing: suffix,
      title: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontSize: MediaQuery.of(context).size.width / 23),
      ),
    );
  }
}
