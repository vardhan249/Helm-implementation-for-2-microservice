# Reusable Helm Chart for Microservices

A single Helm chart that can deploy multiple microservices by changing configmap values.

## System Dependency Installation(K3s + Helm)

1. Clone the repo
    ```sh
    git clone https://github.com/vardhan249/Helm-implementation-for-2-microservice.git
    ```
    
2. Installation of K3's and Helm
    
    ```
    cd Helm-implementation-for-2-microservice && chmod +x install.sh
    ```
    ```
    ./install.sh
    ```
 
## Directory Structure

![Helm Directory Tree](./image/Tree.png)

## Steps for running the project

1.  Install Helm Chart
    ```sh
    helm install apache-test apache-app/
    ```
    This will create the deployment as well as nodeport service on nodeport `30081` and `30082` configurable in values.yaml.

2. Upgrade the Helm Chart by changing the configmap
    ```sh
    helm upgrade apache-test apache-app/ --set configMap.service1Content="Service A Updated to v2" --set configMap.service2Content="Service B Updated to v2"
    ```
 
3. Rollback to the older version   
    ```sh
    helm rollback apache-test
    ```
4. Check Helm history

    ```sh
    helm history apache-test
    ```

8. Check the status of the HPA
    ```sh
    sudo k3s kubectl get hpa
    ```

## Accessing the Application

```sh
http://Node IP>:30081/
```
    
```sh
http://Node IP:30082/
```

This can be accessed by curl also using 

```sh
curl http://<Node IP>:30081/
```

```sh
curl http://<Node IP>:30082/
```