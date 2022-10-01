#!/bin/bash

# https://docs.github.com/en/graphql/overview/public-schema
curl -o packages/gql_github/lib/schema.graphql https://docs.github.com/public/schema.docs.graphql

npx --yes get-graphql-schema https://gitlab.com/api/graphql > packages/gql_gitlab/lib/schema.graphql
