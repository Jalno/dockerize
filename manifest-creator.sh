#!/bin/sh
set -e

helpMe()
{
   echo "";
   echo "Usage: $0 -c path-to-context -f export file";
   echo -e "\t-c context to search for git repositories";
   echo -e "\t-f export file";
   echo -e "\nthe result will save in format this format:\n"
   echo -e "{{{\nDIRECTORY_NAME_CONTAINS_GIT_REPO\nREPO_REMOTE_URL\nREPO_BRANCH_NAME\nREPO_HEAD_COMMIT_ID\n}}}\n"
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
'h_parse_url() {
  eval $(echo "$1" | sed -e "s#^\(\(.*\)://\)\?\(\([^:@]*\)\(:\(.*\)\)\?@\)\?\([^/?]*\)\(/\(.*\)\)\?#${H_PREFIX:-H_URL_}SCHEME=\2 ${H_PREFIX:-H_URL_}USER=\4 ${H_PREFIX:-H_URL_}PASSWORD=\6 ${H_PREFIX:-H_URL_}HOST=\7 ${H_PREFIX:-H_URL_}PATH=\9#")
};
echo "{{{";
basename `dirname {}`;
h_parse_url `git --git-dir={} config --get remote.origin.url`;
echo "$H_URL_SCHEME://$H_URL_HOST/$H_URL_PATH";
git --git-dir={} branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/";
git --git-dir={} rev-parse --verify HEAD;
echo -e "}}}\n";' >> $H_EXPORT_FILE
