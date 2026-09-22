import 'package:flutter/material.dart';

Widget buildBoxSanPham(String tensanpham, String hinhanh, String subtitle, String price, VoidCallback onPressed)
{
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white,
      
    ),
    child: Column(
      children: [
        Image.asset(hinhanh, height: 200, width: 200, fit: BoxFit.contain,),
        Text(tensanpham,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        ),
        Text(subtitle, 
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w100,
        ),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(price,
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w100,
            ),),
            IconButton(onPressed: onPressed, icon: Icon(Icons.add)),
          ],
        )
      ],
    ),
  );
}

Widget buildBoxGioHang(String ten, String gia, VoidCallback onPressed)
{
  return Container(
    child: ListTile(
      title: Text(ten, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      subtitle: Text(gia, style: TextStyle(fontWeight: FontWeight.w200, fontSize: 10),),
      trailing: IconButton(onPressed: onPressed, icon: Icon(Icons.delete)),
    ),
  );
}