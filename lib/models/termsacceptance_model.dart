class TermsAcceptance {
  int id;
  bool accepted;

  TermsAcceptance({required this.id, required this.accepted});

  Map<String, dynamic> toMap() {
    return {'id': id, 'accepted': accepted ? 1 : 0};
  }

  factory TermsAcceptance.fromMap(Map<String, dynamic> map) {
    return TermsAcceptance(
      id: map['id'],
      accepted: map['accepted'] == 1,
    );
  }
}
