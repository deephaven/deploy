#  Running Deephaven application in GCP on VM

This document is about the instructions which will give information on how to run Deephaven application using GCP VM.

Prerequisites:

The user should have a valid GCP account.

Need to have gcloud and terraform installed in your google cloud shell else you can install using links below.

gcloud can be installed by following this document as per the OS --> https://cloud.google.com/sdk/docs/install

Terraform can be installed from here as per the OS --> https://releases.hashicorp.com/terraform/0.14.6/


# Login to GCP console and click to cloud shell where we will run all the commands

   To set the project property in the core section, run Replace YOUR_PROJECT_NAME value:

```
        gcloud config set project YOUR_PROJECT_NAME
```

# To set the zone property in the compute section, run:

```
        gcloud config set compute/zone us-central1-a
```

# Setup up project name and zone as environment variable so it can be used in future commands:

```
export PROJECT_ID="YOUR_PROJECT_NAME"
export ZONE="us-central1-a"
```


1) Create a service account for the terrform authentications named as terraform-service-account.
   To create the service account, run the gcloud iam service-accounts create command:

    ```
    gcloud iam service-accounts create terraform-service-account \
        --description="terraform-service-account" \
        --display-name="terraform-service-account"
    ```

2) To grant your service account an IAM role on your project, run the gcloud projects add-iam-policy-binding command:

```
    gcloud projects add-iam-policy-binding PROJECT_ID \
    --member="SERVICE_ACCOUNT_ID@PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"
```

    Replace the following values:

    PROJECT_ID: The project id.
    SERVICE_ACCOUNT_ID: The service account ID which we created in earlier command (terraform-service-account).
    ROLE_NAME: A role name, such as roles/editor which will suffice all requirements.


3) Download the service account key in json format which need to be used by the terraform using the command below:

```
    gcloud iam service-accounts keys create private-key.json \
    --iam-account="SERVICE_ACCOUNT_ID@PROJECT_ID.iam.gserviceaccount.com"
```

    Replace the following values:

    PROJECT_ID: The project id.
    SERVICE_ACCOUNT_ID: The service account ID which we created in earlier command (terraform-service-account).
    ROLE_NAME: A role name, such as roles/editor which will suffice all requirements.

4) Clone the latest deephaven git repo in your cloud shell using command below:

```
    git clone https://github.com/deephaven/deploy.git
    cd deploy
```

This repo consists of terraform code along with deephaven code which can be used to run the Deephaven application.


5) Once repo is downloaded Open the terraform.tfvars file and change the app_project and gcp_auth_file

   Replace the following values:

   app_project = YOUR_PROJECT_NAME
   gcp_auth_file = The full path for the service account key (private-key.json) which we generated using Step 3.
                  Example: /home/username/private-key.json


6) Now we need to run three terraform commands which will create a new VM and it will have the Deephaven application installed.
   Run the below terraform commands in your cloud shell:

 ```
 terraform init
 terraform plan
 terraform apply -auto-approve
 ```


# If you get any errors as terraform like command not found. Please follow the Prerequisites.


 7) Once the terraform apply is successful it will print an external IP on your screen.
    Copy the IP and paste in the browser url as below to access Deephaven IDE application.

    http://EXTERNAL-IP/10000/ide
