class GetReferralModel {
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? dateOfBirth;
  String? mobile;
  String? creation;
  int? accountClosed;
  String? dateOfJoining;
  String? status;
  String? rank;

  GetReferralModel({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.dateOfBirth,
    this.mobile,
    this.creation,
    this.accountClosed,
    this.dateOfJoining,
    this.status,
    this.rank,
  });

  GetReferralModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    mobile = json['mobile'];
    creation = json['creation'];
    accountClosed = json['account_closed'];
    dateOfJoining = json['date_of_joining'];
    status = json['status'];
    rank = json['rank'];
  }

  @override
  String toString() {
    return 'GetReferralModel(name: $name, firstName: $firstName, lastName: $lastName, email: $email, dateOfBirth: $dateOfBirth, mobile: $mobile, creation: $creation, accountClosed: $accountClosed, dateOfJoining: $dateOfJoining, status: $status, rank: $rank)';
  }
}

class ReferralFilterModel {
  int start;
  int pageLength;

  ReferralFilterModel({required this.start, required this.pageLength});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'page_length': pageLength,
    };
  }

  @override
  String toString() => 'ReferralFilterModel(start: $start, pageLength: $pageLength)';
}
