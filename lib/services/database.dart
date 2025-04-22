import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserInfo(Map<String, dynamic> userData) async {
    try {
      await _firestore.collection("users").add(userData);
    } catch (e) {
      print("Error adding user info: $e");
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserInfo(String email) async {
    try {
      return await _firestore
          .collection("users")
          .where("userEmail", isEqualTo: email)
          .get();
    } catch (e) {
      print("Error fetching user info: $e");
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchByName(String searchField) async {
    try {
      return await _firestore
          .collection("users")
          .where('userName', isEqualTo: searchField)
          .get();
    } catch (e) {
      print("Error searching user: $e");
      rethrow;
    }
  }

  Future<void> addChatRoom(Map<String, dynamic> chatRoom, String chatRoomId) async {
    try {
      await _firestore.collection("chatRoom").doc(chatRoomId).set(chatRoom);
    } catch (e) {
      print("Error adding chatroom: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(String chatRoomId) {
    return _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, Map<String, dynamic> chatMessageData) async {
    try {
      await _firestore
          .collection("chatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .add(chatMessageData);
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(String userName) {
    return _firestore
        .collection("chatRoom")
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
