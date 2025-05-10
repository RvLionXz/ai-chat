import 'package:flutter/material.dart';
import '../components/button_widget.dart';
import '../components/form_widget.dart';
import '../pages/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
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
                  label: "Username",
                  suffixIcon: Icons.person,
                  controller: _usernameController,
                  obsecureText: false,
                ),
                SizedBox(height: 10,),
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
                    text: 'Register',
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    "Sudah punya akun?, login disini!",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
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
