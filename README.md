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
- Note your user OCID
- Note your tenancy namespace
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
  - Deploy a NodeJS expressjs server with score and event public APIs
  - Deploy a Oracle FN (python) with event API
  - Deploy ORDS APIs and tables in ADW
  - publish static content to object storage
- The output variables will have:
  - SQL Developer Web URL (username is ociarcade with password as provided)
  - A template to login into the compute via ssh
  - Pacman URL
  - Space Invaders URL
- Note:
  - Need to "accept" exception in browser for the API calls (https://<compute-public-ip>:8081/event) - Without this step, API calls from game will fail with CERT exception
  - If you are wanting to "Destroy" the stack, you need to delete the folders in the oci-arcade bucket before running the Terraform destroy activity. Otherwise, the bucket will fail to be destroyed.
