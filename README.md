Progress Formatter
=======================

This is a Rspec-1.3 Custom Formatter

Installation
------------

    $ gem install progressbar
    $ git clone git@github.com:daic-h/rspec1.3-progress-formatter.git

How to Use
------------

Normal: => Fail message + Execution time
    spec -r "file-path/progress-formatter" -f Progress */*.rb

Fail list only:
    spec -r "file-path/progress-formatter" -f OnlyFail */*.rb

Execution time only:
    spec -r "file-path/progress-formatter" -f OnlyTime */*.rb
