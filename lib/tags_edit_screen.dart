import 'package:diary/resources/custom_app_bar.dart';
import 'package:diary/resources/my_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';

class TagsEditScreen extends StatefulWidget {
  const TagsEditScreen({super.key});

  @override
  State<TagsEditScreen> createState() => _TagsEditScreenState();
}

class _TagsEditScreenState extends State<TagsEditScreen> {
  TextEditingController _controllerAdd = TextEditingController();
  TextEditingController _controllerSearch = TextEditingController();
  ScrollController _controllerScroll = ScrollController();
  bool isSearch = false;
  final tags = {'vacation': true, 'school': true, 'work': false, 'love': true, 'haha': false};
  Map<String, bool> searchTags = {};
  @override
  void dispose() {
    // TODO: implement dispose
    _controllerAdd.dispose();
    _controllerSearch.dispose();
    _controllerScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyAppTheme.bgColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomAppBar(title: 'Tags'),
              Container(
                  margin: const EdgeInsets.all(10),
                  //padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: MyAppTheme.inactiveDotColor,
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                    onChanged: ((text) {
                      setState(() {
                        searchTags.clear();
                        if (text.isEmpty) {
                          isSearch = false;
                          Fluttertoast.showToast(msg: 'empty');
                        } else {
                          isSearch = true;
                          tags.forEach((key, value) {
                            if (key.contains(text)) {
                              searchTags.addAll({key: value});
                            }
                          });

                          Fluttertoast.showToast(msg: 'edit');
                        }
                      });
                    }),
                    controller: _controllerSearch,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search tag',
                      hintStyle: TextStyle(color: MyAppTheme.disableColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: MyAppTheme.disableColor,
                        size: 20,
                      ),
                    ),
                  )),
              Container(
                  margin: const EdgeInsets.all(10),
                  //padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: MyAppTheme.inactiveDotColor,
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                    controller: _controllerAdd,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add tag',
                        hintStyle: TextStyle(color: MyAppTheme.disableColor),
                        prefixIcon: Icon(
                          Ionicons.pricetag,
                          color: MyAppTheme.disableColor,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                            onPressed: (() {
                              if (_controllerAdd.text.isNotEmpty) {
                                var newT = <String, bool>{_controllerAdd.text: true};
                                setState(() {
                                  tags.addAll(newT);
                                });
                                _controllerAdd.text = '';
                              }
                            }),
                            icon: Icon(
                              Icons.add,
                              color: MyAppTheme.primaryTxtColor,
                            ))),
                  )),
              Expanded(
                child: isSearch ? searchedTags() : normalTags(),
              )
            ],
          ),
        ));
  }

  ListView searchedTags() {
    return ListView.builder(
        itemCount: searchTags.length,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              Fluttertoast.showToast(msg: searchTags.keys.elementAt(index));
              setState(() {
                tags.update(searchTags.keys.elementAt(index), (value) => !value);
                searchTags.update(searchTags.keys.elementAt(index), (value) => !value);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: searchTags.values.elementAt(index)
                      ? MyAppTheme.primaryColor.withOpacity(0.5)
                      : MyAppTheme.itemBgColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(searchTags.keys.elementAt(index)),
                  IconButton(
                    onPressed: (() {
                      //Fluttertoast.showToast(msg: index.toString());
                      setState(() {
                        tags.remove(searchTags.keys.elementAt(index));
                        searchTags.remove(searchTags.keys.elementAt(index));

                        Fluttertoast.showToast(msg: 'remove');
                      });
                    }),
                    icon: Icon(
                      Icons.delete,
                      color: MyAppTheme.secondaryTxtColor,
                    ),
                    //iconSize: 20,
                  )
                ],
              ),
            ),
          );
        }));
  }

  ListView normalTags() {
    return ListView.builder(
        itemCount: tags.length,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                tags.update(tags.keys.elementAt(index), (value) => !tags.values.elementAt(index));
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: tags.values.elementAt(index)
                      ? MyAppTheme.primaryColor.withOpacity(0.5)
                      : MyAppTheme.itemBgColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isSearch
                      ? Text(searchTags.keys.elementAt(index))
                      : Text(tags.keys.elementAt(index)),
                  IconButton(
                    onPressed: (() {
                      Fluttertoast.showToast(msg: index.toString());
                      setState(() {
                        tags.remove(tags.keys.elementAt(index));
                      });
                    }),
                    icon: Icon(
                      Icons.delete,
                      color: MyAppTheme.secondaryTxtColor,
                    ),
                    //iconSize: 20,
                  )
                ],
              ),
            ),
          );
        }));
  }
}
