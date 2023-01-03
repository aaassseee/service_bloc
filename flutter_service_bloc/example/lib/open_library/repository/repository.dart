import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:example/open_library/constant/constant.dart';
import 'package:example/open_library/modal/modal.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class OpenLibraryRepository {
  Future<BuiltList<OpenLibraryAuthorSearchResult>> searchAuthor({
    required String keyword,
    int rowPerPage = 20,
    required int pageNo,
  }) async {
    try {
      final response = await get(Uri.https(apiDomain, searchAuthorPath, {
        'q': keyword,
        'limit': rowPerPage.toString(),
        'offset': (pageNo * rowPerPage).toString(),
      }));

      return OpenLibrarySearchResponse.fromJson<OpenLibraryAuthorSearchResult>(
              json.decode(response.body))
          .result;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<OpenLibraryAuthorDetail> fetchAuthorDetail(
      {required String authorKey}) async {
    try {
      final response =
          await get(Uri.https(apiDomain, '$authorDetailPath/$authorKey.json'));

      return OpenLibraryAuthorDetail.fromJson(json.decode(response.body));
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }
}
