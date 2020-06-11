import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:sides/models/option.dart';
import 'package:sides/utils/net.dart' as net;
import 'package:sides/models/question.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuestionDetail extends StatefulWidget {
  final _question;

  QuestionDetail(this._question);

  @override
  _QuestionDetailState createState() => _QuestionDetailState(_question);
}

class _QuestionDetailState extends State<QuestionDetail> {
  Question _question;
  bool clicked = false;

  _QuestionDetailState(this._question);

  @override
  void initState() {
    _updateQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Theme.of(context).primaryColor,
          forceElevated: true,
          elevation: 8.0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _question.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    if (_question.description != null)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _question.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () => Share.share('''${_question.name}

Diga-nos o que tu achas, pelo aplicativo Sides.''')),
          ],
          expandedHeight: 250.0,
        ),
        SliverList(
            delegate: SliverChildListDelegate(
          _question.options
              .asMap()
              .map((index, option) =>
                  MapEntry(index, _buildTile(context, option, index)))
              .values
              .toList(),
        )),
      ]));

  Widget _buildTile(context, Option option, index) {
    final lineWidth = MediaQuery.of(context).size.width * 0.65;
    return ListTile(
      title: Text('${index + 1}. ${option.name}'),
      subtitle: (!clicked)
          ? Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                left: 2.5,
              ),
              child: SizedBox(width: lineWidth, height: 5.0),
            )
          : Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                left: 2.5,
              ),
              child: LinearPercentIndicator(
                padding: EdgeInsets.all(0.0),
                animation: true,
                width: lineWidth,
                lineHeight: 5.0,
                percent: option.votes / _question.votes,
                backgroundColor: Colors.grey,
                progressColor: Theme.of(context).primaryColor,
              ),
            ),
      trailing: (!clicked)
          ? SizedBox(width: 35.0, height: 35.0)
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              width: 35.0,
              height: 35.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    '${option.votes}',
                    style: Theme.of(context).textTheme.overline.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              )),
      onTap: () => _vote(context, option),
    );
  }

  void _vote(context, option) async {
    try {
      // Tenta votar e actualiza o estado da questão
      final question = await net.vote(option.id);

      setState(() {
        clicked = true;
        this._question = question;
      });

      Fluttertoast.showToast(
          msg: 'Obrigado pela opinião',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: 'Não é possível estabelecer a ligação a rede.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } on PlatformException catch (_) {
      Fluttertoast.showToast(
          msg: 'É necessário dar permissão de leitura do ID do dispositivo.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }
  }

  /// Coloca os dados mais recentes
  void _updateQuestion() async {
    final question = await net.getQuestion(widget._question.id);
    if (mounted) setState(() => this._question = question);
  }
}
