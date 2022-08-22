import 'package:flutter/material.dart';
import 'package:qrgen/widgets/page_title.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key, required this.logInCallback}) : super(key: key);

  final Function logInCallback;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    String loginUser = '';
    String loginPassword = '';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PageTitle(
            text: 'Log In',
          ),
          Container(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) {
                loginUser = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 32.0, right: 32.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              onChanged: (value) {
                loginPassword = value;
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    widget.logInCallback(loginUser, loginPassword);
                  },
                  child: Text('LOG IN', style: Theme.of(context).textTheme.button)),
            ],
          ),
        ],
      ),
    );
  }
}
