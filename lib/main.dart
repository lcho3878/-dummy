import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teampage/teampage.dart';
import 'package:teampage/member_Service.dart';
import 'package:image_picker/image_picker.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MemberService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeamProject',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          //(1)
          tabs: <Widget>[
            Tab(icon: Icon(Icons.people), text: "팀"),
            Tab(
              icon: Icon(Icons.person),
              text: "팀원",
            ),
          ],
          indicatorColor: Colors.transparent, // indicator 없애기
          unselectedLabelColor: Colors.grey, // 선택되지 않은 tab 색
          labelColor: Colors.black, // 선택된 tab의 색
        ),
        body: TabBarView(
          children: <Widget>[
            Tab(
              child: Team(),
            ),
            Tab(
              child: TeamMember(),
            ),
          ],
        ),
      ),
    );
  }
}

// 팀원 소개 페이지
class TeamMember extends StatefulWidget {
  const TeamMember({Key? key}) : super(key: key);

  @override
  State<TeamMember> createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMember> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MemberService>(
      builder: (context, MemberService, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '팀원 소개',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.5,
          ),
          body: MemberService.memberlist.isEmpty
              ? Center(
                  child: Text(
                    '팀원을 등록해주세요',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: MemberService.memberlist.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 240,
                      child: Row(
                        children: [
                          Container(
                            height: 240,
                            width: 200,
                            child: GestureDetector(
                              child: Image.file(
                                  File(MemberService
                                      .memberlist[index].imagepath),
                                  fit: BoxFit.cover), //이미지 해결전엔 일단 아무이미지
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MemberDetail(
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  '이름 : ${MemberService.memberlist[index].name}'),
                              Text(
                                  'MBTI : ${MemberService.memberlist[index].mbti}'),
                              Text(
                                  '장점 : ${MemberService.memberlist[index].advantage}'),
                              Text(
                                  '협업스타일 : ${MemberService.memberlist[index].cooperation}'),
                              Text(
                                  '블로그 : ${MemberService.memberlist[index].blog}'),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MemberAdd(index: MemberService.memberlist.length)),
              );
            },
            backgroundColor: Color(0xFFFF7E36),
            elevation: 1,
            child: Icon(
              Icons.add_rounded,
              size: 36,
            ),
          ),
        );
      },
    );
  }
}

//팀원 등록 페이지
class MemberAdd extends StatefulWidget {
  const MemberAdd({
    Key? key,
    required this.index,
  }) : super(key: key);
  final index;

  @override
  State<MemberAdd> createState() => _MemberAddState();
}

class _MemberAddState extends State<MemberAdd> {
  final ImagePicker _picker = ImagePicker();
  PickedFile? _image;
  Future _getImage() async {
    PickedFile? image = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = PickedFile(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MemberService memberService = context.read<MemberService>();

    final nameController = TextEditingController();
    final mbtiController = TextEditingController();
    final advantageController = TextEditingController();
    final cooperationController = TextEditingController();
    final blogController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.backspace,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '팀원 추가하기',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('저장하겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          memberService.memberAdd(
                              memberService,
                              nameController,
                              mbtiController,
                              advantageController,
                              cooperationController,
                              blogController,
                              _image!.path);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text('저장'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              '저장',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Card(
              child: _image == null
                  ? TextButton(
                      onPressed: () {
                        _getImage();
                      },
                      child: Text('사진추가'),
                    )
                  : GestureDetector(
                      child: Image.file(File(_image!.path)),
                      onTap: _getImage,
                    ),
            ),
          ),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          TextFormField(
            controller: mbtiController,
            decoration: const InputDecoration(labelText: 'MBTI'),
          ),
          TextFormField(
            controller: advantageController,
            decoration: const InputDecoration(labelText: '장점'),
          ),
          TextFormField(
            controller: cooperationController,
            decoration: const InputDecoration(labelText: '협업 스타일'),
          ),
          TextFormField(
            controller: blogController,
            decoration: const InputDecoration(labelText: '블로그'),
          ),
        ],
      ),
    );
  }
}

//팀원 상세 설명 페이지
class MemberDetail extends StatefulWidget {
  MemberDetail({super.key, required this.index});
  final int index;

  @override
  State<MemberDetail> createState() => _MemberDetailState();
}

class _MemberDetailState extends State<MemberDetail> {
  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    PickedFile? _image;
    Future _getImage() async {
      PickedFile? image = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        if (image != null) {
          _image = PickedFile(image.path);
        }
      });
    }

    MemberService memberService = context.read<MemberService>();
    Member member = memberService.memberlist[widget.index];

    final nameController = TextEditingController(text: member.name);
    final mbtiController = TextEditingController(text: member.mbti);
    final advantageController = TextEditingController(text: member.advantage);
    final cooperationController =
        TextEditingController(text: member.cooperation);
    final blogController = TextEditingController(text: member.blog);
    // 이미 들어가있는 회원 정보를 기본값으로 받기위해 사용

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.backspace,
              color: Colors.black,
            )),
        title: Text(
          '팀원 소개',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('저장하겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          memberService.memberSave(
                            memberService,
                            widget.index,
                            nameController,
                            mbtiController,
                            advantageController,
                            cooperationController,
                            blogController,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text('저장'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              '저장',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('삭제하겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          memberService.memberDelete(
                              memberService, widget.index);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text('삭제'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              '삭제',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Image.file(
              File(
                member.imagepath,
              ),
            ),
            // 여기도 기본이미지 일단 사용
            width: double.infinity,
            height: 400,
          ),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: '이름'),
          ),
          TextFormField(
            controller: mbtiController,
            decoration: const InputDecoration(labelText: 'MBTI'),
          ),
          TextFormField(
            controller: advantageController,
            decoration: const InputDecoration(labelText: '장점'),
          ),
          TextFormField(
            controller: cooperationController,
            decoration: const InputDecoration(labelText: '협업 스타일'),
          ),
          TextFormField(
            controller: blogController,
            decoration: const InputDecoration(labelText: '블로그'),
          ),
        ],
      ),
    );
  }
}

//팀원 정보 수정 페이지 (이곳은 건든 부분 없음)
class MemberAdjust extends StatelessWidget {
  const MemberAdjust({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('이곳은 팀원 정보 수정 페이지입니다'),
          ],
        ),
      ),
    );
  }
}
