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
