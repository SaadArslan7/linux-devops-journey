## Case Scenario
Using the commands one at a time from the command line can be a tedious process and could lead to potential errors in syntax.
It is your duty, as an administrator, to make the process as seamless and efficient as possible.

Objectives
Create a bash script to perform user management tasks as outlined below:

-Create a new group. Each group must have a unique name. The script must check to ensure that no duplicate group names exist on the system. If a duplicate is found, 
an error needs to be reported, and the administrator must try another group name.
-Create a new user. Each user must have a unique name. The script must check to ensure that no duplicate usernames exist on the system. If a duplicate is found, 
an error needs to be reported and the administrator must try another username. The user will have a Bash login shell and belong to the group that was created in the previous step.
-Create a password for each user that is created.
-Ensure that the new user created is a member of the new group created.
-Create a directory at the root / of the file system with same name as the user created.
-Set the ownership of the directory to the user and group created.
-Set the permissions of the directory to full control for the owner and full control for the group created.
-Set the permissions to ensure that only the owner of a file can delete it from the directory.
-Ensure that the script is executable.

========================
SOLUTION:
========================

# 1. Check for root privileges

Since the script creates users, groups, and directories under /, it must be run as root.

</> Bash

if [ "$EUID" -ne 0 ]
then
    echo "Please run this script as root."
    exit 1
fi

# 2. Prompt for input

</> Bash

echo "Enter group name:"
read GROUP

echo "Enter username:"
read USER

echo "Enter password:"
read -s PASS
echo

At this point, you have all the information needed before making any changes.

# 3. Validate inputs

Check if the group exists

</> Bash

if getent group "$GROUP" >/dev/null
then
    echo "Error: Group already exists."
    exit 1
fi

Check if the user exists

</> Bash

if id "$USER" >/dev/null 2>&1
then
    echo "Error: User already exists."
    exit 1
fi

Notice that nothing has been created yet. If either check fails, the system remains unchanged.

# 4. Create the group

</> Bash

groupadd "$GROUP"

if [ $? -ne 0 ]
then
    echo "Failed to create group."
    exit 1
fi

# 5. Create the user

</> Bash

useradd -m -s /bin/bash -g "$GROUP" "$USER"

if [ $? -ne 0 ]
then
    echo "Failed to create user."

    groupdel "$GROUP"

    exit 1
fi

Rollback removes the group if user creation fails.

# 6. Set the password

</> Bash

echo "$USER:$PASS" | chpasswd

if [ $? -ne 0 ]
then
    echo "Failed to set password."

    userdel -r "$USER"
    groupdel "$GROUP"

    exit 1
fi

Rollback removes both the user and the group.

# 7. Create the directory

</> Bash

mkdir "/$USER"

if [ $? -ne 0 ]
then
    echo "Failed to create directory."

    userdel -r "$USER"
    groupdel "$GROUP"

    exit 1
fi

# 8. Set ownership

</> Bash

chown "$USER:$GROUP" "/$USER"

if [ $? -ne 0 ]
then
    echo "Failed to set ownership."

    rm -rf "/$USER"
    userdel -r "$USER"
    groupdel "$GROUP"

    exit 1
fi

# 9. Set permissions

</> Bash

chmod 770 "/$USER"

if [ $? -ne 0 ]
then
    echo "Failed to set permissions."

    rm -rf "/$USER"
    userdel -r "$USER"
    groupdel "$GROUP"

    exit 1
fi

# 10. Set the sticky bit

</> Bash

chmod +t "/$USER"

if [ $? -ne 0 ]
then
    echo "Failed to set sticky bit."

    rm -rf "/$USER"
    userdel -r "$USER"
    groupdel "$GROUP"

    exit 1
fi

# 11. Success message

echo
echo "====================================="
echo "User created successfully."
echo "Username : $USER"
echo "Group    : $GROUP"
echo "Directory: /$USER"
echo "====================================="


# Workflow Diagram

Start
 │
 ▼
Check for root
 │
 ▼
Read group name
 │
 ▼
Read username
 │
 ▼
Read password
 │
 ▼
Check group exists?
 │
 ├── Yes → Exit
 │
 ▼
Check user exists?
 │
 ├── Yes → Exit
 │
 ▼
Create group
 │
 ▼
Create user
 │
 ▼
Set password
 │
 ▼
Create directory
 │
 ▼
Change ownership
 │
 ▼
Set permissions
 │
 ▼
Set sticky bit
 │
 ▼
Success
