# Pawpal 🐾

Pawpal is an application that provide user to pet adoption and donation.
It provides the user with a user-friendly view of the pet list and allow user to submit a new pet (include upload 3 image).
The user can view the details from the pet list just click on the card.

---

# Project Setup ⚙️

1. Development Environment
- Flutter
- Dart
- phpMyAdmin

2. Create New Table on Database (tbl_pets)
The attribute are based on the guidelines (docx)
- pet_id
- user_id
- pet_name...

3. Install library
- Geolocator
- Http
- Image_cropper
- Image_picker
- Shared_preferences

4. Design interface (SubmitPetScreen and MainPage)
- Design the interactive interface
- SubmitPetScreen design for submit the new pet
- MainPage design for display all pet that has been submitted

5. Implement backend logic
- Using http.post to post the data to php, and perform query to insert data into database
- Using http.get to get the data from the database, and display the data/image to main interface

6. Add or advise some properties
- AndroidManifest.xml need add user permission to get permission on location feature
```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION"/>
```
- AndroidManifest.xml need add below coding to using Image_Cropper
```
<activity
android:name="com.yalantis.ucrop.UCropActivity"
android:screenOrientation="portrait"
android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
```
---

# API Explaination 🛠️
1. Submit_pet.php
- Method: POST
- Description: Inserts a new pet record into the database, including images and location.

| Field        | Type           | Description                                    |
|--------------|----------------|------------------------------------------------|
| pet_id       | INT PK AI      | Unique ID                                      |
| user_id      | INT            | Foreign key to tbl_users                       |
| pet_name     | VARCHAR(100)   | Pet Name                                       |
| pet_type     | VARCHAR(50)    | Cat/Dog/Rabbit/Other                           |
| category     | VARCHAR(50)    | Adoption/Donation/Help                         |
| description  | TEXT           | Pet Description                                |
| image_paths  | TEXT           | JSON or comma-separated list of up to 3 paths  |
| lat          | VARCHAR(50)    | Latitude                                       |
| lng          | VARCHAR(50)    | Longitude                                      |
| created_at   | DATETIME       | Time When Submmited                            |

2. get_my_pets.php
- Method: GET
- Description: Fetches all pets submitted by users to display on the main page.

# Sample JSON 🧾
- Sample send POST request
```
await http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/server/api/submit_pet.php'),
          body: {
            'user_id': widget.user?.userId,
            'pet_name': petName,
            'pet_type': selectedPetType,
            'category': selectedCategory,
            'description': description,
            'lat': latitude,
            'lng': longitude,
            'image': jsonEncode(base64image),
          },
        )
```
- Example Json 
```
{
  "pet_id": 1,
  "user_id": 1,
  "pet_name": "Buddy",
  "pet_type": "Dog",
  "category": "Adoption",
  "description": "Looking for a loving home.",
  "image_paths": [
    "uploads/pets_1_1.png",
    "uploads/pets_1_2.png",
    "uploads/pets_1_3.png"
  ],
  "lat": "3.1390",
  "lng": "101.6869",
  "created_at": "2025-12-06 14:30:00"
}
```

- Example JsonResponse
```
  $response = array('success' => true, 'message' => 'Pet submitted successfully');
  sendJsonResponse($response);
  {
    "success" : true,
    "message" : "Pet submitted successfully"
  }
  
  $response = array('success' => false, 'message' => 'Pet submitted failed');
  sendJsonResponse($response);
  {
    "success" : false,
    "message" : "Pet submitted failed"
  }

```

# Recommended 💡
If you encounter issues during debugging, please run the following commands in the terminal and try again:
