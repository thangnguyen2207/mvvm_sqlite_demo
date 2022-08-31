import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mvvm_sqlite_demo/ui/drawer/drawer.dart';
import 'package:mvvm_sqlite_demo/ui/login/login_screen.dart';
import 'package:mvvm_sqlite_demo/utils/prefs.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _hidePassword = true;
  var _icon = Icons.visibility;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {

    void _doChangePassword() {
      final curState = _formKey.currentState!;
      curState.save();

      if (curState.validate()) {
        final formValue = curState.value;
        if (formValue['currentPassword'] == Prefs.password && formValue['newPassword'] == formValue['confirmPassword']) {
          Prefs.setPassword(formValue['newPassword']);
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            ((route) => false)
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      drawer: const DrawerMenu(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'currentPassword',
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Current Password",
                          suffixIcon: IconButton(
                            onPressed: () => setState(() {
                              _hidePassword = !_hidePassword;
                              _icon = _hidePassword ? Icons.visibility : Icons.visibility_off;
                            }),
                            icon: Icon(_icon),
                          )
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          ((value) {
                            if (value != Prefs.password) {
                              return 'Wrong current password';
                            }
                            return null;
                          })
                        ]),
                      ),
                      const SizedBox(height: 16,),
                      FormBuilderTextField(
                        name: 'newPassword',
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "New Password",
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.minLength(context, 5),
                        ]),
                      ),
                      const SizedBox(height: 16,),
                      FormBuilderTextField(
                        name: 'confirmPassword',
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirm New Password",
                        ),
                        validator: FormBuilderValidators.compose([
                          ((value) {
                            var state = _formKey.currentState!;
                            state.save();
                            if (value != state.value['newPassword']) {
                              return 'Must be the same with new password';
                            }
                            return null;
                          })
                        ]),
                      ),
                      const SizedBox(height: 16,),
                      ElevatedButton(
                        onPressed: () => _doChangePassword(), 
                        child: const Text('Change Password')
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}