class Person implements Comparable {
  final int id;
  final String firstName;
  final String lastName;
  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  @override
  int compareTo(covariant Person other) => other.id.compareTo(id);

  @override
  bool operator ==(covariant Person other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode => id.hashCode ^ firstName.hashCode ^ lastName.hashCode;

  @override
  String toString() =>
      'Person(id: $id, firstName: $firstName, lastName: $lastName)';

  Person.fromRow(Map<String, Object?> row)
      : id = row['ID'] as int,
        firstName = row['FIRST_NAME'] as String,
        lastName = row['LAST_NAME'] as String;
}
