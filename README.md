# oci-arcade

This was created to demonstrate a few things about Oracle Cloud Infrastructure in a "fun" way. There are different elements of the OCI that have been exercised that will be discussed here.

This borrows a couple of open-source javascript games to extends and play with.

- Space Invaders - https://github.com/lukegreaves5/invaders404
- Pacman - https://github.com/masonicGIT/pacman

This is a rought set of notes to get this up and running.

## Pre-Requisites

- Need an OCI Tenancy and this is built with a Always-Free Tier account in mind.
- Need an administrator access to the account (keeping it simple).

## 1. Get Stuff Prepared

- Create a compartment (and note the OCID)
- Note your tenancy namespace and OCID
- Note your user OCID
- Know which region you are deploying into
- Know which compute shape and source-image to deploy compute
- Know whether you want to run a free-tier instance of the database
- Create a SSH Key (ie using puttygen or ssh-keygen)
- Define an admin password for ADW

### Here are some references to help

- These instructions were built / tested with Oracle-Linux-7.8 image - here are the OCIDs for this image (which is different for each region) - defaulted to the au-sydney-1 region - https://docs.oracle.com/en-us/iaas/images/image/f54bf63c-a3a7-46d0-bccf-6bacf6815994/
- The tenancy OCID and user OCID are used for the automation using the Oracle APIs - here is a description of where in the OCI console to find this information - https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
- The SSH key is a common element to infrastructure so you can log into the compute - use ie puttygen or ssh-keygen - https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/managingkeypairs.htm#Managing_Key_Pairs_on_Linux_Instances
- The compute shape is used for the VM hosting the APIs as well as Oracle Functions (on docker). You can find out the different shapes here (VM.Standard.E2.1.Micro is the only shape available as part of the Always-Free Tier) - https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm
- Oracle FN project is used for some of the APIs - Download and learn about it here - https://fnproject.io/

## 2. Start Provisioning ...

1. Create a VCN with a public subnet
1. Create an ADW instance
1. Create 2 compute instances in the public subnet (for the purposes of this README - one will be referred to as arcade-web and the other as arcade-kafka)
1. Create an object storage bucket that is public
1. On arcade-web:
  1. Install git, docker, docker-compose, pip, Oracle Cloud CLI, Oracle Instant Client
  1. Update the firewall with 8080/tcp, 8081/tcp, 2377/tcp, 4789/ucp, 7946/tcp, 7946/udp
  1. Create a docker-swarm manager (with arcade-kafka as the worker)
  1. Create an attachable and overlay "swarm" network called arcade_network
  1. Create an oracle user
1. On arcade-kafka:
  1. More to come ... 
1. On arcade-kafka (as user):
  1. More to come ... 
1. On arcade-web (as user):
  1. Create a keys for the OCI API Signing Keys.
  1. Configure OCI CLI with a profile to point to your tenancy
  1. Download the ADW wallet and configure.
  1. Install Oracle FN project.
  1. Create a database user and run the following scripts.
    - infra/db/init.sql
    - apis/score/db/init.sql
    - apis/events/db/init.sql
  1. Create a dockerfile from containers/web/api-score.Dockerfile.template
  1. Create a new FN context with the FN_API_URL pointing to the port 8082
  1. Start FN server on arcade_network with the port 8082
  1. More to come ... 

(I'm reverse engineering these steps from the Terraform project).

- Note:
  - In an Always-Free Tier, you make get issues when you "Apply" because (these are the common ones I found):
    - There can only be a single VCN allowed in the tenancy.
    - There can only be 2 x VM instances and 2 x Autonomous Database instances.
  - Need to "accept" exception in browser for the API calls (https://<compute-public-ip>:8081/event) - Without this step, API calls from game will fail with CERT exception
  - If you are wanting to "Destroy" the stack, you need to delete the folders in the oci-arcade bucket before running the Terraform destroy activity. Otherwise, the bucket will fail to be destroyed. You can delete the folders which will delete the underlying objects.
