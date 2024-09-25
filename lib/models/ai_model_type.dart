class AiModelType {
  static var gemini = AiModelType()..typeName = 'Gemini';
  static var openAi = AiModelType()..typeName = 'OpenAI';

  String typeName;
  AiModelType({this.typeName = ''});

  static AiModelType fromString(String value) {
    switch (value) {
      case 'Gemini':
        return AiModelType.gemini;
      case 'OpenAI':
        return AiModelType.openAi;
      default:
        throw Exception('Invalid AiModelType value: $value');
    }
  }

  // get all model types
  static List<AiModelType> get all => [gemini, openAi];

  // comparison operator should compare the fields of the object
  @override
  bool operator ==(Object other) {
    return other is AiModelType && other.typeName == typeName;
  }

  @override
  int get hashCode => typeName.hashCode;

  Map toMap() {
    return {
      'typeName': typeName,
    };
  }

  static AiModelType fromMap(Map map) {
    return AiModelType(
      typeName: map['typeName'],
    );
  }
}
