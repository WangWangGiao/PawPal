class MyAdoption {
  String? adoptionid;
  String? petid;
  String? userid;
  String? motivation;
  String? previousexp;
  String? status;
  String? ownedid;
  String? requestdate;

  String? petName;
  String? userName;
  String? userPhone;

  MyAdoption({
    this.adoptionid,
    this.petid,
    this.userid,
    this.motivation,
    this.previousexp,
    this.status,
    this.ownedid,
    this.requestdate,

    this.petName,
    this.userName,
    this.userPhone
  });

   MyAdoption.fromJson(Map<String, dynamic> json) {
    adoptionid = json['adoption_id'];
    petid = json['pet_id'];
    userid = json['user_id'];
    motivation = json['motivation'];
    previousexp = json['previous_exp'];
    status = json['status'];
    ownedid = json['owned_id'];
    requestdate = json['request_date'];
    //Maping other field
    petName = json['pet_name'];
    userName = json['owner_name'];
    userPhone = json['owner_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adoption_id'] = adoptionid;
    data['pet_id'] = petid;
    data['user_id'] = userid;
    data['motivation'] = motivation;
    data['previous_exp'] = previousexp;
    data['status'] = status;
    data['owned_id'] = ownedid;
    data['request_date'] = requestdate;
    data['pet_name'] = petName;
    data['owner_name'] = userName;
    data['owner_phone'] = userPhone;
    return data;
  }
}
