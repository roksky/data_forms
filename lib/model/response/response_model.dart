class FormResponse<T> {
  T value;
  ResponseType responseType;

  FormResponse({required this.value, required this.responseType});
}

enum ResponseType { string, float, double, fileUrl }
