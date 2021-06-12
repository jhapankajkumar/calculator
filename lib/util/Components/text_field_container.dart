import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/InputValidator.dart/input_validator.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class TextFieldContainerData {
  final String? placeHolder;
  final Function? onTextChange;
  final Function? onFocusChanged;
  final TextFieldFocus? textField;
  final TextFieldFocus? currentFocus;
  final int? textLimit;
  final String? errorText;
  final Function? onDoneButtonTapped;

  TextFieldContainerData(
      {required this.placeHolder,
      required this.onTextChange,
      required this.onFocusChanged,
      required this.textField,
      required this.currentFocus,
      required this.textLimit,
      required this.onDoneButtonTapped,
      this.errorText});
}

class TextFieldContainer extends StatefulWidget {
  final TextFieldContainerData containerData;

  TextFieldContainer({required this.containerData});

  @override
  _TextFieldContainerState createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  TextEditingController? controller;
  TextFieldFocus? focusField;
  FocusNode node = FocusNode();
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusField = widget.containerData.textField;
  }

  @override
  Widget build(BuildContext context) {
    bool shouldShowClearButton = false;
    if (widget.containerData.currentFocus == focusField &&
        (controller?.text.length ?? 0) > 0) {
      shouldShowClearButton = true;
    }
    AmountValidator validator = DecimalRegexValidator(source: decimalRegex);
    if (widget.containerData.textField == TextFieldFocus.amount ||
        widget.containerData.textField == TextFieldFocus.period) {
      validator = AmountRegexValidator(source: regexSource);
    }
    var container = Container(
        height: textFieldContainerSize,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xffEFEFEF),
          boxShadow: [
            BoxShadow(
              color: widget.containerData.currentFocus == focusField
                  ? Colors.blue
                  : Colors.grey,
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: KeyboardActions(
            config: _buildConfig(context),
            autoScroll: false,
            disableScroll: true,
            bottomAvoiderScrollPhysics: ScrollPhysics(),
            child: Center(
              child: FocusScope(
                child: Focus(
                  onFocusChange: (value) {
                    if (widget.containerData.onFocusChanged != null) {
                      widget.containerData.onFocusChanged!(focusField, value);
                    }
                  },
                  child: TextField(
                    focusNode: node,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.containerData.placeHolder,
                      hintStyle: TextStyle(color: Colors.grey[350]),
                      errorText: widget.containerData.errorText,
                      alignLabelWithHint: true,
                      suffixIcon:
                          shouldShowClearButton ? _getClearButton() : null,
                    ),
                    keyboardType: (widget.containerData.textField ==
                                TextFieldFocus.amount ||
                            widget.containerData.textField ==
                                TextFieldFocus.period)
                        ? TextInputType.numberWithOptions(decimal: false)
                        : TextInputType.numberWithOptions(decimal: true),
                    style: appTheme.textTheme.subtitle2,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          widget.containerData.textLimit),
                      InputFormatterValidator(validator: validator)
                    ],
                    controller: controller,
                    onChanged: (value) {
                      if (widget.containerData.onTextChange != null) {
                        widget.containerData.onTextChange!(focusField, value);
                      }
                    },
                  ),
                ),
              ),
            )));

    return container;
  }

  Widget _getClearButton() {
    return IconButton(
      onPressed: () {
        setState(() {});
        controller?.clear();
        if (widget.containerData.onTextChange != null) {
          widget.containerData.onTextChange!(focusField, "");
        }
      },
      icon: Icon(Icons.highlight_off),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: node,
          toolbarButtons: [
            //button 2
            (node) {
              return GestureDetector(
                onTap: () {
                  node.unfocus();
                  if (widget.containerData.onDoneButtonTapped != null) {
                    widget.containerData.onDoneButtonTapped!();
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Done",
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}

Widget buildTextFieldContainerSection({
  required String placeHolder,
  required TextFieldFocus textFieldType,
  TextFieldFocus? focus,
  required int textLimit,
  required String containerTitle,
  Function? onTextChange,
  Function? onFocusChange,
  Function? onDoneButtonTapped,
}) {
  TextFieldContainerData data = TextFieldContainerData(
      placeHolder: placeHolder,
      onTextChange: onTextChange,
      onFocusChanged: onFocusChange,
      textField: textFieldType,
      currentFocus: focus,
      textLimit: textLimit,
      onDoneButtonTapped: onDoneButtonTapped);
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          containerTitle,
          style: appTheme.textTheme.caption,
        ),
        SizedBox(height: 10),
        TextFieldContainer(containerData: data)
      ]);
}
