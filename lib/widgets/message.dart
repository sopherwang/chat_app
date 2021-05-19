import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, authData) {
          if (authData.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('chats')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final chatDoc = chatSnapshot.data.documents;
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemBuilder: (ctx, index) => MessageBubble(
                        key: ValueKey(chatDoc[index].documentID),
                        message: chatDoc[index]['text'],
                        isMe: chatDoc[index]['userId'] == authData.data.uid,
                        username: chatDoc[index]['username'],
                        userImage: chatDoc[index]['userImage'],
                      ),
                      itemCount: chatDoc.length,
                    ),
                  );
                }
              });
        });
  }
}
