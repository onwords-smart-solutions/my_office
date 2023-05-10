import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SubmitScreen extends StatefulWidget {
  final String secretKey;

  const SubmitScreen({Key? key, required this.secretKey}) : super(key: key);

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  @override
  void initState() {
    _addToFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(child: Text('WELCOME TO TEAM ONWORDS'),
        ),
      ),
    );
  }

  Future<void> _addToFirebase() async {
    final ref = FirebaseDatabase.instance.ref('login');
    ref.child(widget.secretKey).set({
      'login_approval': true,
      'uid': false,
    });
  }
}