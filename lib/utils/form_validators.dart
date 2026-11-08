/// Shared form validation that preserves each field's existing error message.
class FormValidators {
  FormValidators._();

  static String? Function(String?) required(String message) {
    return (value) => value!.isEmpty ? message : null;
  }
}
