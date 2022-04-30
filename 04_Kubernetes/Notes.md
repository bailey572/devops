# Kubernetes Notes

So, I had a few different options for how I was going to play with Kubernetes at home.  My first instinct was to do an official full K8S installation but that seemed very heavy handed and I didn't really want to dedicate that kind of time or resources to what was essentially going to be a playground.  Looking around, it quickly became apparant that I was not the only one in this situation and in fact, there are MANY options for those looking to get started.  Three of the biggies are minikube, kind, and k3s.

- Minikube is kubernetes official playground for getting started.  Fundamentally, minikube spawns a virtual machine that is essentailly a single node K8S cluster.  The benefits to the VM approach, is that it is supported on all platforms with little effort.  The only real downside is the fact that it limits you to a single node.
- Kind is another kubernates project where KIND is short for Kubernetes in Docker.  Yep, you have a docker images, running kubernetes, manageing docker images.  The benefit of this of course is the leaner resource needs of the containers versus a VM and the fact that you could create two K8S instances on the same machine.  This setup really is targetted towards a CI/CD pipeline to test K8S elements.  Makes it a little light.
- k3s is a minified/stripped down version of K8S, hence the 3 versus 8 numbers, with the biggest difference being the replacement of etcd with sqlite.  The benefit is low overhead but an installation much like K8S where you can scale with more nodes.  A down side would be that K3S will leave a much bigger footprint of cleanup files to remove.  There is a project out there where the k3s is actually hosted on containers, but the instructions found were light and I didn't want yet another option.

Ultimately, I went with K3S installed on two machines, insp & asus.  I will probably play with kind or some other container based instance on a Windows box at some point but for this writeup, just assume that any weirdness is brought in by k3s.  I will try to call these out as i go, but just in case I miss it :-)

Official repo: [K3S GitHub](https://github.com/k3s-io/k3s)

## Setup

### Configure the cluster

Directions: [K3S Rancher](https://rancher.com/docs/k3s/latest/en/installation/install-options/)

The install.sh script provides a convenient way to download K3s and add a service to systemd or openrc.

To install k3s as a service, run:

```bash
curl -sfL https://get.k3s.io | sh -
```

A kubeconfig file is written to /etc/rancher/k3s/k3s.yaml and the service is automatically started or restarted. The install script will install K3s and additional utilities, such as kubectl, crictl, k3s-killall.sh, and k3s-uninstall.sh

### Configure Nodes

Directions: [K3S Rancher](https://rancher.com/docs/k3s/latest/en/installation/install-options/)

K3S_TOKEN is created at /var/lib/rancher/k3s/server/node-token on your server. To install on worker nodes, pass K3S_URL along with K3S_TOKEN or K3S_CLUSTER_SECRET environment variables, for example:

curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=XXX sh -

### Download and install the Dashboard UI

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml
```
##### Access the Dashboard UI

To protect your cluster data, Dashboard deploys with a minimal RBAC configuration by default. Currently, Dashboard only supports logging in with a Bearer Token. To do so we will need to create a new user using the Service Account mechanism of Kubernetes, grant this user admin permissions and login to Dashboard using a bearer token tied to this user. 

To start, create a Service account.  Create a yaml file, dashboard-adminuser.yaml, with the following content.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```
Apply the config to create the user

```bash
kubectl apply -f dashboard-adminuser.yaml 
serviceaccount/admin-user created
```
Give the new user permission to access the data.  Create a new yaml file, ClusterRoleBinding.yaml, and populate with

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

Get the new users token

```bash
sudo k3s kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token

token:      eyJhbGciOiJSUzI1NiIsImtpZCI6Im5FTHJ0bFkzV3N0TVFxOEVmNVozVVoxUVBYSlFXajhmZ0lkNEdvSEZmSEEifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWpsZHZjIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJhZDZhZTJiYy1jMjkzLTQwMzctOWMwNy0xNzQ3ZTExMTQ1MjYiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.mpDXBLFtQ_ZAKJgJM5t8JH_WqBDaB1NscuKPqNe01MVd3FrRbYTNpsKoOzS8afHwFL-VGcNqkZ97ZWui9Ph2FSpMKHBtIwlQi3gzigo5NUBczEwfal9_lf85TJG2Otv8oyrSxjc1nanqLSLhFUZEybN8ZwTcPKYnPi8w3HYGE0eTbGIMHFsgN6SQkI4j8Ff3SR3cNKA3ImXCt4Y3pM-NtfwDv9-Ot1PDb-ofadRqhJuVsHIjYisgj1p9TN4qXg-rnreFYtBhUJMgqiE8pX9-C1BvSR1C7OLsRbilxwQH0WpREV8J-YBwgo1koIACQ5UOzEZ1uulyE7ezfFpiE5GBqQ
```

Start the dashboard service
```bash
sudo k3s kubectl proxy

```

with KubeCtl installed, you can also just use
```bash
kubectl proxy
# or even
kubectl proxy --port=8888

```
what would be nice would be if you could access from a different machine with something like

```bash
kubectl proxy --address=192.168.1.229 --port=8888
# the above does not work, if you issue the next line you will see why
kubectl -n kubernetes-dashboard get service kubernetes-dashboard
NAME                   TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes-dashboard   ClusterIP   10.43.32.105   <none>        443/TCP   82d
# it is a container.  Will have to play with this further.
```
Go to the page: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login and login with the token

### Install full K8S if you so desire (Will need to remove K3s first)
[Reference of Installation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

#### On Master Node
```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt-cache madison kubeadm
sudo apt-get install -y kubelet kubeadm kubectl
sudo hostnamectl set-hostname master.example.com
```

#### On all other Nodes (Repeat for ALL) 
```bash
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo kubeadm init
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes
```

## Fun with kubectl from the command line


### The create command

While you will often use yaml scripts to define resources and rules, kubectl allows you to do most things directly from the command line.

```bash
 kubectl create --help
Create a resource from a file or from stdin.

 JSON and YAML formats are accepted.

Examples:
  # Create a pod using the data in pod.json
  kubectl create -f ./pod.json

  # Create a pod based on the JSON passed into stdin
  cat pod.json | kubectl create -f -

  # Edit the data in docker-registry.yaml in JSON then create the resource using the edited data
  kubectl create -f docker-registry.yaml --edit -o json

Available Commands:
  clusterrole         Create a cluster role
  clusterrolebinding  Create a cluster role binding for a particular cluster role
  configmap           Create a config map from a local file, directory or literal value
  cronjob             Create a cron job with the specified name
  deployment          Create a deployment with the specified name
  ingress             Create an ingress with the specified name
  job                 Create a job with the specified name
  namespace           Create a namespace with the specified name
  poddisruptionbudget Create a pod disruption budget with the specified name
  priorityclass       Create a priority class with the specified name
  quota               Create a quota with the specified name
  role                Create a role with single rule
  rolebinding         Create a role binding for a particular role or cluster role
  secret              Create a secret using specified subcommand
  service             Create a service using a specified subcommand
  serviceaccount      Create a service account with the specified name
```

```bash
kubectl get deployment
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
redis-slave    2/2     2            2           21h
frontend       3/3     3            3           21h
redis-master   1/1     1            1           21h

kubectl create deployment mydep1 --image=docker.io/httpd
deployment.apps/mydep1 created

kubectl get deployment
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
redis-slave    2/2     2            2           21h
frontend       3/3     3            3           21h
redis-master   1/1     1            1           21h
mydep1         1/1     1            1           10s

kubectl scale deployments mydep1 --replicas=3
deployment.apps/mydep1 scaled

kubectl get deployment
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
redis-slave    2/2     2            2           21h
frontend       3/3     3            3           21h
redis-master   1/1     1            1           21h
mydep1         3/3     3            3           52s

kubectl expose deployment mydep1 --port=80
service/mydep1 exposed

kubectl get svc
NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
kubernetes    ClusterIP   10.43.0.1      <none>        443/TCP        83d
redis         ClusterIP   10.43.99.96    <none>        6379/TCP       21h
redis-slave   ClusterIP   10.43.54.55    <none>        6379/TCP       21h
frontend      NodePort    10.43.156.91   <none>        80:30049/TCP   21h
mydep1        ClusterIP   10.43.80.30    <none>        80/TCP         10s
```

## Cofigurations through Yaml

### Apache 3 Pod

Just a quick deployment and checkout of an apache instance using yaml.  To begin, create a file and populate.

```yaml
vi apachePod.yml

apiVersion: v1
kind: Pod
metadata:
  name: apache3
  labels:
    mycka: simplilearn
spec:
  containers:
  - name: mycontainer
    image: docker.io/httpd
    ports:
    - containerPort: 80
```

Now we create the pod, poll the system while it spins up, and then test it with a curl.

```bash
kubectl create -f apachepod.yml
kubectl create -f ./deployments/apachePod.yml 
pod/apache3 created

kubectl get pods  -o wide
kubectl get pods  -o wide
NAME                           READY   STATUS    RESTARTS      AGE   IP            NODE            NOMINATED NODE   READINESS GATES
apache3                        1/1     Running   0             3s    10.42.0.14    inspiron-3650   <none>           <none>

curl 10.42.0.14
<html><body><h1>It works!</h1></body></html>
```
### Mysql Pod creation

```yaml
vi ./deployments/mysql.yaml

apiVersion: v1
kind: Pod
metadata:
  name: mysql-pod2
  labels:
    name: mysql-pod1
    context: docker-k8s-lab
spec:
  containers:
    - name: mysql2
      image: mysql:latest
      env:
        - name: "MYSQL_USER"
          value: "mysql"
        - name: "MYSQL_PASSWORD"
          value: "mysql"
        - name: "MYSQL_DATABASE"
          value: "sample"
        - name: "MYSQL_ROOT_PASSWORD"
          value: "supersecret"
      ports:
        - containerPort: 3306
```

```bash
kubectl create -f ./deployments/mysql.yaml 

pod/mysql-pod2 created
kubectl get pods

NAME                           READY   STATUS              RESTARTS      AGE
apache3                        1/1     Running             0             10m
mysql-pod2                     0/1     ContainerCreating   0             13s
```
### Multiple pods with Redis

Let's create a sample redis deployment.

Create a file, kubesample.yaml, and populate with the following content

```yaml
vi ./deployments/kubesample.yaml

apiVersion: v1
kind: Service
metadata:
  name: redis
  labels:
    app: hello
    tier: backend
    role: master
spec:
  ports:
  - port: 6379 
    targetPort: 80
  selector:
    app: redis
    tier: backend
    role: master
---
apiVersion: apps/v1 
kind: Deployment
metadata:
  name: redis-master
spec:
  selector:
    matchLabels:
      app: redis
      role: master
      tier: backend
  replicas: 1
  template:
    metadata:
      labels:
        app: redis
        role: master
        tier: backend
    spec:
      containers:
      - name: master
        image: redis
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        ports:
        - containerPort: 6379
---
apiVersion: v1
kind: Service
metadata:
  name: redis-slave
  labels:
    app: redis
    tier: backend
    role: slave
spec:
  ports:
  - port: 6379
  selector:
    app: redis
    tier: backend
    role: slave
---
apiVersion: apps/v1 
kind: Deployment
metadata:
  name: redis-slave
spec:
  selector:
    matchLabels:
      app: redis
      role: slave
      tier: backend
  replicas: 2
  template:
    metadata:
      labels:
        app: redis
        role: slave
        tier: backend
    spec:
      containers:
      - name: slave
        image: gcr.io/google_samples/gb-redisslave:v1
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        env:
        - name: GET_HOSTS_FROM
          value: dns
        ports:
        - containerPort: 6379
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
  labels:
    app: kubesample
    tier: frontend
spec:
  # comment or delete the following line if you want to use a LoadBalancer
  type: NodePort 
  # if your cluster supports it, uncomment the following to automatically create
  # an external load-balanced IP for the frontend service.
  # type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: kubesample
    tier: frontend
---
apiVersion: apps/v1 
kind: Deployment
metadata:
  name: frontend
spec:
  selector:
    matchLabels:
      app: kubesample
      tier: frontend
  replicas: 3
  template:
    metadata:
      labels:
        app: kubesample
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google-samples/gb-frontend:v4
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
        env:
        - name: GET_HOSTS_FROM
          value: dns
        ports:
        - containerPort: 80

```

Verify what is currently running.  Notice this time we are using get all instead of get pod. This will still show all the pods but provides even more information

```bash
kubectl get all

NAME                          READY   STATUS    RESTARTS   AGE
pod/mydep1-6b7cfdd955-b67pq   1/1     Running   0          46m
pod/mydep1-6b7cfdd955-vqvd6   1/1     Running   0          45m
pod/mydep1-6b7cfdd955-qt28h   1/1     Running   0          45m
pod/apache3                   1/1     Running   0          15m
pod/mysql-pod2                1/1     Running   0          5m22s

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.43.0.1     <none>        443/TCP   83d
service/mydep1       ClusterIP   10.43.80.30   <none>        80/TCP    43m

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mydep1   3/3     3            3           46m

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/mydep1-6b7cfdd955   3         3         3       46m
```

Great!  We can see that the pods we created earlier are still up and running, in fact we can also see the service created directly from the command line when we issued the  ```kubectl create deployment mydep1 --image=docker.io/httpd``` command.

To start up the next pods, we are going to switch from the create command to the apply.  While create would work, there are very real differences between create and apply

#### Kubectl create

When we talk about kubectl create, it comes under the category of imperative management. Now, what does this mean?

Well, this approach tells the Kubernetes API about what you want to create, delete or replace. In a more simplified manner, it means that you can create a whole new object from scratch. Or, it makes some changes to any existing object by defining the requirements.

#### Kubectl apply
On the other hand, it is quite a declarative management approach. It means that all the changes that you make to a live object will stay intact even if you apply more changes to the same object.

In simple words, apply means making more changes to an already existing object by declaring what exactly you need.

Go ahead and apply the kubesample
```bash
kubectl apply -f ./deployments/kubesample.yaml 
service/redis created
deployment.apps/redis-master created
service/redis-slave created
deployment.apps/redis-slave created
service/frontend created
deployment.apps/frontend created
```

Now, let's take a look at what is running

```bash
kubectl get all
NAME                               READY   STATUS    RESTARTS   AGE
pod/mydep1-6b7cfdd955-b67pq        1/1     Running   0          57m
pod/mydep1-6b7cfdd955-vqvd6        1/1     Running   0          57m
pod/mydep1-6b7cfdd955-qt28h        1/1     Running   0          57m
pod/apache3                        1/1     Running   0          26m
pod/mysql-pod2                     1/1     Running   0          16m
pod/redis-slave-7979cfdfb8-qcdbw   1/1     Running   0          38s
pod/frontend-667b6d7d5d-skb6z      1/1     Running   0          38s
pod/redis-slave-7979cfdfb8-bp4sr   1/1     Running   0          38s
pod/frontend-667b6d7d5d-fnbx8      1/1     Running   0          38s
pod/frontend-667b6d7d5d-mrj2v      1/1     Running   0          38s
pod/redis-master-85547b7b9-prm5b   1/1     Running   0          38s

NAME                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/kubernetes    ClusterIP   10.43.0.1      <none>        443/TCP        83d
service/mydep1        ClusterIP   10.43.80.30    <none>        80/TCP         54m
service/redis         ClusterIP   10.43.26.238   <none>        6379/TCP       38s
service/redis-slave   ClusterIP   10.43.234.99   <none>        6379/TCP       38s
service/frontend      NodePort    10.43.255.79   <none>        80:30711/TCP   38s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mydep1         3/3     3            3           57m
deployment.apps/redis-slave    2/2     2            2           38s
deployment.apps/frontend       3/3     3            3           38s
deployment.apps/redis-master   1/1     1            1           38s

NAME                                     DESIRED   CURRENT   READY   AGE
replicaset.apps/mydep1-6b7cfdd955        3         3         3       57m
replicaset.apps/redis-slave-7979cfdfb8   2         2         2       38s
replicaset.apps/frontend-667b6d7d5d      3         3         3       38s
replicaset.apps/redis-master-85547b7b9   1         1         1       38s
```

This is getting to be quite a lot of items.  Lets break them down and see where it all came from.

#### PODS

#### SERVICES

#### DEPLOYMENTS

#### REPLICASETS


```bash
kubectl get pods
NAME                           READY   STATUS    RESTARTS   AGE
redis-slave-7979cfdfb8-w5hb6   1/1     Running   0          16m
redis-master-85547b7b9-pdt25   1/1     Running   0          16m
redis-slave-7979cfdfb8-bmnl7   1/1     Running   0          16m
frontend-667b6d7d5d-swr5s      1/1     Running   0          16m
frontend-667b6d7d5d-ms974      1/1     Running   0          16m
frontend-667b6d7d5d-hhp8r      1/1     Running   0          16m

```

```bash
kubectl get rc,services
NAME                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
service/kubernetes    ClusterIP   10.43.0.1      <none>        443/TCP        82d
service/redis         ClusterIP   10.43.99.96    <none>        6379/TCP       17m
service/redis-slave   ClusterIP   10.43.54.55    <none>        6379/TCP       17m
service/frontend      NodePort    10.43.156.91   <none>        80:30049/TCP   17m

```
All are availabl on the master node, "Inspiron"

```bash
ericbailey@Inspiron-3650 docker ps
CONTAINER ID   IMAGE                        COMMAND                  CREATED              STATUS              PORTS     NAMES
8998fd3e6381   kubernetesui/dashboard       "/dashboard --insecu…"   About a minute ago   Up About a minute             k8s_kubernetes-dashboard_kubernetes-dashboard-576cb95f94-52vmq_kubernetes-dashboard_2cafda4b-2935-44d3-9c2d-84bd647a2cce_37
97dd4653e125   746788bcc27e                 "entry"                  About a minute ago   Up About a minute             k8s_lb-port-443_svclb-traefik-f8z5j_kube-system_dd03ea53-0e88-4217-bb58-ab3f7e878259_34
65c71bc03c98   746788bcc27e                 "entry"                  About a minute ago   Up About a minute             k8s_lb-port-80_svclb-traefik-f8z5j_kube-system_dd03ea53-0e88-4217-bb58-ab3f7e878259_34
0471c68c4692   f73640fb5061                 "/metrics-server --c…"   About a minute ago   Up About a minute             k8s_metrics-server_metrics-server-ff9dbcb6c-nwzcf_kube-system_2522280b-7252-4006-84bf-84dbbf774d51_44
039723bd2c51   e2b3e8542af7                 "apache2-foreground"     About a minute ago   Up About a minute             k8s_php-redis_frontend-667b6d7d5d-swr5s_default_e7e4242a-4944-4927-b43d-1fe19ab0b323_1
56267c859620   2cd4bc25ad14                 "/entrypoint.sh --gl…"   About a minute ago   Up About a minute             k8s_traefik_traefik-55fdc6d984-lznj2_kube-system_1b7ea22f-6fad-4e58-acdf-fc9ab029f9f9_34
0b7deede26d5   fb9b574e03c3                 "local-path-provisio…"   About a minute ago   Up About a minute             k8s_local-path-provisioner_local-path-provisioner-84bb864455-6s2cg_kube-system_6a6886fa-f923-4a65-84dd-02e7d4334ec2_36
fbe07557f5a3   a4ca41631cc7                 "/coredns -conf /etc…"   About a minute ago   Up About a minute             k8s_coredns_coredns-96cc4f57d-hn6ws_kube-system_fda01cf5-f8e0-4899-ac01-6209cdaee0d7_34
e112a9dcb163   5f026ddffa27                 "/entrypoint.sh /bin…"   About a minute ago   Up About a minute             k8s_slave_redis-slave-7979cfdfb8-w5hb6_default_bce63ca8-494c-4e47-a688-d0dde0998b14_1
1fd0eb896047   7801cfc6d5c0                 "/metrics-sidecar"       About a minute ago   Up About a minute             k8s_dashboard-metrics-scraper_dashboard-metrics-scraper-c45b7869d-sr9x7_kubernetes-dashboard_5e389b96-210c-4cd5-a887-b17a72d38964_34
228e5faccce1   e2b3e8542af7                 "apache2-foreground"     About a minute ago   Up About a minute             k8s_php-redis_frontend-667b6d7d5d-ms974_default_31e0442a-5598-419e-a49f-d515b851d6b5_1
a0846088ab0d   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_local-path-provisioner-84bb864455-6s2cg_kube-system_6a6886fa-f923-4a65-84dd-02e7d4334ec2_21
3754fd926218   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_coredns-96cc4f57d-hn6ws_kube-system_fda01cf5-f8e0-4899-ac01-6209cdaee0d7_20
2293ee6cd040   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_kubernetes-dashboard-576cb95f94-52vmq_kubernetes-dashboard_2cafda4b-2935-44d3-9c2d-84bd647a2cce_20
8dfd35cd4af8   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_frontend-667b6d7d5d-swr5s_default_e7e4242a-4944-4927-b43d-1fe19ab0b323_2
076aca11e8c7   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_svclb-traefik-f8z5j_kube-system_dd03ea53-0e88-4217-bb58-ab3f7e878259_21
a2f067a72e29   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_metrics-server-ff9dbcb6c-nwzcf_kube-system_2522280b-7252-4006-84bf-84dbbf774d51_20
e75f6f85f24c   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_traefik-55fdc6d984-lznj2_kube-system_1b7ea22f-6fad-4e58-acdf-fc9ab029f9f9_20
6c1c2e5d4ebc   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_frontend-667b6d7d5d-ms974_default_31e0442a-5598-419e-a49f-d515b851d6b5_3
9d2a70bb4a2c   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_dashboard-metrics-scraper-c45b7869d-sr9x7_kubernetes-dashboard_5e389b96-210c-4cd5-a887-b17a72d38964_21
38852974ce1b   rancher/mirrored-pause:3.6   "/pause"                 About a minute ago   Up About a minute             k8s_POD_redis-slave-7979cfdfb8-w5hb6_default_bce63ca8-494c-4e47-a688-d0dde0998b14_3
```

None of them are running on the second node, ASUS.

```bash
ericbailey@asus:~$ sudo docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```


