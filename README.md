# oci-arcade

This was created to demonstrate a few things about Oracle Cloud Infrastructure in a "fun" way. There are different elements of the OCI that have been exercised that will be discussed here.

This borrows a couple of open-source javascript games to extends and play with.

- Space Invaders - https://github.com/lukegreaves5/invaders404
- Pacman - https://github.com/masonicGIT/pacman

This is a rought set of notes to get this up and running.

## Pre-Requisites

- Need an OCI Tenancy and this is built with a Always-Free Tier account in mind.
- Need an administrator access to the account (keeping it simple).

## 1. Prepare for running the Oracle Resource Manager Stack

- Create a compartment (and note the OCID)
- Create a SSH Key (ie using puttygen or ssh-keygen)
- Know which region you are deploying into
- Define an admin password for ADW

## 2. Run the ORM and create a stack using the directory tf-arcade as the source

- Provide the details above into the script
- The outcome will be:
  - A VCN
  - An ADW
  - A compute instance
  - An object storage bucket (public)

## 3. Login into your compute instance

- Using the SSH key that you created
- Run (as root) the bootstrap-server.sh script
  - to install docker, functions and git
- Run (as oracle) the bootstrap-user.sh script
  - to download the repo in the compute 

## 4. Upload the games to objectstorage

- Find the compute public IP address
- In the following files, for the API_HOSTNAME and update the value to the compute's public IP address
  - games/pacman/pacman.js
  - games/spaceinvaders/scripts/classes/eventhandler.js
- From the games directory run the following commands
  - python3 ../bin/bulk-upload.py pacman
  - python3 ../bin/bulk-upload.py spaceinvaders
- In the bucket find the index.htm under the pacman and spaceinvaders directories and view the URLs
- The games should be operational and able to be played

## 5. Enable the database

- Login into APEX Admin (via the OCI Console >> Service Console >> Oracle APEX)
- Establish the SCORE and EVENT tables and REST APIs (via ORDS)
  - import the ociarcade workspace (and update the password)
    - infra/db/OCIARCADE.sql
  - logout of INTERNAL and login to ociarcade workspace then run these SQL Scripts
    - infra/db/init.sql to enable ORDS and create ociarcade_api OAuth user / client
    - apis/events/db/init.sql to create the EVENT table and enables the AutoREST ORDS API and permissions
    - apis/score/db/init.sql to create the SCORE table and enables the AutoREST ORDS API and permissions
  - you should be able to test these end-points, available from table object in the Object Browser
- Configure the public API to connect to the APEX
  - Identify the following parameters
    - APEX HOSTNAME (which is the host of the APEX app)
    - ORDS workspace URI (which is configured as ociarcade by default)
    - ORDS client id and secret (which can be queried by "select client_id, client_secret from user_ords_clients;")
  - Add these parameters to the public API dockerfile (copy the template to a new name)
    - containers/web/api-score.Dockerfile
    - leave EVENT_FNID
  - Build the public API docker image from the project root directory
    - bin/api-score-docker-build.sh
    - NB: This will also create a set of self-signed certs that will be used for HTTPS.
  - Start the public API docker image
    - bin/api-score-docker-run.sh
  - From here you will have a publicly accessible API to execute against ORDS and the database. Test the following from a browser:
    - https://<instance-public-ip>:8081/score/game_id=1
    - NB: You will need to accept the SSL exception because the SSL is setup with self-signed certs. 
  - The game will now be able to call the APIs and the high-scores will now be saved. Play the game and check out the hi-scores
