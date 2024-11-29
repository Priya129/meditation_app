import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/glassmorphism_container.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();

}

class SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if(!_formKey.currentState!.validate()) return;

    try{
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Created successfully!'))
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email is already in use.';
          break;

        case 'invalid-email':
          errorMessage = 'The email is not valid';
          break;

        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;

        default:
          errorMessage = 'Sign Up failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign Up failed: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/Images/logo.png',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20,),

              GlassmorphismContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none
                            ),
                            hintStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value){
                            if(value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;

                          },
                        ),
                        const SizedBox(height: 10 ,),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none
                            ),
                            hintStyle: const TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value){
                            if(value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;

                          },
                        ),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            child: const Text('Sign In', style: TextStyle(color: Colors.white),)
                        ),
                        TextButton(onPressed: (){
                         Navigator.pop(context);
                        }, child: const Text(
                          "Already have an account? Sign In",
                          style: TextStyle(color: Colors.white70),
                        ))

                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}