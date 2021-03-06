import 'package:calculator/util/constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldContainerData {
  final String? placeHolder;
  final Function? onTextChange;
  final Function? onFocusChanged;
  final TextFieldFocus? textField;
  final TextFieldFocus? currentFocus;
  final int? textLimit;

  TextFieldContainerData(
      {required this.placeHolder,
      required this.onTextChange,
      required this.onFocusChanged,
      required this.textField,
      required this.currentFocus,
      required this.textLimit});
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

    var container = Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: widget.containerData.currentFocus == focusField
                  ? Colors.blue
                  : Colors.grey,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: FocusScope(
          child: Focus(
            onFocusChange: (value) {
              if (widget.containerData.onFocusChanged != null) {
                widget.containerData.onFocusChanged!(focusField, value);
              }
            },
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: shouldShowClearButton ? _getClearButton() : null,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: textFieldTextStyle,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                    widget.containerData.textLimit),
              ],
              controller: controller,
              onChanged: (value) {
                if (widget.containerData.onTextChange != null) {
                  widget.containerData.onTextChange!(focusField, value);
                }
              },
            ),
          ),
        ));
    return container;
    // return Container();
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
}

// class TextFieldContainer {
//   TextFieldFocus? focusField;
//   Widget buildContainer(
//       String label,
//       Function onTextChange,
//       Function onFocusChanged,
//       TextFieldFocus textField,
//       TextFieldFocus? currentFocus) {
//     focusField = textField;
//     var container = Container(
//         padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: currentFocus == focusField ? Colors.blue : Colors.grey,
//               spreadRadius: 2,
//               blurRadius: 2,
//               offset: Offset(1, 1), // changes position of shadow
//             ),
//           ],
//         ),
//         child: FocusScope(
//           child: Focus(
//             onFocusChange: (value) {
//               onFocusChanged(focusField, value);
//             },
//             child: TextField(
//               decoration: InputDecoration(
//                   border: InputBorder.none,
//                   labelText: label,
//                   suffixIcon: _getClearButton()),
//               keyboardType: TextInputType.numberWithOptions(decimal: true),
//               style: textFieldTextStyle,
//               controller: ,
//               onChanged: (value) {
//                 onTextChange(focusField, value);
//               },
//             ),
//           ),
//         ));
//     return container;
//   }
//}
