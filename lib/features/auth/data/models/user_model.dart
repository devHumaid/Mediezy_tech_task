class UserModel {
  final String? token;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobileNumber;
  final String? role;
  final String? location;

  UserModel({
    this.token,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.role,
    this.location,
  });

  String get fullName =>
      '${firstName ?? ''} ${lastName ?? ''}'.trim();

factory UserModel.fromJson(Map<String, dynamic> json) {
  final data = json['user'] ?? json['data'] ?? json;  
  return UserModel(
    token:        json['token'],
    userId:       data['user_id']?.toString(),        
    firstName:    data['first_name'],
    lastName:     data['last_name'],
    email:        data['email'],
    mobileNumber: data['mobile_number'],
    role:         data['role'] ?? data['designation'],
    location:     data['location'],
  );
}

  Map<String, dynamic> toJson() => {
        'token':         token,
        'user_id':       userId,
        'first_name':    firstName,
        'last_name':     lastName,
        'email':         email,
        'mobile_number': mobileNumber,
        'role':          role,
        'location':      location,
      };
}