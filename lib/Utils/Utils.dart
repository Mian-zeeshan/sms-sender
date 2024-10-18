


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:open_filex/open_filex.dart';




import 'package:sms_sender/Utils/constants.dart';

class Utils {
  xLHeadingStyle(color) {
    return TextStyle(
        color: color,
        fontSize: xHeadingFontSize.sp,
        fontWeight: xBold,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  xxLHeadingStyle(color) {
    return TextStyle(
        color: color,
        fontSize: xxHeadingFontSize.sp,
        fontWeight: xBold,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  smallLabelStyle(color) {
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  xSmallLabelStyle(color) {
    return TextStyle(
        color: color,
        fontSize: 10.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  xxSmallLabelStyle(color) {
    return TextStyle(
        color: color,
        fontSize: 8.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  xBoldSmallLabelStyle(color) {
    return TextStyle(
        color: color,
        fontSize: 10.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  boldSmallLabelStyle(color) {
    return TextStyle(
        color: color,
        fontSize: smallFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  labelStyle(color) {
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  headingStyle(color) {
    return TextStyle(
        color: color,
        fontSize: headingFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  lheadingStyle(color) {
    return TextStyle(
        color: color,
        fontSize: 26.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  headingStyle2(color) {
    return TextStyle(
        color: color,
        fontSize: headingFontSize.sp,
        fontWeight: normal,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  boldLabelStyle(color) {
    return TextStyle(
        color: color,
        fontSize: labelFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }

  calendarFont(color) {
    return TextStyle(
      color: color,
      fontSize: labelFontSize.sp,
      fontWeight: bold,
      decoration: TextDecoration.none,
    );
  }

  buttonStyle(color) {
    return TextStyle(
        color: color,
        fontSize: buttonFontSize.sp,
        fontWeight: bold,
        decoration: TextDecoration.none,
        fontFamily: 'Poppins');
  }
}