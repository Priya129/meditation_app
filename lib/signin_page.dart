import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation/glassmorphism_container.dart';
import 'package:meditation/signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();

}

class SignInPageState extends State<SignInPage> {
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

  Future<void> _signIn() async {
    if(!_formKey.currentState!.validate()) return;

    try{
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed in successfully!'))
      );

      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PlanScreen())
      );*/

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;

        case 'invalid-password':
          errorMessage = 'Incorrect password.';
          break;

        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;

        default:
          errorMessage = 'Sign in failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
      );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in failed: ${e.toString()}'))
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
                          "Sign In",
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
                            onPressed: _signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                            ),
                            child: const Text('Sign In', style: TextStyle(color: Colors.white),)
                        ),
                        TextButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage())
                          );
                        }, child: const Text(
                          "Don't have an account? Sign Up",
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