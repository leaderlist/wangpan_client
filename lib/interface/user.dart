class UserResponseData {
  final int id;
  final String username;
  final String password;
  final String basePath;
  final List<int> role;
  final bool disabled;
  final int permission;
  final String ssoId;
  final bool otp;
  final List<String> roleNames;
  final List<Permission> permissions;

  const UserResponseData({
    required this.id,
    required this.username,
    required this.password,
    required this.basePath,
    required this.role,
    required this.disabled,
    required this.permission,
    required this.ssoId,
    required this.otp,
    required this.roleNames,
    required this.permissions,
  });

  factory UserResponseData.fromJson(Map<String, dynamic> json) {
    return UserResponseData(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      basePath: json['base_path'] as String,
      role: (json['role'] as List).map((e) => e as int).toList(),
      disabled: json['disabled'] as bool,
      permission: json['permission'] as int,
      ssoId: json['sso_id'] as String,
      otp: json['otp'] as bool,
      roleNames: (json['role_names'] as List).map((e) => e as String).toList(),
      permissions: (json['permissions'] as List)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'base_path': basePath,
      'role': role,
      'disabled': disabled,
      'permission': permission,
      'sso_id': ssoId,
      'otp': otp,
      'role_names': roleNames,
      'permissions': permissions.map((e) => e.toJson()).toList(),
    };
  }
}

class Permission {
  final String path;
  final int permission;

  const Permission({
    required this.path,
    required this.permission,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      path: json['path'] as String,
      permission: json['permission'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'permission': permission,
    };
  }
}

