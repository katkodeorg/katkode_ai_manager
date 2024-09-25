import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/ai_model.dart';
import '../screens/page_add_ai_model/page_add_ai_model.dart';
import '../services/manager_ai.dart';
import '../services/manager_dialog.dart';
import '../services/manager_routing.dart';
import '../utilities/constants.dart';
import 'card_ai_model.dart';

class DialogAIModels extends StatefulWidget {
  const DialogAIModels({super.key});

  @override
  State<DialogAIModels> createState() => _DialogAIModelsState();
}

class _DialogAIModelsState extends State<DialogAIModels> {
  List<AIModel> _aiModels = [];

  Future<void> _openAddPage() async {
    await Navigator.of(context).push(
      ManagerRouting.getPageRouteBuilderWithAnimation(
        const PageAddAIModel(),
      ),
    );

    if (!mounted) return;
    ManagerDialog.hideDialog(context);
  }

  Future<void> _getAIModels() async {
    // get all the AI models
    List<AIModel> am = await ManagerAI.loadAllModels();
    setState(() {
      _aiModels = am;
    });
  }

  Future<void> _deleteAIModel(AIModel aiModel) async {
    // delete the AI model
    List<AIModel> am = await ManagerAI.deleteModel(aiModel);
    // remove the AI model from the list
    setState(() {
      _aiModels = am;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAIModels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
      child: AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'AI Models',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2F2F2F),
                  fontVariations: [
                    FontVariation('wght', 700),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              for (var model in _aiModels)
                CardAIModel(
                  aiModel: model,
                  onDelete: _deleteAIModel,
                ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: _openAddPage,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: mainButtonColor.withAlpha(50),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 40.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  // horizontal line
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 40.0,
                        right: 10.0,
                      ),
                      height: 1.0,
                      color: mainButtonColor,
                    ),
                  ),
                  Text(
                    'OR',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: mainButtonColor,
                      fontVariations: [
                        FontVariation('wght', 400),
                      ],
                    ),
                  ),
                  // horizontal line
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 10.0,
                        right: 40.0,
                      ),
                      height: 1.0,
                      color: mainButtonColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    // dismiss the dialog
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: mainButtonColor,
                    disabledBackgroundColor: const Color(0xffC0C0C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    shadowColor: const Color.fromRGBO(114, 114, 114, 0.45),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Continue Without AI',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontVariations: [
                        FontVariation('wght', 600),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
    );
  }
}
