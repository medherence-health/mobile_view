import 'package:medherence/core/model/models/user_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  // Singleton pattern to ensure only one database instance is used
  Future<Database> get database async {
    _db ??=
        await _initializeDatabase(); // If _db is null, initialize the database
    return _db!;
  }

  // Initialize the database and create the tables if not already done
  Future<Database> _initializeDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "medherence_db.db");

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Handle database schema changes for version 2 or higher
          // Example: db.execute('ALTER TABLE ...')
        }
      },
    );
  }

  // Create all tables
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE UserData (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        fullName TEXT,
        userId TEXT UNIQUE,
        email TEXT,
        password TEXT,
        phoneNumber TEXT,
        dob TEXT,
        gender TEXT,
        waPhoneNumber TEXT,
        ecName TEXT,
        ecGender TEXT,
        ecNum TEXT,
        ecEmail TEXT,
        ecRelationship TEXT,
        nofName TEXT,
        nofGender TEXT,
        nofNum TEXT,
        nofEmail TEXT,
        nofRelationship TEXT,
        state TEXT,
        country TEXT,
        localGovernmentArea TEXT,
        ward TEXT,
        city TEXT,
        address TEXT,
        postalCode TEXT,
        firstName TEXT,
        lastName TEXT,
        language TEXT,
        loginType TEXT,
        profileImg TEXT,
        createdAt TEXT,
        isActive INTEGER,  -- Store boolean as INTEGER (0 for false, 1 for true)
        role TEXT,
        accountStatus TEXT,
        facilityId TEXT,
        facilityCode TEXT,
        facilityLevel TEXT,
        facilityOwnership TEXT,
        verificationType TEXT,
        verificationCode TEXT,
        bankName TEXT,
        accountNumber TEXT,
        cardNumber TEXT,
        medhecoinBalance REAL,
        totalNairaBalance REAL,
        subscriptionType TEXT,
        subscriptionExpirationDate INTEGER,
        subscriptionTotalPatients TEXT,  -- Can store as a comma-separated list or JSON
        subscriptionPatientsSlots INTEGER,
        myReferralCode TEXT,
        message TEXT,
        messageType TEXT,
        totalPatients TEXT  -- Can store as a comma-separated list or JSON
      );
    ''');
  }

  Future<String> insertUserData(UserData userData) async {
    try {
      // Get a reference to the database.
      final db = await database;

      // Insert the user data into the table, replacing any existing data with the same `userId`.
      await db.insert(
        'UserData',
        userData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return 'OK'; // Return success message on successful insertion.
    } catch (error) {
      // Log the error and return a failure message.
      print('Error inserting user data: $error');
      return 'Error: Unable to insert user data.';
    }
  }

  Future<UserDataResult> getUserDataById(String userId) async {
    final db = await database;

    try {
      // Query the database to retrieve user data by userId
      final data = await db.query(
        'UserData',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      // Check if any data was returned
      if (data.isNotEmpty) {
        // Map the first result to a UserData object using a factory method
        return UserDataResult(
            userData: UserData.fromMap(data.first), message: "OK");
      }

      // If no matching user is found, return null
      return UserDataResult(userData: null, message: "User not found");
    } catch (error) {
      // Log the error for debugging purposes
      print("Error retrieving user data for userId=$userId: $error");
      return UserDataResult(
          userData: null,
          message: "Error retrieving user data for userId=$userId: $error");
    }
  }

  Future<String> updateUserData(UserData userData) async {
    try {
      // Get a reference to the database.
      final db = await database;

      // Attempt to update the user data.
      final rowsUpdated = await db.update(
        'UserData',
        userData.toMap(),
        where: 'userId = ?',
        whereArgs: [userData.userId],
      );

      // Check if any rows were updated.
      if (rowsUpdated > 0) {
        return 'OK'; // Update was successful.
      } else {
        return 'Error: No matching user found to update.';
      }
    } catch (error) {
      // Handle errors during the update process.
      print('Error updating user data: $error');
      return 'Error: Unable to update user data.';
    }
  }

  Future<String> deleteTree(UserData userData) async {
    final db = await database;

    try {
      // Use a parameterized query to delete the user data by userId
      int rowsAffected = await db.rawDelete(
        'DELETE FROM UserData WHERE userId = ?',
        [userData.userId],
      );

      if (rowsAffected > 0) {
        // If rows were affected, the deletion was successful
        return 'OK';
      } else {
        // If no rows were affected, the user was not found
        return 'No user found with ID: ${userData.userId}';
      }
    } catch (error) {
      // Catch any error that occurs during the deletion
      print("Error deleting user: $error"); // Log the error for debugging
      return 'Error: $error';
    }
  }
}

class UserDataResult {
  final UserData? userData;
  final String message;

  UserDataResult({this.userData, required this.message});
}
