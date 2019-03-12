import 'package:flutter/material.dart';
import 'package:flutter_app_demo/router.dart';
import 'dart:convert';
import 'asset.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      ),
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            var json = jsonEncode({'words': Utf8Encoder().convert(query)});
            Routes.router.navigateTo(context, '${Routes.goodsSearch}?data=$json',replace: false);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    return query == ''
        ? Placeholder(
            fallbackHeight: 1,
            color: Colors.transparent,
          )
        : Container(
            height: 40.0,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black26))),
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () {
                var json = jsonEncode({'words': Utf8Encoder().convert(query)});
                Routes.router.navigateTo(context, '${Routes.goodsSearch}?data=$json',replace: true);
              },
              child: Text(
                query,
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =
        query.isEmpty ? recentSuggest : searchList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              title: RichText(
                  text: TextSpan(
                      text: suggestionList[index].substring(0, query.length),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(text: suggestionList[index].substring(query.length), style: TextStyle(color: Colors.grey))
                  ])),
            ));
  }
}
