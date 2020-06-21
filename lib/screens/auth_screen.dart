import 'package:chat_app/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helpers/field_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatelessWidget {
  Future<void> _handleSubmit(
    Map<String, String> state,
    BuildContext context,
  ) async {
    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state['email'].trim(),
        password: state['password'].trim(),
      );
      authResult.user.reload();
    } on PlatformException catch (err) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(30),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: AuthForm(
                handleSubmit: _handleSubmit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  final Future<void> Function(
    Map<String, String> data,
    BuildContext context,
  ) handleSubmit;

  AuthForm({@required this.handleSubmit});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formState = {};

  Future<void> _submit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      await widget.handleSubmit(_formState, context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            key: const Key('email'),
            validator: FieldValidators.email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            onSaved: (value) {
              _formState['email'] = value;
            },
            onFieldSubmitted: (value) {
              FocusScope.of(context).nextFocus();
            },
            textInputAction: TextInputAction.next,
          ),
          TextFormField(
            key: const Key('password'),
            validator: FieldValidators.password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            onSaved: (value) {
              _formState['password'] = value;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : RaisedButton(
                  child: const Text('Login'),
                  onPressed: _submit,
                ),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: const Text('Create new account'),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) {
                  return SignUpScreen();
                },
              ));
            },
          )
        ],
      ),
    );
  }
}
