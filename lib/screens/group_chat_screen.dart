//
// import 'package:flutter/material.dart';
//
// import '../../../models/message.dart';
// import '../widgets/TextInputField.dart';
// import '../widgets/message_bubble.dart';
//
// class GroupChatScreen extends StatefulWidget {
//     List<Message> messages;
//     GroupChatScreen({required this.messages});
//
//
//   @override
//   State<GroupChatScreen> createState() => _GroupChatScreenState();
// }
//
// class _GroupChatScreenState extends State<GroupChatScreen> {
//   TextEditingController _controller = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//       children: [
//
//             Expanded(
//               child: ListView(
//                    children:
//                    widget.messages.map((message) => MessageBubble(message: message, senderName: '', isMe: true,)).toList(),
//               ),
//             ),
//
//             Container(
//               height: 100,
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               color: Colors.pink,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                    Expanded(
//                     child: TextInputField(hintText: 'Type a message', controller: _controller,),
//                   ),
//                   IconButton(
//                     icon:  Icon(Icons.send, color: Colors.grey[350],),
//                     onPressed: () {
//                       setState(() {
//                       widget.messages.add(Message(text: _controller.text, senderID: '', timeStamp: ''));
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             ],
//           );
//   }
// }
//
//
