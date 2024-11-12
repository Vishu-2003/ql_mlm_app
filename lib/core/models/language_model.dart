import 'package:qm_mlm_flutter/utils/utils.dart';

class GetLanguageModel {
  final String language;
  String languageName;

  GetLanguageModel({required this.language, required this.languageName});

  factory GetLanguageModel.fromJson(Map<String, dynamic> json) {
    return GetLanguageModel(
      language: json['language'] as String,
      languageName: json['language_name'] as String,
    );
  }

  factory GetLanguageModel.defaultLocale() {
    return defaultLocale.copyWith();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    data['language_name'] = languageName;
    return data;
  }

  @override
  String toString() => 'GetLanguageModel(language: $language, languageName: $languageName)';

  @override
  bool operator ==(covariant GetLanguageModel other) {
    if (identical(this, other)) return true;

    return other.language == language && other.languageName == languageName;
  }

  @override
  int get hashCode => language.hashCode ^ languageName.hashCode;

  GetLanguageModel copyWith({
    String? language,
    String? languageName,
  }) {
    return GetLanguageModel(
      language: language ?? this.language,
      languageName: languageName ?? this.languageName,
    );
  }
}
