import 'package:flutter/material.dart';

class BaiTap02HUIT extends StatefulWidget {
  const BaiTap02HUIT({super.key});

  @override
  State<BaiTap02HUIT> createState() => _BaiTap02HUITState();
}

class _BaiTap02HUITState extends State<BaiTap02HUIT> {
  // Chỉ số tab hiện tại đang chọn
  int _selectedIndex = 0;

  // Danh sách các trang nội dung tương ứng với từng Tab
  static const List<Widget> _pages = <Widget>[
    // Tab 0: Trang chủ
    Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              "Trường Đại học Công thương TP.HCM",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Chào mừng bạn đến với ứng dụng giới thiệu cơ sở vật chất HUIT!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),

    // Tab 1: Cơ sở vật chất (Hiển thị danh sách các cơ sở)
    SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Danh sách Cơ sở",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: Colors.red),
              title: Text("Cơ sở chính"),
              subtitle: Text("140 Lê Trọng Tấn, P. Tây Thạnh, Q. Tân Phú, TP.HCM"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: Colors.orange),
              title: Text("Cơ sở Thi nghiem"),
              subtitle: Text("247 Nguyễn Sơn, P. Phú Thạnh, Q. Tân Phú, TP.HCM"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: Colors.green),
              title: Text("Cơ sở 2"),
              subtitle: Text("P. Tăng Nhơn Phú B, TP. Thủ Đức, TP.HCM"),
            ),
          ),
        ],
      ),
    ),

    // Tab 2: Liên hệ
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contact_support, size: 70, color: Colors.teal),
          SizedBox(height: 16),
          Text(
            "Thông tin liên hệ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("Email: infor@huit.edu.vn"),
          Text("Website: huit.edu.vn"),
        ],
      ),
    ),
  ];

  // Cập nhật trạng thái khi người dùng nhấn chuyển Tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giới thiệu HUIT"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex], // Hiển thị nội dung tương ứng với tab được chọn
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Cơ sở vật chất',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Liên hệ',
          ),
        ],
      ),
    );
  }
}