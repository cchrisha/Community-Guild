// lib/repository/change_password_repository.dart
class ChangePasswordRepository {
  Future<void> changePassword(String oldPassword, String newPassword) async {
    // Simulate password change process (call API or logic here)
    await Future.delayed(const Duration(seconds: 2));

    if (oldPassword != "currentPassword") {
      throw Exception("Old password is incorrect.");
    }

    // Assuming the password change is successful
  }
}
