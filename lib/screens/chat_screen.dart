import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messaging_app/components/my_text_field.dart';
import 'package:flutter_messaging_app/services/chat/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatScreen({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    // only send message when there is text
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserID,
          widget.receiverUserEmail, _messageController.text);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // a number to scale size according to the height of the display
    final double displayScale = MediaQuery.of(context).size.height / 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverUserEmail,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            color: Colors.red,
          )),
          _buildMessageInput(displayScale)
        ],
      ),
    );
  }

  // build message list

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align message to the right if it is from the current, left if it is the other user
    var alignment = (data["senderId"] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

  }

  // build message input
  Widget _buildMessageInput(double displayScale) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
                controller: _messageController, hintText: "Enter your message"),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.lightBlue,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
