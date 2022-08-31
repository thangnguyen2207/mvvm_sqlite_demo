import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mvvm_sqlite_demo/ui/drawer/drawer.dart';
import 'package:mvvm_sqlite_demo/ui/major/major_item.dart';
import 'package:mvvm_sqlite_demo/ui/major/major_view.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../model/major.dart';

class MajorScreen extends StatelessWidget {
  MajorScreen({Key? key}) : super(key: key);
  final _majorVM = MajorViewModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _majorVM,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Major'),
          actions: [
            IconButton(
              onPressed: () => _showEditDialog(context, _majorVM), 
              icon: const Icon(Icons.add)
            )
          ],
        ),
        drawer: const DrawerMenu(),
        body: _listMajor(),
      )
    );
  }

  Widget _listMajor() => ScopedModelDescendant<MajorViewModel>(
    builder: (context, child, model) {
      return ListView.builder(
        itemCount: model.majors.length,
        itemBuilder: (context, index) {
          return MajorItem(
            major: model.majors[index], 
            onClick: (major) => _showEditDialog(context, model, major: major), 
            onDelete: (major) => model.delete(major),
          );
        }
      );
    },
  );

  final _formKey = GlobalKey<FormBuilderState>();
  Future<void> _showEditDialog(var context, MajorViewModel model, {Major? major}) async {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter major name'),
          content: FormBuilder(
            key: _formKey,
            child: FormBuilderTextField(
              name: 'name',
              initialValue: major?.name,
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10)
              ),
              validator: FormBuilderValidators.required(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final curState = _formKey.currentState!;
                curState.save();

                if (curState.validate()) {
                  final formValue = curState.value;
                  final data = Major(name: formValue['name']);
                  if (major != null) {
                    data.id = major.id;
                  }
                  model.save(data);
                  Navigator.of(context).pop();
                }
              }, 
              child: const Text('Save')
            )
          ],
        );
      } 
    );
  }
}