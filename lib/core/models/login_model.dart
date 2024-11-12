import 'dart:convert';

class GetLoginModel {
  List? data;
  String? user;
  String? message;
  String? fullName;
  String? homePage;
  String? memberId;
  String? mobileNo;
  bool? tacVerified;
  KeyDetails? keyDetails;
  bool? twoFactorAuthentication;

  GetLoginModel({
    this.data,
    this.user,
    this.message,
    this.fullName,
    this.homePage,
    this.memberId,
    this.mobileNo,
    this.tacVerified,
    this.keyDetails,
    this.twoFactorAuthentication,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'message': message,
      'full_name': fullName,
      'home_page': homePage,
      'member_id': memberId,
      'mobile_no': mobileNo,
      'key_details': keyDetails?.toMap(),
      'tac_verified': tacVerified == true ? 1 : 0,
      'data': data?.map((x) => x?.toMap()).toList(),
      'two_factor_authentication': twoFactorAuthentication == true ? 1 : 0,
    };
  }

  factory GetLoginModel.fromMap(Map<String, dynamic> map) {
    return GetLoginModel(
      tacVerified: map['tac_verified'] == 1,
      data: map['data'] != null ? List.from(map['data'] as List) : null,
      user: map['user'] != null ? map['user'] as String : null,
        message: map['message'] != null ? map['message'] as String : null,
      fullName: map['full_name'] != null ? map['full_name'] as String : null,
      homePage: map['home_page'] != null ? map['home_page'] as String : null,
      keyDetails: map['key_details'] != null
          ? KeyDetails.fromMap(map['key_details'] as Map<String, dynamic>)
          : null,
      memberId: map['member_id'] != null ? map['member_id'] as String : null,
      twoFactorAuthentication: map['two_factor_authentication'] == 1,
      mobileNo: map['mobile_no'] != null ? map['mobile_no'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetLoginModel.fromJson(String source) =>
      GetLoginModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetLoginModel(data: $data, user: $user, message: $message, fullName: $fullName, homePage: $homePage, memberId: $memberId, mobileNo: $mobileNo, tacVerified: $tacVerified, keyDetails: $keyDetails, twoFactorAuthentication: $twoFactorAuthentication)';
  }
}

class KeyDetails {
  String? apiSecret;
  String? apiKey;
  KeyDetails({this.apiSecret, this.apiKey});

  KeyDetails copyWith({
    String? apiSecret,
    String? apiKey,
  }) {
    return KeyDetails(
      apiSecret: apiSecret ?? this.apiSecret,
      apiKey: apiKey ?? this.apiKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'api_secret': apiSecret,
      'api_key': apiKey,
    };
  }

  factory KeyDetails.fromMap(Map<String, dynamic> map) {
    return KeyDetails(
      apiSecret: map['api_secret'] != null ? map['api_secret'] as String : null,
      apiKey: map['api_key'] != null ? map['api_key'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory KeyDetails.fromJson(String source) =>
      KeyDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => '_KeyDetails(api_secret: $apiSecret, api_key: $apiKey)';

  @override
  bool operator ==(covariant KeyDetails other) {
    if (identical(this, other)) return true;

    return other.apiSecret == apiSecret && other.apiKey == apiKey;
  }

  @override
  int get hashCode => apiSecret.hashCode ^ apiKey.hashCode;
}
