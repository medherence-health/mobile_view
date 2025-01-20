class UserData {
  final int id;
  final String username;
  final String fullName;
  final String userId;
  final String email;
  final String password;
  final String phoneNumber;
  final String? dob;
  final String? gender;
  final String? waPhoneNumber;

  // Emergency Contact
  final String? ecName;
  final String? ecGender;
  final String? ecNum;
  final String? ecEmail;
  final String? ecRelationship;

  // Next of Kin
  final String? nofName;
  final String? nofGender;
  final String? nofNum;
  final String? nofEmail;
  final String? nofRelationship;

  // Location Information
  final String? state;
  final String? country;
  final String? localGovernmentArea;
  final String? ward;
  final String? city;
  final String? address;
  final String? postalCode;

  // Personal Information
  final String? firstName;
  final String? lastName;
  final String language;

  // Authentication and Status
  final String loginType;
  final String? profileImg;
  final String createdAt;
  final bool isActive;
  final String role;
  final String accountStatus;

  // Facility Information
  final String? facilityId;
  final String? facilityCode;
  final String? facilityLevel;
  final String? facilityOwnership;

  // Verification Information
  final String? verificationType;
  final String? verificationCode;

  // Financial Information
  final String? bankName;
  final String? accountNumber;
  final String? cardNumber;
  final double medhecoinBalance;
  final double totalNairaBalance;

  // Subscription Information
  final String subscriptionType;
  final int subscriptionExpirationDate;
  final List<String>? subscriptionTotalPatients;
  final int subscriptionPatientsSlots;
  final String myReferralCode;

  // Messages
  final String? message;
  final String? messageType;

  // Statistics
  final List<String>? totalPatients;

  const UserData({
    required this.id,
    required this.username,
    required this.fullName,
    required this.userId,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.dob,
    this.gender,
    this.waPhoneNumber,
    this.ecName,
    this.ecGender,
    this.ecNum,
    this.ecEmail,
    this.ecRelationship,
    this.nofName,
    this.nofGender,
    this.nofNum,
    this.nofEmail,
    this.nofRelationship,
    this.state,
    this.country,
    this.localGovernmentArea,
    this.ward,
    this.city,
    this.address,
    this.postalCode,
    this.firstName,
    this.lastName,
    this.language = "en",
    this.loginType = "email",
    this.profileImg,
    this.createdAt = "0",
    this.isActive = true,
    this.role = "user",
    this.accountStatus = "pending",
    this.facilityId,
    this.facilityCode,
    this.facilityLevel,
    this.facilityOwnership,
    this.verificationType,
    this.verificationCode,
    this.bankName,
    this.accountNumber,
    this.cardNumber,
    this.medhecoinBalance = 0.0,
    this.totalNairaBalance = 0.0,
    this.subscriptionType = "free",
    this.subscriptionExpirationDate = 0,
    this.subscriptionTotalPatients,
    this.subscriptionPatientsSlots = 0,
    this.myReferralCode = "",
    this.message,
    this.messageType,
    this.totalPatients,
  });

  // Factory constructor to create UserData from a Map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      fullName: map['full_name'] ?? '',
      userId: map['user_id'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      dob: map['dob'],
      gender: map['gender'],
      waPhoneNumber: map['wa_phone_number'],
      ecName: map['ec_name'],
      ecGender: map['ec_gender'],
      ecNum: map['ec_num'],
      ecEmail: map['ec_email'],
      ecRelationship: map['ec_relationship'],
      nofName: map['nof_name'],
      nofGender: map['nof_gender'],
      nofNum: map['nof_num'],
      nofEmail: map['nof_email'],
      nofRelationship: map['nof_relationship'],
      state: map['state'],
      country: map['country'],
      localGovernmentArea: map['local_government_area'],
      ward: map['ward'],
      city: map['city'],
      address: map['address'],
      postalCode: map['postal_code'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      language: map['language'] ?? 'en',
      loginType: map['login_type'] ?? 'email',
      profileImg: map['profile_img'],
      createdAt: map['created_at'] ?? "0",
      isActive: (map['is_active'] ==
          1), // Convert int to bool (1 -> true, 0 -> false)
      role: map['role'] ?? 'user',
      accountStatus: map['account_status'] ?? 'pending',
      facilityId: map['facility_id'],
      facilityCode: map['facility_code'],
      facilityLevel: map['facility_level'],
      facilityOwnership: map['facility_ownership'],
      verificationType: map['verification_type'],
      verificationCode: map['verification_code'],
      bankName: map['bank_name'],
      accountNumber: map['account_number'],
      cardNumber: map['card_number'],
      medhecoinBalance: (map['medhecoin_balance'] ?? 0.0).toDouble(),
      totalNairaBalance: (map['total_naira_balance'] ?? 0.0).toDouble(),
      subscriptionType: map['subscription_type'] ?? 'free',
      subscriptionExpirationDate: map['subscription_expiration_date'] ?? 0,
      subscriptionTotalPatients:
          _stringToList(map['subscription_total_patients']),
      subscriptionPatientsSlots: map['subscription_patients_slots'] ?? 0,
      myReferralCode: map['my_referral_code'] ?? '',
      message: map['message'],
      messageType: map['message_type'],
      totalPatients: _stringToList(map['total_patients']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'user_id': userId,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'dob': dob,
      'gender': gender,
      'wa_phone_number': waPhoneNumber,
      'ec_name': ecName,
      'ec_gender': ecGender,
      'ec_num': ecNum,
      'ec_email': ecEmail,
      'ec_relationship': ecRelationship,
      'nof_name': nofName,
      'nof_gender': nofGender,
      'nof_num': nofNum,
      'nof_email': nofEmail,
      'nof_relationship': nofRelationship,
      'state': state,
      'country': country,
      'local_government_area': localGovernmentArea,
      'ward': ward,
      'city': city,
      'address': address,
      'postal_code': postalCode,
      'first_name': firstName,
      'last_name': lastName,
      'language': language,
      'login_type': loginType,
      'profile_img': profileImg,
      'created_at': createdAt,
      'is_active':
          isActive ? 1 : 0, // Boolean to Integer (0 for false, 1 for true)
      'role': role,
      'account_status': accountStatus,
      'facility_id': facilityId,
      'facility_code': facilityCode,
      'facility_level': facilityLevel,
      'facility_ownership': facilityOwnership,
      'verification_type': verificationType,
      'verification_code': verificationCode,
      'bank_name': bankName,
      'account_number': accountNumber,
      'card_number': cardNumber,
      'medhecoin_balance': medhecoinBalance,
      'total_naira_balance': totalNairaBalance,
      'subscription_type': subscriptionType,
      'subscription_expiration_date': subscriptionExpirationDate,
      'subscription_total_patients': subscriptionTotalPatients?.join(','),
      'subscription_patients_slots': subscriptionPatientsSlots,
      'my_referral_code': myReferralCode,
      'message': message,
      'message_type': messageType,
      'total_patients': totalPatients?.join(','),
    };
  }

  /// Helper method to convert a String or List into a List<String>
  static List<String> _stringToList(dynamic value) {
    if (value is String) {
      return value.split(','); // Split string into list by commas
    } else if (value is Iterable) {
      return List<String>.from(
          value); // Directly convert if it's already a list
    } else {
      return []; // Return an empty list if the value is neither
    }
  }

  @override
  String toString() {
    return 'UserData{id: $id, username: $username, full_name: $fullName, user_id: $userId, email: $email, password: $password, phone_number: $phoneNumber, dob: $dob, gender: $gender, wa_phone_number: $waPhoneNumber, ec_name: $ecName, ec_gender: $ecGender, ec_num: $ecNum, ec_email: $ecEmail, ec_relationship: $ecRelationship, nof_name: $nofName, nof_gender: $nofGender, nof_num: $nofNum, nof_email: $nofEmail, nof_relationship: $nofRelationship, state: $state, country: $country, local_government_area: $localGovernmentArea, ward: $ward, city: $city, address: $address, postal_code: $postalCode, first_name: $firstName, last_name: $lastName, language: $language, login_type: $loginType, profile_img: $profileImg, created_at: $createdAt, is_active: $isActive, role: $role, account_status: $accountStatus, facility_id: $facilityId, facility_code: $facilityCode, facility_level: $facilityLevel, facility_ownership: $facilityOwnership, verification_type: $verificationType, verification_code: $verificationCode, bank_name: $bankName, account_number: $accountNumber, card_number: $cardNumber, medhecoin_balance: $medhecoinBalance, total_naira_balance: $totalNairaBalance, subscription_type: $subscriptionType, subscription_expiration_date: $subscriptionExpirationDate, subscription_total_patients: $subscriptionTotalPatients, subscription_patients_slots: $subscriptionPatientsSlots, my_referral_code: $myReferralCode, message: $message, message_type: $messageType, total_patients: $totalPatients}';
  }
}
