#!/bin/bash

# Stage all changes
git add .

# Display the staged changes
git status

# Pause for user to check the status
echo "Press enter to continue after reviewing the status."
read

# Prompt for the commit message
echo "Please enter the commit message: "
read commit_message

# Commit the changes
git commit -m "$commit_message"

# Check if commit was successful
if [ $? -eq 0 ]; then
  echo "Commit successful."
else
  echo "Commit failed. Exiting."
  exit 1
fi

# Push the changes to remote
git push

# Check if push was successful
if [ $? -eq 0 ]; then
  echo "Push successful."
else
  echo "Push failed. Exiting."
  exit 1
fi
