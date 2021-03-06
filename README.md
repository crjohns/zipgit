zipgit
======

Tools for storing git repositories in zip files

If you have ever had trouble storing git repositories in a cloud service
like Dropbox, this project can help.

Installation
------------

Simply copy zipgit.sh to your PATH. Optionally set up a symbolic link to
it with 'ln -s zipgit.sh zipgit'.

Usage
-----

There are currently three commands: "init", "open", and "close".

'zipgit init FILE' will initialize a bare git repository and store it
in the root directory of a zip file at the given path. NOTE: This 
will delete any zip file currently there.

'zipgit open FILE' will extract 'FILE' to './.ziprepo' and make note of it
in './.zipgitopened'

You may then add '.ziprepo' as a remote for your git repository, and push your changes there.

When you are done, run 'zipgit close' which does the following:

1. Remove the previously opened FILE
2. Zip the contents of .ziprepo and store in FILE
3. Remove .ziprepo and .zipgitopened

Example
-------

I have a git repository in ~/myproject and a bare git repo in 
~/Dropbox/myproject.zip

In ~/myproject, run 'zipgit open ~/Dropbox/myproject.zip'.

Do 'git remote add origin .ziprepo'.

Do 'git push -u origin master'

This sets up the bare repo in the zip file as a remote.

Now make whatever changes and push them as normal.

When done, do 'zipgit close' to store changes back in Dropbox.

If you end up with conflicts between two versions in Dropbox, treat them as
two different remotes which you can merge into your tree separately.

TODO
----

This is clearly a work in progress (I just hacked together this script in
30 minutes).

Overall, the "open/close" paradigm may need to be rethinked for this 
utility.
