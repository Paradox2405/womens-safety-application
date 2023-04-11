class UserModel {
  String? name;
  String? id;
  String? phone;
  String? womanEmail;
  String? guardianEmail;
  String? type;
  List<String>? guardiansWomenEmails;

  UserModel(
      {this.name,
      this.womanEmail,
      this.id,
      this.guardianEmail,
      this.phone,
      this.type,
      this.guardiansWomenEmails});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'id': id,
        'womanEmail': womanEmail,
        'guardianEmail': guardianEmail,
        'type': type,
    'guardiansWomenEmails':guardiansWomenEmails,
      };
}
