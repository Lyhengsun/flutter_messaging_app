import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  MessageModel(this.senderId, this.senderEmail, this.receiverId, this.message, this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      "senderId" : senderId,
      "senderEmail" : senderEmail,
      "receiverId" : receiverId,
      "message" : message,
      "timestamp" : timestamp,
    };
  }
}