#!/bin/bash

# ./legal.dev.sh --action addPermissions --space "$space" --group "$group" --permissions "$rightname"

perms=()
perms+=(VIEWSPACE)
perms+=(REMOVEOWNCONTENT)
perms+=(EXPORTPAGE)
perms+=(REMOVEPAGE)
perms+=(EDITBLOG)
perms+=(REMOVEBLOG)
perms+=(CREATEATTACHMENT)
perms+=(REMOVEATTACHMENT)
perms+=(COMMENT)
perms+=(REMOVECOMMENT)
perms+=(SETPAGEPERMISSIONS)
perms+=(REMOVEMAIL)
perms+=(EXPORTSPACE)
perms+=(EDITSPACE)

sed 's/;/ /g' <legal_dev.permissions.cleaned.csv |
while read
do
    set -- $REPLY
    spacekey=$1
    group=$2
    shift
    shift
    perm_idx=0
    for i
    do
        if [[ "$i" == "Yes" ]]
        then
            echo ./legal.dev.sh --action addPermissions --space "$spacekey" --group "$group" --permissions "${perms[$perm_idx]}"
        elif [[ "$i" == "No" ]]
        then
            echo ./legal.dev.sh --action removePermissions --space "$spacekey" --group "$group" --permissions "${perms[$perm_idx]}"
        fi
        ((perm_idx++))
    done
    echo
done
