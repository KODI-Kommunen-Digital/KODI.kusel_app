import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveBoxFunctionProvider = Provider((ref) => HiveBoxFunction());

class HiveBoxFunction {
  Future<void> openBox(String name) async {
    await Hive.openBox(name);
  }

  bool isBoxOpen(String name) {
    return Hive.isBoxOpen(name);
  }

  Future<Box<T>?> getBoxReference<T>(String name) async {
    if (isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return null;
  }

  Future<void> closeBox(Box box) async {
    await box.close();
  }

  Future<void> clearBox(Box box) async {
    await box.clear();
  }

  Future<T?> getValue<T>(Box box, dynamic key) async {
    return await box.get(key);
  }

  Future<void> putValue<T>(Box box, dynamic key, T value) async {

    await box.put(key, value);
  }

  Future<void> deleteValue<T>(Box box, dynamic key) async {
    if(await containsKey(box, key)) {
      await box.delete(key);
    }
  }

  Future<bool> containsKey<T>(Box box, dynamic key) async {
    return box.containsKey(key) ;
  }

  Future<List<dynamic>> getAllKeys<T>(Box box) async {
    return box.keys.toList();
  }

  Future<List<T>> getAllValues<T>(Box box) async {
    return box.values.cast<T>().toList() ;
  }

  Future<Map<dynamic,dynamic>> getAllBoxData(Box box)
  async{
    return  box.toMap();
  }

}
