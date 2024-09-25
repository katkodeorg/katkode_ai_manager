import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_gemini/flutter_gemini.dart';

import '../utilities/utils_common.dart';
import 'ai_model.dart';
import 'ai_model_type.dart';
import 'ai_status.dart';

class GeminiAI implements AIModel {
  @override
  AiModelType modelType = AiModelType.gemini;

  @override
  bool defaultModel = false;

  @override
  String id = UtilsCommon.generateId();

  String name = 'Gemini AI';
  String apiKey = 'apiKey';

  DateTime? lastStatusCheckedTime;
  AIStatus lastStatus = AIStatus.notConfigured;

  Future<bool> setApiKey(String k) async {
    apiKey = k;
    lastStatus = AIStatus.inactive;
    return await testModel();
  }

  void setStatusBasedOnError(dynamic e) {
    lastStatus = AIStatus.tokenLimitError;
    lastStatusCheckedTime = DateTime.now().toUtc();

    if (e is String) {
      UtilsCommon.log(
        'GeminiAI$e',
        isError: true,
      );
      return;
    }
    UtilsCommon.log(
      'GeminiAI',
      error: e,
      isError: true,
    );
  }

  void setDefaultModel(bool value) {
    defaultModel = value;
  }

  @override
  Future<bool> initialize() {
    UtilsCommon.log('Initializing AI Status: ${lastStatus.statusName}');
    if (lastStatus == AIStatus.notConfigured) {
      return Future.value(false);
    }

    Gemini.init(apiKey: apiKey);

    return Future.value(true);
  }

  @override
  AIStatus getStatus() {
    return lastStatus;
  }

  @override
  Future<String?> getTextCompletion(String text) async {
    bool initComplete = await initialize();
    if (!initComplete) {
      return Future.value(null);
    }

    Completer<String?> c = Completer();

    final gemini = Gemini.instance;

    gemini.text(text).then(
      (value) {
        UtilsCommon.log('Text completion: ${value?.content?.parts?.last.text}');
        if (value?.content?.parts?.last.text == null) {
          c.complete(null);
          return;
        }

        c.complete(value?.content?.parts?.last.text);
      },
    ).catchError(
      (e) {
        setStatusBasedOnError(e);
        c.completeError(e);
      },
    );

    return c.future;
  }

  @override
  Future<String?> getTextAndDocumentCompletion(
    String text,
    List<Uint8List> files,
  ) async {
    bool initComplete = await initialize();
    if (!initComplete) {
      return Future.value(null);
    }

    Completer<String?> c = Completer();

    final gemini = Gemini.instance;

    gemini
        .textAndImage(
      text: text,
      images: files,
    )
        .then(
      (value) {
        if (value?.content?.parts?.last.text == null) {
          c.complete(null);
          return;
        }

        c.complete(value?.content?.parts?.last.text);
      },
    ).catchError(
      (e) {
        setStatusBasedOnError(e);
        c.completeError(e);
      },
    );

    return c.future;
  }

  @override
  Future<bool> testModel() async {
    try {
      String? testResult = await getTextCompletion(
        'Reply with the text "Working"',
      );
      if (testResult == 'Working') {
        lastStatus = AIStatus.active;
        lastStatusCheckedTime = DateTime.now().toUtc();
        return Future.value(true);
      }

      setStatusBasedOnError('Test failed Result: $testResult');
      return Future.value(false);
    } catch (e) {
      setStatusBasedOnError(e);
      return Future.value(false);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modelType': modelType.toMap(),
      'defaultModel': defaultModel,
      'apiKey': apiKey,
      'lastStatusCheckedTime': lastStatusCheckedTime?.toUtc().toIso8601String(),
      'lastStatus': lastStatus.toMap(),
    };
  }

  static GeminiAI fromMap(Map map) {
    return GeminiAI()
      ..id = map['id']
      ..modelType = AiModelType.fromMap(map['modelType'])
      ..defaultModel = map['defaultModel']
      ..apiKey = map['apiKey']
      ..lastStatusCheckedTime = map['lastStatusCheckedTime'] == null
          ? null
          : DateTime.parse(map['lastStatusCheckedTime'])
      ..lastStatus = AIStatus.fromMap(map['lastStatus']);
  }
}
