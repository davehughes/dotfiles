function git-settings-common {
    git config rebase.autosquash true
}

function git-settings-personal {
    git config user.name "Dave Hughes"
    git config user.email "d@vidhughes.com"
    git-settings-common
}

function git-settings-sutrolabs {
    git config user.name "Dave Hughes"
    git config user.email "dave@getcensus.com"
    git-settings-common
}

function git-changed-files {
    commit1=HEAD^
    commit2=HEAD
    git diff-tree -r --no-commit-id --name-only $commit1 $commit2
}
