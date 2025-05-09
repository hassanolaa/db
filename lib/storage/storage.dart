import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';


void saveSchemas(Map<String, List<Map<String, dynamic>>> schema) {
  File("schemas").writeAsString(jsonEncode(schema));
}

Map<String, List<Map<String, dynamic>>> loadSchemas() {
   return
      (jsonDecode(File("schemas").readAsStringSync()) as Map<String, dynamic>)
          .map((key, value) => MapEntry(
              key,
              (value as List).map((e) => e as Map<String, dynamic>).toList()));
}

Map<String, List<Map<String, dynamic>>> loadData() {
  return (jsonDecode(File("data").readAsStringSync()) as Map<String, dynamic>)
    .map((key, value) => MapEntry(
        key,
        (value as List).map((e) => e as Map<String, dynamic>).toList()));
}

void saveData(Map<String, List<Map<String, dynamic>>> data) {
    File("data").writeAsString(jsonEncode(data));
}

enum Type {
  string,
  number,
  boolean,
  map,
  array,
  date,
}

class Storage {
  Storage(this.workingDirectory);
  String workingDirectory = "";
  String get collectionsStore => workingDirectory + "/" + "collections";
  String get stringsStore => workingDirectory + "/" + "strings";
  String get jsonStore => workingDirectory + "/" + "jsons";
  // String get mapsStore => workingDirectory + "/" + "maps";
  
  int storeString(String str) {
    sha1.convert(utf8.encode(str)).toString();
    int hash = _hashString(str) ;
    // _stringStore.putIfAbsent(hash , () => str );
    File(stringsStore + "/" + hash.toString()).writeAsString(str);
    return hash;
  }
  
  String getString(int hash) {
    return File(stringsStore + "/" + hash.toString()).readAsStringSync(); 
  }
  
  int _hashString(String str) {
    int sum = 0;
    for (int i in str.codeUnits) {
      sum += i;
    }
    return sum;
  }
}

Future<String> readOrCreateDefault(String filePath, String defaultValue) async {
  final file = File(filePath);

  if (await file.exists()) {
    return await file.readAsString();
  } else {
    await file.create(recursive: true);
    await file.writeAsString(defaultValue);
    return defaultValue;
  }
}

// String
// Number
// Boolean
// Map
// Array
// Date