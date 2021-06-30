#!/bin/sh
set -e

helpMe()
{
   echo "";
   echo "Usage: $0 -c path-to-context -f export file";
   echo "\t-c context to search for git repositories";
   echo "\t-f export file";
   echo "\nthe result will save in format this format:\n
{{{\nDIRECTORY_NAME_CONTAINS_GIT_REPO\nREPO_REMOTE_URL\n(REPO_BRANCH_NAME)\nREPO_HEAD_COMMIT_ID\n}}}\n"
   exit 1;
}

while getopts "f:c:" opt
do
   case "$opt" in
      c ) H_CONTEXT="$OPTARG" ;;
      f ) H_EXPORT_FILE="$OPTARG" ;;
      ? ) helpMe ;;
   esac
done

# print helpMe in case parameters are empty
if [ -z "$H_CONTEXT" ] || [ -z "$H_EXPORT_FILE" ]
then
   echo "Some or all of the parameters are empty!";
   helpMe
fi

echo "find all git repositories in:" `realpath "$H_CONTEXT"`;
echo "export the result in file:" `realpath "$H_EXPORT_FILE"`;
echo -n "" > $H_EXPORT_FILE;

/usr/bin/find `realpath "$H_CONTEXT"` -follow -type d -name ".git" -print | \
xargs -i  /bin/sh -c \
'echo "{{{";
basename `dirname {}`;
git --git-dir={} config --get remote.origin.url;
git --git-dir={} branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/(\1)/"
git --git-dir={} rev-parse --verify HEAD;
echo "}}}\n"' >> $H_EXPORT_FILE

