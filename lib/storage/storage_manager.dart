import 'package:get_storage/get_storage.dart';

class StorageManager {
  StorageManager._();

  static final GetStorage box = GetStorage();

  static void saveData(String key, dynamic value) {
    box.write(key, value);
  }

  static readData(String key) {
    return box.read(key);
  }

  static void remoData(String key) {
    box.remove(key);
  }
}
