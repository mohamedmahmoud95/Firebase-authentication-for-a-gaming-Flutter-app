import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mutli_user_2d_car_racing_game_with_group_chat_using_flutter_and_firebase_7june/models/message.dart';
import 'package:provider/provider.dart';

import '../firebase_services/cloud_firestore_database_services.dart';

class ChatBottomSheet extends StatefulWidget {
  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<List<Message>>(context) ?? [];

    return Consumer<DatabaseServices>(

      builder: (context, databaseServices, _) {
        return StreamBuilder<List<Message>>(
          stream: databaseServices.chatMessages,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: 100,
                child: CircularProgressIndicator(),
              );
            }

           // List<Message> messages = snapshot.data!;

            return Container(
              height: 400,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Message message = messages[index];
                        return ListTile(
                          title: Text(message.message),
                          subtitle: Text(message.senderName),
                          trailing: Text(message.timestamp.toString()),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            String message = _textEditingController.text.trim();
                            if (message.isNotEmpty) {
                              String senderName = 'YourName'; // Replace with the sender's name
                              databaseServices.sendChatMessage(message, senderName);
                              _textEditingController.clear();
                            }
                          },
                          child: Text('Send'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
