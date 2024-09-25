class AIStatus {
  static var active = AIStatus()..statusName = 'ACTIVE';
  static var inactive = AIStatus()..statusName = 'INACTIVE';
  static var notConfigured = AIStatus()..statusName = 'NOT_CONFIGURED';
  static var tokenLimitError = AIStatus()..statusName = 'TOKEN_LIMIT_ERROR';

  String statusName;

  AIStatus({this.statusName = ''});

  static AIStatus fromString(String value) {
    switch (value) {
      case 'ACTIVE':
        return AIStatus.active;
      case 'INACTIVE':
        return AIStatus.inactive;
      case 'NOT_CONFIGURED':
        return AIStatus.notConfigured;
      case 'TOKEN_LIMIT_ERROR':
        return AIStatus.tokenLimitError;
      default:
        throw Exception('Invalid AIStatus value: $value');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is AIStatus && other.statusName == statusName;
  }

  @override
  int get hashCode => statusName.hashCode;

  Map toMap() {
    return {
      'statusName': statusName,
    };
  }

  static AIStatus fromMap(Map map) {
    return AIStatus(
      statusName: map['statusName'],
    );
  }
}
