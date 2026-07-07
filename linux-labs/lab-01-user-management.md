## Case Scenario
As the Linux Administrator for fast-growing company, you have been tasked with creating, modifying, and removing user accounts from the Linux server.
The company has just hired 9 new employees to fill 3 newly designed departments. The departments that have been created are Engineering, Sales and IS. 
The server must be setup with the appropriate files, folders, users, groups and permissions to ensure a successful launch of the newly designed departments.

## Objectives
•Create a directory at the root (/) of the file system for each department. This name should reflect the department name that will use the directory.
•Create a group for each department. This name should reflect the department name that the group will be assigned.

•Create an administrative user for each of the departments.

	•The user will have a Bash login shell.
	•The user will belong to the respective group for each department. This will need to be the user’s primary group.

•Create two additional users for each department.

	•The users will have a Bash login shell.
	•The users will belong to their respective group for each department. This will need to be the user’s primary group.

•For security reasons, the following modifications will need to be made to each of the departments' respective directories:

	•Ensure that the owner of each of the directories is the department administrator and the group ownership is the group for each department.
	•The department administrator will have full access to their respective department directories.
	•Ensure that only the owner of a file in the department’s directory can delete the file. The user will also have ownership of their respective department folders.
	•Normal users in each department will have full access (Read, Write and Execute) to their respective department folders.
	•The department folders will ONLY be accessible by users/administrators in each of the respective departments. Ensure that no one else will have permissions to the folders.

•Create a document in each of the department directories.

	•The ownerships on this file will be the same as the directory it is located in.
	•The document should contain only one line of text that states, “This file contains confidential information for the department.”
	•This file can be read by any user in the department, but can only be modified by the department administrator. No one else has permissions to this file.

## Deliverables
•Use the appropriate command to verify each user and group has been created.
•Use the appropriate command to verify each user’s group assignment.
•Use the appropriate command to verify the directory creation and the permission settings.
•Use the appropriate command to verify the files are created in their respective directories.

###############
Solution
###############

## Step 1: Become root

</> Bash

sudo -i

or

su -

## Step 2: Create the department directories

Create one directory for each department under /.

</> Bash 

mkdir /Engineering
mkdir /Sales
mkdir /IS

Verify:

</> Bash 

ls /

You should see

Engineering
Sales
IS

## Step 3: Create the groups

Create one Linux group for each department.

</> Bash 

groupadd Engineering
groupadd Sales
groupadd IS

Verify:

</> Bash 

getent group Engineering
getent group Sales
getent group IS

## Step 4: Create the department administrators

Suppose the administrators are

Department	Admin Username
Engineering	engadmin
Sales	salesadmin
IS	isadmin

Create them.

# Engineering:

</> Bash 

useradd -m -s /bin/bash -g Engineering engadmin
passwd engadmin

# Sales:

</> Bash 

useradd -m -s /bin/bash -g Sales salesadmin
passwd salesadmin

# IS:

</> Bash 

useradd -m -s /bin/bash -g IS isadmin
passwd isadmin

Explanation:

-m → create home directory
-s /bin/bash → Bash shell
-g → primary group

Verify:

</> Bash 

id engadmin

Example output:

uid=1001(engadmin)
gid=1001(Engineering)

## Step 5: Create two normal users per department

Example names:

# Engineering

eng1
eng2

# Sales

sales1
sales2

# IS

is1
is2

# Engineering

</> Bash 

useradd -m -s /bin/bash -g Engineering eng1
passwd eng1

useradd -m -s /bin/bash -g Engineering eng2
passwd eng2

# Sales

</> Bash 

useradd -m -s /bin/bash -g Sales sales1
passwd sales1

useradd -m -s /bin/bash -g Sales sales2
passwd sales2

# IS

useradd -m -s /bin/bash -g IS is1
passwd is1

useradd -m -s /bin/bash -g IS is2
passwd is2

# Verify one:

</> Bash 

id eng1

## Step 6: Change ownership of the department directories

# Engineering

</> Bash 

chown engadmin:Engineering /Engineering

# Sales

</> Bash 

chown salesadmin:Sales /Sales

# IS

</> Bash 

chown isadmin:IS /IS

# Verify

</> Bash 

ls -ld /Engineering

Example:

drwxr-xr-x engadmin Engineering

## Step 7: Configure directory permissions

The requirements are:

Administrator has full control
Department members have full control
Others have no access
Users can delete only their own files

The sticky bit prevents users from deleting files they don't own.

# Set permissions:

# Engineering

</> Bash 

chmod 1770 /Engineering

# Sales

</> Bash 

chmod 1770 /Sales

# IS

</> Bash 

chmod 1770 /IS

Explanation:

1 = sticky bit

770

Owner = rwx
Group = rwx
Others = ---

Verify

</> Bash 

ls -ld /Engineering

Output:

drwxrwx--T

or

drwxrwx--t

The important part is the t at the end.

## Step 8: Set the SetGID bit

This requirement says:

The user will also have ownership of their respective department folders.

Actually, to ensure new files inherit the department group, you should set the setgid bit on the directories.

</> Bash 

chmod g+s /Engineering
chmod g+s /Sales
chmod g+s /IS

Now verify:

</> Bash 

ls -ld /Engineering

You should see

drwxrws--t

Notice the s.

This means every new file automatically belongs to the Engineering group.

## Step 9: Create the confidential document

# Engineering

</> Bash 

touch /Engineering/confidential.txt

# Sales

</> Bash 

touch /Sales/confidential.txt

# IS

</> Bash 

touch /IS/confidential.txt

## Step 10: Add the required text

# Engineering

</> Bash 

echo "This file contains confidential information for the department." > /Engineering/confidential.txt

Repeat for Sales and IS.

## Step 11: Set ownership on the files

# Engineering

</> Bash 

chown engadmin:Engineering /Engineering/confidential.txt

# Sales

</> Bash 

chown salesadmin:Sales /Sales/confidential.txt

# IS

</> Bash 

chown isadmin:IS /IS/confidential.txt

## Step 12: Set file permissions

Requirements:

Admin can modify
Department users can read
Others have no access

Permission:

640

# Engineering

</> Bash 

chmod 640 /Engineering/confidential.txt

# Sales

</> Bash 

chmod 640 /Sales/confidential.txt

# IS

</> Bash 

chmod 640 /IS/confidential.txt

Verify

</> Bash 

ls -l /Engineering/confidential.txt

# Output:

-rw-r----- 1 engadmin Engineering confidential.txt

Meaning:

Owner

rw-

Group

r--

Others

---

## Step 13: Test the permissions

Login as a normal Engineering user:

</> Bash 

su - eng1

Create a file:

</> Bash 

touch myfile

Verify ownership:

</> Bash 

ls -l

Should show

</> Bash 

eng1 Engineering

Try reading:

</> Bash 

cat confidential.txt

Works.

Try editing:

</> Bash 

echo test >> confidential.txt

Should fail:

Permission denied

Try deleting another user's file (after they create one):

</> Bash 

rm eng2file

Should fail because of the sticky bit.

## Step 14: Verify everything

# Users

</> Bash 

cat /etc/passwd

# Groups

</> Bash 

cat /etc/group

# Directory permissions

</> Bash 

ls -ld /Engineering /Sales /IS

# File permissions

</> Bash 

ls -l /Engineering
ls -l /Sales
ls -l /IS

# User information

</> Bash 

id engadmin
id eng1
id eng2

id salesadmin
id sales1
id sales2

id isadmin
id is1
id is2

## Final expected permissions

Object	Owner	Group	Permissions
/Engineering	engadmin	Engineering	drwxrws--t (mode 3770)
/Sales	salesadmin	Sales	drwxrws--t (mode 3770)
/IS	isadmin	IS	drwxrws--t (mode 3770)
confidential.txt	Department admin	Department group	-rw-r----- (mode 640)

Note on the directory mode: To satisfy both requirements—(1) new files inherit the department group and (2) only the file owner can delete their own files—you need both the setgid bit and the sticky bit. The resulting numeric mode is 3770 (2000 for setgid + 1000 for sticky + 770 for permissions), which appears as drwxrws--t in ls -ld.
