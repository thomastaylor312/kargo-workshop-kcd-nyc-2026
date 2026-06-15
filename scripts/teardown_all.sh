#! /bin/bash

participants=(
"thomastaylor312"
"akuity"
)

stages=(
  "dev"
  "staging"
  "prod"
)

#requires AWS access
if ! aws sts get-caller-identity >/dev/null 2>&1; then
  aws sso login 
fi
export AWS_PROFILE=admin

script_dir="$(dirname "$(realpath "$0")")"

# tear down all environments for all participants
for participant in "${participants[@]}"; do
  echo "Tearing down $participant's environments..."
  empty=true
  for stage in "${stages[@]}"; do
    echo -e "\tTearing down $stage environment"
    pushd "$script_dir/../env/$stage/terraform" >/dev/null
      rm .terraform/terraform.tfstate* 2>/dev/null || true
      #echo -e "\nterraform destroy -auto-approve -var \"participant=$participant\""
      tofu init -var "participant=$participant" >> teardown.log 2>&1
      tofu destroy -auto-approve -var "participant=$participant" >> teardown.log 2>&1
    popd >/dev/null
    resources=$(aws s3 cp "s3://kcd-workshop/${participant}/${stage}/terraform.tfstate" - | jq '.resources[]' )

    if [ -n "$resources" ]; then
      echo -e "\t\tWarning: Statefile is not empty, some resources may not have been destroyed. Please check the S3 bucket for details: s3://kcd-workshop/${participant}/${stage}/terraform.tfstate"
      empty=false
    else
      echo -e "\t\tStatefile is empty, all resources successfully destroyed for $stage environment"
    fi
  done
  # Check the backend S3 statefile. If all resources successfully destroyed, the statefile resources field should be empty. If so delete it, if not print a warning message.
  if [ "$empty" = "true" ]; then
    echo -e "\tStatefile is empty, deleting statefile from S3 bucket"
    aws s3 rm "s3://kcd-workshop/${participant}/" --recursive 
  else
    echo -e "\tWarning: Statefile is not empty, some resources may not have been destroyed. Please check the S3 bucket for details: s3://kcd-workshop/${participant}/${stage}/terraform.tfstate"
  fi
done


