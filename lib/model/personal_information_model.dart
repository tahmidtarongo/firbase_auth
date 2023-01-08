class PersonalInformationModel {
  PersonalInformationModel({
    this.phoneNumber,
    this.companyName,
    this.pictureUrl,
    this.businessCategory,
    this.language,
    this.countryName,
    this.saleInvoiceCounter,
    this.purchaseInvoiceCounter,
    this.dueInvoiceCounter,
    this.smsBalance
  });

  PersonalInformationModel.fromJson(dynamic json) {
    phoneNumber = json['phoneNumber'];
    companyName = json['companyName'];
    pictureUrl = json['pictureUrl'];
    businessCategory = json['businessCategory'];
    language = json['language'];
    countryName = json['countryName'];
    saleInvoiceCounter = json['saleInvoiceCounter'];
    purchaseInvoiceCounter = json['purchaseInvoiceCounter'];
    dueInvoiceCounter = json['dueInvoiceCounter'];
    smsBalance = json['smsBalance'] ?? 50;
  }
  dynamic phoneNumber;
  String? companyName;
  String? pictureUrl;
  String? businessCategory;
  String? language;
  String? countryName;
  int? saleInvoiceCounter;
  int? purchaseInvoiceCounter;
  int? dueInvoiceCounter;
  int? smsBalance;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['companyName'] = companyName;
    map['pictureUrl'] = pictureUrl;
    map['businessCategory'] = businessCategory;
    map['language'] = language;
    map['countryName'] = countryName;
    map['saleInvoiceCounter'] = saleInvoiceCounter;
    map['purchaseInvoiceCounter'] = purchaseInvoiceCounter;
    map['dueInvoiceCounter'] = dueInvoiceCounter;
    map['smsBalance'] = smsBalance;
    return map;
  }
}
