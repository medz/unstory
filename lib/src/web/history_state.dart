class HistoryState {
  final Object? userData;
  final int index;
  final String? identifier;

  const HistoryState({required this.index, this.identifier, this.userData});

  Map<String, dynamic> toJson() => {
    'index': index,
    'identifier': identifier,
    'userData': userData,
  };

  factory HistoryState.fromJson(Map<dynamic, dynamic> json) => HistoryState(
    index: json['index'] as int? ?? 0,
    identifier: json['identifier'] as String?,
    userData: json['userData'],
  );
}
