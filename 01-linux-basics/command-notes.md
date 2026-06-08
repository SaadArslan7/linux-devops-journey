# Linux Commands Notes

## Navigating & creating the directory

## pwd
Prints the current working directory.

Example:
pwd

Output:
It displays your current location in the file system.

## mkdir
Creates a new directory.

Example:
mkdir testdir

Output:
The mkdir command (short for "make directory") creates a new directory named testdir.

## Creating Files and Listing Directory Contents

## ls
Lists files and directories.

Example:
ls

Output:
This will list the files and directories in your current working directory

## ls -l
The -l option provides a "long" format listing. You'll see additional details like file permissions, owner, size, and modification date.

Example:
ls -l testdir

Output:
This lists the contents of the testdir directory.

## ls -a
This will show all files, including the hidden ones.

## ls -la
This combines the long format (-l) with showing all files (-a).

## ls ~
Lists the contents of your home directoryThis command lists the contents of your home directory.

## cd
This command is used to navigate to a specific directory.

Example:
cd project

## cd ..
Move up one level to the parent directory. The .. means "the directory above".

## cd ~
This takes us to our home directory. The ~ is a shortcut for home directory.

## touch
The touch command is used to create an empty file. If the file already exists, it updates the file's timestamp without changing its content.

Example:
touch file1.txt

## echo 
This commands prints text.

Example:
echo "Hello, Linux" > file2.txt

Output:
The > symbol redirects the output of echo into a file named file2.txt. If the file doesn't exist, it's created. If it does exist, its content is replaced.

## Copying Files and Directories

## cp
Copy a file.

Example:
cp file1.txt file1_copy.txt

Output:
This creates a copy of file1.txt named file1_copy.txt in the current directory.

Example:
cp file2.txt testdir

Output:
This copies file2.txt into the testdir directory.

Example:
cp -r testdir testdir_copy

Output:
The -r option stands for "recursive". It's necessary when copying directories to ensure all contents are copied.

## Moving and Renaming Files and Directories

## mv
The mv command is used for both moving and renaming.

Example:
mv file1.txt newname.txt

Output:
This renames file1.txt to newname.txt.

## (Move a file to a directory)

Example:
mv newname.txt testdir/

Output:
This moves newname.txt into the testdir directory.

## (Rename a directory)

Example:
mv testdir_copy new_testdir

Output:
This renames testdir_copy to new_testdir.

## (Move and rename in one command)

Example:
mv testdir/newname.txt ./original_file1.txt

Output:
This moves newname.txt out of testdir and renames it to original_file1.txt in the current directory.

## Removing Files and Directories

## rm
The rm command (short for "remove") deletes files.

Example:
rm original_file1.txt

Output:
It deletes the original_file1.txt.

## (Remove interactively (safer))

Example:
rm -i file2.txt

Output:
The -i option prompts you for confirmation before deleting each file. Type y (for yes) and press Enter to confirm the deletion. If you type n or anything else, the file will not be deleted.

## (Remove an empty directory)

## rmdir
rmdir (remove directory) only works on empty directories.

Example:
rmdir testdir

Output:
This command will remove testdir if it's empty.

## (Remove a directory and its contents (recursively):

To remove a directory that is not empty, we need to use rm with the -r (recursive) option:

rm -r testdir

This command removes the testdir directory and everything inside it. Use this command with caution.

## (Force removal (use with extreme caution))

Sometimes, you might want to remove files without being prompted, even if they are write-protected (though we don't have any here). The -f (force) option does this.
Now, let's combine -r and -f. The rm -rf command is extremely powerful and potentially dangerous. It removes directories recursively (-r) and forces removal without prompting (-f).
Be ABSOLUTELY SURE you know what you are deleting before running rm -rf. A small typo could delete critical system files or your personal data. 
There is no undo. For example, rm -rf / could attempt to delete your entire system (if you have permissions). Always double-check the path.
