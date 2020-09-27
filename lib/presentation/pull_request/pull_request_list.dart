import 'package:flutter/material.dart';
import 'package:github_graphql_client/domain/github_gql/github_queries.data.gql.dart';
import 'package:github_graphql_client/domain/github_gql/github_queries.req.gql.dart';
import 'package:github_graphql_client/infrastructure/exception/index.dart';
import 'package:gql_link/gql_link.dart';
import 'package:github_graphql_client/infrastructure/util/index.dart';

class PullRequestsList extends StatefulWidget {
  const PullRequestsList({@required this.link});
  final Link link;
  @override
  _PullRequestsListState createState() => _PullRequestsListState();
}

class _PullRequestsListState extends State<PullRequestsList> {
  Future<List<$PullRequests$viewer$pullRequests$edges$node>> _pullRequests;

  @override
  void initState() {
    super.initState();
    _pullRequests = _retrivePullRequests(widget.link);
  }

  Future<List<$PullRequests$viewer$pullRequests$edges$node>>
      _retrivePullRequests(Link link) async {
    var result = await link.request(PullRequests((b) => b..count = 100)).first;
    if (result.errors.notEmpty) {
      throw QueryException(result.errors);
    }

    return $PullRequests(result.data)
        .viewer
        .pullRequests
        .edges
        .map((e) => e.node)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<$PullRequests$viewer$pullRequests$edges$node>>(
      future: _pullRequests,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var pullRequests = snapshot.data;
        return ListView.builder(
          itemBuilder: (context, index) {
            var pullRequest = pullRequests[index];
            return ListTile(
              title: Text('${pullRequest.title}'),
              subtitle: Text('${pullRequest.repository.nameWithOwner} '
                  'PR #${pullRequest.number} '
                  'opened by ${pullRequest.author.login} '
                  '(${pullRequest.state.value.toLowerCase()})'),
              onTap: () => launchUrl(context, pullRequest.url.value),
            );
          },
          itemCount: pullRequests.length,
        );
      },
    );
  }
}
