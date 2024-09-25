import 'dart:typed_data';

import 'ai_model_type.dart';
import 'ai_status.dart';

abstract class AIModel {
  late AiModelType modelType;
  late bool defaultModel;
  late String id;

  Future<bool> initialize();

  Future<bool> testModel();

  Future<String?> getTextCompletion(String text);

  Future<String?> getTextAndDocumentCompletion(
    String text,
    List<Uint8List> files,
  );

  AIStatus getStatus();
}
