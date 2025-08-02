import 'package:equatable/equatable.dart';

class DateEkskulState extends Equatable {
  final DateTime selectedDate;
  final Map<String, int> rekapStatus;
  final bool isLoading;
  final String? error;

  const DateEkskulState({
    required this.selectedDate,
    required this.rekapStatus,
    this.isLoading = false,
    this.error,
  });

  factory DateEkskulState.initial() => DateEkskulState(
        selectedDate: DateTime.now(),
        rekapStatus: const {'H': 0, 'I': 0, 'S': 0, 'A': 0},
      );

  DateEkskulState copyWith({
    DateTime? selectedDate,
    Map<String, int>? rekapStatus,
    bool? isLoading,
    String? error,
  }) {
    return DateEkskulState(
      selectedDate: selectedDate ?? this.selectedDate,
      rekapStatus: rekapStatus ?? this.rekapStatus,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedDate, rekapStatus, isLoading, error];
}
