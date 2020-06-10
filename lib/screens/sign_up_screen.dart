import 'dart:io';

import 'package:chat_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helpers/field_validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  Future<void> _handleSubmit(
    Map<String, String> state,
    BuildContext context,
  ) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: state['email'].trim(),
        password: state['password'].trim(),
      );
      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({'username': state['username'], 'email': state['email']});
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
  final _picker = ImagePicker();
  File _image;

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

  Future<void> _pickImage() async {
    final pickedImage = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundImage: _image == null ? null : FileImage(_image),
          ),
          FlatButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Add Image'),
            textColor: Theme.of(context).primaryColor,
          ),
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
            key: const Key('username'),
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
          SizedBox(
            height: 10,
          ),
          isLoading
              ? CircularProgressIndicator()
              : RaisedButton(
                  child: const Text('Create'),
                  onPressed: _submit,
                ),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: const Text('I already have account'),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) {
                  return AuthScreen();
                },
              ));
            },
          )
        ],
      ),
    );
  }
}
