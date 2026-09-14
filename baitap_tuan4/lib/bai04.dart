import 'package:flutter/material.dart';

class Bai04SC extends StatelessWidget
{
  const Bai04SC({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: 
          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildTitle(),

              const SizedBox(height: 10,),
              _buildInfo(),
              const SizedBox(height: 10,),
              _buildDaiBam(),
              const SizedBox(height: 10,),
              _buildKhungTuongTac(),
              const SizedBox(height: 10,),
              _buildIcon(icon: Icons.bar_chart, title: 'Statistics', subtitle: 'Payment and income', coloricon: Colors.blue),
              const SizedBox(height: 10,),
              _buildIcon(icon: Icons.money_off, title: 'transacsion', subtitle: 'Transacsion History', coloricon: Colors.green),
              const SizedBox(height: 20,),
              _buildFloating(),
            ],
          ),
          ),
        ),
      ),
    );
  }

  //xay dung thanh tieu de
  Widget _buildTitle()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('My Cards',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.black87,),
        )
      ],
    );
  }

  //xay dung khung chua thong tin so tien 
  Widget _buildInfo()
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 138, 42, 235),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance',
            style: TextStyle(
              fontSize: 16,
              fontWeight:FontWeight.normal,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8,),
          const Text(
            '\$5250.25',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold, 
              color: Colors.white,
            ),
          ),

          //Id and date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '12345678',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              const Text(
                '10/12',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  //dai bam chi so
  Widget _buildDaiBam()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 8,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 101, 100, 100),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4,),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4,),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  //khung tuong tac
  Widget _buildKhungTuongTac()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildIconItems(Icons.send, Colors.green, 'Send'),
        _buildIconItems(Icons.payment, Colors.blue, 'Pay'),
        _buildIconItems(Icons.receipt_long, const Color.fromARGB(255, 113, 218, 117), 'Bills'),
      ],
    );
  }

  //khung Item
  Widget _buildIconItems(IconData icon, Color color, String label)
  {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ]
          ),
          child: Icon(icon, color: color, size: 20,),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  //khung button
  Widget _buildIcon(
    {
      required IconData icon,
      required String title,
      required String subtitle,
      required Color coloricon,
    }
  )
  {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: coloricon,size: 28,),
          ),
          SizedBox(width: 8,),
          Expanded(
            child: Column(
              children: [
                Text(
                 title,
                 style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                 ),
                ),
                const SizedBox(height: 5,),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[400],
                  ),
                )
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
  Widget _buildFloating()
  {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 160, 23, 69),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.attach_money,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}