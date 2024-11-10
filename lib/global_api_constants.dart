//const String baseUrl = 'http://104.237.9.211:8007/karuthal/api/v1';
const String baseUrl = 'http://localhost:8007/karuthal/api/v1';

String loginUrl() {
  return '$baseUrl/usermanagement/login';
}

String registerCustomerUrl() {
  return '$baseUrl/persona/regcustomer';
}

String getStudentsUrl() {
  return '$baseUrl/persona/students';
}


String getServicesUrl() {
  return '$baseUrl/metadata/services';
}

String getBookingRequestsUrl() {
  return '$baseUrl/bookingrequest';
}

String getSignupUrl() {
  return '$baseUrl/persona/signup';
}

String getStudentUpdateUrl(){
  return '$baseUrl/staff/students/';
}

String getPatientsForStudentUrl(){
  return '$baseUrl/staff/patientsforstudent';
}


String getBRequestsForStudentUrl(){
  return '$baseUrl/bookingrequest/student';
}

String getWorkLogUrl(){
  return '$baseUrl/worklog';
}

String getUnifinishedWorkLogUrl(){
  return '$baseUrl/worklog/unfinished/student';
}

String getAssignStudentUrl(){
  return '$baseUrl/staff/assignstudents';
}

String getPendingRoleRequest(){
  return '$baseUrl/rolerequest/pending';
}

String updatePendingRoleRequest(){
  return '$baseUrl/rolerequest/update-status';
}

String getChangePasswordOtpUrl(){
  return '$baseUrl/email/sendpasswordchangeotp';
}

