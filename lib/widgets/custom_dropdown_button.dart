import 'package:flutter/material.dart';

//ignore: must_be_immutable
class CustomDropdownButton extends StatelessWidget {
  dynamic value;
  final Map<int, String> menuMap;
  final bool isCurrentUser;
  final Function(dynamic) onChanged;

  CustomDropdownButton({
    this.value,
    this.menuMap,
    this.isCurrentUser,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    List<DropdownMenuItem<dynamic>> dropdownMenuList = [];

    menuMap.forEach((key, i) {
      dropdownMenuList.add(
        DropdownMenuItem(
          child: Text(
            menuMap[key],
          ),
          value: key,
        ),
      );
    });

    return Container(
      width: deviceWidth * 0.3,
      height: deviceHeight * 0.065,
      child: DropdownButton(
        isExpanded: true,
        style: TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
        value: value,
        items: dropdownMenuList,
        disabledHint: Text(
          menuMap[value],
        ),
        onChanged: isCurrentUser ? onChanged : null,
      ),
    );
  }
}
