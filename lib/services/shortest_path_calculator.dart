import 'dart:collection';

class ShortestPathCalculator {
  // Основний метод
  List<Map<String, int>> findShortestPath(
      List<String> field, Map<String, int> start, Map<String, int> end) {
    final rows = field.length;
    final cols = field[0].length;

    // Перетворюємо рядки в список символів
    final grid = field.map((row) => row.split("")).toList();

    // Напрямки руху (вгору, вниз, вліво, вправо і по діагоналі)
    const directions = [
      [0, 1], [1, 0], [0, -1], [-1, 0], // Прямі напрямки
      [-1, -1], [-1, 1], [1, -1], [1, 1] // Діагональні напрямки
    ];

    // Масив для збереження відстаней
    final dist = List.generate(rows, (_) => List.filled(cols, double.infinity));
    dist[start['x']!][start['y']!] = 0; // Встановлюємо початкову відстань

    // Збереження попередньої клітинки для відновлення шляху
    final previous = <String, String?>{};

    // Черга для BFS
    final queue = Queue<List<int>>();
    queue.add([start['x']!, start['y']!]); // Додаємо початкову точку

    // Пошук шляху
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      final x = current[0], y = current[1];

      // Якщо дійшли до кінцевої точки
      if (x == end['x'] && y == end['y']) {
        return _reconstructPath(previous, end);
      }

      // Перевіряємо всі сусідні клітинки
      for (final direction in directions) {
        final newX = x + direction[0];
        final newY = y + direction[1];

        // Перевірка, чи можна рухатись у цю клітинку
        if (_isValidMove(newX, newY, rows, cols, grid) &&
            dist[newX][newY] > dist[x][y] + 1) {
          dist[newX][newY] = dist[x][y] + 1; // Оновлюємо відстань
          queue.add([newX, newY]); // Додаємо нову точку в чергу
          previous["$newX,$newY"] = "$x,$y"; // Запам'ятовуємо, звідки прийшли
        }
      }
    }

    // Якщо шлях не знайдено, повертаємо порожній список
    return [];
  }

  // Метод для перевірки валідності клітинки
  bool _isValidMove(int x, int y, int rows, int cols, List<List<String>> grid) {
    return x >= 0 &&
        y >= 0 &&
        x < rows &&
        y < cols &&
        grid[x][y] != "X"; // Перевіряємо, що клітинка не є стіною
  }

  // Метод для відновлення шляху
  List<Map<String, int>> _reconstructPath(
      Map<String, String?> previous, Map<String, int> end) {
    final path = <Map<String, int>>[];
    String? currentKey = "${end['x']},${end['y']}";

    // Відновлюємо шлях, поки є попередня точка
    while (currentKey != null) {
      final parts = currentKey.split(",");
      path.insert(0, {"x": int.parse(parts[0]), "y": int.parse(parts[1])});
      currentKey = previous[currentKey];
    }

    return path;
  }
}
