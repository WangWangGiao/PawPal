# Pawpal 🐾 

**Pawpal** is a comprehensive mobile application designed to bridge the gap between pet rescuers, adopters, and donors. The platform facilitates seamless pet adoption processes and provides a secure way to donate to animals in need.

> **Status:** Fully deployed and accessible globally via Jomhosting.

---

## 📖 Project Overview
Pawpal offers a centralized ecosystem for pet welfare, including:
* **User Lifecycle:** Secure Registration and Login.
* **Pet Listings:** Submit pets for adoption, donation, or emergency rescue/help.
* **Content Management:** Full CRUD (Create, Read, Update, Delete) capabilities for user-submitted pet records.
* **Donation System:** A dual-mode donation system supporting both **Items** (Food/Medical) and **Monetary** contributions.
* **Wallet Integration:** In-app credit system with secure Top-Up functionality.
* **Adoption Workflow:** Formal adoption application process with status tracking.
* **Profile Management:** Interactive UI to manage user data and avatars.

---

## 🛠️ Tech Stack & Environment
* **Frontend:** Flutter | Dart
* **Backend:** PHP (Hosted on cPanel - Jomhosting)
* **Database:** MySQL (Managed via phpMyAdmin)
* **Payment Gateway:** Billplz (Sandbox mode)
* **Libraries:** `geolocator`, `http`, `image_cropper`, `image_picker`, `shared_preferences`, `webview_flutter`.

---

## ⚙️ Project Setup & Deployment

### 1. Domain & Hosting
* Configured via **Jomhosting cPanel**.
* **SSL/TLS:** AutoSSL enabled via cPanel to ensure secure `https` connections.
* **DNS:** Pointed domain name to hosting servers.

### 2. Database Configuration
* Database Name: `youcapfu_pawpal_db`
* Tables Implemented:
    * `tbl_users`: User credentials and credit balances.
    * `tbl_pets`: Pet profiles and status information.
    * `tbl_adoptions`: Records of adoption applications.
    * `tbl_donations`: Transaction logs for monetary and item donations.

### 3. Backend Deployment
* PHP API scripts uploaded to `/pawpal/server/api/`.
* Directory permissions configured for image storage:
    * `/server/uploads/pet/`
    * `/server/uploads/user_profile/`

### 4. Billplz Integration
* API Keys and Collection IDs configured within the Billplz sandbox for secure payment processing.

---

## ✨ Features

### 1. Pet Management
* Multi-attribute listings (Name, age, gender, health, category, location).
* Supports **Multiple Image Uploads** (Max 3) with cropping functionality.

### 2. Adoption System
* View detailed pet/owner profiles.
* Motivation-based application forms.
* Real-time status tracking for applicants.

### 3. Donation System
* **Monetary:** Uses in-app credits with atomic database transactions.
* **Item-based:** Specific categories for Food and Medical aid.
* Detailed donation history with pet name associations.

### 4. Credit Top-Up
* Seamless integration with Billplz for purchasing in-app credits.

### 5. User Experience
* Responsive and interactive UI.
* Profile customization including avatar uploads and personal info editing.

---

## 🛠️ API Usage Reference

| API NAME | METHOD | DESCRIPTION |
|:---|:---:|:---|
| `dbconnect.php` | - | Establishes connection to the hosting server database (Jomhosting). |
| `register_user.php` | POST | Handles new user account registration. |
| `login_user.php` | POST | Authenticates user credentials and returns user session data. |
| `submit_pet.php` | POST | Inserts a new pet record and stores uploaded images on the server. |
| `get_my_pets.php` | GET | Retrieves all pet records added by the currently logged-in user. |
| `update_pet.php` | POST | Updates existing pet details and refreshes server-side images. |
| `delete_pet.php` | POST | Removes pet records, associated adoption requests, and server images. |
| `pet_adopt_request.php` | POST | Submits a formal pet adoption application. |
| `get_my_adoptions.php` | GET | Retrieves all adoption applications made by the logged-in user. |
| `delete_adoption_request.php` | POST | Cancels a pending adoption request. |
| `submit_donate.php` | POST | Records a donation and deducts credit from the donor's balance. |
| `get_my_donations.php` | GET | Retrieves the personal donation history of the logged-in user. |
| `payment.php` | GET | Initiates the Billplz payment process for credit top-ups. |
| `payment_update.php` | GET | Validates and updates the user's credit balance after a payment. |
| `update_user_profile.php` | POST | Updates user profile information and avatar images. |

---

## 💡 Troubleshooting & Notes

### Maintenance Commands
If you encounter build issues or UI inconsistencies, run:
```bash
flutter clean
flutter pub get