#!/bin/bash

# https://docs.github.com/en/graphql/overview/public-schema
curl -o lib/gql_github/schema.graphql https://docs.github.com/public/schema.docs.graphql

npx --yes get-graphql-schema https://gitlab.com/api/graphql > lib/gql_gitlab/schema.graphql
