# katkode_ai_manager

[![pub package](https://img.shields.io/pub/v/katkode_ai_manager.svg)](https://pub.dartlang.org/packages/katkode_ai_manager)

A flutter library to let users use their own LLM keys to access AI models


## Sponsors
Consider supporting this project by becoming a sponsor. Your logo will show up here with a link to your website.


## How to use
To use this plugin, add `katkode_ai_manager` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

Add a new model to the store:
```dart
    AIModel aiModel = await ManagerAI.createAIModel(
      AiModelType.gemini,
      "xxx",
    );

    bool testResult = await aiModel.testModel();

    if (testResult) {
      await ManagerAI.addModel(aiModel);
      // Success
    } else {
      // Fail
    }
````

To use the model:
```dart
    AIModel? aiModel = await ManagerAI.getDefaultModel();
    String? aiResponse = await aiModel.getTextAndDocumentCompletion(
        "This is an exmaple prompt",
        [], // file bytes list
    );
```

## How it works
Uses the LLM API to access the AI models.

## FAQ
### How do I add additional AI model types?
Send a pull request with the new AI model and the corresponding test.
