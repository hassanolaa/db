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

class Storage {
  Storage(this.workingDirectory);
  String workingDirectory = "";
  String get collectionsStore => workingDirectory + "/" + "collections";
  String get stringsStore => workingDirectory + "/" + "strings";
  String get jsonStore => workingDirectory + "/" + "jsons";
  // String get mapsStore => workingDirectory + "/" + "maps";

  final Map<int,String> _stringStore = {};
  
  int storeString(String str) {
    sha1.convert(utf8.encode(str)).toString();
    int hash = hashString(str) ;
    _stringStore.putIfAbsent(hash , () => str );
    return hash;
  }
  
  String getString(int hash) {
    var str = _stringStore[hash];
    if (str == null) {
      return "";
    }
    return str;
  }
  
  int hashString(String str) {
    int sum = 0;
    for (int i in str.codeUnits) {
      sum += i;
    }
    return sum;
  }
}

// String
// Number
// Boolean
// Map
// Array
// Date