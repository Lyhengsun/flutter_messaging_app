import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messaging_app/models/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of firebase and firestore
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // SEND MESSAGE
  Future<void> sendMessage(String receiverId, String receiverEmail, String messageString) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    MessageModel message = MessageModel(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: messageString,
      timestamp: timestamp,
    );

    // construct chatroom id from current user and receiver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the two ids (ensure that the 2 pair of user id is always in the same order)
    String chatroomId =
        ids.join("_"); // create the chatroom id from the id of both user

    // add new message to the database
    await _firestore
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .add(message.toMap());
  }

  // GET MESSAGE
  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomId = ids.join("_");

    return _firestore
        .collection("chatrooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
