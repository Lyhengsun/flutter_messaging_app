import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_messaging_app/screens/screens.dart';
import 'package:flutter_messaging_app/services/auth/auth_service.dart';
import 'package:flutter_messaging_app/services/chat/chat_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final double displayScale = MediaQuery.of(context).size.height / 900;
    // final double header1Size = 24 * displayScale;
    // final double header2Size = 16 * displayScale;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(
              Icons.logout_sharp,
              color: Colors.white,
              size: 28 * displayScale,
            ),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        // if (snapshot.hasError) {
        //   return const Center(
        //     child: Text("Error"),
        //   );
        // }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        // return Placeholder();
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data["email"]) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: ListTile(
          title: Text(data["email"]),
          subtitle: StreamBuilder(
            stream:
                ChatService().getMessage(_auth.currentUser!.uid, data["uid"]),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading.....");
              }

              var messageList = snapshot.data!.docs;
              if (messageList.isEmpty) {
                return Text("start your conversation with ${data["email"]}");
              }
              var lastMessage = messageList.last.data() as Map<String, dynamic>;
              return Row(
                children: [
                  Text(
                    "${lastMessage["senderEmail"]}: ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      lastMessage["message"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
          tileColor: Colors.grey.shade300,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiverUserEmail: data["email"],
                  receiverUserID: data["uid"],
                ),
              ),
            );
          },
        ),
      );
    }
    return const SizedBox();
  }
}
