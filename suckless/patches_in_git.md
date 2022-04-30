
# Cloning the repository

You need to have the Git VCS installed first. Then clone the upstream repository locally

```
git clone git://git.suckless.org/dwm
```

# Recording customizations

Create a special branch where all the customizations will be kept. It doesn't matter what the name is, it just needs to be something different than master.

```
git branch my_dwm
```

Now switch to the new branch. This will do nothing at the moment as the branches are the same.

```
git checkout my_dwm
```

Now make your changes. If you want to apply one of the contributed patches you can use the git apply command

```
git apply some_patch.diff
```

Note that many patches make changes `config.def.h` instead of `config.h`. Either move those changes also to `config.h`, or add `rm config.h` to the `clean` target in the Makefile.

Then record the changes as commits

```
# tell git to add the changes in the given file(s) to be recorded
git add some_file.ext
# git will ask you to provide a message describing your changes,
# while showing a diff of what's being commited.
git commit -v
```

##  Experimenting with different combinations of customizations

If you plan on experimenting with different combinations of customizations it might be easier to record the commits in separate feature branches by first creating and checking out a branch and then recording the changes as commits. Having patches in different branches also helps to keep their dependencies transparent by creating branches based on other patch branches.

Then merge the selected combination of changes into your branch

```
git merge some_feature_branch
git merge other_feature_branch
```

If you some conflicts occur, resolve them and then record the changes and commit the result. git mergetool can help with resolving the conflicts.

# Updating customizations after new release

When the time comes to update your customizations after a new release of dwm or when the dwm repository contains a commit fixing some bug, you first pull the new upstream changes into the master branch

```
git checkout master
git pull
```

Then rebase your customization branch on top of the master branch

```
git checkout my_dwm
git rebase --preserve-merges master
```

The --preserve-merges option ensures that you don't have to resolve conflicts which you have already resolved while performing merges again.

In case there are merge conflicts anyway, resolve them (possibly with the help of git mergetool), then record them as resolved and let the rebase continue

```
git add resolved_file.ext
git rebase --continue
```

If you want to give up, you can always abort the rebase

```
git rebase --abort
```

# Author

    Ondřej Grover
