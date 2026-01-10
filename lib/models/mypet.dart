class MyPet {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? petAge;
  String? petGender;
  String? petHealth;
  String? category;
  String? description;
  String? lat;
  String? lng;
  String? timeCreated;
  
  String? userName;
  String? userEmail;
  String? userPhone;

  MyPet({
    this.petId,
    this.userId,
    this.petName,
    this.petType,
    this.petAge,
    this.petGender,
    this.petHealth,
    this.category,
    this.description,
    this.lat,
    this.lng,
    this.timeCreated,
    this.userName,
    this.userEmail,
    this.userPhone,
  });

   MyPet.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    petType = json['pet_type'];
    petAge = json['pet_age'];
    petGender = json['pet_gender'];
    petHealth = json['pet_health'];
    category = json['category'];
    description = json['description'];
    lat = json['lat'];
    lng = json['lng'];
    timeCreated = json['time_created'];
    //Mapping user field
    userName = json['name'];
    userEmail = json['email'];
    userPhone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_type'] = petType;
    data['pet_age'] = petAge;
    data['pet_gender'] = petGender;
    data['pet_health'] = petHealth;
    data['category'] = category;
    data['description'] = description;
    data['lat'] = lat;
    data['lng'] = lng;
    data['time_created'] = timeCreated;
    //Mapping user field
    data['name'] = userName;
    data['email'] = userEmail;
    data['phone'] = userPhone;
    return data;
  }
}
