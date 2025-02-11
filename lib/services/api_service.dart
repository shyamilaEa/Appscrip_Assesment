import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/users";

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw HttpException("Failed to fetch users. Error ${response.statusCode}");
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception("No internet connection. Please check your network.");
      } else if (e is HttpException) {
        throw Exception("Server error. Please try again later.");
      } else if (e is FormatException) {
        throw Exception("Invalid response from server.");
      } else {
        throw Exception("Something went wrong. Please try again.");
      }
    }
  }
}
