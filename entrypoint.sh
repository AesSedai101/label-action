#!/bin/bash
set -e

if [[ -z "$INPUT_GITHUB_TOKEN" ]]; then
    echo "Set the GITHUB_TOKEN env variable."
    exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
    echo "Set the GITHUB_REPOSITORY env variable."
    exit 1
fi

if [[ -z "$GITHUB_EVENT_PATH" ]]; then
    echo "Set the GITHUB_EVENT_PATH env variable."
    exit 1
fi

addLabel=$INPUT_ADD_LABEL
if [[ -n "$INPUT_LABEL_NAME" ]]; then
    echo "Warning: Plase define the ADD_LABEL variable instead of the deprecated LABEL_NAME."
    addLabel=$INPUT_LABEL_NAME
fi

if [[ -z "$addLabel" ]]; then
    echo "Set the ADD_LABEL or the LABEL_NAME env variable."
    exit 1
fi

URI="https://api.github.com"
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

action=$(jq --raw-output .action "$GITHUB_EVENT_PATH")
state=$(jq --raw-output .review.state "$GITHUB_EVENT_PATH")
number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")

curl -sSL \
    -H "${AUTH_HEADER}" \
    -H "${API_HEADER}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"labels\":[\"${addLabel}\"]}" \
    "${URI}/repos/${GITHUB_REPOSITORY}/issues/${number}/labels"
