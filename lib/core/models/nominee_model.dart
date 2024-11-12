import 'package:freezed_annotation/freezed_annotation.dart';

part 'nominee_model.freezed.dart';
part 'nominee_model.g.dart';

@Freezed(toJson: false, copyWith: false, equal: false)
class GetNomineeDetailsModel with _$GetNomineeDetailsModel {
  @JsonSerializable(createToJson: true, fieldRename: FieldRename.snake)
  const factory GetNomineeDetailsModel({
    String? name,
    String? email,
    double? share,
    String? status,
    String? mobileNo,
    String? nomineeName,
    String? relationship,
    String? identificationType,
    String? identificationNumber,
  }) = _GetNomineeDetailsModel;

  factory GetNomineeDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$GetNomineeDetailsModelFromJson(json);
}

class GetMemberDetailsNomineeModel {
  String? mobile;
  String? email;
  double? nomineeShareRemaining;
  double? nomineeShare;
  int? numberOfNomineeAdded;
  int? numberOfNomineeRemaining;

  GetMemberDetailsNomineeModel({
    this.mobile,
    this.email,
    this.nomineeShareRemaining,
    this.nomineeShare,
    this.numberOfNomineeAdded,
    this.numberOfNomineeRemaining,
  });

  GetMemberDetailsNomineeModel.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    email = json['email'];
    nomineeShareRemaining = json['nominee_share_remaining'];
    nomineeShare = json['nominee_share'];
    numberOfNomineeAdded = json['number_of_nominee_added'];
    numberOfNomineeRemaining = json['number_of_nominee_remaining'];
  }

  @override
  String toString() {
    return 'GetMemberDetailsNomineeModel(mobile: $mobile, email: $email, nomineeShareRemaining: $nomineeShareRemaining, nomineeShare: $nomineeShare, numberOfNomineeAdded: $numberOfNomineeAdded, numberOfNomineeRemaining: $numberOfNomineeRemaining)';
  }
}

class PostAddNomineeModel {
  String? identificationType;
  String? identificationNumber;
  String? nomineeName;
  String? relationship;
  String? email;
  double? share;
  String? mobileNo;
  List<PostAddNominationWitnessModel> memberNominationWitnesses;

  PostAddNomineeModel({
    required this.identificationType,
    required this.identificationNumber,
    required this.nomineeName,
    required this.relationship,
    required this.email,
    required this.share,
    required this.mobileNo,
    required this.memberNominationWitnesses,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['share'] = share;
    data['mobile_no'] = mobileNo;
    data['nominee_name'] = nomineeName;
    data['relationship'] = relationship;
    data['identification_type'] = identificationType;
    data['identification_number'] = identificationNumber;
    data['member_nomination_witnesses'] = memberNominationWitnesses.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'PostAddNomineeModel(identificationType: $identificationType, identificationNumber: $identificationNumber, nomineeName: $nomineeName, relationship: $relationship, email: $email, share: $share, mobileNo: $mobileNo, memberNominationWitnesses: $memberNominationWitnesses)';
  }
}

class PostAddNominationWitnessModel {
  String? identificationType;
  String? identificationNumber;
  String? witnessesName;
  String? email;
  String? mobile;

  PostAddNominationWitnessModel({
    required this.identificationType,
    required this.identificationNumber,
    required this.witnessesName,
    required this.email,
    required this.mobile,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['identification_type'] = identificationType;
    data['identification_number'] = identificationNumber;
    data['witnesses_name'] = witnessesName;
    data['email'] = email;
    data['mobile'] = mobile;
    return data;
  }

  @override
  String toString() {
    return 'PostAddNominationWitnessModel(identificationType: $identificationType, identificationNumber: $identificationNumber, witnessesName: $witnessesName, email: $email, mobile: $mobile)';
  }
}
