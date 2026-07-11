## Case Scenario
A staff member has requested a list of the names of the services recognized by the current Linux image.
A file named /etc/services has been located that contains the pertinent information; however it is not organized to easily determine all of the services.
Using a combination of pipes, redirects and control statements, produce output that contains only the service names. 
The entire task must be accomplished without using any intermediary files. Each service should only be listed once and captured to a file named uniqueservices.txt, located in the home directory. Remove any blank lines or lines that are deemed to be comments.

There could be more than one possible solution for obtaining the desired results.

## Objectives

- Extract all the service names from the file.
- Sort the names alphabetically removing any duplicates.
- Remove any blank lines or lines that do not begin with a letter of the alphabet.
- Capture the final output to a file named uniqueservices.txt.
- Count the lines in the file using a conditional command that is only executed if the previous combined commands are successful.

## Step 1: Understand the file

Look at the first few lines:

head /etc/services

Typical output:

# Network services

tcpmux      1/tcp
echo        7/tcp
echo        7/udp
discard     9/tcp
discard     9/udp

Notice:

- Comment lines start with #
- Blank lines exist
- Service name is the first field
- The same service appears multiple times (TCP and UDP)

Our goal is to end up with:

chargen
daytime
discard
echo
ftp
http
...

Each service only once.

## Step 2: Remove comments and blank lines

The requirement says:

Remove blank lines or lines that do not begin with a letter.

We can use:

</> Bash

grep '^[A-Za-z]' /etc/services

- Explanation:

^ = beginning of line
[A-Za-z] = any alphabetic character

This automatically ignores:

comments (#)
blank lines
anything not beginning with a letter

</> Bash

## Step 3: Extract only the service name

The service name is the first column.

Use awk:

</> Bash

grep '^[A-Za-z]' /etc/services | awk '{print $1}'

- Example output:

echo
echo
discard
discard
ftp
ftp

## Step 4: Sort and remove duplicates

Use sort -u:

</> Bash

grep '^[A-Za-z]' /etc/services | awk '{print $1}' | sort -u

- Now you'll get:

chargen
daytime
discard
echo
ftp
http
...

## Step 5: Save to the required file

Redirect the output:

</> Bash

grep '^[A-Za-z]' /etc/services | awk '{print $1}' | sort -u > ~/uniqueservices.txt

- Now verify:

cat ~/uniqueservices.txt

## Step 6: Count the lines only if everything succeeded

The exercise specifically says:

Count the lines using a conditional command only if the previous commands are successful.

Use &&:

</> Bash

grep '^[A-Za-z]' /etc/services | awk '{print $1}' | sort -u > ~/uniqueservices.txt && wc -l ~/uniqueservices.txt

- What && does

Command 2 only runs if Command 1 exits successfully.

If something fails:

grep ...

then

wc -l

will not execute.

# Complete solution

</> Bash

grep '^[A-Za-z]' /etc/services | awk '{print $1}' | sort -u > ~/uniqueservices.txt && wc -l ~/uniqueservices.txt

- Breaking down the pipeline

/etc/services
      │
      ▼
grep '^[A-Za-z]'
(Removes comments and blank lines)
      │
      ▼
awk '{print $1}'
(Extract first field)
      │
      ▼
sort -u
(Sort alphabetically and remove duplicates)
      │
      ▼
> ~/uniqueservices.txt
(Save output)
      │
      ▼
&&
      │
      ▼
wc -l ~/uniqueservices.txt
(Count lines only if previous command succeeded)

# Alternative solution (without awk)

You could also use cut:

</> Bash

grep '^[A-Za-z]' /etc/services | cut -d' ' -f1 | sort -u > ~/uniqueservices.txt && wc -l ~/uniqueservices.txt

However, awk '{print $1}' is generally more reliable because /etc/services often uses tabs and varying amounts of whitespace.
awk treats any whitespace as a field separator automatically, making it the preferred approach for this file.
