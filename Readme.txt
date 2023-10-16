Kubernetes Learning: Container Architecture Management
-------------------


Cluster:
Kubernetes - Master Machine Components:

API Server: 
Kubernetes is an API server which provides all the 
operation on cluster using the API. API server implements an interface,
which means different tools and libraries can readily communicate with it.
Kubeconfig is a package along with the server side tools that can be used 
for communication. It exposes Kubernetes API.

etcd:
It stores the configuration information which can be used by each of the nodes 
in the cluster. It is a high availability key value store that can be distributed 
among multiple nodes. It is accessible only by Kubernetes API server as it may have 
some sensitive information. It is a distributed key value Store which is accessible to all.

Controller Manager:
This component is responsible for most of the collectors that regulates the state of cluster 
and performs a task. In general, it can be considered as a daemon which runs in nonterminating 
loop and is responsible for collecting and sending information to API server.

Scheduler:
This is one of the key components of Kubernetes master. It is a service in master responsible 
for distributing the workload. It is responsible for tracking utilization of working load on 
cluster nodes and then placing the workload on which resources are available and accept the workload.
------------------------------------------------------------------------------------------------

Kubernetes - Node Components

Docker:
The first requirement of each node is Docker which helps in running the encapsulated 
application containers in a relatively isolated but lightweight operating environment.

Kubelet Service:
This is a small service in each node responsible for relaying information to and from control 
plane service. It interacts with etcd store to read configuration details and wright values. 
This communicates with the master component to receive commands and work. The kubelet process 
then assumes responsibility for maintaining the state of work and the node server. It manages 
network rules, port forwarding, etc.

Kubernetes Proxy Service:
This is a proxy service which runs on each node and helps in making services available to the 
external host. It helps in forwarding the request to correct containers and is capable of 
performing primitive load balancing. It makes sure that the networking environment is predictable 
and accessible and at the same time it is isolated as well. 
It manages pods on node, volumes, secrets, creating new containers’ health checkup, etc.

------------------------------------------------------------------------------------

Deployment: It ensure desire number of pods are in running condition.
            Total of replicas.
			
			
Service: To access application.
         Load balancing activity
	
	services:- 4 types -- 1) Cluster IP    - within the Cluster(its a default service type)
	                      2) Nodeport      - From outside of the cluster
						  3) Load-Balancer - From outside of the cluster
						                     (default LB is Classic LB)
						  4) ingress
						  


	                   
					   
					   
					   
					   
					   
					   
					   
--------------------------------------------------------------------------					   
RBAC: - (Role Based Access Control) 

===> Subject                  API Resource              Operation(verbs)
	 
	 Groups                   ConfigMap	                create
	 Users                    Pod                       List
	 service Accounts         Deployment                watch
	                          Node etc.                 delete 
					

                               Error                                                        Error
               Authentication   401                       Authorization                      403
Credentials = ---------------- -----  = --------------------------------------------------  -----
                Valide User     200       Check that we can perform ant task or not(verbs)   200
				              Approved                                                     Approved
							  
							  
							  
							  
Hands On:
To create User :    Check Cluster Details: ~/.kube/config 

* reate user Private Key with openssl
=> openssl genrsa -out avinash.key 2048

* Create Certificate siging request for the user with above key
=> openssl req -new -key avinash.key -out avinash.csr -subj "/CN=avinash/0=dev/0=example.org"     - try with CN

* So,Certificate signing request and Private key daetails are ready
* Now this Certificate Signing request ust be signed with the certificate authority, So we get certificate authority details
=> openssl x509 -req -CA ~/.minikube/ca/crt -CAkey ~/.minikube/ca.key -CAcreateserial -days 730 -in avinash.csr -out avinash.crt

* Certificate is generated 
* Now, we should set user with kubectl config set-credentials
=> kubectl config set-credentials avinash --client-certificate=avinash.crt --client-key=avinash.key

* Set-Context entry in kubectl config
=> kubectl config set-context avinash-minikube --cluster=minikube --user=avinash --namespace=default
-----------------------------------------
TO Check and Switch to Kubectl Context 
=> kubectl config get-context
=> kubectl config use-context avinash-minikube
--------------------------------------------------------------------------------------------------

Role and Role Binding:

Subject                +               Role                 =  RoleBinding

User                          Create,Read,Update pods    
Groups                            Delete Pods etc.
Service Account  


Role:

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: Pod-reader
rules:
- apiGroup: [""]  # indicates the core API Group
  verbs: ["get","watch","list"]
  resources: ["pods","pods/log"]
  
  --------------------
  
Role-binding.yaml:

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: sample-role-binding
subjects:
- kind: User
  name: avinash        # Replace <username> with the target username
  apiGroup: rbac.authorization.k8s.io
- kind: Group
  name: dev        # Replace <groupname> with the target group name
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role  # The type of role you want to bind (Role or ClusterRole)
  name: Pod-reader  # Replace with the name of the Role you want to bind
  apiGroup: rbac.authorization.k8s.io
----------------------------------

Cluster Role:

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: my-cluster-role
rules:
- apiGroups: [""]
  resources: ["pods","pod/log"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
  


ClusterRoleBinding:

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: my-cluster-role-binding
subjects:
- kind: User
  name: avinash  # Replace with the username or email of the user you want to bind
  apiGroup: rbac.authorization.k8s.io
- kind: Group
  name: dev
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: my-cluster-role  # Replace with the name of the ClusterRole you want to bind
  apiGroup: rbac.authorization.k8s.io
  
-----------------------------------------------------------

Service Accounts: When namespace is created a default service account is created. 
Pods use default service Account to authenticate them self with in the api server.

kubectl get sa
kubectl get sa -n test
kubectl create sa test-sa

kubectl auth can-i create pods
kubectl auth can-i create pods --as="system:serviceaccount:default:test-sa"

------------------------------------------------------------------------------------------------------- 
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


Multi-Node Kubernetes Cluster Setup Using Kubeadm
This readme provides step-by-step instructions for setting up a multi-node Kubernetes cluster using Kubeadm.

Overview
This guide provides detailed instructions for setting up a multi-node Kubernetes cluster using Kubeadm. The guide includes instructions for installing and configuring containerd and Kubernetes, disabling swap, initializing the cluster, installing Flannel, and joining nodes to the cluster.

Prerequisites
Before starting the installation process, ensure that the following prerequisites are met:

You have at least two Ubuntu 18.04 or higher servers available for creating the cluster.
Each server has at least 2GB of RAM and 2 CPU cores.
The servers have network connectivity to each other.
You have root access to each server.
Installation Steps
The following are the step-by-step instructions for setting up a multi-node Kubernetes cluster using Kubeadm:

Update the system's package list and install necessary dependencies using the following commands:

sudo apt-get update
sudo apt install apt-transport-https curl -y
Install containerd
To install Containerd, use the following commands:

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install containerd.io -y
Create containerd configuration
Next, create the containerd configuration file using the following commands:

sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
Edit /etc/containerd/config.toml
Edit the containerd configuration file to set SystemdCgroup to true. Use the following command to open the file:

sudo nano /etc/containerd/config.toml
Set SystemdCgroup to true:

SystemdCgroup = true
Restart containerd:

sudo systemctl restart containerd
Install Kubernetes
To install Kubernetes, use the following commands:

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt install kubeadm kubelet kubectl kubernetes-cni
Disable swap
Disable swap using the following command:

sudo swapoff -a
If there are any swap entries in the /etc/fstab file, remove them using a text editor such as nano:

sudo nano /etc/fstab
Enable kernel modules

sudo modprobe br_netfilter
Add some settings to sysctl

sudo sysctl -w net.ipv4.ip_forward=1
Initialize the Cluster (Run only on master)
Use the following command to initialize the cluster:

sudo kubeadm init --pod-network-cidr=10.244.0.0/16
Create a .kube directory in your home directory:

mkdir -p $HOME/.kube
Copy the Kubernetes configuration file to your home directory:

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
Change ownership of the file:

sudo chown $(id -u):$(id -g) $HOME/.kube/config
Install Flannel (Run only on master)
Use the following command to install Flannel:

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
Verify Installation
Verify that all the pods are up and running:

kubectl get pods --all-namespaces
Join Nodes
To add nodes to the cluster, run the kubeadm join command with the appropriate arguments on each node. The command will output a token that can be used to join the node to the cluster.
________________________________________________________________________________________________________________
_________________________________________________________________________________________________________________