#!/bin/bash

function checked_mkdir( ) {

    # make directory $1 if it does not exist and exit on error
    
    echo "creating directory '$1'"

    [ -d "$1" ] || mkdir -p "$1/"
    if [ $? -ne 0 ] ; then
        echo "fatal error creating directory '$1' ($?)"
        exit
    else
        echo "directory '$1' existed already"
    fi
    
    # __="$RESULT_check_double_quotes"

}

function check_name_email( ) {

    # mask all double quotes and remove the trailing and leading double quote

    declare -n RESULT_check_email_name=$1
    declare -n RESULT_check_email_name_full=$2
    declare -n RESULT_check_email_email=$3
    
    echo ""

    echo "your name is '$RESULT_check_email_name'";
    echo "your full name is '$RESULT_check_email_name_full'";
    echo "your email is '$RESULT_check_email_email'";
    
    echo ""
    
    read -p "Press enter if this okay or any other key" userInput

    # Check if string is empty using -z. For more 'help test'    
    if [[ -z "$userInput" ]]; then
        printf '%s\n' "name and email are okay now"    
    else
    
        echo ""
        echo "'0' changes your name: '$RESULT_check_email_name'";
        echo "'1' changes your full name: '$RESULT_check_email_name_full'";
        echo "'2' changes your email: '$RESULT_check_email_email'";            
        echo ""
    
    
        read -p "Press enter if the values are okay or '0','1' or '2'
        >" userInput
        while [[ $userInput != '' ]] 
        do
        
       
            if [[ $userInput == "0" ]] ; then 
                read -p "Enter the new name
                >" RESULT_check_email_name
            fi
            
            if [[ $userInput == "1" ]] ; then 
                read -p "Enter the new name
                >" RESULT_check_email_name_full
            fi
            
            
            if [[ $userInput == "2" ]] ; then 
                read -p "Enter the new email
                >" RESULT_check_email_email
            fi           
            
            echo ""
            echo "'0' changes your name: '$RESULT_check_email_name'";
            echo "'1' changes your full name: '$RESULT_check_email_name_full'";
            echo "'2' changes your email: '$RESULT_check_email_email'";            
            echo ""
            
            
            read -p "Press enter if the values are okay or '0','1' or '2'
            >" userInput
            
        done
    fi

}

function check_double_quotes( ) {

    # mask all double quotes and remove the trailing and leading double quote

    declare -n RESULT_check_double_quotes=$1
    RESULT_check_double_quotes=$(echo "$RESULT_check_double_quotes" | sed 's/\(\([^\]\)["]\)/\2\\\"/g' )

    if [[ ${RESULT_check_double_quotes:0:1} == "\"" ]] ; then 
        RESULT_check_double_quotes=${RESULT_check_double_quotes:1}
        # echo "removed leading double quote"
    fi

    if [[ ${RESULT_check_double_quotes: -2} == "\\\"" ]] ; then 
        count=${#RESULT_check_double_quotes}
        let count count-=2
        RESULT_check_double_quotes=${RESULT_check_double_quotes:0:$count}
        # echo "removed trailing double quote"
    fi

    # __="$RESULT_check_double_quotes"

}

function check_backslashes( ) {

    # single backslashes to double backslashes
    
    declare -n RESULT_check_backslashes=$1
    RESULT=$(echo "$RESULT_check_backslashes" | sed 's/\(\([^\]\)[\]\([^\]\)\)/\2\\\\\3/g' )
    
    # __="$RESULT"

}

function check_namespace( ) {

    # single backslashes to double backslashes
    # and a trailing double backslah
    
    declare -n RESULT_check_namespace=$1
    check_backslashes RESULT_check_namespace    
    
    # RESULT_check_namespace=$(echo "$1" | sed 's/\(\([^\]\)[\]\([^\]\)\)/\2\\\\\3/g' )
    
    if [[ ${RESULT_check_namespace: -2} != "\\\\" ]] ; then 
        RESULT_check_namespace="$RESULT_check_namespace\\\\"
    fi    

    # __="$RESULT_check_namespace"

}


function check_new( ) {

    # single backslashes to double backslashes
    # and a trailing double backslah
    declare -n RESULT_check_new=$1
    # RESULT_check_new=$(check_backslashes $1)    
    
    # RESULT_check_new=$(echo "$1" | sed 's/\(\([^\]\)[\]\([^\]\)\)/\2\\\\\3/g' )
    
    if [[ ${RESULT_check_new: -2} != "\\\\" ]] ; then 
        RESULT_check_new="$RESULT_check_new\\\\"
    fi    

    # __="$RESULT_check_new"

}

# we need bash version >= 4.4 for declare -n
if [[ $( bash --version |  grep -o  '[0-9\.]*' |head -n 1 )  < "4.4" ]]; then 
    echo "The script '$0' needs a bash version >= 4.4 in order to work"; 
    exit 1
fi

if (( $# < 4 )); then
    echo "exiting: at least four parameters are necessary to run $0"
    echo "- the first parameter is the vendor string on github (your username) ie: 'rstoetter'"
    echo "- the second parameter is the name the new repository ie: 'cdependencymanager-php'"
    echo "- the third parameter is the name of the namespace ie: 'cdependencymanager'"
    echo "- the fourth parameter is the name of the main class provided by your repository ie: 'myClass'"
    # echo "- use double quotes for the namespace and surround the namespace with quotation marks"
    exit 1
fi

YEAR=$(date +%Y)
DATE=$(date)

# fill in here your personal data

AUTHOR_NAME="rstoetter"
AUTHOR_NAME_FULL="Rainer Stötter"
AUTHOR_EMAIL="rstoetter@users.sourceforge.net"

check_name_email AUTHOR_NAME AUTHOR_NAME_FULL AUTHOR_EMAIL

echo "Your name is '$AUTHOR_NAME_FULL' and your email is '$AUTHOR_EMAIL'". 
read -p "Press enter to continue"
echo ""

VENDOR_NAME="$1"
# REPOSITORY_PATH="$1-php"

REPOSITORY_NAME="$2"

REPOSITORY_PATH="$2"
if [[ "$REPOSITORY_PATH" != *"/"* ]]; then
    REPOSITORY_PATH="$VENDOR_NAME/$REPOSITORY_PATH"
fi

REPOSITORY_PATH_DOUBLE="$REPOSITORY_PATH"

NAMESPACE="$3"
if [[ "$NAMESPACE" != *"\\"* ]]; then
    # echo "namespace '$NAMESPACE' contains no backslash - did you forget the superior vendor specifier?";
    NAMESPACE="$VENDOR_NAME\\\\$NAMESPACE\\\\"
fi

check_namespace NAMESPACE

CLASS_NAME="$4"

echo "The vendor string is '$VENDOR_NAME'."
echo "The repository has the name '$REPOSITORY_NAME' and the repository path is '$REPOSITORY_PATH'."
echo "You must have created the repository and saved the first wiki page on github before you can go on."
echo "   NO files like LICENSE or README!"
echo "The namespace will be '$NAMESPACE'"
echo "The main class name provided by the repository will be '$CLASS_NAME'"
read -p "Press enter to continue"
echo ""

# if [[ $NAMESPACE != *"\\\\"* ]]; then
#  echo "You have forgotten to use double backslashes in the namespace '$NAMESPACE'"
#  exit 1;
# fi

if [ -d "$REPOSITORY_NAME" ]; then
  echo exiting: the directory '$REPOSITORY_NAME' exists already
  exit 1
fi

# echo "do not forget to use double backslahes for the oneliner, the namespace and the README.md file - this does not affect the code sections in the README.md file!"
# read -p "Press enter to continue"
# echo ""

echo "give me now a oneliner to describe the repository '$REPOSITORY_PATH' - press ctrl-d when done:"
ONE_LINER=$(</dev/stdin)

echo ""

check_double_quotes ONE_LINER

echo $ONE_LINER

echo "give me now keywords fitting to the repository '$REPOSITORY_PATH' seperated by a space - press ctrl-d when done:"
KEY_WORDS=$(</dev/stdin)

# split the array into single elements and surround each element with quotation marks
STR_KEYWORDS=""
IFS=', ' read -r -a array <<< "$KEY_WORDS"
for element in "${array[@]}"
do
    STR_KEYWORDS=$STR_KEYWORDS\"$element\",
done
# remove the last colon
STR_KEYWORDS="${STR_KEYWORDS::-1}"

echo ""

echo "give me now the long description of the class '$CLASS_NAME' - use ctrl-d when done:"
CLASS_DESCRIPTION=$(</dev/stdin)

echo ""

check_double_quotes CLASS_DESCRIPTION
check_backslashes CLASS_DESCRIPTION

if [[ $CLASS_DESCRIPTION == *"\\"* ]]; then
if [[ $CLASS_DESCRIPTION != *"\\\\"* ]]; then
 echo "You seem to have forgotten to use double backslashes in the  "
 read -p "If this is okay then press enter to continue"
fi
fi

README_ADDON="
# The repository '$REPOSITORY_PATH'

# Index

## [Description](#index_description)
## [Use Cases](#index_use_cases)
## [Provided Classes](#index_classes)
## [Namespaces](#index_namespaces)
## [Installation](#index_installation)
## [Usage Example](#index_example)
## [More Informations](#index_informations)

<a name=\"index_description\"></a><h2>Description</h2>

$CLASS_DESCRIPTION

<a name=\"index_use_cases\"></a><h2>Use Cases</h2>

<a name=\"index_classes\"></a><h2>Provided Classes</h2>

The class \\rstoetter\\$NAMESPACE\\$CLASS_NAME is the main class of the repository $REPOSITORY_PATH_DOUBLE.

There are no helper classes necessary in order to use the class $CLASS_NAME:

But you will need PHP 7 or later to use this repository

<a name=\"index_namespaces\"></a><h2>Namespace</h2>

Use the [namespace](http://php.net/manual/en/language.namespaces.php) **rstoetter\\$NAMESPACE** in order to access the classes provided by the repository $REPOSITORY_PATH_DOUBLE.

<a name=\"index_installation\"></a><h2>Installation</h2>

The releases of the repository $REPOSITORY_PATH_DOUBLE are hosted by [Packagist](https://packagist.org), the main [composer](https://getcomposer.org/) repository. The repository assumes that you have composer installed. Simply add:

    \"require\" : {

        \"$AUTHOR_NAME/$REPOSITORY_NAME\" : \">=1.0.0\"

    }

to your **composer.json**, and then you can simply install it with the command:

    composer install

<a name=\"index_example\"></a><h2>Usage Example</h2>

\`\`\`php

//
// end the program
//

die( PHP_EOL . PHP_EOL . ' program finished in ' . __FILE__ . ' on line ' . __LINE__  . PHP_EOL );


\`\`\`


<a name=\"index_informations\"></a><h2>More Information</h2>

See the [project wiki of $REPOSITORY_PATH_DOUBLE](https://github.com/$AUTHOR_NAME/$REPOSITORY_NAME/wiki) for more technical informations.
"

README_ADDON_OLD="

## Installation

This project assumes you have composer installed. Simply add:

\"require\" : {

    \"$AUTHOR_NAME/$REPOSITORY_NAME\" : \">=1.0.0\"

}

to your composer.json, and then you can simply install with:

composer install

## Namespace

Use the namespace '$NAMESPACE' in order to access the classes provided by the repository '$REPOSITORY_PATH_DOUBLE'

## More information

See the [project wiki of $REPOSITORY_PATH_DOUBLE](https://github.com/$AUTHOR_NAME/$REPOSITORY_NAME/wiki) for more technical informations.

"


README_FILE="README.md"

# create the directory and change in it

checked_mkdir "$REPOSITORY_NAME"
cd "$REPOSITORY_NAME"

# the quotation marks will echo new line characters, too
echo "$README_ADDON" >> "$README_FILE"


# create LICENSE file

# -ne suppresses the new line character at the end of the line
# echo -ne $YEAR >> LICENSE

LICENSE_FILE="LICENSE"
LICENSE_VAR=" 

MIT License

Copyright (c) $YEAR $AUTHOR_NAME_FULL

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"

# surround with quotation marks in order to keep the new lines
echo "$LICENSE_VAR" >"$LICENSE_FILE"

# LICENSE file created

# create CHANGELOG.md file
CHANGELOG_FILE="CHANGELOG.md"
CHANGELOG_VAR="
    ver 1.00 : first version of repository $REPOSITORY_PATH on github on $DATE
"

echo "$CHANGELOG_VAR" > "$CHANGELOG_FILE"

# create file composer.json

COMPOSER_JSON_FILE="composer.json"
COMPOSER_JSON_CONTENTS="
{
    \"name\": \"$AUTHOR_NAME/$REPOSITORY_NAME\",
    \"description\": \"$ONE_LINER\",
    \"license\": \"MIT\",
    \"keywords\": [$STR_KEYWORDS],
    \"authors\": [
        {
            \"name\": \"$AUTHOR_NAME_FULL\",
            \"email\": \"$AUTHOR_EMAIL\"
        }
    ],
    \"require\": {
        \"php\": \">=7.0\"
    },
    \"require-dev\": {
        
    },
    \"autoload\": {
        \"psr-4\": {
            \"$NAMESPACE\": \"src\"
        }
    }
}
"

echo "$COMPOSER_JSON_CONTENTS" > "$COMPOSER_JSON_FILE"


# create a shell script, which calls phpDocumentor

PHPDOC_EXECUTABLE="phpdoc.sh"
PHPDOC_EXECUTABLE_SCRIPT="#!/bin/bash

# call the phpDocumentor

../../misc/phpdoc.sh \$*

"

echo "$PHPDOC_EXECUTABLE_SCRIPT" > "$PHPDOC_EXECUTABLE"
chmod +x "$PHPDOC_EXECUTABLE"

# create a shell script, which calls phpDocumentor

PHPDOC_MD_EXECUTABLE="phpdocmd.sh"
PHPDOC_MD_EXECUTABLE_SCRIPT="#!/bin/bash

# call the phpdocmd program, which generates md files out of the data phpDocumentor has found

../../misc/phpdocmd.sh \$*

"

echo "$PHPDOC_MD_EXECUTABLE_SCRIPT" > "$PHPDOC_MD_EXECUTABLE"
chmod +x "$PHPDOC_MD_EXECUTABLE"

# create the git revision finding script

GIT_REVISION_EXECUTABLE="git-revision.sh"
GIT_REVISION_CONTENTS="#!/bin/bash

# get the git revision

# vorher muss ausgeführt werden:
# git tag Prod-1

revisioncount=\`git log --oneline | wc -l\`
projectversion=\`git describe --tags --long\`
cleanversion=\${projectversion%%-*}

echo \"\$projectversion-\$revisioncount\"
"

echo "$GIT_REVISION_CONTENTS" > "$GIT_REVISION_EXECUTABLE"
chmod +x "$GIT_REVISION_EXECUTABLE"



# create the executable file to generate the xref with phpDocumentor
PHP_DOC_DIRECTORY="phpDocumentor.xref"
PHPDOC_CONFIG_FILE="phpdoc-$REPOSITORY_NAME.cfg"
PHPDOC_MAKER_EXECUTABLE="phpdoc-$REPOSITORY_NAME.sh"
PHPDOC_MAKER_EXECUTABLE_SCRIPT="#!/bin/bash

# scan the source files of repository $REPOSITORY_PATH_DOUBLE and generate a xref with phpDocumentor

DATUMSBLOCK=\$(date \"+%Y-%m-%d-%H-%M\")
STARTTIME=\$(date +%s)

echo \"harvesting..\"
time nice ./$PHPDOC_EXECUTABLE --config $PHPDOC_CONFIG_FILE -p --quiet \$*
echo \".. done the harvest\"

ENDTIME=\$(date +%s)
secs=\$((\$ENDTIME - \$STARTTIME))
printf 'Elapsed Time %dh:%dm:%ds\n' \$((\$secs/3600)) \$((\$secs%3600/60)) \$((\$secs%60))

for i in \"\$@\" ; do
    if [[ \$i == \"no-browser\" ]] ; then
        NO_BROWSER=1
        break
    fi
done

if [ -z \"\$NO_BROWSER\" ]; then
    chromium "$URL" &
fi

sleep 5
"

echo "$PHPDOC_MAKER_EXECUTABLE_SCRIPT" > "$PHPDOC_MAKER_EXECUTABLE"
chmod +x "$PHPDOC_MAKER_EXECUTABLE"

# creating the config file for phpdoc

PHPDOC_CONFIG_FILE_CONTENT="<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<phpdoc>
  <parser>
    <target>$PHP_DOC_DIRECTORY</target>
    <encoding>utf8</encoding>
    <markers>
      <item>TODO</item>
      <item>FIXME</item>
    </markers>
    <extensions>
      <extension>php</extension>
      <extension>php3</extension>
      <extension>phtml</extension>
    </extensions>
  </parser>
  <transformer>
    <target>$PHP_DOC_DIRECTORY</target>
  </transformer>
  <files>
    <file>src/*.php</file>
    <directory>not.available</directory>
    <directory>not.avail*</directory>
    <ignore>xdebug/*</ignore>
  </files>
  <title><![CDATA[<b>$REPOSITORY_NAME</b>]]></title>
  <logging>
      <level>warn</level>
      <paths>
          <default>{APP_ROOT}/phpdoc-$REPOSITORY_NAME-{DATE}.log</default>
          <errors>{APP_ROOT}/phpdoc-$REPOSITORY_NAME-{DATE}.errors.log</errors>
      </paths>
  </logging>
</phpdoc>
"

echo "$PHPDOC_CONFIG_FILE_CONTENT" > "$PHPDOC_CONFIG_FILE"

# create the bash file to generate the documentation from phpDocumentor generated files

WIKI_DIRECTORY="wiki/$REPOSITORY_NAME.wiki"
checked_mkdir "$WIKI_DIRECTORY"

PHP_DOC_MAKE_MD_EXECUTABLE="phpdoc-make-md-$REPOSITORY_NAME.sh"

PHP_DOC_MAKE_MD_EXECUTABLE_SCRIPT="#!/bin/bash

# create the md-files for the repository $REPOSITORY_NAME

DATUMSBLOCK=\$(date \"+%Y-%m-%d-%H-%M\")
STARTTIME=\$(date +%s)

checked_mkdir -p $WIKI_DIRECTORY/md-files.new
# mkdir -p $WIKI_DIRECTORY/md-files.dev
# mkdir -p $WIKI_DIRECTORY/md-files.usr

# rm $WIKI_DIRECTORY/md-files.usr/*
# rm $WIKI_DIRECTORY/md-files.dev/*
rm $WIKI_DIRECTORY/md-files.new/*

export NO_BROWSER=1

echo \"running $PHPDOC_MAKER_EXECUTABLE in order to generate the xml-templates\"
time nice ./$PHPDOC_MAKER_EXECUTABLE --template=\"xml\"

echo \"running ./$PHPDOC_MD_EXECUTABLE in order to generate the wiki pages\"

# time nice ./$PHPDOC_MD_EXECUTABLE $PHP_DOC_DIRECTORY/structure.xml $WIKI_DIRECTORY/md-files.usr/ --sort-index --sort-see --level component --public-on --private-off --protected-off \$*
time nice ./$PHPDOC_MD_EXECUTABLE $PHP_DOC_DIRECTORY/structure.xml $WIKI_DIRECTORY/md-files.new/ --sort-index --sort-see --level component    \$*

# export include_path=./misc/phpdoc-md/src

ENDTIME=\$(date +%s)
secs=\$((\$ENDTIME - \$STARTTIME))
printf 'Elapsed Time %dh:%dm:%ds\n' \$((\$secs/3600)) \$((\$secs%3600/60)) \$((\$secs%60))

# chromium $PHP_DOC_DIRECTORY/index.html &

sleep 5
"

echo "$PHP_DOC_MAKE_MD_EXECUTABLE_SCRIPT" > "$PHP_DOC_MAKE_MD_EXECUTABLE"
chmod +x "$PHP_DOC_MAKE_MD_EXECUTABLE"


# create file phpunit.xml

PHP_UNIT_FILE_NAME="phpunit.xml"
PHP_UNIT_FILE_CONTENTS="
phpunit.xml 
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<phpunit backupGlobals=\"false\"
         backupStaticAttributes=\"false\"
         bootstrap=\"vendor/autoload.php\"
         colors=\"true\"
         convertErrorsToExceptions=\"true\"
         convertNoticesToExceptions=\"true\"
         convertWarningsToExceptions=\"true\"
         processIsolation=\"false\"
         stopOnFailure=\"false\"
         syntaxCheck=\"false\">
    <testsuites>
        <testsuite name=\"$AUTHOR_NAME\\$REPOSITORY_NAME Test Suite\">
            <directory suffix=\".php\">./tests/</directory>
        </testsuite>
    </testsuites>
</phpunit>
"

echo "$PHP_UNIT_FILE_CONTENTS" > "$PHP_UNIT_FILE_NAME"

checked_mkdir src
checked_mkdir "$PHP_DOC_DIRECTORY"
checked_mkdir tests



## create the bash file to download the actual wiki pages and execute it

WIKI_GIT_CLONE_FILE="git-clone-documentation.sh"
WIKI_GIT_CLONE_CONTENTS="#!/bin/bash

# clone the wiki pages from repository $REPOSITORY_PATH
git clone https://github.com/$AUTHOR_NAME/$REPOSITORY_NAME.wiki.git
"

echo "$WIKI_GIT_CLONE_CONTENTS" > "wiki/$WIKI_GIT_CLONE_FILE"
chmod +x "wiki/$WIKI_GIT_CLONE_FILE"

cd wiki
./$WIKI_GIT_CLONE_FILE
cd ..

###

# create the main wiki files
WIKI_HOME_MD="Home.md"
WIKI_HOME_MD_CONTENTS="

Welcome to the wiki of the github repository '$REPOSITORY_PATH_DOUBLE'!

## Description

$ONE_LINER

## Namespace

Use the namespace $NAMESPACE in order to access the classes provided by the repository '$REPOSITORY_PATH_DOUBLE'

## Documentation:

see the [[English documentation]] in order to explore the classes of this repository

## History

see the CHANGELOG for the version history

## Documentation in other languages

If you want to maintain a wiki in another language, then contact me, please
"

echo "$WIKI_HOME_MD_CONTENTS" > "$WIKI_DIRECTORY/$WIKI_HOME_MD"

WIKI_FOOTER_MD="_Footer.md"
WIKI_FOOTER_MD_CONTENTS="
This wiki page is part of the documentation of the github repository [$REPOSITORY_PATH_DOUBLE](https://github.com/$AUTHOR_NAME/$REPOSITORY_NAME)
"
echo -ne $WIKI_FOOTER_MD_CONTENTS > "$WIKI_DIRECTORY/$WIKI_FOOTER_MD"

WIKI_ENGLISH="English-Documentation.md"
WIKI_ENGLISH_CONTENTS="

This is the English documentation of the repository $AUTHOR_NAME/$REPOSITORY_NAME

$ONE_LINER

[[English-Reference]]
"

echo "$WIKI_ENGLISH_CONTENTS" > "$WIKI_DIRECTORY/$WIKI_ENGLISH"

WIKI_REFERENCE="English-Reference.md"
WIKI_REFERENCE_CONTENTS="
# Reference of the github repository '$REPOSITORY_PATH_DOUBLE'

## purpose

$ONE_LINER

## namespace

- The namespace of the classes is **$NAMESPACE**.

## The API

<!---
hints to refer to API indexes or classes
use 'pub' as prefix for the API, which shows merely public available members or 'dev' for all access types
the template is '<prefix>-<namespace>--index' to access the API Index (you could copy it here)
the template is '<prefix>-<namespace>-<classname>' to access a certain class 


## The API for those, who want to use the classes in their code

  * the classes are listed in the **[Api Index](pub-rstoetter-cbalancedbinarytree--index)**

  * The class **[cBalancedBinaryTreeNode](pub-rstoetter-cbalancedbinarytree-cBalancedBinaryTreeNode)** which represents

## The Dev API for developers, who want to add features to the classes or to subclass the classes

  * the classes are listed in the **[Developers Api Index](dev-rstoetter-cbalancedbinarytree--index)**

  * The class **[cBalancedBinaryTreeNode](dev-rstoetter-cbalancedbinarytree-cBalancedBinaryTreeNode)** which represents

-->

## howto

$README_ADDON_OLD

_____

## The API documentation

- If you want to use the repository '$REPOSITORY_PATH_DOUBLE' in your projects, then use the reference: [[ApiIndex]]

- If you want to use protected methods and member variables by subclassing the classes of the repository '$REPOSITORY_PATH_DOUBLE' in your projects, then use the reference: [[DevApiIndex]]

_____

"

echo "$WIKI_REFERENCE_CONTENTS" > "$WIKI_DIRECTORY/$WIKI_REFERENCE"


# create the git add-script for the wiki pages

WIKI_GIT_ADD_EXECUTABLE="git-add.sh"
WIKI_GIT_ADD_CONTENTS="#!/bin/bash

# add all fresh and updated files to the repository 

git add ./*.md

"
echo "$WIKI_GIT_ADD_CONTENTS" > "$WIKI_DIRECTORY/$WIKI_GIT_ADD_EXECUTABLE"
chmod +x "$WIKI_DIRECTORY/$WIKI_GIT_ADD_EXECUTABLE"


# create the update script for the wiki pages

WIKI_GIT_UPDATE_FILE="git-update-documentation.sh"
WIKI_GIT_UPDATE_FILE_CONTENTS="#!/bin/bash

# push the changed wiki pages on the github server

./$WIKI_GIT_ADD_EXECUTABLE

echo \"give me a oneliner desribing the changes you have made - end your input with ctl-d\"
MESSAGE=\$(</dev/stdin)

git commit -m \"\$MESSAGE\"

git push origin master
"

echo "$WIKI_GIT_UPDATE_FILE_CONTENTS" > "$WIKI_DIRECTORY/$WIKI_GIT_UPDATE_FILE"
chmod +x "$WIKI_DIRECTORY/$WIKI_GIT_UPDATE_FILE"

# create the travis file

TRAVIS_YML_FILE=".travis.yml"
TRAVIS_YML_FILE_CONTENTS="
language: php

php:
  - hhvm
  - '7.0'

before_script:
  - composer self-update
  - composer install --prefer-source --no-interaction --dev
"

echo "$TRAVIS_YML_FILE_CONTENTS" > "$TRAVIS_YML_FILE"


# create the git add-script for the repository

GIT_ADD_EXECUTABLE="git-add.sh"
GIT_ADD_CONTENTS="#!/bin/bash

# add new files to the repository $REPOSITORY_PATH

git add ./*.php
git add ./composer.json
git add ./$README_FILE
git add src/*.php
git add tests/*.php
git add ./.travis.yml
git add ./phpunit.xml
git add ./$CHANGELOG_FILE
git add ./$LICENSE_FILE
"

echo "$GIT_ADD_CONTENTS" > "$GIT_ADD_EXECUTABLE"
chmod +x "$GIT_ADD_EXECUTABLE"



# make shell script to upload the files on github

UPLOAD_SCRIPT_NAME="git-push-$REPOSITORY_NAME.sh"
UPLOAD_SCRIPT_CONTENTS="#!/bin/bash

# upload the changed code on the github server

./$GIT_ADD_EXECUTABLE
echo \"give me a oneliner desribing the changes you have made - end your input with ctl-d\"
MESSAGE=\$(</dev/stdin)
git commit -m \"\$MESSAGE\"

git push origin master
echo \"do not forget to update the file $WIKI_DIRECTORY/$WIKI_REFERENCE when you have added classes to the repository!\"
echo \"do not forget to update the file $COMPOSER_JSON_FILE when you are using classes from other repositories!\"
echo \"do not forget to add a new release for $REPOSITORY_PATH on https://github.com in order to reflect your changes on https://packagist.org !\"
"

echo "$UPLOAD_SCRIPT_CONTENTS" > "$UPLOAD_SCRIPT_NAME"
chmod +x "$UPLOAD_SCRIPT_NAME"

# creating the wiki upload script

WIKI_UPLOAD_SCRIPT_NAME="git-push-wiki-$REPOSITORY_NAME.sh"
WIKI_UPLOAD_SCRIPT_CONTENTS="#!/bin/bash

# upload the changed wiki pages on the github server

./$WIKI_GIT_ADD_EXECUTABLE
echo \"give me a oneliner desribing the changes you have made - use ctl-d to accept your input\"
MESSAGE=\$(</dev/stdin)

git commit -m \"\$MESSAGE\"

git push origin master

echo \"do please edit the file $WIKI_REFERENCE if you have added classes to your repository!\"

"
echo "$WIKI_UPLOAD_SCRIPT_CONTENTS" > "$WIKI_DIRECTORY/$WIKI_UPLOAD_SCRIPT_NAME"
chmod +x "$WIKI_DIRECTORY/$WIKI_UPLOAD_SCRIPT_NAME"


# create git-ignore for the wiki pages
WIKI_GIT_IGONORE=".gitignore"
WIKI_GIT_IGONORE_CONTENTS="

# ignore the following files and directories when working with git

*~
$WIKI_UPLOAD_SCRIPT_NAME
$WIKI_GIT_UPDATE_FILE
*.000
*.org
*.swp
md-files.new/*
"

echo "$WIKI_GIT_IGONORE_CONTENTS" > "$WIKI_DIRECTORY/$WIKI_GIT_IGONORE"

# create .gitignore
GIT_IGONORE=".gitignore"
GIT_IGONORE_CONTENTS="

# ignore the following files and directories when working with git

xref/*
wiki/*
misc/*
tmp/*
*~
*.org
phpDocumentor.xref/*
*.swp
classes.org/*
tst.org/*
/vendor
composer.lock
$GIT_ADD_EXECUTABLE
$PHPDOC_MAKER_EXECUTABLE
$PHPDOC_CONFIG_FILE
$PHP_DOC_MAKE_MD_EXECUTABLE
$PHP_DOC_DIRECTORY/*
$WIKI_DIRECTORY/*
$UPLOAD_SCRIPT_NAME
$PHPDOC_EXECUTABLE
$PHPDOC_MD_EXECUTABLE
$GIT_REVISION_EXECUTABLE
"
echo "$GIT_IGONORE_CONTENTS" > "$GIT_IGONORE"


# now we can upload the first version

git init
git add $README_FILE
git add $CHANGELOG_FILE
git add $LICENSE_FILE

git commit -m "first commit"

git remote add origin https://github.com/$AUTHOR_NAME/$REPOSITORY_NAME.git
git push -u origin master


echo "Completed the creation of the skeleton directory '$REPOSITORY_NAME' for your new repository '$REPOSITORY_PATH'"
echo "The next steps suggested are:"
echo "- Change the contents of the file $WIKI_DIRECTORY/$WIKI_REFERENCE !"
echo "- Change the requirements in the file $COMPOSER_JSON_FILE when you are using classes from other repositories!"
echo "- Add a new release to your project on https://github.com"
echo "- Link your project with a new package on https://packagist.org/"

