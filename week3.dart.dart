// week 3
//Library Desk Assistant.
// name:Humaira Nadeem
// roll no: 04072313009
final List<Map<String, dynamic>> books = [
  {
    'title': 'Dart in Action',
    'author': 'Ada',
    'year': 2021,
    'copies': 3,
    'tags': ['dart', 'programming'],
  },
  {
    'title': 'Flutter Basics',
    'author': 'Sam',
    'year': 2023,
    'copies': 0,
    'tags': ['flutter', 'mobile'],
  },
  {
    'title': 'Clean Code',
    'author': 'Martin',
    'year': 2008,
    'copies': 2,
    'tags': ['programming', 'design'],
  },
  {
    'title': 'Algorithms',
    'author': 'Knuth',
    'year': 1968,
    'copies': 1,
    'tags': ['programming', 'math'],
  },
  {
    'title': 'UI Design',
    'author': 'Nora',
    'year': 2019,
    'copies': 4,
    'tags': ['design', 'mobile'],
  },
];

double lateFee(int daysLate, double ratePerDay) => daysLate * ratePerDay;

String formatTitle(String title, [String? author]) {
  if (author == null) {
    return title;
  }
  return '$title by $author';
}

Map<String, dynamic> makeBook({
  required String title,
  required String author,
  int year = 2024,
  int copies = 1,
}) {
  return {'title': title, 'author': author, 'year': year, 'copies': copies};
}

bool isClassic(int year) => year < 2000;

// part2
// Because desk1 and desk2 are completely independent desk1() only increments its own counter and desk2 to start from 0 and return 1.

List<String> transformAll(List<String> items, String Function(String) fn) {
  return items.map(fn).toList();
}

int Function() makeCounter() {
  int count = 0;

  return () {
    count++;
    return count;
  };
}

double Function(int) makeFeeCalculator(double rate) {
  return (int days) => days * rate;
}

int sumDigits(int n) {
  if (n < 10) {
    return n;
  }

  return (n % 10) + sumDigits(n ~/ 10);
}

//part3

Map<String, int> buildStock() {
  return {
    for (var book in books) book['title'] as String: book['copies'] as int,
  };

  final availableUsingFilter = filterBy(
    books,
    (book) => (book['copies'] as int) > 0,
  );

  final availableTitlesUsingFilter = availableUsingFilter
      .map((book) => book['title'] as String)
      .toList();

  print('Available using filterBy: $availableTitlesUsingFilter');
}

//part4 classes
class Box<T> {
  T value;

  Box(this.value);
}

// Task 4.2: Generic function

T firstOr<T>(List<T> items, T fallback) {
  if (items.isNotEmpty) {
    return items.first;
  }

  return fallback;
}

class Pair<A, B> {
  A first;
  B second;

  Pair(this.first, this.second);

  String toString() {
    return '($first, $second)';
  }
}
//part5
//custom exception

class BookNotFoundException implements Exception {
  final String title;

  BookNotFoundException(this.title);
}

class BookNotAvailableException implements Exception {
  final String title;

  BookNotAvailableException(this.title);
}

void checkOut(Map<String, int> stock, String title) {
  if (!stock.containsKey(title)) {
    throw BookNotFoundException(title);
  }

  if (stock[title]! <= 0) {
    throw BookNotAvailableException(title);
  }

  stock[title] = stock[title]! - 1;
}

Map<String, dynamic> findBook(String title) {
  return books.firstWhere((book) => book['title'] == title);
}

//part6 async fucntions

Future<String> fetchBookOfTheDay() async {
  await Future.delayed(const Duration(seconds: 1));

  return 'Dart in Action';
}

Future<String> fetchBroken() async {
  await Future.delayed(const Duration(milliseconds: 500));

  throw Exception('Server down');
}

Map<String, List<String>> groupTitlesByTag() {
  final result = <String, List<String>>{};

  for (final book in books) {
    final title = book['title'] as String;
    final tags = book['tags'] as List<String>;

    for (final tag in tags) {
      result.putIfAbsent(tag, () => []).add(title);
    }
  }

  return result;
}

List<T> filterBy<T>(List<T> items, bool Function(T) test) {
  return items.where(test).toList();
}
//void main

void main() async {
  part1();
  part2();
  part3();
  part4();
  part5();
  await part6();
}

void part1() {
  print('--- Part 1 ---');

  print('Late fee: ${lateFee(5, 0.5)}');

  print(formatTitle('Dart in Action'));
  print(formatTitle('Dart in Action', 'Ada'));

  print(makeBook(title: 'Clean Code', author: 'Martin'));

  print(makeBook(title: 'Algorithms', author: 'Knuth', year: 1968));

  print(isClassic(1968));
  print(isClassic(2021));
}

void part2() {
  print('--- Part 2 ---');

  // Task 2.1
  final titles = ['Dart in Action', 'Clean Code'];

  final upperCaseTitles = transformAll(titles, (title) => title.toUpperCase());

  final excitedTitles = transformAll(titles, (title) => '$title!');

  print(upperCaseTitles);
  print(excitedTitles);

  // Task 2.2
  final desk1 = makeCounter();
  final desk2 = makeCounter();

  print(desk1());
  print(desk1());
  print(desk1());

  print(desk2());

  // Task 2.3
  final studentFee = makeFeeCalculator(0.25);
  final staffFee = makeFeeCalculator(0.10);

  print('Student fee: ${studentFee(4)}');
  print('Staff fee: ${staffFee(4)}');

  // Task 2.4
  print('Sum of digits: ${sumDigits(125)}');
}

void part3() {
  print('--- Part 3 ---');

  // Task 3.1: map and where
  final titles = books.map((book) => book['title'] as String).toList();

  final available = books
      .where((book) => (book['copies'] as int) > 0)
      .map((book) => book['title'] as String)
      .toList();

  print('Titles: $titles');
  print('Available: $available');

  // Task 3.2: fold
  final totalCopies = books.fold<int>(
    0,
    (sum, book) => sum + (book['copies'] as int),
  );

  final years = books.map((book) => book['year'] as int).toList();

  final oldestYear = years.reduce(
    (oldest, year) => year < oldest ? year : oldest,
  );

  print('Total copies: $totalCopies');
  print('Oldest year: $oldestYear');

  // Task 3.3: Sorting without changing original books
  final sortedBooks = List<Map<String, dynamic>>.of(books);

  sortedBooks.sort((a, b) => (a['year'] as int).compareTo(b['year'] as int));

  final sortedTitles = sortedBooks
      .map((book) => book['title'] as String)
      .toList();

  print('By year: $sortedTitles');

  // Task 3.4: Map
  final stock = buildStock();

  print('Stock: $stock');

  stock.forEach((title, copies) {
    if (copies == 0) {
      print('Out of stock: $title');
    }
  });

  print('Copies of Unknown: ${stock['Unknown'] ?? 0}');

  // Task 3.5: Set of all tags
  final allTags = <String>{
    for (var book in books) ...(book['tags'] as List<String>),
  };

  print('All tags: $allTags');

  final a = {'Dart in Action', 'Clean Code', 'Flutter Basics'};

  final b = {'Clean Code', 'Flutter Basics', 'Algorithms'};

  print('Union: ${a.union(b)}');
  print('Common: ${a.intersection(b)}');
  print('Only in A: ${a.difference(b)}');
  print('Grouped by tag: ${groupTitlesByTag()}');
}

void part4() {
  print('--- Part 4 ---');

  // Task 4.1
  final intBox = Box<int>(5);
  final stringBox = Box<String>('dart');

  print('Box<int>: ${intBox.value}');
  print('Box<String>: ${stringBox.value}');

  // Task 4.2
  print(firstOr(['Dart in Action', 'Clean Code'], 'none'));

  print(firstOr<String>([], 'z'));

  // Task 4.3
  print(Pair<String, int>('Dart in Action', 3));
}

void part5() {
  print('--- Part 5 ---');

  final stock = buildStock();

  final titles = ['Dart in Action', 'Flutter Basics', 'Unknown Book'];

  for (final title in titles) {
    try {
      checkOut(stock, title);

      print('Checked out: $title');
    } on BookNotAvailableException {
      print('Sorry: "$title" has no copies left');
    } on BookNotFoundException {
      print('Not found: "$title"');
    } finally {
      print('Transaction logged.');
    }
  }

  print('Copies left of Dart in Action: ${stock['Dart in Action']}');

  // Task 5.4: StateError
  try {
    findBook('Missing');
  } catch (e) {
    if (e is StateError) {
      print('Search failed: no such book');
    }
  }
}

Future<void> part6() async {
  print('--- Part 6 ---');

  // Task 6.1
  print('Fetching...');

  final book = await fetchBookOfTheDay();

  print('Book of the day: $book');

  // Task 6.3
  try {
    await fetchBroken();
  } catch (e) {
    print('Fetch failed: $e');
  }
}

//reflection here

// 1. When to choose fold over reduce?
// Choose fold when handling empty collections and when a initial value/type is required.

// 2. What does variable "capturing" mean in a closure, and what was captured in makeCounter?
// Capturing means a closure still having access to variables. In makeCounter, it captured `count`.

// 3. Why must specific exceptions come before general catch blocks?
// Dart evaluates handlers from top-to-bottom; catch first would intercept
// 4. Why does omitting await compile but return wrong results?
// Omitting await returns the `Future` object itself rather than resolving to its underlying `String` value.
