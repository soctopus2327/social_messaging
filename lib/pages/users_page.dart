import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/components/my_back_button.dart';
import 'package:social_media/helper/helper_functions.dart';
import 'package:flutter/src/widgets/scroll_view.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("User"),
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   elevation: 0,
      // ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            displayMessageToUser("Something wnet wrong", context);
          }

          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null){
            return const Text("No Data");
          }

          final users = snapshot.data!.docs;

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50, left: 25),
                child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index){
                    final user = users[index];
                
                    return ListTile(
                      title: Text(user['username']),
                      subtitle: Text(user['email']),
                    );
                  }
                ),
              )
            ],
          );

        }
      )
    );
  }
}