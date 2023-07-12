import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'main.dart';

// Memo 데이터의 형식을 정해줍니다. 추후 isPinned, updatedAt 등의 정보도 저장할 수 있습니다.
class Member {
  Member({
    required this.name,
    required this.mbti,
    required this.hobby,
  });

  String name;
  String mbti;
  String hobby;

  Map toJson() {
    return {
      'name': name,
      'mbti': mbti,
      'hobby': hobby,
    };
  }

  factory Member.fromJson(json) {
    return Member(
      name: json['name'],
      mbti: json['mbti'],
      hobby: json['hobby'],
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
    Member(
      name: '노진구',
      mbti: 'ISTP',
      hobby: '이슬이',
    ),
    Member(
      name: '도라에몽',
      mbti: 'ENFJ',
      hobby: '단팥빵',
    ),
    Member(
      name: '도라미',
      mbti: 'ESTP',
      hobby: '집안일',
    ),
  ];
  memberSave(
    memberService,
    index,
    nameController,
    mbtiController,
    hobbyController,
  ) {
    memberService.memberlist[index].name = nameController.text;
    memberService.memberlist[index].mbti = mbtiController.text;
    memberService.memberlist[index].hobby = hobbyController.text;
    saveMemberList();
    notifyListeners();
  }

  memberDelete(memberService, index) {
    memberlist.removeAt(index);
    saveMemberList();
    notifyListeners();
  }

  imagetobyte(_image) async {
    String base64Image = "";

    if (null != _image) {
      //_image1가 null 이 아니라면
      final bytes = File(_image!.path).readAsBytesSync(); //image 를 byte로 불러옴
      base64Image = base64Encode(
          bytes); //불러온 byte를 base64 압축하여 base64Image1 변수에 저장 만약 null이였다면 가장 위에 선언된것처럼 공백으로 처리됨
    }
    return base64Image;
  }

  memberAdd(memberService, nameController, mbtiController, hobbyController) {
    String name = nameController.text;
    String mbti = mbtiController.text;
    String hobby = hobbyController.text;

    Member newmember = Member(
      name: name,
      mbti: mbti,
      hobby: hobby,
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