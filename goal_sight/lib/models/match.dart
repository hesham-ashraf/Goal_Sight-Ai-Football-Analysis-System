class Match {
  final int? id;
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final DateTime matchDate;
  final String? notes;

  Match({
    this.id,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.matchDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teamA': teamA,
      'teamB': teamB,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'matchDate': matchDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'] as int?,
      teamA: map['teamA'] as String,
      teamB: map['teamB'] as String,
      scoreA: map['scoreA'] as int,
      scoreB: map['scoreB'] as int,
      matchDate: DateTime.parse(map['matchDate'] as String),
      notes: map['notes'] as String?,
    );
  }

  Match copyWith({
    int? id,
    String? teamA,
    String? teamB,
    int? scoreA,
    int? scoreB,
    DateTime? matchDate,
    String? notes,
  }) {
    return Match(
      id: id ?? this.id,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      matchDate: matchDate ?? this.matchDate,
      notes: notes ?? this.notes,
    );
  }
}

