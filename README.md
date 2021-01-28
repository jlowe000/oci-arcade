# oci-arcade

This was created to demonstrate a few things about Oracle Cloud Infrastructure in a "fun" way. There are different elements of the OCI that have been exercised that will be discussed here.

This borrows a couple of open-source javascript games to extends and play with.

- Space Invaders - https://github.com/lukegreaves5/invaders404
- Pacman - https://github.com/masonicGIT/pacman

This is a rought set of notes to get this up and running.

# Pre-Requisites

- Need an OCI Tenancy and this is built with a Always-Free Tier account in mind.
- Need an administrator access to the account (keeping it simple).

# 1. Prepare for running the Oracle Resource Manager Stack

- Create a compartment (and note the OCID)
- Create a SSH Key (ie using puttygen or ssh-keygen)
- Know which region you are deploying into
- Define an admin password for ADW

# 2. Run the ORM and create a stack using the directory tf-arcade as the source

- Provide the details above into the script
- The outcome will be:
  - A VCN
  - An ADW
  - A compute instance
  - An object storage bucket (public)

# 3. Login into your compute instance

- Using the SSH key that you created
- Run (as root) the bootstrap-server.sh script
  - to install docker, functions and git
- Run (as oracle) the bootstrap-user.sh script
  - to download the repo in the compute 

# 4. Upload the games to objectstorage

- Find the compute public IP address
- In the following files, for the API_HOSTNAME and update the value to the compute's public IP address
  - games/pacman/pacman.js
  - games/spaceinvaders/scripts/classes/eventhandler.js
- From the games directory run the following commands
  - python3 ../bin/bulk-upload.py pacman
  - python3 ../bin/bulk-upload.py spaceinvaders
- In the bucket find the index.htm under the pacman and spaceinvaders directories and view the URLs
- The games should be operational and able to be played
