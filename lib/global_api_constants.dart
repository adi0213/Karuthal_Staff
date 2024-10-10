const String baseUrl = 'http://104.237.9.211:8007/karuthal/api/v1';
//const String baseUrl = 'http://localhost:8007/karuthal/api/v1';

String loginUrl() {
  return '$baseUrl/usermanagement/login';
}

String registerCustomerUrl() {
  return '$baseUrl/persona/regcustomer';
}

String getStudentsUrl() {
  return '$baseUrl/persona/students';
}


String getBookingRequestsUrl() {
  return '$baseUrl/bookingrequest';
}



