class MyDonation {
  String? donationid;
  String? petid;
  String? userid;
  String? donationtype;
  String? amount;
  String? description;
  String? donatedate;

  String? petname;
  MyDonation({
    this.donationid,
    this.petid,
    this.userid,
    this.donationtype,
    this.amount,
    this.description,
    this.donatedate,
    this.petname
  });

   MyDonation.fromJson(Map<String, dynamic> json) {
    donationid = json['donation_id'];
    petid = json['pet_id'];
    userid = json['user_id'];
    donationtype = json['donation_type'];
    amount = json['amount'];
    description = json['description'];
    donatedate = json['donation_date'];
    petname = json['pet_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donation_id'] = donationid;
    data['pet_id'] = petid;
    data['user_id'] = userid;
    data['donation_type'] = donationtype;
    data['amount'] = amount;
    data['description'] = description;
    data['donation_date'] = donatedate;
    data['pet_name'] = petname;
    return data;
  }
}
