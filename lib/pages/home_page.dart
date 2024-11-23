import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/components/my_drawer.dart';
import 'package:social_media/components/my_list_tile.dart';
import 'package:social_media/components/my_post_button.dart';
import 'package:social_media/components/my_textfield.dart';
import 'package:social_media/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController postController = TextEditingController();

  void postMessage(){
    if(postController.text.isNotEmpty){
      String message = postController.text;
      database.addPost(message);
    }
    postController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wall"),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,  
      ),
      drawer: const MyDrawer(),
      body: Column(  
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: 'Say something . . .', 
                    obscureText: false, 
                    controller: postController,
                  ),
                ),
                MyPostButton(
                  onTap: postMessage,
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: database.getPostsStream(), 
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              final posts = snapshot.data!.docs;

              if (snapshot.data == null || posts.isEmpty){
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No posts yet'),
                  )
                );
              }
              
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index){
                    final post = posts[index];
                    String message = post['Message'];
                    String email = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];

                    return MyListTile(title: message, subtitle: email);
                  },
                ),
              );
            }
          ),
        ],
      )
    );
  }
}