String toTitleCase(String input) {
  if (input.isEmpty) {
    return '';
  }

  final List<String> words = input.split(' ');
  final List<String> capitalizedWords = [];

  for (final word in words) {
    if (word.isNotEmpty) {
      final String capitalizedWord = word[0].toUpperCase() + word.substring(1);
      capitalizedWords.add(capitalizedWord);
    }
  }

  return capitalizedWords.join(' ');
}
