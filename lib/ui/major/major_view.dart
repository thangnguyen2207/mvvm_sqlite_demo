import 'package:mvvm_sqlite_demo/dao/major_dao.dart';
import 'package:mvvm_sqlite_demo/model/major.dart';
import 'package:scoped_model/scoped_model.dart';

class MajorViewModel extends Model {
  static final MajorViewModel _instance = MajorViewModel._internal();
  factory MajorViewModel() => _instance;
  final MajorDao _repo = MajorDao();
  List<Major> majors = [];

  MajorViewModel._internal() {updateList();}

  void updateList() async {
    majors = await _repo.getMajors();
    notifyListeners(); 
  }

  void save(Major major) async {
    major.id == 0 ? await _repo.insert(major) : await _repo.update(major);
    updateList();
  }

  void delete(Major major) async {
    await _repo.delete(major.id);
    updateList();
  }
}