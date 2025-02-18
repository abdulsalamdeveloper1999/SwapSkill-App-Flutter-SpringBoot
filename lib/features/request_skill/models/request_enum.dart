enum RequestStatus {
  pending,
  accepted,
  rejected,
  cancelled;

  String toApiString() {
    return name.toUpperCase(); // Convert to uppercase to match backend
  }

  static RequestStatus fromString(String status) {
    return RequestStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == status.toUpperCase(),
        orElse: () => RequestStatus.pending);
  }
}
