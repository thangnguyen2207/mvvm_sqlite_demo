import 'package:mvvm_sqlite_demo/dao/student_dao.dart';
import 'package:mvvm_sqlite_demo/model/student.dart';
import 'package:scoped_model/scoped_model.dart';

class StudentViewModel extends Model {
  static final StudentViewModel _instance = StudentViewModel._internal();
  factory StudentViewModel() => _instance;
  final StudentDao _repo = StudentDao();
  List<Student> students = [];

  StudentViewModel._internal() {updateList();}

  void updateList() async {
    students = await _repo.getStudents();
    notifyListeners();
  }

  void save(Student student) async {
    student.id == 0 ? await _repo.insert(student) : await _repo.update(student);
    updateList();
  }

  void delete(Student student) async {
    await _repo.delete(student.id);
    updateList();
  }
}