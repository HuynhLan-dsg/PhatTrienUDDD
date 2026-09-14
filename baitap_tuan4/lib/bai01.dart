import 'package:flutter/material.dart';

class BaiTapCalculator extends StatefulWidget
{
  const BaiTapCalculator({super.key});
  @override
  State<BaiTapCalculator> createState() => _BaiCalculatorState();
}
class _BaiCalculatorState extends State<BaiTapCalculator>
{
  String _input = '0';
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Standar"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: (){},
          )
        ],
      ),

      //drawer tao menu chon che do 
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(child: Text(
              "Calculator", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text("Standard"),
              selected: true,
            ),
            ListTile(
              leading: Icon(Icons.science),
              title: Text("Scientific"),
            ),
            ListTile(
              leading: Icon(Icons.show_chart),
              title: Text("Graphing"),
            ),
            ListTile(
              leading: Icon(Icons.code),
              title: Text("Programmer"),
            ),
          ],
        ),
      ),
      body: Column(
        children: [

          //Man hinh hien thi so
          Expanded( //dung de chiem het cac phan khong gian con lai
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _input,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildButtonGrid(),
        ],
      ),
    );
  }
  Widget _buildButtonGrid()
  {
    final List<List<String>> button = [
      ['MC', 'MR', 'M+', 'M-', 'MS', 'M^'],
      ['%', 'CE', 'C', 'DEL'],
      ['1/x','X^2', 'Sqrt(X)', '/'],
      ['7', '8', '9', 'x'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['+/-', '0', '.', '='],
    ];
    return Column(
      children:button.map((row) {
        return Row(
          children: row.map((text) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: text == '=' ? Colors.blue[700] : Colors.grey[100],
                      foregroundColor: text == '=' ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      elevation: 1,
                    ),
                    onPressed: () {
                      setState(() {
                        if (text == 'C' || text == 'CE') {
                          _input = '0';
                        } else if (_input == '0') {
                          _input = text;
                        } else {
                          _input += text;
                        }
                      });
                    },
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: text.length > 2 ? 12 : 18,
                        fontWeight: text == '=' ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}