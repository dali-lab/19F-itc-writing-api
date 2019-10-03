# Template App

In order to convert this template app for use, please search for all instances of
`replaceappname`
and replace with the short name chosen for the new app.
It is also used to mark page titles, links, etc which will need to be modified appropriately.

The main page should be moved from the ApplicationController to an appropriate new controller

The 'Send Email' action is used to demonstrate/test email handling in test environments
You can remove or re-purpose the example_mailer

Generate new secrets for config/secrets.yml using `rake secret`

# Merge Request Process

## Git workflow for developers
### clone and setup
1. `git clone git@git.dartmouth.edu:wag/the-project`
2. `cd the-project`
3. `git checkout master`
4. `git fetch`
5. `git pull`
6. `git flow init`
   * optionally, to redo gitflow, `git flow init -f`
   * set up with defaults except "feature" and "version" as follows:
      * master
      * develop
      * **feature-yourinitials/**
      * release/
      * hotfix/
      * support/
      * **v**


### do work

1. find a feature in pivotal tracker to work on
2. `git flow feature start my-awesome-feature`
3. Do some work!
4. `git add .`
5. `git commit -am "my awesome commit message"`
6. push your work to the server!
   * if this is your first push, then `git flow feature publish my-awesome-feature`
   * if you've already published then `git push`

** repeat steps 3-6 until your feature is done. **

## Create a Merge Request as a Developer

1. log into git.dartmouth.edu
2. **Navigate:** groups > wag > the-project
3. **Left menu:** Repository > branches
4. find feature-yourinitials/my-awesome-feature
5. select "merge request"
6. write a message describing the change
7. assign to scrum master
8. submit merge request
9. obtain feedback
10. implement feedback, commit and push

## Complete Merge Request as Scrum Master

1. log into git.dartmouth.edu
2. **Navigate:** groups > wag > the-project
3. **Left menu:** merge requests
4. select an active request
5. Inspect for merge conflicts.
6. use the in-browser diff tool or checkout the code locally and use your favorite editor. The website has instructions on how to accomplish this.
7. Merge **AND REMOVE MERGED BRANCH!**

## After care - All Developers
1. `git checkout develop`
2. `git pull`
3. `git fetch --prune` to remove any references to the removed, merged feature on the server
4. if it was not your branch that was merged, then you may want to rebase your feature:
   * `git checkout feature-yourinitials/my-feature-that-wasn't-merged`
   * `git rebase develop`
   * `git pull`
   * manage merge conflicts if there are any
   * `git push`
5. if it was your branch that was merged, then you can safely remove your old local copy:
   * `git branch -d feature-yourinitials/my-awesome-feature`

## GOTO: do work
