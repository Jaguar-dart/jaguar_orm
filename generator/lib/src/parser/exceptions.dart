class FieldParseException implements Exception {
  dynamic inner;

  String fieldName;

  String message;

  StackTrace trace;

  FieldParseException(this.fieldName, this.inner, this.trace, {this.message});

  String toString() {
    var sb = StringBuffer();
    sb.writeln('Exception while parsing field: $fieldName!');
    if (message != null) {
      sb.writeln("Message: $message");
    }
    sb.writeln(inner);
    sb.writeln(trace);
    return sb.toString();
  }
}