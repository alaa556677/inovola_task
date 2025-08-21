class Failure {
  String errorMessage;
  int? statusCode;
  Failure(this.errorMessage , {this.statusCode = 200});
}