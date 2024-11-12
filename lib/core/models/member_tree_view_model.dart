class GetMemberTreeViewModel {
  String? name;
  String? memberName;
  String? sponserName;
  bool hasChildren = true;
  String? sponserMemberName;

  GetMemberTreeViewModel({
    this.name,
    this.memberName,
    this.sponserName,
    this.sponserMemberName,
  });

  GetMemberTreeViewModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    memberName = json['member_name'];
    sponserName = json['sponser_name'];
    sponserMemberName = json['sponser_member_name'];
  }

  @override
  String toString() {
    return 'GetMemberTreeViewModel(name: $name, memberName: $memberName, sponserName: $sponserName, sponserMemberName: $sponserMemberName)';
  }
}
