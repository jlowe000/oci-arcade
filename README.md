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
- Note your tenancy namespace and OCID
- Note your user OCID
- Know which region you are deploying into
- Know which compute shape and source-image to deploy compute
- Know whether you want to run a free-tier instance of the database
- Create a SSH Key (ie using puttygen or ssh-keygen)
- Define an admin password for ADW

### Here are some references to help with filling in this information from your tenancy

- The source-image-id was based upon an Oracle-Linux-7.8 image - here are the OCIDs for this image (which is different for each region) - defaulted to the au-sydney-1 region - https://docs.oracle.com/en-us/iaas/images/image/f54bf63c-a3a7-46d0-bccf-6bacf6815994/
- The tenancy OCID and user OCID are used for the automation using the Oracle APIs - here is a description of where in the OCI console to find this information - https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
- The SSH key is a common element to infrastructure so you can log into the compute - use ie puttygen or ssh-keygen - https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#Managing_Key_Pairs_on_Linux_Instances
- The compute shape is used for the VM hosting the APIs as well as Oracle Functions (on docker). You can find out the different shapes here (VM.Standard.E2.1.Micro is the only shape available as part of the Always-Free Tier) - https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm

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
  - In an Always-Free Tier, you make get issues when you "Apply" because (these are the common ones I found):
    - There can only be a single VCN allowed in the tenancy.
    - There can only be 2 x VM instances and 2 x Autonomous Database instances.
  - Need to "accept" exception in browser for the API calls (https://<compute-public-ip>:8081/event) - Without this step, API calls from game will fail with CERT exception
  - If you are wanting to "Destroy" the stack, you need to delete the folders in the oci-arcade bucket before running the Terraform destroy activity. Otherwise, the bucket will fail to be destroyed. You can delete the folders which will delete the underlying objects.
