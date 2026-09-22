import 'package:bai_tap_tuan_05/cuuhang.dart';
import 'package:flutter/material.dart';

class Trangchu extends StatelessWidget {
  const Trangchu({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 232, 232),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    "assets/img/logtruong.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Cửu hàng điện thoại",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "140 Lê Trọng Tân, Tân Phú, Hồ Chí Minh",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
              SizedBox(height: 20),
              IconButton(onPressed: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context)=> Cuuhang()),
                );
              }, icon: Icon(Icons.arrow_forward)),
            ],
          ),
        ),
      ),
    );
  }
}
