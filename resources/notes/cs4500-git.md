git-reference
===

### Background

Git is a tool for recording the history of a software project.

A Git history is a sequence of commits.

A commit describes some changes to some files.

The `git` command-line tool helps: (1) create commits and (2) share commits.

A simple workflow for creating commits is:

1. Edit some files
2. Save some of the edits
3. Create a commit from the saved edits

A simple workflow for sharing commits is:

1. Check whether your partner made changes to your shared project
2. If so, pull the partners' changes and replay yours on top
3. Push your commits to the shared project


### Basic Commands

- `git status`
  show the current status of the local repo **VERY IMPORTANT COMMAND**

- `git diff <filename>`
  show current changes to `<filename>`

- `git add <filename>`
  stage changes to `<filename>`

- `git commit --message <message>`
  make a local commit from current staged changes (`-m` is a shortcut for `--message`)

- `git pull --rebase origin master`
  get new commits from shared repo, put local commits on top of shared history (`-r` is a shortcut for `--rebase`)

- `git push origin master`
  send local commits to shared repo


### Undo

There are three "levels" of changes to a file with respect to the local history.

- Level 1: _unstaged changes_, caused by editing a file under version control
- Level 2: _staged changes_, caused by running `git add <filename` on a file
  with unstaged (Level 1) changes
- Level 3: _committed changes_, caused by running `git commit --message <message>`
  in a repository with staged changes

To undo the most recent commit (i.e., move Level 3 changes down to Level 2):

- `git reset --soft HEAD~1`

To un-stage staged changes to a file (Level 2 to Level 1):

- `git reset HEAD <filename>`

To un-do unstaged edits to a file (Level 1 to nothing):

- `git checkout -- <filename>`

Do not try to undo changes that have been pushed to your shared repo.
Instead, push a new commit that overwrites the bad changes.


### Local vs. Shared

At the beginning of the semester, the CS4500 staff created a shared repository
for you and your partner. The URL for the shared repository is something like:

- `https://github.ccs.neu.edu/CS4500-F18/abcd-efgh`

where `abcd-efgh` is somehow related to you and your partner.

To start working with this repository you both needed to run:

- `git clone <URL>`

The `git clone` created a local repository. After you and your partner made
clones, the state of your git world is something like this, with lifetimes
going down.

```
   partner A          github.ccs.neu.edu       partner B
   (local repo)       (shared repo)            (local repo)
       |                    |                      |
       |                    |                      |
       |                    |                      |
       |                    |                      |
       |                    |                      |
```

Your goal for this semester is to put a history into the shared repo ---
something like this, where each `O` represents a commit and the words after the
`#` are things that might go in a commit message:

```
end-of-semester github.ccs.neu.edu
(shared repo)
      |
      O # week1: start memo
      |
      O # week1: change language from Java to Racket
      |
      O # week1: fix typo
      |
      O # week1: fix another typo, baseline size, margins
      |
      O # week1: final draft of memo
      |
      O # week2: purpose statement + examples
      |
      O # week2: first draft spreadsheet spec
      |
      |
```

To build this history:
- make local commits
- pull partners changes to shared repo
- push your local commits to shared repo

```
   partner A          github.ccs.neu.edu       partner B
   (local repo)       (shared repo)            (local repo)
       |                    |                      |
       O # commit1          |                      |
       |                    |                      |
       O # commit2          |                      |
       | <---(pull -r)----- |                      |
       | ----(push)-------> |                      |
       |                    O # commit1            |
       |                    O # commit2            |
       |                    | -----(pull -r)-----> |
       |                    |                      O # commit1
       |                    |                      O # commit2
       |                    |                      |
       |                    |                      O # commit3
       |                    | <----(push)--------- |
       |                    O # commit3            |
       |                    |                      |
       |                    |                      |
```

We suggest `pull -r` (or `pull --rebase`) instead of plain `pull` because
if your local repo and the shared repo get new commits at the same point
in real-time, `pull -r` replays your local commits on top of the shared
commits.

So if:
- you make `# commit2` in your local repo
- your partner makes `# commit1` in their local repo
- your partner pushes to the shared repo
- and you `pull -r`

then your history shows `# commit1` before `# commit2`.
This is good because the commits appear in the same order in the shared repo.


### Push error: failed to push some refs

Always do a `git pull -r origin master` before pushing new local commits.

If you forget to pull, and the shared repo happens to have new commits, then
the push will fail with an error message like the following:

```
  $ git push origin master
  To <url>
   ! [rejected]        master -> master (non-fast-forward)
  error: failed to push some refs to '<url>'
  hint: Updates were rejected because the tip of your current branch is behind
  hint: its remote counterpart. Integrate the remote changes (e.g.
  hint: 'git pull ...') before pushing again.
  hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

To fix, do a pull.


### Pull error: working tree files would be overwritten

If you:
- create a file (for example, called `NEW-FILE`)
- but do not `git add` the `NEW-FILE`
- and the shared repo has a commit for a file named `NEW-FILE`

then a `git pull` will fail with an error message like this one:

```
  $ git pull -r origin master
  From <url>
   * branch            master     -> FETCH_HEAD
  First, rewinding head to replay your work on top of it...
  error: The following untracked working tree files would be overwritten by checkout:
    NEW-FILE
  Please move or remove them before you switch branches.
  Aborting
  could not detach HEAD
```

To fix: commit, delete, or rename the `NEW-FILE`.


### Pull issue: merge conflict

If your local repo has a commit that affects a file named `MY-FILE`
and the shared repo has a commit that affects `MY-FILE` in a different way,
then the commits may lead to a merge conflict when you pull.

If a conflict occurs, `git` prints a message like the following:

```
  $ git pull origin master
  From <url>
   * branch            master     -> FETCH_HEAD
  First, rewinding head to replay your work on top of it...
  Applying: <commit message>
  Using index info to reconstruct a base tree...
  M  MY-FILE
  Falling back to patching base and 3-way merge...
  Auto-merging MY-FILE
  CONFLICT (content): Merge conflict in MY-FILE
  error: Failed to merge in the changes.
  Patch failed at 0001 <commit message>
  hint: Use 'git am --show-current-patch' to see the failed patch
```

This message does not mean the pull failed. Repeat: THE PULL DID NOT FAIL.
Git pulled some changes, got stuck, edited `MY-FILE`, and is now asking for
your help on how to proceed.

To go back to the way things were before you pulled:

1. `git rebase --abort`

To fix the conflict:

1. open `MY-FILE` with your favorite text editor
2. search for a line that contains only `=======`
3. look for a line that starts with `<<<<<<<` above the `=======` line,
   and a line that starts with `>>>>>>>` below the `=======` line;
   replace the whole chunk from `<<<<<<<` to `>>>>>>>` with the code you want
4. repeat from step 2 for any other `=======` lines
5. close the text editor, run `git add <MY-FILE>` and `git rebase --continue`

Merge conflicts are frustrating. Be patient.


### Non-Basic Commands

- `git commit --amend`
  put currently-staged changes into the previous commit

- `git diff --staged`
  show currently-staged changes (by default, `git diff` shows unstaged changes)

- `git stash`
  hide current unstaged changes in a stack of "stashes"

- `git stash list`
  show the current stack of "stashes"

- `git stash pop`
  apply the most-recent stash

- `git blame <filename>`
  print `<filename>` with annotations showing what commit last-touched what line

- `git bisect`
  binary search debugger --- see the manual page


### What is `origin master`?

`origin` is the default name for the shared repo

`master` is the default name of the main branch on any repo --- local or shared

Git branches are VERY interesting, but you don't need them to survive cs4500.
