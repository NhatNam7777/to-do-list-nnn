import 'package:flutter/material.dart';

const TextStyle kmainTextColor = TextStyle(
  color: Colors.black,
);

const Color kmainIconColor = Color(0xff737373);

//Khi xài các màu của Colors, thì phải khởi tạo như dưới, rất phiền phức, dùng màu SRGBS luôn!
// final purple = Colors.purple[900];
// final kitemInDrawerColor = purple;

const kdraweritemColor = Color.fromARGB(255, 35, 89, 151);
const kdrawersubItemColor = Color.fromARGB(255, 153, 153, 153);
const TextStyle ktaskName =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500);
const TextStyle ktaskNameDetailPage = TextStyle(
    decoration: TextDecoration.none,
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 30);

TextStyle kHeaderTaskOverview = TextStyle(
    color: Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 18);
const TextStyle kHeaderTaskChart =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18);
const TextStyle kNumTask =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30);
TextStyle kNumTaskCategory = TextStyle(
    color: Colors.grey.shade700, fontWeight: FontWeight.w300, fontSize: 16);
const Color kSubColor = Color(0XFFC4CDD4);

const Color kActiveTracSwitchkGreenLight = Color(0XFF96C6C5);

const Color kActiveSwitchGreen = Color(0XFF318D89);

const Color kSelectedOptionLoop = Color(0XFF4DA8A3);

const Color kGreyTextOptionLoop = Color(0XFF6F7071);

const Color kGreyIconTaskCard = Color(0XFF97A2AC);

const Color kGreyLight = Color(0XFFF2F6F7);

//GREEN
const Color kMainGreen = Color(0XFF1C997F);
const Color kGreenlight = Color.fromARGB(255, 221, 246, 241);
const Color kUpGreenLight = Color.fromARGB(255, 136, 208, 194);
const Color kHuyGreen = Color(0XFF91CBC4);
const Color kProGreenCardUser = Color.fromARGB(255, 57, 138, 122);

//PINK
const Color kMainPink = Color(0XFFEF89AA);
const Color kPinklight = Color(0XFFFDF3F6);
const Color kUpPinkLight = Color.fromARGB(255, 251, 192, 211);
const Color kHuyPink = Color.fromARGB(255, 255, 206, 206);
const Color kProPinkCardUser = Color.fromARGB(255, 236, 104, 146);

//BLUE
const Color kMainBlue = Color(0XFF7DABF6);
const Color kBluelight = Color.fromARGB(255, 237, 242, 250);
const Color kUpBlueLight = Color.fromARGB(255, 172, 199, 244);
const Color kHuyBlue = Color.fromARGB(255, 180, 201, 235);
const Color kProBlueCardUser = Color.fromARGB(255, 85, 132, 208);

//RED
const Color kMainRed = Color(0XFFDE6768);
const Color kRedlight = Color.fromARGB(255, 248, 210, 211);
const Color kUpRedLight = Color.fromARGB(255, 252, 143, 145);
const Color kHuyRed = Color.fromARGB(255, 246, 184, 185);
const Color kProRedCardUser = Color.fromARGB(255, 189, 75, 77);

//YELLOW
const Color kMainYellow = Color(0XFFF9C93A);
const Color kYellowlight = Color.fromARGB(255, 253, 251, 242);
const Color kUpYellowLight = Color.fromARGB(255, 247, 225, 160);
const Color kHuyYellow = Color.fromARGB(255, 255, 237, 183);
const Color kProYellowCardUser = Color.fromARGB(255, 243, 191, 33);

//GREEN1
const Color kMainGreen1 = Color(0XFF4DA8A3);
const Color kGreen1light = Color.fromARGB(255, 233, 248, 248);
const Color kUpGreen1Light = Color.fromARGB(255, 126, 224, 219);
const Color kHuyGreen1 = Color.fromARGB(255, 157, 217, 214);
const Color kProGreen1CardUser = Color.fromARGB(255, 33, 150, 145);

//ORANGE

const Color kMainOrange = Color(0XFFF59058);
const Color kOrangelight = Color.fromARGB(255, 252, 239, 232);
const Color kUpOrangeLight = Color.fromARGB(255, 237, 182, 153);
const Color kHuyOrange = Color.fromARGB(255, 246, 211, 193);
const Color kProOrangeCardUser = Color.fromARGB(255, 253, 188, 89);

//PURPLE
const Color kMainPurple = Color(0XFF9556DD);
const Color kPurplelight = Color.fromARGB(255, 239, 230, 249);
const Color kUpPurpleLight = Color.fromARGB(255, 201, 157, 253);
const Color kHuyPurple = Color.fromARGB(255, 225, 205, 248);
const Color kProPurpleCardUser = Color.fromARGB(255, 113, 46, 190);
List<List<Color>> listColor = [
  [
    kMainGreen,
    kGreenlight,
    kUpGreenLight,
    kHuyGreen,
    kProGreenCardUser,
  ],
  [
    kMainPink,
    kPinklight,
    kUpPinkLight,
    kHuyPink,
    kProPinkCardUser,
  ],
  [
    kMainBlue,
    kBluelight,
    kUpBlueLight,
    kHuyBlue,
    kProBlueCardUser,
  ],
  [
    kMainRed,
    kRedlight,
    kUpRedLight,
    kHuyRed,
    kProRedCardUser,
  ],
  [
    kMainYellow,
    kYellowlight,
    kUpYellowLight,
    kHuyYellow,
    kProYellowCardUser,
  ],
  [
    kMainGreen1,
    kGreen1light,
    kUpGreen1Light,
    kHuyGreen1,
    kProGreen1CardUser,
  ],
  [
    kMainOrange,
    kOrangelight,
    kUpOrangeLight,
    kHuyOrange,
    kProOrangeCardUser,
  ],
  [
    kMainPurple,
    kPurplelight,
    kUpPurpleLight,
    kHuyPurple,
    kProPurpleCardUser,
  ],
];
