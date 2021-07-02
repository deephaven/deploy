# Deploy Google Cloud Virtual Machines in a public-only single region with Terraform

The script will install deephaven application on the virtual machines.

network-firewall.tf --> Configure basic firewall for the network

network.tf --> Define network, vpc, subnet, icmp firewall

provider.tf --> Configure Google Cloud provider

terraform.tfvars --> Defining variables

variables-auth.tf --> Application and authentication variables

vm-output.tf --> Output of VM

vm.tf --> Create a Ubuntu VM

# Notes

# We have used custom image for this VM which has specific required packages installed. Once the VM was ready. We created an image using below command.

gcloud compute images create deephaven    --source-disk=deeephaven-test-instance-1   --source-disk-zone=us-central1-a  --project himantej-development-test

Check list of Google Cloud OS images --> https://cloud.google.com/compute/docs/images

Create the Json file for authentication --> https://cloud.google.com/iam/docs/creating-managing-service-account-keys
