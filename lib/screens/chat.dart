import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.childEmail, required this.teacherEmail}) : super(key: key);
  final String childEmail;
  final String teacherEmail;


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _messageController = TextEditingController();
  List chats =[];
  late String roomId;
  bool loading = true;
  String teacherEmail = '';

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String parentEmail = prefs.getString('email') ?? ''; // Retrieve parent's email

    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('students').where('email', isEqualTo: widget.childEmail).get().then((value) => {
      // print(value.docs.length),
      teacherEmail = value.docs.first.get('teacher_email'),
      setState(() {}),
    });

    await _firestore.collection('rooms').where('teacher', isEqualTo: teacherEmail.replaceAll(' ', '')).where('parent',isEqualTo:parentEmail.replaceAll(' ', '') ).where('child',isEqualTo:widget.childEmail.replaceAll(' ', '') ).get().then((value) => {
      value.docs.forEach((element) async {
        roomId=element.get('id');
    _firestore.collection("chat").where('room_id',isEqualTo:element.get('id') ).orderBy('time',descending: true).snapshots().listen((event) {

      chats.clear();
      event.docs.forEach((cValue) {


      chats.add(cValue.data());
      setState(() {

      });

      });


  });
        // chats.addAll();
      }),
    });
    setState(() {
      print(chats);
      loading = false;
    });
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String parentEmail = prefs.getString('email') ?? ''; // Retrieve parent's email

      // Get the current timestamp
      FieldValue timestamp = FieldValue.serverTimestamp();

      // Create a new message map
      Map<String, dynamic> newMessage = {
        'msg': message,
        'from': parentEmail, // Use the parent's email as the sender
        'to': teacherEmail,
        'timestamp': timestamp,
      };

      // Add the message to the Firestore collection
      await _firestore.collection('chat').add({
        'msg': message,
        'room_id':roomId,
        'from': parentEmail, // Use the parent's email as the sender
        'to': teacherEmail,
        'time': timestamp,
      });

      // Clear the message input field
      _messageController.clear();

    }
  }










  // getData() async {
  //   SharedPreferences get= await SharedPreferences.getInstance();
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   await _firestore.collection('students').where('email', isEqualTo: widget.childEmail).get().then((value) => {
  //     print(value.docs.length),
  //
  //     teacherEmail = value.docs.first.get('teacher_email'),
  //     setState(() {
  //
  //     })
  //   });
  //
  //
  //   await _firestore.collection('chat').where('users',arrayContains: teacherEmail.replaceAll(' ', '')).get().then((value) => {
  //
  //     value.docs.forEach((element) {
  //       chats.addAll(element.get('chat'));
  //     })
  //   });
  //   setState(() {
  //     loading = false;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat App')),
      body: Column(
        children: [
          Expanded(
            child:
            ListView.builder (
              reverse: true,
              itemCount: chats.length,
              itemBuilder: (context, i) {
                bool isTeacherMessage = chats[i]['to'] == teacherEmail;
                // print('i am here');
                // print(chats[i]);
                //print(teacherEmail);
                //print(chats[i]['to']);
                return loading==true? Center(
                  child: CircularProgressIndicator(),


                ):

                    Container(

                      alignment: isTeacherMessage ? Alignment.centerLeft : Alignment.centerRight,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isTeacherMessage ? Colors.grey : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(chats[i]['msg']??'',style: TextStyle(color: Colors.white),)
                      //,Text(chats[i]['msg']??''),
                    );


    })
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = _messageController.text.trim(); // Get the message text
                    if (_messageController.text.isNotEmpty) {

                      _sendMessage(message); // Call the _sendMessage function
                      //_sendMessage(_messageController.text);
                    }
                  },
                ),
                Expanded(

                  child: TextField(
                    controller: _messageController,
                    onChanged: (message) {
                      // Handle text input change
                    },
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}


