import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sides/models/question.dart';
import 'package:sides/screens/detail.dart';
import 'package:sides/utils/net.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Escolha o seu lado'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => _showDisclaimer(context),
          )
        ],
      ),
      body: FutureBuilder<List<Question>>(
          future: getQuestions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var questions = snapshot.data;
              if (questions.isEmpty) return _buildNoData();
              return _buildList(context, questions);
            } else if (snapshot.hasError) return _buildError();
            return _buildLoading();
          }));

  Widget _buildError() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 50.0,
          ),
          SizedBox(width: 5.0),
          Text('Oops, problemas de conexão.'),
        ],
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.clear,
            size: 75.0,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Oops! Sem enquetes...'),
          )
        ],
      ),
    );
  }

  Widget _buildList(context, List<Question> questions) =>
      GroupedListView<Question, String>(
          elements: questions,
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

  Widget _buildLoading() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.5),
              child: Text('Carregando enquetes...'),
            )
          ],
        ),
      );

  void _showDisclaimer(context) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('Importante'),
              content: Text('Para garantir que a sua opinião seja válida, ' +
                  'o Sides necessita do ID do dispositivo.'),
            ));
  }
}
