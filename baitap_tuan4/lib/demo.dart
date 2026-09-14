import 'package:flutter/material.dart';

//tao lop
class Bai01Screen extends StatelessWidget
{
  const Bai01Screen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo", style: TextStyle(fontSize: 18, color: Colors.white),),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Stack(//stack dung sap xep layout theo truc z
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(image: AssetImage('assets/images/dong_phong_nha.jpg'), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 20,
            left: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 10,),
                  Text(
                    "Dong Phong Nha", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Dong Phong Nha nam trong vuon quoc gia phong nha ke bang, tinh Quang Binh, la Hang dong lon nhat the gioi",
                      maxLines: 4,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}