import 'package:flutter/material.dart';

class BaiTap03SC extends StatelessWidget
{
  const BaiTap03SC({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(// widget tu dong chen vao cho trong
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,//don tat ca qua ben trai
                children: [
                  const SizedBox( height: 20),

                  //hang tieu de
                  _buildHeader(),
                  //ham search
                  _buildSeachBar(),

                  //ham trang thai
                  _buildMoodTitle(),

                  //ham list nhiem vu
                  _buildMoodList(),
                ],
              ),
            ),
            Expanded(child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )
              ),
              child: _buildListTask(),
            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ]),
    );
  }
  Widget _buildHeader()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, Jared!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8,),
            const Text(
              '23 Jan, 2021',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 13,
              ),
            )
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.notification_add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
  Widget _buildSeachBar()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: const Row(
        children: [
        Icon(Icons.search, color: Colors.white,),
        SizedBox(width: 10,),
        Text(
          'Search',
          style: TextStyle(color: Colors.white),
        )
        ]
      ),
    );
  }
  Widget _buildMoodTitle()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const[
        Text(
          'How do you feel?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.more_horiz, color: Colors.white,),
      ],
    );
  }
  Widget _buildMoodList()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       _buildEmtion('😩', 'Bad'),
        _buildEmtion('🥳', 'Fine'),
        _buildEmtion('😌', 'Well'),
        _buildEmtion('😃', 'Excellent'),
      ],
    );
  }
  Widget _buildEmtion(String emoji, String title)
  {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 28),
          ),          
        ),
        const SizedBox(height: 8,),
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget _buildListTask() 
  {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nhiem Vu',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.more_horiz),
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              _buildExerciseCard(icon: Icons.favorite, color: Colors.orange, title: 'Speaking skill', subtitle: '16 execise'),
              _buildExerciseCard(icon: Icons.person, color: Colors.green, title: 'Reading skill', subtitle: '8 execise'),
              _buildExerciseCard(icon: Icons.star, color: Colors.redAccent, title: 'Writting skill', subtitle: '20 execise'),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildExerciseCard(
    {
      required IconData icon,
      required Color color,
      required String title, 
      required String subtitle,
    }
  )
  {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon),
              ),
              const SizedBox(width: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8,),
                  Text(
                    subtitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              )
            ],
          ),
          Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}