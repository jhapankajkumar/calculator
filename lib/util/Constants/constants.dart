import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum DeviceType { Phone, Tablet }

DeviceType getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
  return data.size.shortestSide < 550 ? DeviceType.Phone : DeviceType.Tablet;
}

var device = getDeviceType();

//Fonts
double captionFontSize = device == DeviceType.Phone ? 12 : 20;
double subTtitleFontSize = device == DeviceType.Phone ? 16 : 24;
double indicatorFontSize = device == DeviceType.Phone ? 12 : 26;
double bodyText1FontSize = device == DeviceType.Phone ? 20 : 28;
double bodyText2FontSize = device == DeviceType.Phone ? 14 : 26;
double calculateButtonFont = device == DeviceType.Phone ? 20 : 28;
double menuFontSize = device == DeviceType.Phone ? 10 : 20;
double headerFontSize = device == DeviceType.Phone ? 30 : 40;
double swpBarWidht = device == DeviceType.Phone ? 5 : 20;
double loanBarWidht = device == DeviceType.Phone ? 10 : 30;

//ComponentsR
double menuContainerSize = device == DeviceType.Phone ? 120 : 220;
double menuImageSize = device == DeviceType.Phone ? 60 : 120;
double shareImageSize = device == DeviceType.Phone ? 45 : 80;
double chartSectionSize = device == DeviceType.Phone ? 150 : 300;
double chartRadisuSize = device == DeviceType.Phone ? 75 : 150;
double indicatorSize = device == DeviceType.Phone ? 16 : 32;
double buttonContainerSize = device == DeviceType.Phone ? 55 : 80;
double textFieldContainerSize = device == DeviceType.Phone ? 50 : 80;

Color ternaryColor = Color(0xffFA6A30);
Color wealthColor = Color(0xff5c76bc);
Color ascentColor = Color(0xff212E51);

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xffEFEFEF),
  accentColor: ascentColor,
  fontFamily: 'Oxygen',
  scaffoldBackgroundColor: Color(0xffEFEFEF),
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: bodyText1FontSize,
        fontWeight: FontWeight.normal,
        color: Colors.white),
    bodyText2: TextStyle(
        fontSize: bodyText2FontSize,
        fontWeight: FontWeight.bold,
        color: ascentColor),
    caption: TextStyle(
      fontSize: captionFontSize,
      fontWeight: FontWeight.bold,
      color: ascentColor,
    ),
    subtitle1: TextStyle(
        fontSize: subTtitleFontSize,
        fontWeight: FontWeight.bold,
        color: Color(0xff212E51)),
    subtitle2: TextStyle(
        fontSize: subTtitleFontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black54),
  ),
);

TextStyle subTitle1 = TextStyle(
    fontSize: subTtitleFontSize,
    fontWeight: FontWeight.bold,
    color: ternaryColor);
TextStyle subTitle2 = TextStyle(
    fontSize: subTtitleFontSize,
    fontWeight: FontWeight.bold,
    color: ascentColor);
TextStyle caption3 = TextStyle(
  fontSize: captionFontSize,
  fontWeight: FontWeight.normal,
  color: ternaryColor,
);

TextStyle caption2 = TextStyle(
  fontSize: captionFontSize,
  fontWeight: FontWeight.normal,
  color: ascentColor,
);

TextStyle captionHeader = TextStyle(
  fontSize: captionFontSize,
  fontWeight: FontWeight.bold,
  color: Color(0xffffffff),
);

TextStyle buttonStyle = TextStyle(
  fontSize: calculateButtonFont,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);

TextStyle headerTitleStyle = TextStyle(
  fontSize: headerFontSize,
  fontWeight: FontWeight.bold,
  color: ascentColor,
);

TextStyle headerValueStyle = TextStyle(
  fontSize: headerFontSize,
  fontWeight: FontWeight.bold,
  color: ternaryColor,
);

int amountTextLimit = 16;
int periodTextLimit = 4;
int monthsLimit = 2;
int interestRateTextLimit = 5;
int ageLimit = 3;
int expensLimit = 8;
int currentinvestmentLimit = 11;

int periodYearMaxValue = 100;
int periodMonthsMaxValue = 100 * 12;
double interestRateMaxValue = 100;

//EMI
int loanPeriodYearMaxValue = 30;
int loanPeriodMonthsMaxValue = 30 * 12;
int loanMaxInterestValue = 30;
int minCurrentAge = 15;
int maxCurrentAge = 98;

int minRetirementAge = 25;
int maxRetirementAge = 99;
int minLifeExpectancy = 30;
int maxLifeExpectancy = 100;

double maxInflationRate = 100;

enum Screen {
  home,
  sip,
  stepup,
  swp,
  lumpsum,
  fd,
  rd,
  emi,
  loan,
  fv,
  pv,
  target,
  retirement,
  retirementResult,
  detail,
}

enum ErrorType {
  minAge,
  maxAge,
  minRetirementAge,
  maxRetirementAge,
  minLifeExpectancy,
  maxLifeExpectancy,
  invalidAge,
  invalidRetirementAge,
  invalidLifeExpectancy,
  maxRetirementCorpusReturn,
  maxLoanPeriodMonth,
  maxLoanInterestRate,
  maxLoanPeriodYear,
  maxPeriodMonths,
  maxPeriodYears,
  maxInterestRate,
  maxReturnRate,
  maxStepUpRate,
  maxInflationRate,
  invalidWithdrawalAmount,
}
