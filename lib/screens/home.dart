import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sides/models/question.dart';
import 'package:sides/screens/detail.dart';
import 'package:sides/utils/net.dart' as net;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> questions;

  @override
  void initState() {
    super.initState();
    _getQuestions();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Opine aqui!'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: questions != null ? _buildList(context) : _buildLoading(context));

  Widget _buildList(context) => GroupedListView<Question, String>(
      elements: this.questions,
      groupBy: (question) => question.category,
      groupSeparatorBuilder: (category) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              category,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
      itemBuilder: (context, question) => _buildTile(context, question));

  Widget _buildTile(context, Question question) => ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(question.name),
        ),
        subtitle: Text('Postado por ${question.entity.email}'),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuestionDetail(question))),
      );

  Widget _buildLoading(context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(2.5),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: ListView.builder(
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
                subtitle: Container(
                  width: mediaQuery.size.width * 0.5,
                  height: 8.0,
                  color: Colors.white,
                ),
              ),
            ),
            itemCount: 12,
          ),
        ),
      ),
    );
  }

  Future<void> _getQuestions() async {
    try {
      final questions = await net.getQuestions();
      this.setState(() => this.questions = questions);
    } on SocketException catch (_) {
      this.setState(() => questions = []);
      Fluttertoast.showToast(
          msg: 'Não é possível estabelecer a ligação a rede.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }
}
