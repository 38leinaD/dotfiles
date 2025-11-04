#!/bin/bash
set -e

branch_to_cherry_pick_to=$1

if [ "$1" == "" ]; then
    echo "please provide name of branch to cherry-pick to"
    exit 1
fi

current_branch_name=$(git rev-parse --abbrev-ref HEAD)
latest_commit_id=$(git log --format="%H" -n 1)
latest_commit_comment=$(git log --format=%B -n 1 $latest_commit_id)

echo "*****************************************************************************************************"
echo "Cherry-picking commit ${latest_commit_id} from ${current_branch_name} to ${branch_to_cherry_pick_to}"
echo " $latest_commit_comment"
echo "*****************************************************************************************************"

echo ""

git checkout $branch_to_cherry_pick_to
git pull --rebase
git cherry-pick $latest_commit_id
git push
git checkout $current_branch_name
