
import 'package:flutter/material.dart';

import '../../../../models/message.dart';

const Color messagewGrey = Color.fromARGB(255 , 230,229,235);

class MessageBubble extends StatelessWidget {
  final Message message;
  final String senderName;
  final bool isMe;

  const MessageBubble({required this.message, required this.senderName, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          isMe?


          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Expanded(
                flex: 1,
               child: SizedBox(width: MediaQuery.of(context).size.width/2,),),
          Expanded(
            flex: 1,
            child: Material(

              borderRadius: BorderRadius.circular(12.0),
              elevation: 4.0,
              color: isMe ? Colors.blue.shade900 : messagewGrey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                child: Text(
                  message.message,
                  maxLines: 20,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
              const SizedBox(width: 10,),

          CircleAvatar(
            backgroundColor: Colors.blue.shade900,
            child:  Text(
              senderName,
              style:  TextStyle(
                fontWeight: FontWeight.normal,
                color: isMe ? Colors.white : Colors.black,
                fontSize: 10.0,
              ),
            ),
          ),
          ],
      )





              :


          Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children:[
                CircleAvatar(
                  radius: 25,
                  backgroundColor: messagewGrey,
                  child: Text(
                    senderName,
                    style:  TextStyle(
                      fontWeight: FontWeight.normal,
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 10.0,
                    ),
                  ),
                ),

                const SizedBox(width: 10,),
                Material(
                  borderRadius: BorderRadius.circular(12.0),
                  elevation: 4.0,
                  color: isMe ? Colors.blue : messagewGrey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    child: Text(
                      message.message,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ]
          )
        ]
      )
    );
  }
}
