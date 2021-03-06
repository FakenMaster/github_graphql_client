import 'package:gql_exec/gql_exec.dart';

class QueryException implements Exception {
  QueryException(this.errors);
  List<GraphQLError> errors;
  @override
  String toString() =>
      'Query Exception: ${errors.map((err) => '$err').join(',')}';
}
