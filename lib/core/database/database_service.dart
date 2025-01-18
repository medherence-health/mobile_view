import 'package:medherence/core/model/models/user_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "tree_db.db");
    final database =
        await openDatabase(databasePath, version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE UserData (id INTEGER PRIMARY KEY, name TEXT, dob TEXT, dod TEXT, image TEXT, fatherId TEXT, motherId TEXT, level INTEGER, spouse INTEGER, treeId TEXT, dateCreated INTEGER, gender TEXT, children INTEGER, personId TEXT, position INTEGER, spouseId TEXT, fcPosition INTEGER, lcPosition INTEGER, lastSCPosition INTEGER, tNOSC INTEGER, tNOPC INTEGER, tNOC INTEGER, adopted INTEGER)');
      db.execute(
          'CREATE TABLE Drugs (id INTEGER PRIMARY KEY, highestLevel INTEGER, lowestLevel INTEGER, image TEXT, familyName TEXT, highestPosition INTEGER, numberOfFamilyMember INTEGER, dateCreated INTEGER, treeId TEXT)');
    });
    return database;
  }

  void addUserData(UserData userData) async {
    final db = await database;

    await db.insert(
      'UserData', // Table name
      {
        'id': userData.id,
        'username': userData.username,
        'fullName': userData.fullName,
        'userId': userData.userId,
        'email': userData.email,
        'password': userData.password,
        'phoneNumber': userData.phoneNumber,
        'dob': userData.dob,
        'gender': userData.gender,
        'waPhoneNumber': userData.waPhoneNumber,
        'ecName': userData.ecName,
        'ecGender': userData.ecGender,
        'ecNum': userData.ecNum,
        'ecEmail': userData.ecEmail,
        'ecRelationship': userData.ecRelationship,
        'nofName': userData.nofName,
        'nofGender': userData.nofGender,
        'nofNum': userData.nofNum,
        'nofEmail': userData.nofEmail,
        'nofRelationship': userData.nofRelationship,
        'state': userData.state,
        'country': userData.country,
        'localGovernmentArea': userData.localGovernmentArea,
        'ward': userData.ward,
        'city': userData.city,
        'address': userData.address,
        'postalCode': userData.postalCode,
        'firstName': userData.firstName,
        'lastName': userData.lastName,
        'language': userData.language,
        'loginType': userData.loginType,
        'profileImg': userData.profileImg,
        'createdAt': userData.createdAt,
        'isActive': userData.isActive
            ? 1
            : 0, // SQLite uses integers for boolean values
        'role': userData.role,
        'accountStatus': userData.accountStatus,
        'facilityId': userData.facilityId,
        'facilityCode': userData.facilityCode,
        'facilityLevel': userData.facilityLevel,
        'facilityOwnership': userData.facilityOwnership,
        'verificationType': userData.verificationType,
        'verificationCode': userData.verificationCode,
        'bankName': userData.bankName,
        'accountNumber': userData.accountNumber,
        'cardNumber': userData.cardNumber,
        'medhecoinBalance': userData.medhecoinBalance,
        'totalNairaBalance': userData.totalNairaBalance,
        'subscriptionType': userData.subscriptionType,
        'subscriptionExpirationDate': userData.subscriptionExpirationDate,
        'subscriptionTotalPatients': userData.subscriptionTotalPatients != null
            ? userData.subscriptionTotalPatients!
                .join(',') // Convert list to comma-separated string
            : null,
        'subscriptionPatientsSlots': userData.subscriptionPatientsSlots,
        'myReferralCode': userData.myReferralCode,
        'message': userData.message,
        'messageType': userData.messageType,
        'totalPatients': userData.totalPatients != null
            ? userData.totalPatients!
                .join(',') // Convert list to comma-separated string
            : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts
    );
  }

  Future<UserData?> getUserDataById(String userId) async {
    final db = await database;

    try {
      // Query the database to get the user data by userId
      final data = await db
          .rawQuery('SELECT * FROM UserData WHERE userId = ?', [userId]);

      if (data.isNotEmpty) {
        // Map the first result to a UserData object
        return UserData(
          id: data[0]['id'] as int,
          username: data[0]['username'] as String,
          fullName: data[0]['fullName'] as String,
          userId: data[0]['userId'] as String,
          email: data[0]['email'] as String,
          password: data[0]['password'] as String,
          phoneNumber: data[0]['phoneNumber'] as String,
          dob: data[0]['dob'] as String?,
          gender: data[0]['gender'] as String?,
          waPhoneNumber: data[0]['waPhoneNumber'] as String?,
          ecName: data[0]['ecName'] as String?,
          ecGender: data[0]['ecGender'] as String?,
          ecNum: data[0]['ecNum'] as String?,
          ecEmail: data[0]['ecEmail'] as String?,
          ecRelationship: data[0]['ecRelationship'] as String?,
          nofName: data[0]['nofName'] as String?,
          nofGender: data[0]['nofGender'] as String?,
          nofNum: data[0]['nofNum'] as String?,
          nofEmail: data[0]['nofEmail'] as String?,
          nofRelationship: data[0]['nofRelationship'] as String?,
          state: data[0]['state'] as String?,
          country: data[0]['country'] as String?,
          localGovernmentArea: data[0]['localGovernmentArea'] as String?,
          ward: data[0]['ward'] as String?,
          city: data[0]['city'] as String?,
          address: data[0]['address'] as String?,
          postalCode: data[0]['postalCode'] as String?,
          firstName: data[0]['firstName'] as String?,
          lastName: data[0]['lastName'] as String?,
          language: data[0]['language'] as String,
          loginType: data[0]['loginType'] as String,
          profileImg: data[0]['profileImg'] as String?,
          createdAt: data[0]['createdAt'] as String,
          isActive:
              (data[0]['isActive'] as int) == 1, // Convert from int to bool
          role: data[0]['role'] as String,
          accountStatus: data[0]['accountStatus'] as String,
          facilityId: data[0]['facilityId'] as String?,
          facilityCode: data[0]['facilityCode'] as String?,
          facilityLevel: data[0]['facilityLevel'] as String?,
          facilityOwnership: data[0]['facilityOwnership'] as String?,
          verificationType: data[0]['verificationType'] as String?,
          verificationCode: data[0]['verificationCode'] as String?,
          bankName: data[0]['bankName'] as String?,
          accountNumber: data[0]['accountNumber'] as String?,
          cardNumber: data[0]['cardNumber'] as String?,
          medhecoinBalance: data[0]['medhecoinBalance'] as double,
          totalNairaBalance: data[0]['totalNairaBalance'] as double,
          subscriptionType: data[0]['subscriptionType'] as String,
          subscriptionExpirationDate:
              data[0]['subscriptionExpirationDate'] as int,
          subscriptionTotalPatients:
              (data[0]['subscriptionTotalPatients'] as String?)
                  ?.split(','), // Convert comma-separated string back to list
          subscriptionPatientsSlots:
              data[0]['subscriptionPatientsSlots'] as int,
          myReferralCode: data[0]['myReferralCode'] as String,
          message: data[0]['message'] as String?,
          messageType: data[0]['messageType'] as String?,
          totalPatients: (data[0]['totalPatients'] as String?)?.split(','),
        );
      }

      // If no matching user is found, return null
      return null;
    } catch (error) {
      print("Error retrieving user data: $error"); // Log the error
      return null; // Return null if an error occurs
    }
  }

  Future<int> updateUserData(UserData userData) async {
    final db = await database;

    try {
      // Update the UserData table with the provided userData
      int rowsAffected = await db.rawUpdate(
        'UPDATE UserData SET '
        'username = ?, '
        'fullName = ?, '
        'email = ?, '
        'phoneNumber = ?, '
        'dob = ?, '
        'gender = ?, '
        'waPhoneNumber = ?, '
        'ecName = ?, '
        'ecGender = ?, '
        'ecNum = ?, '
        'ecEmail = ?, '
        'ecRelationship = ?, '
        'nofName = ?, '
        'nofGender = ?, '
        'nofNum = ?, '
        'nofEmail = ?, '
        'nofRelationship = ?, '
        'state = ?, '
        'country = ?, '
        'localGovernmentArea = ?, '
        'ward = ?, '
        'city = ?, '
        'address = ?, '
        'postalCode = ?, '
        'firstName = ?, '
        'lastName = ?, '
        'language = ?, '
        'loginType = ?, '
        'profileImg = ?, '
        'createdAt = ?, '
        'isActive = ?, '
        'role = ?, '
        'accountStatus = ?, '
        'facilityId = ?, '
        'facilityCode = ?, '
        'facilityLevel = ?, '
        'facilityOwnership = ?, '
        'verificationType = ?, '
        'verificationCode = ?, '
        'bankName = ?, '
        'accountNumber = ?, '
        'cardNumber = ?, '
        'medhecoinBalance = ?, '
        'totalNairaBalance = ?, '
        'subscriptionType = ?, '
        'subscriptionExpirationDate = ?, '
        'subscriptionTotalPatients = ?, '
        'subscriptionPatientsSlots = ?, '
        'myReferralCode = ?, '
        'message = ?, '
        'messageType = ?, '
        'totalPatients = ? '
        'WHERE userId = ?',
        [
          userData.username,
          userData.fullName,
          userData.email,
          userData.phoneNumber,
          userData.dob,
          userData.gender,
          userData.waPhoneNumber,
          userData.ecName,
          userData.ecGender,
          userData.ecNum,
          userData.ecEmail,
          userData.ecRelationship,
          userData.nofName,
          userData.nofGender,
          userData.nofNum,
          userData.nofEmail,
          userData.nofRelationship,
          userData.state,
          userData.country,
          userData.localGovernmentArea,
          userData.ward,
          userData.city,
          userData.address,
          userData.postalCode,
          userData.firstName,
          userData.lastName,
          userData.language,
          userData.loginType,
          userData.profileImg,
          userData.createdAt,
          userData.isActive ? 1 : 0, // Convert boolean to int
          userData.role,
          userData.accountStatus,
          userData.facilityId,
          userData.facilityCode,
          userData.facilityLevel,
          userData.facilityOwnership,
          userData.verificationType,
          userData.verificationCode,
          userData.bankName,
          userData.accountNumber,
          userData.cardNumber,
          userData.medhecoinBalance,
          userData.totalNairaBalance,
          userData.subscriptionType,
          userData.subscriptionExpirationDate,
          userData.subscriptionTotalPatients
              ?.join(','), // Convert list to comma-separated string
          userData.subscriptionPatientsSlots,
          userData.myReferralCode,
          userData.message,
          userData.messageType,
          userData.totalPatients
              ?.join(','), // Convert list to comma-separated string
          userData.userId,
        ],
      );

      return rowsAffected; // Return the number of rows updated
    } catch (error) {
      print("Error updating user: $error"); // Log the error
      return 0; // Return 0 if an error occurs
    }
  }

  void deleteTree(UserData userData) async {
    final db = await database;

    try {
      // Use a parameterized query to delete the user data by userId
      int rowsAffected = await db.rawDelete(
        'DELETE FROM UserData WHERE userId = ?',
        [userData.userId],
      );

      if (rowsAffected > 0) {
        print('Successfully deleted user with ID: ${userData.userId}');
      } else {
        print('No user found with ID: ${userData.userId}');
      }
    } catch (error) {
      print("Error deleting user: $error"); // Log the error for debugging
    }
  }
}
