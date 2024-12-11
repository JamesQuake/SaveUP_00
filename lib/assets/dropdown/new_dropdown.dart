import 'package:flutter/material.dart';

import 'expanded_section.dart';
import 'scrollbar.dart';

class NewDropDown extends StatefulWidget {
  final List dropList;
  String dropTitle;

  NewDropDown({Key key, @required this.dropList, @required this.dropTitle})
      : super(key: key);

  @override
  _NewDropDownState createState() => _NewDropDownState();
}

class _NewDropDownState extends State<NewDropDown> {
  bool isStrechedDropDown = false;
  int groupValue;
  // String title = 'Where would you like to Shop?';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.black),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        // height: 45,
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: 45,
                          minWidth: double.infinity,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Text(
                                  widget.dropTitle,
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isStrechedDropDown = !isStrechedDropDown;
                                });
                              },
                              child: Icon(
                                isStrechedDropDown
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                      ExpandedSection(
                        expand: isStrechedDropDown,
                        height: 100,
                        child: (widget.dropList.length > 3)
                            ? MyScrollbar(
                                builder: (context, scrollController2) =>
                                    ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  controller: scrollController2,
                                  shrinkWrap: true,
                                  itemCount: widget.dropList.length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      title: Text(
                                          widget.dropList.elementAt(index)),
                                      activeColor: Color(0xff0070c0),
                                      value: index,
                                      groupValue: 0,
                                      onChanged: (val) {
                                        setState(() {
                                          groupValue = val;
                                          widget.dropTitle =
                                              widget.dropList.elementAt(index);
                                        });
                                      },
                                    );
                                  },
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(0),
                                // controller: scrollController2,
                                shrinkWrap: true,
                                itemCount: widget.dropList.length,
                                itemBuilder: (context, index) {
                                  return RadioListTile(
                                    title: (index == 1)
                                        ? Text(
                                            widget.dropList.elementAt(index),
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Text(
                                            widget.dropList.elementAt(index),
                                          ),
                                    activeColor: Color(0xff0070c0),
                                    value: index,
                                    groupValue: 0,
                                    onChanged: (val) {
                                      if (val == 0) {
                                        setState(() {
                                          groupValue = val;
                                          widget.dropTitle =
                                              widget.dropList.elementAt(index);
                                          if (isStrechedDropDown == true) {
                                            setState(() {
                                              isStrechedDropDown = false;
                                            });
                                          }
                                        });
                                      }
                                    },
                                  );
                                },
                              ),
                      )
                    ],
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
