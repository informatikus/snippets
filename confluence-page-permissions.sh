#!/bin/bash

declare -A mapping
OIFS=$IFS
IFS=';'
while read old_name new_name
do
    mapping[$old_name]=$new_name
    echo "'$old_name' -> '$new_name'"
done <mapping
IFS=$OIFS


./confluence.sh --action getSpaceList | sed 1,2d | grep -v '^$' |
while read -r
do
    space=$(echo "$REPLY" | sed -r 's/^"([^"]+)",.*/\1/')
    echo "=> Space '$space'"

    ./confluence.sh --action getPageList --space "$space" | sed 1d | grep -v '^$' |
    while read -r
    do
        page=$REPLY
        echo "  => Page '$page'"

        ./confluence.sh --action getPermissionList --space "$space" --title "$page" | sed 1,2d | grep -v '^$' |
        while read -r
        do
            permission=$REPLY
            echo "    => Permission line '$REPLY'"

            #foo='"Edit","confluence-administrators"'
            perm=$(echo "$permission" | sed -r 's/"([^"]+)","([^"]+)"/\1/')
            group_old=$(echo "$permission" | sed -r 's/"([^"]+)","([^"]+)"/\2/')

            if [[ -z "${mapping[$group_old]}" ]]
            then
                echo "      Old name '$group_old' does not appear to be a group name, ignoring"
                continue
            fi

            if [[ "$group_old" == "${mapping[$group_old]}" ]]
            then
                echo "      Old group name '$group_old' equals new name, ignoring"
                continue
            fi

            if [[ "${mapping[$group_old]}" == "_" ]]
            then
                echo "      Old group name '$group_old' is unknown in new system, ignoring"
                continue
            fi

            echo "      Old group name '$group_old' is '${mapping[$group_old]}' in new system, adjusting"

            echo ./confluence.sh --action removePermissions --space "$space" --title "$page" --group "$group_old" --permissions "$perm"
            ./confluence.sh --action removePermissions --space "$space" --title "$page" --group "$group_old" --permissions "$perm"

            echo ./confluence.sh --action addPermissions --space "$space" --title "$page" --group "${mapping[$group_old]}" --permissions "$perm"
            ./confluence.sh --action addPermissions --space "$space" --title "$page" --group "${mapping[$group_old]}" --permissions "$perm"
        done
    done
done
