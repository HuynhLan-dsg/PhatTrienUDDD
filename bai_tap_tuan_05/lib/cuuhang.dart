import 'package:bai_tap_tuan_05/giohang.dart';
import 'package:bai_tap_tuan_05/phone.dart';
import 'package:flutter/material.dart';
import 'package:bai_tap_tuan_05/functions.dart';

class Cuuhang extends StatefulWidget {
  const Cuuhang({super.key});
  @override
  State<Cuuhang> createState() => _CuuHangState();
}

class _CuuHangState extends State<Cuuhang> {
  //Tạo danh sach phone
  List<Phone> dsPhone = [
    Phone(
      ten: "Redmi note 9",
      hinh: "assets/img/redmi1.jpg",
      mota: "điện thoại redmi note 9 pro ",
      gia: "7.000.000 vnd",
    ),
    Phone(
      ten: "Redmi note 15",
      hinh: "assets/img/redmi2.jpg",
      mota: "điện thoại redmi note 15 pro ",
      gia: "10.000.000 vnd",
    ),
    Phone(
      ten: "SamSung galaxy s25",
      hinh: "assets/img/samsung1.jpg",
      mota: "điện thoại samsung s25 ultra ",
      gia: "24.000.000 vnd",
    ),
    Phone(
      ten: "Samsung galaxy s26",
      hinh: "assets/img/samsung2.jpg",
      mota: "điện thoại samsung s26 plus ",
      gia: "19.000.000 vnd",
    ),
  ];

  List<Phone> dsGiohang = [];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Cửa hàng điện thoại: Danh sách giỏ hàng  ${dsGiohang.length}"),
        backgroundColor: const Color.fromARGB(255, 252, 182, 78),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>Giohang(DsGioHang: dsGiohang)));
            },
            icon: Icon(Icons.shopping_cart, size: 35),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 218, 217, 217),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Center(
                child: Text(
                  "Chọn sản phẩm bạn muốn mua",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: [
            //       buildBoxSanPham(
            //         "Điện thoại 1",
            //         "assets/img/redmi1.jpg",
            //         "Điện thoại Xiaomi",
            //         "5.000.000đ",
            //       ),

            //       buildBoxSanPham(
            //         "Điện thoại 2",
            //         "assets/img/redmi2.jpg",
            //         "Điện thoại Xiaomi",
            //         "6.000.000đ",
            //       ),

            //       buildBoxSanPham(
            //         "Điện thoại 3",
            //         "assets/img/samsung1.jpg",
            //         "Điện thoại Samsung",
            //         "7.000.000đ",
            //       ),
            //       buildBoxSanPham(
            //         "Điện thoại 3",
            //         "assets/img/samsung2.jpg",
            //         "Điện thoại Samsung",
            //         "10.000.000đ",
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                itemCount: dsPhone.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return buildBoxSanPham(
                    dsPhone[index].ten,
                    dsPhone[index].hinh,
                    dsPhone[index].mota,
                    dsPhone[index].gia,
                    () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Thông báo"),
                            content: Text("Thêm vào giỏ hàng"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  //hàm setstate sẽ chạy làm hàm build( Buildcontext context), cập nhật lại dữ liệu và vẽ lại giao diện
                                  setState(() {
                                    dsGiohang.add(dsPhone[index]);
                                    
                                  });
                                 Navigator.pop(context); //* thoat khung thong báo
                                },
                                child: Text("Đồng ý"),
                              ),
                              TextButton(onPressed: ()
                              {
                                Navigator.pop(context);
                              }, child: Text("Cancel")),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  "Sản phẩm bán chạy nhất",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 155, 210, 255),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 252, 182, 78),
              ),
              currentAccountPicture: ClipOval(
                child: Image.asset(
                  "assets/img/logtruong.jpg",
                  height: 100,
                  width: 100,
                ),
              ),
              accountName: Text("Huỳnh văn Lân"),
              accountEmail: Text("huynhtai@gmail.com"),
            ),
            ListTile(leading: Icon(Icons.shop), title: Text("Cửa hàng")),
            ListTile(
              leading: IconButton(onPressed: ()
              {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => Giohang(DsGioHang: dsGiohang)));
              }, icon: Icon(Icons.shopping_cart)),
              title: Text("Giỏ hàng"),
            ),
            ListTile(leading: Icon(Icons.logout), title: Text("Đăng xuất")),
          ],
        ),
      ),
    );
  }
}
