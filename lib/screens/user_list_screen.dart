import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/user_card.dart';
import '../widgets/search_bar.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<UserProvider>(context, listen: false).fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final filteredUsers = userProvider.users.where((user) {
      final nameMatch = user.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final emailMatch = user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      return nameMatch || emailMatch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200], // Subtle background color
      appBar: AppBar(
        title: Text(
          "User List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.deepOrangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 6, // Elevated shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
          ),
          Expanded(
            child: userProvider.isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                : userProvider.errorMessage.isNotEmpty
                    ? _buildErrorMessage(userProvider)
                    : RefreshIndicator(
                        onRefresh: () async => userProvider.fetchUsers(),
                        color: Colors.blueAccent,
                        backgroundColor: Colors.white,
                        strokeWidth: 2,
                        child: filteredUsers.isEmpty ? _buildEmptyState() : _buildUserList(filteredUsers),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(UserProvider userProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
          SizedBox(height: 10),
          Text(
            userProvider.errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh, color: Colors.white),
            label: Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => userProvider.fetchUsers(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
  return Center(
    child: Text(
      "No users found",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[700]),
    ),
  );
}


  Widget _buildUserList(List users) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildUserCard(users[index]);
      },
    );
  }

  Widget _buildUserCard(user) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: UserCard(user: user), // Using your custom widget
    );
  }
}
