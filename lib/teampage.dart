// 팀소개 페이지
import 'package:flutter/material.dart';

class Team extends StatelessWidget {
  const Team({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return teampage();
  }
}

class teampage extends StatelessWidget {
  const teampage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          '또래또래를 소개합니다',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset('images/8team.png'),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 70,
              child: Card(
                child: Center(
                  child: Text(
                    '팀 목표 : 프로젝트 끝까지 잘 마무리하기!',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                color: Colors.pink.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 100,
              child: Card(
                child: Center(
                  child: Text(
                    '팀 특징 : 비슷한 또래들끼리 모여 또래또래가 되었다.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                color: Color.fromARGB(255, 129, 229, 170),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 200,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '우리팀 약속',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '• Git Merge는 매일 6시에 하기',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '• 식사시간은 점심 PM 1:00, 저녁 PM 6:00',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '• 매일 2시간 이상 수강 및 복습 후 팀프로젝트 참여하기',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                color: Colors.blue.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
