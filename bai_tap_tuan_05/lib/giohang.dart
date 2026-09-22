import 'package:bai_tap_tuan_05/functions.dart';
import 'package:bai_tap_tuan_05/phone.dart';
import 'package:flutter/material.dart';

class Giohang extends StatefulWidget {
  final List<Phone> DsGioHang;
  const Giohang({super.key, required this.DsGioHang});
  @override
  State<Giohang> createState() => _GioHangState();
}

class _GioHangState extends State<Giohang> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Gio Hang cua ban"),
        backgroundColor: const Color.fromARGB(255, 255, 204, 129),
      ),
      body: Column(
        children: [
          Center(child: Text("Gio hang cua ban")),
          Expanded(
            child: ListView.builder(
              itemCount: widget.DsGioHang.length,
              itemBuilder: (context, index) {
                return buildBoxGioHang(
                  widget.DsGioHang[index].ten,
                  widget.DsGioHang[index].gia,
                  () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("THÔNG BÁO"),
                          content: Text("Bạn chắc chắn muốn xóa"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  widget.DsGioHang.removeAt(index);
                                });
                                Navigator.pop(context);
                              },
                              child: Text("Xác nhận"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Hủy"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 100,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context)
            {
              return AlertDialog(
                title: Text("Thông báo"),
                content: Text("Xác nhận thanh toán"),
                actions: [
                  TextButton(onPressed: ()
                  {
                    setState(() {
                      widget.DsGioHang.clear();
                    });
                    Navigator.pop(context);
                  }, child: Text("Xác Nhận thanh toán")),
                  TextButton(onPressed: 
                  ()
                  {
                    Navigator.pop(context);
                  }, child: Text("Hủy"))
                ],
              );
            });
          },
          tooltip: "Thêm mới",
          child: Text("Thanh Toán", textAlign: TextAlign.center,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
