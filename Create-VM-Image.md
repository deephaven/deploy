# Deephaven

This repo consists of instructions about how any user can run the deephaven application.


#Create Image steps

# Login to GCP console and Click to cloud shell where we will run all the commands

   To set the project property in the core section, run:

```
        gcloud config set project YOUR_PROJECT_NAME
```

    To set the zone property in the compute section, run:

```
        gcloud config set compute/zone us-central1-a
```

# Setup up project name and zone as environment variable as well

```
export PROJECT_ID="YOUR_PROJECT_NAME"
export ZONE="us-central1-a"
```

# Run below command in the cloud shell which will create a GCP vm

You need to replace the PROJECT_ID and PROJECT_NUMBER in the below command:

```
gcloud beta compute --project=$PROJECT_ID instances create deephaven --zone=us-central1-a --machine-type=n2-standard-4 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=PROJECT_NUMBER-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=deephaven,http-server,https-server --image=centos-7-v20210701 --image-project=centos-cloud --boot-disk-size=30GB --boot-disk-type=pd-balanced --boot-disk-device-name=deephaven --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any
```


# Login to the vm which we created, use below command to login to vm

```
gcloud beta compute ssh --zone "us-central1-a" "deephaven" --project "$PROJECT_ID"
```

# Once you login to vm copy and paste below commands and hit enter on the server.

This will install the required packages and then clone the  deephaven git repo and start the application.

These commands will run for around 20 to 25 min. We have to wait until this is finished, docker build takes time.  


```
#!/bin/bash
cd /opt
sudo yum -y update
sudo yum install yum-utils git wget java-1.8.0-openjdk-devel gcloud -y
sudo export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk >> /etc/bashrc
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo yum install docker-ce-17.03.0.ce-1.el7.centos docker-ce-cli-17.03.0.ce-1.el7.centos containerd.io -y
sudo service docker start; sudo systemctl enable docker; docker info
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo docker-compose version
sudo cd /opt
sudo git clone https://github.com/deephaven/deephaven-core.git
cd deephaven-core; sudo ./gradlew prepareCompose
sudo docker-compose build
sudo docker-compose up
echo “all done”
exit 1
```

# Once all the steps are completed and the deephaven process starts running. You can see the output on your screen as below snapshot:

<img width="628" alt="Output" src="https://user-images.githubusercontent.com/80594801/125849884-3671ecf0-4747-4ea7-a4b6-5cad42b33997.png">

This indicates the server is ready with a deephaven application installed in it.

Now find out the deephaven server external ip as shown in the below snapshot:

![8He0V](https://user-images.githubusercontent.com/80594801/125961697-96eeb548-b97e-4d0b-8393-8f2bd57dad7a.jpeg)

# Run Deephaven IDE

Now you can launch a Deephaven IDE in your browser by entering the url as below:


```
EXTERNAL-IP:10000/ide
```

You will be able to see the Deephaven IDE in your browser as shown in snapshot below:



<img width="627" alt="Screen Shot 2021-07-15 at 3 04 15 PM" src="https://user-images.githubusercontent.com/80594801/125850504-a279f017-69e9-4009-96bc-d90f3e8bf830.png">


Now at this point if you are able to see the application in the browser successfully. Then the vm is ready with a deephaven application.

#The next step is to create an image from this vm.

For this we need to stop the vm, Open a new cloud shell use below gcloud command to stop the vm or you can stop using google console.

To set the project property in the core section, run:

```
     gcloud config set project YOUR_PROJECT_NAME
```

 To set the zone property in the compute section, run:

```
     gcloud config set compute/zone us-central1-a
```

#Stop the vm

```
gcloud compute instances stop deephaven --project $PROJECT_ID --zone=us-central1-a

```

Once instance is stopped, run the below command to create an image:


```
gcloud beta compute machine-images create deephaven \
--source-instance deephaven --project $PROJECT_ID
```

Once the command is successful, the machine image is ready and you can see that inside Google cloud console under Compute Image >> Machine Images option.

This image can be used to create a new vm.
