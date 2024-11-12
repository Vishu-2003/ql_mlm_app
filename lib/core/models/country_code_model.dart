class GetCountryCodeModel {
  String? code;
  String? country;

  GetCountryCodeModel({
    this.code,
    this.country,
  });

  GetCountryCodeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    country = json['country'];
  }

  @override
  String toString() => 'GetCountryCodeModel(code: $code, country: $country)';

  @override
  bool operator ==(covariant GetCountryCodeModel other) {
    if (identical(this, other)) return true;

    return other.code == code && other.country == country;
  }

  @override
  int get hashCode => code.hashCode ^ country.hashCode;
}
