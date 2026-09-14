import 'package:flutter/material.dart';

class Bai06SC extends StatefulWidget
{
  const Bai06SC({super.key});
  @override
  State<Bai06SC> createState() => _BaiTap06MusicState();
  
}
class _BaiTap06MusicState extends State<Bai06SC> {
  bool isPlaying = false;
  double _progress = 0.6; // Giá trị thanh tiến trình (0.0 -> 1.0)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC), // Nền màu xám xịn chuẩn Neumorphism
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Thanh Top Bar
              _buildTopBar(),

              // 2. Thẻ Album + Thông tin bài hát
              _buildAlbumCard(),

              // 3. Thanh thông số thời gian & các nút phụ
              _buildTimeAndOptions(),

              // 4. Thanh tiến trình nhạc (Progress Bar)
              _buildProgressBar(),

              // 5. Bộ 3 nút bấm điều khiển phát nhạc
              _buildControlButtons(),
            ],
          ),
        ),
      ),
    );
  }
 // 1. Top Bar
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNeumorphicButton(icon: Icons.arrow_back),
        const Text(
          'P L A Y L I S T',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.black54,
          ),
        ),
        _buildNeumorphicButton(icon: Icons.menu),
      ],
    );
  }

  // 2. Thẻ Album và Bài hát
  Widget _buildAlbumCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFFA3B1C6),
            offset: Offset(6, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bìa Album
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/album_cover.jpg', // Đường dẫn tới ảnh của bạn
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.orangeAccent,
                  child: const Center(
                    child: Icon(Icons.music_note, size: 80, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          // Tên bài hát & Icon Yêu thích
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Kota The Friend',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Birdie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // 3. Thời gian và nút Shuffle/Repeat
  Widget _buildTimeAndOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('0:00', style: TextStyle(color: Colors.black54, fontSize: 12)),
          Icon(Icons.shuffle, color: Colors.black54, size: 18),
          Icon(Icons.repeat, color: Colors.black54, size: 18),
          Text('4:22', style: TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }

  // 4. Progress Bar
  Widget _buildProgressBar() {
    return Container(
      height: 14,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFA3B1C6),
            offset: Offset(3, 3),
            blurRadius: 5,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-3, -3),
            blurRadius: 5,
          ),
        ],
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: _progress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF63B865), // Thanh tiến trình màu xanh lá
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // 5. Thanh nút điều khiển (3 nút vuông)
  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNeumorphicButton(
          icon: Icons.skip_previous,
          width: 70,
          height: 60,
        ),
        _buildNeumorphicButton(
          icon: isPlaying ? Icons.pause : Icons.play_arrow,
          width: 100,
          height: 60,
          onTap: () {
            setState(() {
              isPlaying = !isPlaying;
            });
          },
        ),
        _buildNeumorphicButton(
          icon: Icons.skip_next,
          width: 70,
          height: 60,
        ),
      ],
    );
  }

  // Widget tái sử dụng cho Nút bấm phong cách Neumorphic
  Widget _buildNeumorphicButton({
    required IconData icon,
    double width = 45,
    double height = 45,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E5EC),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 6,
            ),
            BoxShadow(
              color: Color(0xFFA3B1C6),
              offset: Offset(4, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black12),
      ),
    );
  }
}