import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qm_mlm_flutter/utils/utils.dart';

class FlagConverter implements JsonConverter<bool, int?> {
  const FlagConverter();

  @override
  bool fromJson(int? json) => switch (json) { 1 => true, _ => false };

  @override
  int? toJson(bool? object) => switch (object) { true => 1, false => 0, null || _ => null };
}

class DateConverter implements JsonConverter<DateTime?, String?> {
  const DateConverter();

  @override
  DateTime? fromJson(String? json) =>
      switch (json) { null => null, _ => json.convertDefaultDateTime };

  @override
  String? toJson(DateTime? object) =>
      switch (object) { null => null, _ => object.getDefaultDateFormat };
}
