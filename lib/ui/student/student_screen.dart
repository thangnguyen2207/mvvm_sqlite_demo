import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mvvm_sqlite_demo/ui/drawer/drawer.dart';
import 'package:mvvm_sqlite_demo/ui/student/student_item.dart';
import 'package:mvvm_sqlite_demo/ui/student/student_view.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../model/student.dart';
import '../major/major_view.dart';

class StudentScreen extends StatelessWidget {
  StudentScreen({Key? key}) : super(key: key);
  final _studentVM = StudentViewModel();
  final _majorVM = MajorViewModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _studentVM,
      child: ScopedModel(
        model: _majorVM,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Student'),
            actions: [
              IconButton(
                onPressed: () => _showEditDialog(context, _studentVM), 
                icon: const Icon(Icons.add)
              )
            ],
          ),
          drawer: const DrawerMenu(),
          body: _listStudent(),
        ),
      )
    );
  }

  Widget _listStudent() => ScopedModelDescendant<StudentViewModel>(
    builder: (context, child, model) {
      return ListView.builder(
        itemCount: model.students.length,
        itemBuilder: (context, index) {
          return StudentItem(
            student: model.students[index], 
            onClick: (student) => _showEditDialog(context, model, student: student), 
            onDelete: (student) => model.delete(student)
          );
        }
      );
    }
  );

  final _formKey = GlobalKey<FormBuilderState>();
  Future<void> _showEditDialog(var context, StudentViewModel model, {Student? student}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FormBuilderDropdown(
                      name: 'majorId',
                      decoration: const InputDecoration(
                        labelText: 'Major',
                        contentPadding: EdgeInsets.symmetric(horizontal: 5)
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context)
                      ]),
                      initialValue: student?.major_id,
                      items: _majorVM.majors.map((major) => DropdownMenuItem(
                          value: major.id,
                          child: Text(major.name)
                        )
                      ).toList(),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'lastName',
                      keyboardType: TextInputType.name,
                      initialValue: student?.lastName,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 5)
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                    ),
                    const SizedBox(height: 16,),
                    FormBuilderTextField(
                      name: 'firstName',
                      keyboardType: TextInputType.name,
                      initialValue: student?.firstName,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 5)
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                      ]),
                    ),
                    const SizedBox(height: 16,),
                    FormBuilderRadioGroup(
                      name: 'gender',
                      initialValue: student?.gender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        labelStyle: TextStyle(fontSize: 21),
                        border: InputBorder.none,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context)
                      ]),
                      options: [0, 1].map((gender) => FormBuilderFieldOption(
                        value: gender,
                        child: Text(gender == 0 ? 'Male' : 'Female'),
                      )).toList(),
                    ),
                    FormBuilderTextField(
                      name: 'phone',
                      keyboardType: TextInputType.phone,
                      initialValue: student?.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        contentPadding: EdgeInsets.symmetric(horizontal: 5)
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(context, 9),
                        FormBuilderValidators.maxLength(context, 13)
                      ]),
                    ),
                    const SizedBox(height: 16,),
                    FormBuilderTextField(
                      name: 'email',
                      keyboardType: TextInputType.emailAddress,
                      initialValue: student?.email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        contentPadding: EdgeInsets.symmetric(horizontal: 5)
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.email(context)
                      ]),
                    ),
                    const SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onPressed: () {
                            final curState = _formKey.currentState!;
                            curState.save();

                            if (curState.validate()) {
                              final formValue = curState.value;
                              final data = Student(major_id: formValue['majorId'], lastName: formValue['lastName'], firstName: formValue['firstName'], 
                                gender: formValue['gender'], phone: formValue['phone'], email: formValue['email']);
                              if (student != null) {
                                data.id = student.id;
                              }
                              model.save(data);
                              Navigator.of(context).pop();
                            }
                          }, 
                          child: const Text('ADD', style: TextStyle(color: Colors.black),)
                        ),
                        const SizedBox(width: 8,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }, 
                          child: const Text('CLOSE', style: TextStyle(color: Colors.black),)
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        );
      }
    );
  }
}