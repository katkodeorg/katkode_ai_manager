import '../models/ai_model.dart';
import '../models/ai_model_type.dart';
import '../models/gemini_ai.dart';
import '../utilities/utils_common.dart';
import 'manager_ai_database.dart';

class ManagerAI {
  static Map<AiModelType, List<String>> aiModelTypeAddSteps = {
    AiModelType.gemini: [
      'Go to Gemini website',
      'Login with google',
      'Get your API key',
      'Copy and ddd your API key here',
      'Done'
    ],
    AiModelType.openAi: [
      'Go to OpenAI website',
      'Login with google',
      'Get your API key',
      'Copy and ddd your API key here',
      'Done'
    ],
  };

  static Map<AiModelType, String> aiModelTypeApiKeyURL = {
    AiModelType.gemini: 'https://aistudio.google.com/app/apikey',
    AiModelType.openAi: 'https://www.openai.com/',
  };

  static String getAiModelApiKeyURL(AiModelType aiModelType) {
    return aiModelTypeApiKeyURL[aiModelType] ?? '';
  }

  static List<String> getAiModelAddSteps(AiModelType aiModelType) {
    return aiModelTypeAddSteps[aiModelType] ?? ['Figure it out yourself lol'];
  }

  /// Create an AI Model based on the type and API key
  static Future<AIModel> createAIModel(
    AiModelType aiModelType,
    String apiKey,
  ) async {
    AIModel aiModel;

    if (aiModelType == AiModelType.gemini) {
      GeminiAI gAI = GeminiAI();
      gAI.setApiKey(apiKey);
      aiModel = gAI;
    } else {
      throw Exception('Invalid AI Model Type');
    }

    return aiModel;
  }

  static Future<List<AIModel>> saveModels(List<AIModel> inputAIModels) async {
    List<AIModel> models = await loadAllModels();

    if (models.isEmpty) {
      for (var aiModel in inputAIModels) {
        aiModel.defaultModel = true;
        break;
      }
    }

    models.addAll(inputAIModels);

    for (var aiModel in models) {
      if (aiModel is GeminiAI) {
        await ManagerAIDatabase.saveMap(
          aiModel.id,
          aiModel.toMap(),
        );
      } else {
        throw Exception('Invalid AI Model Type');
      }
    }

    return await loadAllModels();
  }

  // add new model
  static Future<List<AIModel>> addModel(AIModel aiModel) async {
    return await saveModels([aiModel]);
  }

  // get all models
  static Future<List<AIModel>> loadAllModels() async {
    var data = await ManagerAIDatabase.loadAll();
    var models = <AIModel>[];

    for (var item in data) {
      UtilsCommon.log('ManagerAI $item');
      var modelType = AiModelType.fromString(item['modelType']['typeName']);

      AIModel aiModel;
      if (modelType == AiModelType.gemini) {
        aiModel = GeminiAI.fromMap(item);
      } else {
        throw Exception('Invalid AI Model Type');
      }

      models.add(aiModel);
    }
    UtilsCommon.log('ManagerAI aiModel $models');

    return models;
  }

  // set default model
  static Future<List<AIModel>> setDefaultModel(AIModel aiModel) async {
    List<AIModel> models = await loadAllModels();
    for (var model in models) {
      model.defaultModel = model.id == aiModel.id;
    }

    return await saveModels(models);
  }

  // get default model
  static Future<AIModel?> getDefaultModel() async {
    List<AIModel> models = await loadAllModels();
    for (var model in models) {
      if (model.defaultModel == true) {
        return model;
      }
    }

    return null;
  }

  // delete model
  static Future<List<AIModel>> deleteModel(AIModel aiModel) async {
    List<AIModel> models = await loadAllModels();

    // remove the model
    models.removeWhere((model) => model.id == aiModel.id);
    await ManagerAIDatabase.deleteMap(aiModel.id);

    // check if no model is default and set the first model as default
    if (models.any((model) => model.defaultModel == true) == false &&
        models.isNotEmpty) {
      models[0].defaultModel = true;
    }

    // save the models
    return await saveModels(models);
  }
}
