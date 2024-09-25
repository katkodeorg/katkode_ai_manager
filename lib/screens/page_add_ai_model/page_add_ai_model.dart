import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/ai_model.dart';
import '../../models/ai_model_type.dart';
import '../../services/manager_ai.dart';
import '../../services/manager_dialog.dart';
import '../../utilities/constants.dart';
import '../../utilities/utils_common.dart';
import '../../widgets/dialog_done.dart';

class PageAddAIModel extends StatefulWidget {
  const PageAddAIModel({super.key});

  @override
  State<PageAddAIModel> createState() => _PageAddAIModelState();
}

class _PageAddAIModelState extends State<PageAddAIModel> {
  bool _loading = false;

  AiModelType _selectedAiModelType = AiModelType.all[0];
  String _apiKey = '';

  Future<void> _addAIModel() async {
    if (_apiKey.isEmpty) {
      return;
    }

    setState(() {
      _loading = true;
    });

    AIModel aiModel = await ManagerAI.createAIModel(
      _selectedAiModelType,
      _apiKey,
    );

    bool testResult = await aiModel.testModel();

    UtilsCommon.log('Test result: $testResult');
    UtilsCommon.log(aiModel);

    if (testResult) {
      await ManagerAI.addModel(aiModel);

      if (!mounted) return;
      await ManagerDialog.showCustomDialog(
        context,
        DialogDone(
          onComplete: () {
            ManagerDialog.hideDialog(context);
          },
        ),
        false,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _getBody(BuildContext context) {
    List<AiModelType> aiModelTypes = AiModelType.all;
    List<String> instructions =
        ManagerAI.getAiModelAddSteps(_selectedAiModelType);

    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40.0,
            width: double.infinity,
          ),

          // back button and heading
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Expanded(
                  child: Text(
                    'Add AI Model',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontVariations: [
                        FontVariation('wght', 600),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select AI type',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontVariations: const [
                      FontVariation('wght', 600),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    color: mainButtonColor.withAlpha(30), // Light background
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Rounded corners
                  ),
                  child: PopupMenuButton<AiModelType>(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    onSelected: (AiModelType value) {
                      setState(() {
                        _selectedAiModelType = value;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return aiModelTypes.map((AiModelType value) {
                        return PopupMenuItem<AiModelType>(
                          value: value,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(
                                Icons.bolt,
                                color: mainButtonColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                value.typeName,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                  fontVariations: const [
                                    FontVariation('wght', 600),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(
                            Icons.bolt,
                            color: mainButtonColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _selectedAiModelType.typeName,
                            style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontVariations: const [
                                FontVariation('wght', 600),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Steps to add',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontVariations: const [
                      FontVariation('wght', 600),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                for (int i = 0; i < instructions.length; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${i + 1}. ${instructions[i]}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontVariations: const [
                            FontVariation('wght', 400),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6.0),
                    ],
                  ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () async {
                    Uri geminiUrl = Uri.parse(
                      ManagerAI.getAiModelApiKeyURL(_selectedAiModelType),
                    );
                    await launchUrl(geminiUrl);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withAlpha(50),
                          blurRadius: 5.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Open link to get key',
                          style: TextStyle(
                            color: mainButtonColor,
                            fontSize: 16.0,
                            fontVariations: [
                              FontVariation('wght', 500),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 20.0,
                          color: mainButtonColor,
                        ),
                      ],
                    ),
                  ),
                ),

                // input field for api key
                const SizedBox(height: 60.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (String value) {
                          setState(() {
                            _apiKey = value;
                          });
                        },
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontVariations: const [
                            FontVariation('wght', 400),
                          ],
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter API Key',
                          filled: true,
                          fillColor: mainButtonColor.withAlpha(30),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 20.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        _addAIModel();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 14.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withAlpha(50),
                              blurRadius: 5.0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Add',
                              style: TextStyle(
                                color: mainButtonColor,
                                fontSize: 16.0,
                                fontVariations: [
                                  FontVariation('wght', 500),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: _getBody(context),
    );
  }
}
