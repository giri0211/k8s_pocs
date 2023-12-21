#!/bin/bash

# Get the current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Fetch the latest branches from the remote repository
git fetch -p

# Iterate through local branches and delete them (except the current branch)
for branch in $(git for-each-ref --format '%(refname:short)' refs/heads/); do
  if [ "$branch" != "$current_branch" ]; then
    git branch -D "$branch"
    echo "deleted - $branch"
  fi
done

echo "Local branches (except the current branch) have been deleted."
