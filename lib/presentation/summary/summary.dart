import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:github_graphql_client/presentation/issue/assigned_issue_list.dart';
import 'package:github_graphql_client/presentation/pull_request/pull_request_list.dart';
import 'package:github_graphql_client/presentation/repository/repository_list.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

class GitHubSummary extends StatefulWidget {
  GitHubSummary({@required http.Client client})
      : _link = HttpLink(
          'https://api.github.com/graphql',
          httpClient: client,
        );
  final HttpLink _link;
  @override
  _GitHubSummaryState createState() => _GitHubSummaryState();
}

class _GitHubSummaryState extends State<GitHubSummary> {
  BehaviorSubject<int> indexSubject;

  @override
  void initState() {
    super.initState();
    indexSubject = BehaviorSubject.seeded(0);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder<int>(
          stream: indexSubject,
          builder: (context, snapshot) {
            return NavigationRail(
              selectedIndex: snapshot.data ?? 0,
              onDestinationSelected: (value) => indexSubject.add(value),
              labelType: NavigationRailLabelType.selected,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Octicons.repo),
                  label: Text('Repositories'),
                ),
                NavigationRailDestination(
                  icon: Icon(Octicons.issue_opened),
                  label: Text('Assigned Issues'),
                ),
                NavigationRailDestination(
                  icon: Icon(Octicons.git_pull_request),
                  label: Text('Pull Requests'),
                ),
              ],
            );
          },
        ),
        VerticalDivider(
          thickness: 1,
          width: 1,
        ),
        Expanded(
          child: StreamBuilder(
            stream: indexSubject,
            builder: (context, snapshot) {
              return IndexedStack(
                index: snapshot.data ?? 0,
                children: [
                  RepositoriesList(link: widget._link),
                  AssignedIssuesList(link: widget._link),
                  PullRequestsList(link: widget._link),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

