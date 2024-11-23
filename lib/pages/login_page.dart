import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/components/my_textfield.dart';
import 'package:social_media/components/my_button.dart';
import 'package:social_media/helper/helper_functions.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void login() async{
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passController.text);

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch(e) {
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              //logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),
              const Text(  
                'S O C I A L',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),
              //email
              MyTextField(
                hintText: "Email", 
                obscureText: false, 
                controller: emailController,
              ),
              const SizedBox(height: 10),
              //password
              MyTextField(
                hintText: "Password", 
                obscureText: true, 
                controller: passController,
              ),
              //forgot
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style:TextStyle(
                      color: Theme.of(context).colorScheme.secondary)
                  )
                ],
              ),
              //sign in
              const SizedBox(height: 10),
              MyButton(
                text: "Login", 
                onTap: login,
              ),

              //register
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                      style:TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(" Register Here",
                        style:TextStyle(
                          fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}