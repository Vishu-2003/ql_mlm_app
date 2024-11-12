import 'dart:ui';

import 'package:qm_mlm_flutter/utils/utils.dart';

class GetTicketModel {
  String? subject;
  String? description;
  String? creation;
  String? status;

  GetTicketModel({this.subject, this.description, this.creation, this.status});

  GetTicketModel.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    description = json['description'];
    creation = json['creation'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    data['description'] = description;
    data['creation'] = creation;
    data['status'] = status;
    return data;
  }

  Color get getStatusColor {
    switch (status) {
      case 'Open':
        return lightRed;
      case 'Closed':
        return green;
      default:
        return grey1;
    }
  }

  @override
  String toString() {
    return 'GetTicketModel(subject: $subject, description: $description, creation: $creation, status: $status)';
  }
}

class TicketsFilterModel {
  int start;
  int pageLength;

  TicketsFilterModel({required this.start, required this.pageLength});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'page_length': pageLength,
    };
  }

  @override
  String toString() => 'TicketsFilterModel(start: $start, pageLength: $pageLength)';
}
