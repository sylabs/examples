ronn.sif(1) - Ronn in an Alpine container
=============================================

## SYNOPSIS

`ronn.sif` [<OPTION>] [<COMMAND>] [<YOUR_MARKDOWN_FILE>]

## DESCRIPTION
Ronn (v0.7.3) in an Alpine (3.8) container<br>
ronn can convert markdown to manpages and html files

## OPTIONS

* `--help`, `--run-help` :
    print container help

* `--info`, `--run-info` :
    print container info

* `-m`, `--man` :
    only generate man page

* `-g`, `--gzip` :
    only generate gzip file

* `-h`, `--html` :
    only generate html file

## VARIABLES:

* `-o=`, `--out=`[<`string`>.1] :
    specify an output file

## COMMANDS

* `exec`, `system` :
    execute a command in the container

* `view`, `view-file` :
    view a manpage from the container

* `ronn` :
    execute a ronn command in the container

## EXAMPLES
making a manpage:<br>
this will make a `*.1`, `*.1.gz` and `*.1.html` file<br>
`$` ./ronn.sif manpage-test.md

only generate a manpage:<br>
`$` ./ronn.sif --man manpage-test.md

only generate a manpage and gzip file:<br>
`$` ./ronn.sif --man --gzip manpage-test.md

only generate a manpage and html file with specific output:<br>
`$` ./ronn.sif --man --html --out=your_output_file.1 manpage-test.md

viewing a manpage or markdown file:<br>
`$` ./ronn.sif view manpage-test.1<br>
or:<br>
`$` ./ronn.sif view manpage-test.md

viewing a manpage or gzip file the normal way:<br>
`$` man ./manpage-test.1

running a ronn command:<br>
`$` ./ronn.sif ronn --version

running a command in the container:<br>
`$` ./ronn.sif exec ls /

## NOTES
for full tutorial/info, visit: `https://github.com/sylabs/examples`

## AUTHOR
definition file made by: `WestleyK` <westleyk@nym.hush.com>

## REPORTING BUGS
`https://github.com/sylabs/examples` or <support@sylabs.io>

