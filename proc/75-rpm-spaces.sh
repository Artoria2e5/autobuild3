{ find abdist/ -name "* *" -type d | rename 's/ /_/g' 
find abdist/ -name "* *" -type f | rename 's/ /_/g'; } 2>/dev/null || abinfo "Nothing to rename."