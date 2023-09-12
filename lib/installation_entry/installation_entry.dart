import 'package:flutter/material.dart';

class InstallationEntry extends StatelessWidget {
  const InstallationEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heading'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashRadius: 20.0,
        ),
      ),
      body: const Center(
        child: Text('InstallationEntry Screen'),
      ),
    );
  }
}
