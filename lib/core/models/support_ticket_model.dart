class PostSupportTicketModel {
  String? issueType;
  String? priority;
  String? subject;
  String? description;

  PostSupportTicketModel({this.issueType, this.priority, this.subject, this.description});

  PostSupportTicketModel.fromJson(Map<String, dynamic> json) {
    issueType = json['issue_type'];
    priority = json['priority'];
    subject = json['subject'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['issue_type'] = issueType;
    data['priority'] = priority;
    data['subject'] = subject;
    data['description'] = description;
    return data;
  }

  @override
  String toString() {
    return 'PostSupportTicketModel(issueType: $issueType, priority: $priority, subject: $subject, description: $description)';
  }
}
