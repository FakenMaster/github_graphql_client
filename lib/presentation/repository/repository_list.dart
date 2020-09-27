import 'package:flutter/material.dart';
import 'package:github_graphql_client/domain/github_gql/github_queries.data.gql.dart';
import 'package:github_graphql_client/domain/github_gql/github_queries.req.gql.dart';
import 'package:github_graphql_client/infrastructure/exception/index.dart';
import 'package:gql_link/gql_link.dart';
import 'package:github_graphql_client/infrastructure/util/index.dart';

class RepositoriesList extends StatefulWidget {
  const RepositoriesList({@required this.link});
  final Link link;
  @override
  _RepositoriesListState createState() => _RepositoriesListState(link: link);
}

class _RepositoriesListState extends State<RepositoriesList> {
  _RepositoriesListState({@required Link link}) {
    _repositories = _retriveRepositories(link);
  }

  Future<List<$Repositories$viewer$repositories$nodes>> _repositories;

  Future<List<$Repositories$viewer$repositories$nodes>> _retriveRepositories(
      Link link) async {
    var result = await link.request(Repositories((b) => b..count = 100)).first;
    if (result.errors != null && result.errors.isNotEmpty) {
      throw QueryException(result.errors);
    }
    return $Repositories(result.data).viewer.repositories.nodes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<$Repositories$viewer$repositories$nodes>>(
      future: _repositories,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var repositories = snapshot.data;
        return ListView.builder(
          itemBuilder: (context, index) {
            var repository = repositories[index];
            return ListTile(
              title: Text('${repository.owner.login}/${repository.name}'),
              subtitle: Text(repository.description ?? 'No description'),
              onTap: () => launchUrl(context, repository.url.value),
            );
          },
          itemCount: repositories.length,
        );
      },
    );
  }
}
