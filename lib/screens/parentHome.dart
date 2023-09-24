import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import '../settings/color.dart';
import '../settings/keys.dart';
import 'chat.dart';
class ParentHome extends StatefulWidget {
  const ParentHome({Key? key}) : super(key: key);

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class ChildEmail {
  final String email;

  ChildEmail(this.email);
}

class _ParentHomeState extends State<ParentHome> {
  final TextEditingController _childEmailController = TextEditingController();
  String _parentEmail = "";
  List<ChildEmail> children = [];

  Future<void> _saveChildEmailToSharedPreferences(String childEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('child_email', childEmail);
  }

  void _removeChildEmailFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('child_email');
  }

  @override
  void initState() {
    super.initState();
    _getParentEmailFromPreferences();
  }

  void _getParentEmailFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _parentEmail = prefs.getString('email') ?? "";
    });
  }

  //
  void _updateChildEmail(String childEmail) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Check if the student email exists in the "students" collection
    await firestore
        .collection('students')
        .where('email', isEqualTo: childEmail)
        .get()
        .then((studentQuerySnapshot) {
      if (studentQuerySnapshot.docs.isNotEmpty) {
        // Student email exists, proceed to update parent
        firestore
            .collection('parents')
            .where('email', isEqualTo: _parentEmail)
            .get()
            .then((parentQuerySnapshot) {
          if (parentQuerySnapshot.docs.isNotEmpty) {
            String parentDocId = parentQuerySnapshot.docs[0].id;

            firestore.collection('parents').doc(parentDocId).update({
              'child_email': FieldValue.arrayUnion([childEmail]),
            }).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تمت اضافة الابن بنجاح')),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('الرجاء كتابة الإيميل الصحيح للابن')),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('الرجاء كتابة الإيميل الصحيح للابن')),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الرجاء كتابة الإيميل الصحيح للابن')),
        );
      }
    });
  }


  Future<void> _signOut(BuildContext context) async {
    try {
      SharedPreferences save = await SharedPreferences.getInstance();
      save.clear();
      // Clear any locally stored authentication tokens or credentials here.
      // For example, you can use shared preferences or secure storage to store user tokens.

      // Remove any references to the current user.
      // For example, if you are using Provider, you can do something like:
      // Provider.of<UserData>(context, listen: false).clearUserData();

      // Navigate to the login page.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (route) => false, // Remove all previous routes from the stack.
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // void addChild(String email) {
  //   setState(() {
  //     children.add(ChildEmail(email));
  //     _childEmailController.clear();
  //   });
  // }
  void addChild(String email) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Check if the student email exists in the "students" collection
    firestore
        .collection('students')
        .where('email', isEqualTo: email)
        .get()
        .then((studentQuerySnapshot) {
      if (studentQuerySnapshot.docs.isNotEmpty) {
        setState(() {
          children.add(ChildEmail(email));
          _childEmailController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('الرجاء كتابة الإيميل الصحيح للابن')),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_childEmailController.text.isNotEmpty) {
                      String childEmail = _childEmailController.text;
                      addChild(childEmail);
                      _updateChildEmail(childEmail);
                    }
                  },
                  icon: const Icon(Icons.add_circle),
                ),
                SizedBox(width: 16),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: _childEmailController,
                    decoration: InputDecoration(
                      labelText: 'Child Email',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: children.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(children[index].email),
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('parents')
                  .where('email', isEqualTo: _parentEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return const Text('No child emails available.');
                }

                QueryDocumentSnapshot parentDocument = snapshot.data!.docs.first;
                print(parentDocument.data());
                List<dynamic> childEmails = parentDocument['child_email'];

                List<ChildEmail> childrenFromFirestore = childEmails.map((email) => ChildEmail(email)).toList();

                return ListView.builder(
                  itemCount: childrenFromFirestore.length,
                  itemBuilder: (context, index) {
                    return Row(

                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(childrenFromFirestore[index].email),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await _saveChildEmailToSharedPreferences(childrenFromFirestore[index].email);

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatScreen(childEmail: childrenFromFirestore[index].email, teacherEmail: childrenFromFirestore[index].email,),)
                            );
                            // Perform an action when the icon button is clicked
                            // For example, you can delete the child email here
                            // or perform any other desired action.
                          },
                          icon: Icon(Icons.chat_bubble_outline),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          IconButton(
            onPressed: () => _signOut(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}