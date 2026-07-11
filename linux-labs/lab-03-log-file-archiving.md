## Case Scenario

There has been suspicious activity on the system. In order to preserve log information, it will be necessary to archive the current files in /var/log ending with the .log extension.
The files are to be saved to a file named log.tar, stored in the directory, ~/archive.
It has also been requested that the files that were archived be saved to a directory, ~/backup.

## Objectives

-Create an archive named log.tar that is stored in the archive directory located in the home directory.
-Remove path names from the files that are archived.
-Produce verbose output while archiving.
-List the contents of the archive without extracting.
-Extract the files to the directory, ~/backup.

## Step 1: Create the required directories

First, make sure the archive and backup directories exist in your home directory.

</> Bash

mkdir -p ~/archive ~/backup

# Explanation:

mkdir = create directory.
-p = don't complain if the directory already exists.

- Verify:

ls ~

- You should see:

archive
backup

## Step 2: Go to the directory containing the log files

</> Bash

cd /var/log

- Verify you're in the correct location:

pwd

Output:

/var/log

## Step 3: Create the archive

</> Bash

tar -cvf ~/archive/log.tar *.log

- What each option means
c → Create a new archive.
v → Verbose (shows every file being archived).
f → Archive filename follows (~/archive/log.tar).

Since you're already inside /var/log, using *.log archives only the filenames, not the full path.

This satisfies:

✔ Create archive

✔ Remove path names

✔ Verbose output

Example output:

boot.log
dpkg.log
kern.log
syslog.log
...

## Step 4: Verify the archive was created

</> Bash

ls ~/archive

- Expected:

log.tar

- You can also check its size:

ls -lh ~/archive

## Step 5: List the contents without extracting

</> Bash

tar -tf ~/archive/log.tar

- You'll see something like:

boot.log
dpkg.log
kern.log
...

Notice there are no paths like /var/log/.

## Step 6: Extract into the backup directory

</> Bash

tar -xf ~/archive/log.tar -C ~/backup

- Options
x = extract
f = archive file
-C = extract into another directory

## Step 7: Verify extraction

</> Bash

ls ~/backup

or

ls -l ~/backup

- You should see:

boot.log
dpkg.log
kern.log
...

## Complete command sequence

</> Bash

mkdir -p ~/archive ~/backup

cd /var/log

tar -cvf ~/archive/log.tar *.log

tar -tf ~/archive/log.tar

tar -xf ~/archive/log.tar -C ~/backup

ls ~/backup

- Why cd /var/log first?

The objective says:

Remove path names from the files that are archived.

If you instead ran:

tar -cvf ~/archive/log.tar /var/log/*.log

the archive would likely contain entries like:

var/log/boot.log
var/log/dpkg.log

By changing into /var/log first and archiving *.log, only the filenames are stored, which is exactly what the exercise requires.
