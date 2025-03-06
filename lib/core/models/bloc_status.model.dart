enum BlocStatus {
  initial,
  loading,
  success,
  error;

  bool get isLoading => this == BlocStatus.loading;
  bool get isSuccess => this == BlocStatus.success;
  bool get isError => this == BlocStatus.error;
  bool get isInitial => this == BlocStatus.initial;
}
