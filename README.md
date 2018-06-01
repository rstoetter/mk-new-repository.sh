
# The repository 'rstoetter/mk-new-repository.sh'

# Index

## [Description](#index_description)
## [Requirements](#index_requirements)
## [Use Cases](#index_use_cases)
## [Provided Files and Directories](#index_files)
## [Installation](#index_installation)
## [More Informations](#index_informations)

<a name="index_description"></a><h2>Description</h2>

bash script, which creates a skeleton directory with the necessary bunch of files for a fresh github PHP repository

<a name="index_requirements"></a><h2>Requirements</h2>

make sure, that you are running a bash version >= 4.4 

    bash --version


<a name="index_use_cases"></a><h2>Use Cases</h2>

## What you should have done before executing the bash script mk-new-repository.sh

- create a new EMPTY ( no files! ) repository on github 
- save the first wiki page 

## executing the bash script mk-new-repository.sh

    mk-new-repository.sh vendor_string repository_name namespace class_name

- the first parameter is the vendor string on github (your username) ie: 'rstoetter'"
- the second parameter is the name the new repository ie: 'cdependencymanager-php'"
- the third parameter is the name of the namespace ie: 'cdependencymanager'"
- the fourth parameter is the name of the main class provided by your repository ie: 'myClass'"

The bash script will then create a directory withe the name 'repository_name' and fill it with files and directories you may find useful in order to start your new project

<a name="index_files"></a><h2>Provided Files and Directories</h2>

    <RepositoryName>
    ├── ./CHANGELOG.md
    ├── ./composer.json
    ├── ./git-add.sh
    ├── ./git-push-<RepositoryName>.sh
    ├── ./git-revision.sh
    ├── ./LICENSE
    ├── ./phpdoc-make-md-<RepositoryName>.sh
    ├── ./phpdocmd.sh
    ├── ./phpdoc-<RepositoryName>.cfg
    ├── ./phpdoc-<RepositoryName>.sh
    ├── ./phpdoc.sh
    ├── ./phpDocumentor.xref
    ├── ./phpunit.xml
    ├── ./README.md
    ├── ./src
    ├── ./tests
    └── ./wiki
        ├── ./wiki/git-clone-documentation.sh
        └── ./wiki/<RepositoryName>.wiki
            ├── ./wiki/<RepositoryName>.wiki/English-Documentation.md
            ├── ./wiki/<RepositoryName>.wiki/English-Reference.md
            ├── ./wiki/<RepositoryName>.wiki/_Footer.md
            ├── ./wiki/<RepositoryName>.wiki/git-add.sh
            ├── ./wiki/<RepositoryName>.wiki/git-push-wiki-<RepositoryName>.sh
            ├── ./wiki/<RepositoryName>.wiki/git-update-documentation.sh
            └── ./wiki/<RepositoryName>.wiki/Home.md

<a name="index_installation"></a><h2>Installation</h2>

    git clone https://github.com/rstoetter/mk-new-repository.sh.git


<a name="index_informations"></a><h2>More Information</h2>

See the [project wiki of rstoetter/mk-new-repository.sh](https://github.com/rstoetter/mk-new-repository.sh/wiki) for more technical informations.

