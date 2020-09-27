import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:github_graphql_client/domain/github_gql/github_queries.data.gql.dart';
import 'package:github_graphql_client/domain/github_gql/github_queries.req.gql.dart';
import 'package:github_graphql_client/infrastructure/credentials/github_oauth_credentials.dart';
import 'package:github_graphql_client/infrastructure/exception/index.dart';
import 'package:github_graphql_client/presentation/login/login.dart';
import 'package:github_graphql_client/presentation/summary/summary.dart';
import 'package:gql_http_link/gql_http_link.dart';
import 'package:gql_link/gql_link.dart';
import 'package:window_to_front/window_to_front.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github GraphQL API Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Github GraphQL API Client'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      builder: (context, httpClient) {
        WindowToFront.activate();

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: GitHubSummary(
            client: httpClient,
          ),
        );
      },
      githubClientId: githubClientId,
      githubClentSecret: githubClientSecret,
      githubScopes: githubScopes,
    );
  }
}

Future<$ViewerDetail$viewer> viewerDetail(Link link) async {
  var result = await link.request(ViewerDetail((b) => b)).first;
  inspect(result);
  if (result.errors != null && result.errors.isNotEmpty) {
    throw QueryException(result.errors);
  }

  return $ViewerDetail(result.data).viewer;
}
