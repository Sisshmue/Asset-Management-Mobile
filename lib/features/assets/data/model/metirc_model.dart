class Metric {
  final Map<String, int> counts;

  Metric({required this.counts});

  factory Metric.fromJson(Map<String, dynamic> json) {
    return Metric(
      counts: json.map((key, value) => MapEntry(key, value as int)),
    );
  }
}
