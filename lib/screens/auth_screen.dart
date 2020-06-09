import 'package:flutter/material.dart';
import 'package:chat_app/helpers/field_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  Future<void> _handleSubmit(
    Map<String, String> state,
    bool isLogin,
    BuildContext context,
  ) async {
    AuthResult authResult;
    final authFunc = isLogin
        ? _auth.signInWithEmailAndPassword
        : _auth.createUserWithEmailAndPassword;
    try {
      authResult = await authFunc(
        email: state['email'].trim(),
        password: state['password'].trim(),
      );
      if (!isLogin) {
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({'username': state['username'], 'email': state['email']});
      }
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
    bool isLogin,
    BuildContext context,
  ) handleSubmit;

  AuthForm({@required this.handleSubmit});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var isLogin = true;
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
      await widget.handleSubmit(_formState, isLogin, context);
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
            key: Key('email'),
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
          if (!isLogin)
            TextFormField(
              key: Key('username'),
              validator: FieldValidators.username,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              onSaved: (value) {
                _formState['username'] = value;
              },
              onFieldSubmitted: (value) {
                FocusScope.of(context).nextFocus();
              },
              textInputAction: TextInputAction.next,
            ),
          TextFormField(
            key: Key('password'),
            validator: FieldValidators.password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            onSaved: (value) {
              _formState['password'] = value;
            },
          ),
          SizedBox(
            height: 10,
          ),
          isLoading
              ? CircularProgressIndicator()
              : RaisedButton(
                  child: Text(isLogin ? 'Login' : 'Create'),
                  onPressed: _submit,
                ),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            child:
                Text(isLogin ? 'Create new account' : 'I already have account'),
            onPressed: () {
              setState(() {
                isLogin = !isLogin;
              });
            },
          )
        ],
      ),
    );
  }
}
