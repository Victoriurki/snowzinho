import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String? _email;
  late String? _password;
  late String? _confirmPassword;

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: _email!, password: _password!);
        User user = result.user!;
        print(user.email);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> recoverPassword() async {
    await _auth.sendPasswordResetEmail(email: _email!);
    print('Password reset email sent to $_email');
  }

  String? validatePassword(String? value) {
    String pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (!regExp.hasMatch(value)) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (_password != _confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input) =>
                    !input!.contains('@') ? 'Not a valid email' : null,
                onSaved: (input) => _email = input!,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                validator: validatePassword,
                onSaved: (input) => _password = input,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                validator: validateConfirmPassword,
                onSaved: (input) => _confirmPassword = input,
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: signIn,
                  child: Text('Sign Up'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: recoverPassword,
                  child: Text('Forgot password?'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
