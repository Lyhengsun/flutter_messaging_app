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
      await _chatService.sendMessage(
        widget.receiverUserID,
        widget.receiverUserEmail,
        _messageController.text,
      );
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
            child: _buildMessageList(),
          ),
          _buildMessageInput(displayScale)
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessage(
        _firebaseAuth.currentUser!.uid,
        widget.receiverUserID,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var messageDocumentList = snapshot.data!.docs;
        return ListView(
          children: () {
            List<Widget> messageItemList = [];

            // check if the sender is the same. if true show email, else no email
            String userEmail = "";
            for (var i = 0; i < messageDocumentList.length; i++) {
              String newUserEmail = (messageDocumentList[i].data()
                  as Map<String, dynamic>)["senderEmail"];
              if (newUserEmail != userEmail) {
                userEmail = newUserEmail;
                messageItemList
                    .add(_buildMessageItem(messageDocumentList[i], false));
              } else {
                messageItemList
                    .add(_buildMessageItem(messageDocumentList[i], true));
              }
            }
            return messageItemList;
          }(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document, bool sameUser) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align message to the right if it is from the current, left if it is the other user
    bool isCurrentUser = (data["senderId"] == _firebaseAuth.currentUser!.uid);
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    var crossAlignment =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    Color messageBubbleColor =
        isCurrentUser ? Colors.lightBlue : Colors.grey.shade300;
    Color messageTextColor = isCurrentUser ? Colors.white : Colors.black87;

    return Container(
      alignment: alignment,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          crossAxisAlignment: crossAlignment,
          children: [
            // show the sender name only once for consecutive messages
            sameUser
                ? const SizedBox()
                : Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Text(
                      data["senderEmail"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: messageBubbleColor,
                borderRadius: BorderRadius.only(
                  topRight:
                      isCurrentUser ? Radius.zero : const Radius.circular(10),
                  bottomRight:
                      isCurrentUser ? Radius.zero : const Radius.circular(10),
                  topLeft:
                      isCurrentUser ? const Radius.circular(10) : Radius.zero,
                  bottomLeft:
                      isCurrentUser ? const Radius.circular(10) : Radius.zero,
                ),
              ),
              child: Text(
                data["message"],
                style: TextStyle(color: messageTextColor),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
    );
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
            onTap: sendMessage,
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
