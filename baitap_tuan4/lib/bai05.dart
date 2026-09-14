import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Bai05SC extends StatelessWidget {
  const Bai05SC({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //header
              _buildHeader(),
              const SizedBox(height: 10),
              _buildStatr(),
              const SizedBox(height: 10),
              _buildFind(),
              const SizedBox(height: 10),
              _buildList(),
              const SizedBox(height: 20,),
              _buildTitleList(),
              const SizedBox(height: 10,),
              _buildListDoctor(),
            ],
          ),
        ),
      ),
    );
  }

  //header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            const Text(
              'Mitch Koto',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 167, 247),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.person, color: Colors.black),
        ),
      ],
    );
  }

  //khung bat dau
  Widget _buildStatr() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 249, 164, 235),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 228, 120, 247),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How do you feel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'find out your medical card right now',
                  maxLines: 5,
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7), // Màu tím
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //khung tim kiem
  Widget _buildFind() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 244, 182, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.find_in_page, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              'How can i help you?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //list danh muc bac si
  Widget _buildList() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal, //cho phep keo ngang duoc
        children: [
          _buildDanhMuc(Icons.clean_hands, 'Dentist'),
          const SizedBox(width: 12),
          _buildDanhMuc(Icons.person_outline, 'Surgeon'),
          const SizedBox(width: 12),
          _buildDanhMuc(Icons.medication, 'Pharmacy'),
          const SizedBox(width: 12),
          _buildDanhMuc(Icons.medication, 'Pharmacy'),
          const SizedBox(width: 12),
          _buildDanhMuc(Icons.medication, 'Pharmacy'),
          const SizedBox(width: 12),
          _buildDanhMuc(Icons.medication, 'Pharmacy'),
          const SizedBox(width: 12),
          _buildDanhMuc(Icons.medication, 'Pharmacy'),
          const SizedBox(width: 12),
          _buildDanhMuc(Icons.medication, 'Pharmacy'),
        ],
      ),
    );
  }

  //danh muc
  Widget _buildDanhMuc(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 242, 197, 250),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  //title list doctor
  Widget _buildTitleList()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Doctor List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          'see all',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        )
      ],
    );
  }

  //list danh sach doctor
  Widget _buildListDoctor()
  {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildDoctor(sosao: '4.4', tenBacSi: 'John', kinhNghiem: 'thac si'),
          const SizedBox(width: 5.5,),
          _buildDoctor(sosao: '5', tenBacSi: 'Anna', kinhNghiem: 'Tien Si'),
        ],
      ),
    );
  }

  //the Doctor
  Widget _buildDoctor(
    {
      required String sosao,
      required String tenBacSi,
      required String kinhNghiem,
    }
  )
  {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 195, 254),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 36,
            child: const Icon(Icons.person, size: 40, color: Colors.grey,),
          ),
          const SizedBox(height: 10,),
          //so sao
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rate, color: Colors.amber, size: 16,),
              const SizedBox(width: 4,),
              Text(
                sosao,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
              )
            ],
          ),
          const SizedBox(height: 8,),
          Text(
            tenBacSi,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          // Chuyên ngành
          Text(
            kinhNghiem,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
