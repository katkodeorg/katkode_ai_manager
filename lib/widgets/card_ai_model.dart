import 'package:flutter/material.dart';

import '../models/ai_model.dart';
import '../models/gemini_ai.dart';
import '../utilities/constants.dart';

class CardAIModel extends StatefulWidget {
  final AIModel aiModel;
  final Function(AIModel) onDelete;
  const CardAIModel({
    super.key,
    required this.aiModel,
    required this.onDelete,
  });

  @override
  State<CardAIModel> createState() => _CardAIModelState();
}

class _CardAIModelState extends State<CardAIModel> {
  bool _testLoading = false;

  Future<void> _testModel() async {
    setState(() {
      _testLoading = true;
    });

    await widget.aiModel.testModel();
    // update Storage

    setState(() {
      _testLoading = false;
    });
  }

  Future<void> _deleteAIModel() async {
    widget.onDelete(widget.aiModel);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.aiModel is GeminiAI) {
      return GestureDetector(
        onTap: _testModel,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(50),
                blurRadius: 5.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.aiModel.modelType.typeName,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontVariations: const [
                          FontVariation('wght', 600),
                        ],
                      ),
                    ),
                    if (widget.aiModel.defaultModel)
                      Text(
                        'Default Model',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontVariations: const [
                            FontVariation('wght', 400),
                          ],
                        ),
                      ),
                    Text(
                      widget.aiModel.getStatus().statusName,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        fontVariations: const [
                          FontVariation('wght', 400),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (_testLoading)
                    const SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(),
                    )
                  else
                    GestureDetector(
                      onTap: _testModel,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: mainButtonColor.withAlpha(50),
                        ),
                        child: Icon(
                          Icons.refresh,
                          size: 20.0,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: _deleteAIModel,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: mainButtonColor.withAlpha(50),
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 20.0,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Container();
  }
}
