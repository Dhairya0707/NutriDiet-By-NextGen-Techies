// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipRecommendationWidget extends StatefulWidget {
  const TipRecommendationWidget({super.key});

  @override
  _TipRecommendationWidgetState createState() =>
      _TipRecommendationWidgetState();
}

class _TipRecommendationWidgetState extends State<TipRecommendationWidget> {
  String tip = "Loading...";
  DateTime? lastTipTime;

  @override
  void initState() async {
    super.initState();
    _fetchTip();
  }

  Future<void> _fetchTip() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the last tip and its timestamp from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tips')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get()
        .then((value) => value.docs[0]);

    if (snapshot != null) {
      lastTipTime = snapshot['timestamp'].toDate();
      if (lastTipTime != null &&
          DateTime.now().difference(lastTipTime!).inHours >= 2) {
        // Fetch a new tip if the last tip is older than 2 hours
        await _getNewTip(userId);
      } else {
        setState(() {
          tip = snapshot['content'];
        });
      }
    } else {
      await _getNewTip(userId);
    }
  }

  Future<void> _getNewTip(String userId) async {
    // Fetch a new random tip (you can customize this)
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('tips') // Collection where all tips are stored
        .orderBy(FieldPath.documentId)
        .limit(1)
        .get()
        .then((value) => value.docs[0]);

    // Store the new tip in Firestore for the user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tips')
        .add({
      'content': snapshot['content'],
      'timestamp': DateTime.now(),
    });

    setState(() {
      tip = snapshot['content'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tip of the Hour",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            tip,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
