import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
  String title = 'Carregando questões...';
  List<Question> questions;

  @override
  void initState() {
    super.initState();
    _getQuestions();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Entypo.info),
              onPressed: () => _showDisclaimer(context))
        ],
      ),
      body: (questions != null)
          ? (questions.isEmpty ? _buildNoData() : _buildList(context))
          : _buildLoading());

  Widget _buildNoData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Entypo.trash,
            size: 75.0,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Sem dados',
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildList(context) => GroupedListView<Question, String>(
      separator: Divider(),
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
        subtitle: Text('Postado por ${question.entity.name}'),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuestionDetail(question))),
      );

  Widget _buildLoading() => Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
          itemBuilder: (_, __) => ListTile(
            title: Container(
              height: 8.0,
              color: Colors.white,
            ),
            subtitle: Container(
              height: 8.0,
              color: Colors.white,
            ),
          ),
          itemCount: 5,
        ),
      );

  Future<void> _getQuestions() async {
    try {
      final questions = await net.getQuestions();
      this.setState(() {
        this.questions = questions;
        title = 'Sides';
      });
    } on SocketException catch (_) {
      this.setState(() {
        questions = [];
        title = 'Sides';
      });
      Fluttertoast.showToast(
          msg: 'Não é possível estabelecer a ligação a rede.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  void _showDisclaimer(context) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Info'),
              content: Text('Para garantir que a sua opinião seja válida, ' +
                  'o Sides necessita do ID do dispositivo.'),
            ));
  }
}
