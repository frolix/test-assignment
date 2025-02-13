import 'package:flutter/material.dart';
import '../../data/models/cell_type_style.dart';

class ResultDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultDetailsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final field =
        (result['field'] as List<dynamic>).map((e) => e as String).toList();
    final pathString = result['result']['path'] as String;
    final gridSize = field.length;

    final path = _parsePath(pathString);

    final startCell = '(${path.first['x']},${path.first['y']})';
    final endCell = '(${path.last['x']},${path.last['y']})';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                final row = index ~/ gridSize;
                final col = index % gridSize;
                final cell = '($row,$col)';

                final cellColor = _getCellColor(
                  cell,
                  startCell,
                  endCell,
                  path,
                  field,
                );

                return _buildCell(cell, cellColor);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Path: ${path.map((step) => '(${step['x']},${step['y']})').join(' -> ')}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, int>> _parsePath(String pathString) {
    return pathString.split('->').map((step) {
      final coords = step.replaceAll('(', '').replaceAll(')', '').split(',');
      return {
        'x': int.parse(coords[0]),
        'y': int.parse(coords[1]),
      };
    }).toList();
  }

  Color _getCellColor(String cell, String startCell, String endCell,
      List<Map<String, int>> path, List<String> field) {
    final row = int.parse(cell.split(',')[0].replaceAll('(', ''));
    final col = int.parse(cell.split(',')[1].replaceAll(')', ''));

    if (cell == startCell) {
      return CellStyles.colors[CellType.start]!;
    } else if (cell == endCell) {
      return CellStyles.colors[CellType.end]!;
    } else if (path.any((step) => step['x'] == row && step['y'] == col)) {
      return CellStyles.colors[CellType.path]!;
    } else if (field[row][col] == 'X') {
      return CellStyles.colors[CellType.blocked]!;
    }
    return CellStyles.colors[CellType.empty]!;
  }

  Widget _buildCell(String cell, Color cellColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: cellColor,
      ),
      child: Center(
        child: Text(
          cell,
          style: TextStyle(
            color: cellColor == CellStyles.colors[CellType.blocked]
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
