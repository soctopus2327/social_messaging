import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/components/my_textfield.dart';
import 'package:social_media/components/my_button.dart';
import 'package:social_media/helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controller
  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  TextEditingController confPassController = TextEditingController();

  TextEditingController userController = TextEditingController();

  void register() async{
    showDialog(
      context: context, 
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      )
    );

    if (passController.text != confPassController.text){
      Navigator.pop(context);
    }
    displayMessageToUser("Passwords don't match!", context);

    try{
      UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e){
      Navigator.pop(context);
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
              //username
              MyTextField(
                hintText: "Username", 
                obscureText: false, 
                controller: userController,
              ),
              //email
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Email", 
                obscureText: false, 
                controller: emailController,
              ),
              //password
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Password", 
                obscureText: true, 
                controller: passController,
              ),
              //confirm password
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Confirm Password", 
                obscureText: true, 
                controller: confPassController,
              ),
              //sign in
              const SizedBox(height: 10),
              MyButton(
                text: "Register", 
                onTap: register,
              ),
              //login
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                      style:TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(" Login Here",
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