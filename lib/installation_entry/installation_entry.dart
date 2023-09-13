import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_office/installation_entry/start_info_detail.dart';
import 'package:my_office/provider/user_provider.dart';
import 'package:provider/provider.dart';

class InstallationEntry extends StatelessWidget {
  const InstallationEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Installation Entry',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashRadius: 20.0,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref('installation_tracker/${DateFormat('yyyy-MM-dd').format(DateTime.now())}/${userProvider.user!.uid}')
              .onValue,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data!.snapshot.exists) {
                return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        // title: Text('Pending entry (${DateFormat('yyyy-MM-dd').format(date)})'),
                      );
                    });
              }
            }
            return const Center(
              child: Text(
                'No Pending Entries',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const StartInfoDetail(),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
