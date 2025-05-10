import 'package:ai_chatbot/pages/chat_screen.dart';
import 'package:ai_chatbot/pages/register_screen.dart';
import 'package:flutter/material.dart';
import '../components/form_widget.dart';
import '../components/button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NormalForm(
                  label: "Email",
                  suffixIcon: Icons.email_outlined,
                  controller: _emailController,
                  obsecureText: false,
                ),
                SizedBox(height: 10),
                NormalForm(
                  label: "Password",
                  suffixIcon: Icons.password,
                  controller: _passwordController,
                  obsecureText: true,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: NormalButton(
                    onPressed: _handleButton,
                    color: Colors.blue,
                    textColor: Colors.white,
                    text: 'Login',
                  ),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    "Belum punya akun?, Daftar disini!",
                    style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
