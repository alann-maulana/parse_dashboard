import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:parse_dashboard/core/db/local_storage.dart';
import 'package:parse_dashboard/core/models/parse_credential.dart';

final ParseCredentialApi parseCredentialApi = ParseCredentialApi._();

class ParseCredentialApi {
  ParseCredentialApi._();

  List<ParseCredential> _assetCredentials;
  List<ParseCredential> _localStorageCredentials;

  bool _parseString(String source) {
    final list = json.decode(source);

    if (list is List) {
      _assetCredentials = list.map((c) => ParseCredential.fromMap(c)).toList();
      return true;
    }

    return false;
  }

  Future<void> initializeAssetJSON(String path) async {
    if (_assetCredentials != null) {
      return;
    }

    final source = await rootBundle.loadString(path);
    if (_parseString(source)) {
      return;
    }

    throw FormatException('invalid json credentials');
  }

  Future<void> initializeURLJSON(String path,
      {Map<String, String> headers}) async {
    if (_assetCredentials != null) {
      return;
    }

    final result = await http.get(path, headers: headers);
    final source = result.body;
    if (_parseString(source)) {
      return;
    }

    throw FormatException('invalid json credentials');
  }

  Future<List<ParseCredential>> getFromLocalStorage() async {
    final credentials = await localStorage.read('credentials') as List;
    if (credentials is List) {
      _localStorageCredentials =
          credentials.map((c) => ParseCredential.fromMap(c)).toList();
      return _localStorageCredentials;
    }

    final importFromAssets = await localStorage.read('importFromAssets');
    if (importFromAssets == true) {
      return credentials;
    }

    await localStorage.write('importFromAssets', true);
    await localStorage.write(
        'credentials', _assetCredentials.map((c) => c.asMap).toList());
    _localStorageCredentials = _assetCredentials;
    return _assetCredentials;
  }

  Future<void> setLocalStorage(List<ParseCredential> credentials) async {
    await localStorage.write(
        'credentials', credentials.map((c) => c.asMap).toList());
    _localStorageCredentials = credentials;
  }
}
