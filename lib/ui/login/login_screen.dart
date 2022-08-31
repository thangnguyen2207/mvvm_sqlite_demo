import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mvvm_sqlite_demo/utils/prefs.dart';

import '../student/student_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _hidePassword = true;
  var _icon = Icons.visibility;

  void _doLogin() {
    final curState = _formKey.currentState!;
    curState.save();

    if (curState.validate()) {
      final formValue = curState.value;
      if (Prefs.username.isNotEmpty || Prefs.password.isNotEmpty) {
        if (formValue["username"] == Prefs.username && formValue["password"] == Prefs.password) {
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: ((context) => StudentScreen())), 
            (route) => false
          );
        } else {
          const snackBar =  SnackBar(
            content: Text(
              "Wrong username or password", 
              style: TextStyle(color: Colors.red),
            )
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        Prefs.setUserName(formValue["username"]);
        Prefs.setPassword(formValue["password"]);
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => StudentScreen()), 
          (route) => false,
        );
      }
    } else {
      const snackBar =  SnackBar(
        content: Text("Validation failed")
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: "username",
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context, errorText: "Không được bỏ trống"),
                      FormBuilderValidators.maxLength(context, 70, errorText: "Tối đa 70 kí tự")
                    ]),
                  ),
                  const SizedBox(height: 16,),
                  FormBuilderTextField(
                    name: "password",
                    keyboardType: TextInputType.text,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _hidePassword = !_hidePassword;
                          _icon = _hidePassword ? Icons.visibility : Icons.visibility_off;
                        }),
                        icon: Icon(_icon),
                      )
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context, errorText: "Không được bỏ trống"),
                      FormBuilderValidators.minLength(context, 5, errorText: "Tối thiểu 5 kí tự")
                    ]),
                  ),
                  const SizedBox(height: 16,),
                  ElevatedButton(
                    onPressed: () => _doLogin(),
                    child: const Text("Login")
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}