import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';

// Memo 데이터의 형식을 정해줍니다. 추후 isPinned, updatedAt 등의 정보도 저장할 수 있습니다.
class Member {
  Member({
    required this.name,
    required this.mbti,
    required this.advantage,
    required this.cooperation,
    required this.blog,
    required this.imagepath,
  });

  String name;
  String mbti;
  String advantage;
  String cooperation;
  String blog;
  String imagepath;

  Map toJson() {
    return {
      'name': name,
      'mbti': mbti,
      'advantage': advantage,
      'cooperation': cooperation,
      'blog': blog,
      'imagepath': imagepath,
    };
  }

  factory Member.fromJson(json) {
    return Member(
      name: json['name'],
      mbti: json['mbti'],
      advantage: json['advantage'],
      cooperation: json['cooperation'],
      blog: json['blog'],
      imagepath: json['imagepath'],
    );
  }
}

// Member 데이터는 모두 여기서 관리
class MemberService extends ChangeNotifier {
  MemberService() {
    loadMemberList();
  }

  List<Member> memberlist = [
    // dummy 파일
    // Member(
    //   name: '노진구',
    //   mbti: 'ISTP',
    //   hobby: '이슬이',

    // ),
    // Member(
    //   name: '도라에몽',
    //   mbti: 'ENFJ',
    //   hobby: '단팥빵',
    // ),
    // Member(
    //   name: '도라미',
    //   mbti: 'ESTP',
    //   hobby: '집안일',
    // ),
  ];
  memberSave(
    memberService,
    index,
    nameController,
    mbtiController,
    advantageController,
    cooperationController,
    blogController,
    imagepath,
  ) {
    memberService.memberlist[index].name = nameController.text;
    memberService.memberlist[index].mbti = mbtiController.text;
    memberService.memberlist[index].advantage = advantageController.text;
    memberService.memberlist[index].cooperation = cooperationController.text;
    memberService.memberlist[index].blog = blogController.text;
    memberService.memberlist[index].imagepath = imagepath;

    saveMemberList();
    notifyListeners();
  }

  memberDelete(memberService, index) {
    memberlist.removeAt(index);
    saveMemberList();
    notifyListeners();
  }

  // imagetobyte(_image) async {
  //   String base64Image = "";

  //   if (null != _image) {
  //     //_image1가 null 이 아니라면
  //     final bytes = File(_image!.path).readAsBytesSync(); //image 를 byte로 불러옴
  //     base64Image = base64Encode(
  //         bytes); //불러온 byte를 base64 압축하여 base64Image1 변수에 저장 만약 null이였다면 가장 위에 선언된것처럼 공백으로 처리됨
  //   }
  //   return base64Image;
  // }

  memberAdd(
    memberService,
    nameController,
    mbtiController,
    advantageController,
    cooperationController,
    blogController,
    imagepath,
  ) {
    String name = nameController.text;
    String mbti = mbtiController.text;
    String advantage = advantageController.text;
    String cooperation = cooperationController.text;
    String blog = blogController.text;

    Member newmember = Member(
      name: name,
      mbti: mbti,
      advantage: advantage,
      cooperation: cooperation,
      blog: blog,
      imagepath: imagepath,
    );
    memberService.memberlist.add(newmember);

    saveMemberList();
    notifyListeners();
  }

  saveMemberList() {
    List memoJsonList = memberlist.map((member) => member.toJson()).toList();
    // [{"content": "1"}, {"content": "2"}]

    String jsonString = jsonEncode(memoJsonList);
    // '[{"content": "1"}, {"content": "2"}]'

    prefs.setString('memberlist', jsonString);
  }

  loadMemberList() {
    String? jsonString = prefs.getString('memberlist');
    // '[{"content": "1"}, {"content": "2"}]'

    if (jsonString == null) return; // null 이면 로드하지 않음

    List memberJsonList = jsonDecode(jsonString);
    // [{"content": "1"}, {"content": "2"}]

    memberlist = memberJsonList.map((json) => Member.fromJson(json)).toList();
  }
}
