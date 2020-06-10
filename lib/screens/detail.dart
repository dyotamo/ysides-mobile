import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_color/random_color.dart';
import 'package:share/share.dart';
import 'package:sides/models/option.dart';
import 'package:sides/utils/net.dart' as net;
import 'package:sides/models/question.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuestionDetail extends StatefulWidget {
  final _question;
  final _color = RandomColor().randomColor();

  QuestionDetail(this._question);

  @override
  _QuestionDetailState createState() => _QuestionDetailState(_question);
}

class _QuestionDetailState extends State<QuestionDetail> {
  Question _question;

  // O IMEI já votou?
  bool _cliked = false;

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
          backgroundColor: widget._color,
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
                        color: Colors.white.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _question.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                    ),
                    if (_question.description != null)
                      Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _question.description,
                            textAlign: TextAlign.center,
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
    final lineWidth = MediaQuery.of(context).size.width * 0.55;
    return ListTile(
      title: Text('${index + 1}. ${option.name}'),
      subtitle: (this._cliked)
          ? LinearPercentIndicator(
              padding: EdgeInsets.all(2.5),
              animation: true,
              width: lineWidth,
              lineHeight: 5.0,
              percent: option.votes / _question.votes,
              backgroundColor: Colors.grey,
              progressColor: widget._color,
            )
          : null,
      trailing: (this._cliked)
          ? Container(
              color: widget._color,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '${option.votes}',
                  style: Theme.of(context).textTheme.overline.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ))
          : null,
      onTap: () => _vote(context, option),
    );
  }

  void _vote(context, option) async {
    try {
      // Tenta votar e actualiza o estado da questão
      final question = await net.vote(option.id);

      setState(() {
        this._question = question;
        this._cliked = true;
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
    }
  }

  /// Coloca os dados mais recentes
  void _updateQuestion() async {
    final question = await net.getQuestion(widget._question.id);
    if (mounted) setState(() => this._question = question);
  }
}
