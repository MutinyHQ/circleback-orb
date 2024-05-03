#!/bin/bash
# This example uses envsubst to support variable substitution in the string parameter type.
# https://circleci.com/docs/orbs-best-practices/#accepting-parameters-as-strings-or-environment-variables

# Check if the key variable is set
if [ -z "${!PARAM_CIRCLECI_API_KEY}" ]; then
  echo "CircleCI API key not set"
fi

if [ -z "${PARAM_WORKFLOW_ID}" ] && [ -z "${PARAM_PIPELINE_ID}" ]; then
  echo "CircleCI Workflow ID and Pipeline not set"
fi

if [ -z "${PARAM_APPROVAL_JOB}" ]; then
  echo "CircleCI approval job not set"
fi

CIRCLE_TOKEN="${!PARAM_CIRCLECI_API_KEY}"

if [ -z "${PARAM_WORKFLOW_ID}" ]; then
  echo "Fetching workflow from pipeline ID: $PARAM_PIPELINE_ID"
  WORKFLOW_API_RESPONSE=$(
    curl --request GET \
      --url "https://circleci.com/api/v2/pipeline/$PARAM_PIPELINE_ID/workflow" \
      --header "Circle-Token: $CIRCLE_TOKEN" \
      --header "content-type: application/json"
  )

  if [[ $PARAM_WORKFLOW_NAME ]]
  then
    PARAM_WORKFLOW_ID=$(echo "${WORKFLOW_API_RESPONSE}" | \
                          jq -r --arg workflow_name "${PARAM_WORKFLOW_NAME}" '.items[] | select(.name == $workflow_name) | .id')
  elif [[ $PARAM_PIPELINE_ID == "${CIRCLE_PIPELINE_ID}" ]]
  then
    # Since we've specified our own pipeline, let's assume it's our own workflow
    PARAM_WORKFLOW_ID="${CIRCLE_WORKFLOW_ID}"
  else
    echo "Choosing first workflow for pipeline ${PARAM_WORKFLOW_ID}"
    PARAM_WORKFLOW_ID=$(echo "$WORKFLOW_API_RESPONSE" | jq -r ".items[0].id")
  fi
fi

echo "Workflow ID: $PARAM_WORKFLOW_ID"

JOB_API_RESPONSE=$(
  curl --request GET \
    --url "https://circleci.com/api/v2/workflow/$PARAM_WORKFLOW_ID/job" \
    --header "Circle-Token: $CIRCLE_TOKEN" \
    --header "content-type: application/json"
)

JOB_ID=$(echo "$JOB_API_RESPONSE" | jq -r ".items[] | select(.name == \"$PARAM_APPROVAL_JOB\") | .id")

echo "Approval job ID: $JOB_ID"

APPROVAL_API_RESPONSE=$(
  curl -iX POST \
    --url "https://circleci.com/api/v2/workflow/$PARAM_WORKFLOW_ID/approve/$JOB_ID" \
    --header "Circle-Token: $CIRCLE_TOKEN"
)

APPROVAL_API_RESPONSE_CODE=$(echo "$APPROVAL_API_RESPONSE" | head -n 1 | cut -d$' ' -f2)

if [ "$APPROVAL_API_RESPONSE_CODE" -ne 202 ]; then
  echo "Failed to approve job"
  echo "API Response Code: $APPROVAL_API_RESPONSE_CODE"
  echo "API Response: $APPROVAL_API_RESPONSE"
  exit 1
else
  echo "Approved job ID: $JOB_ID"
fi
