## dbo-ecom-demo

Welcome to dbo ecommerce demo app!!

## Setup Guide

### Step 1 - Deploy ecommerce app & locust load test tool

Update DB details in demo-ecom-app.yaml 
```
        env:
          - name: DB_NAME
            value: "rundb"
          - name: DB_USER
            value: "postgres"
          - name: DB_PASSWORD
            value: ""
          - name: DB_HOST # DBO K8S service endpoint
            value: "dbo-database-1-c68f7.castai-db-optimizer.svc.cluster.local"
          - name: DB_PORT
            value: "5432"
```
<br>

```
kubectl apply -f demo/

demo-ecom-app can be accessed at http://loadbalancer-ip:3000 
demo-ecom-app admin panel can be accessed at http://loadbalancer-ip:3000/admin 
locust load app can be accessed at http://loadbalancer-ip:8089 

Admin password will be created in step 2
```

### Step 2 - Setup admin user for demo-ecom-app & boostrap mock data

```
kubectl exec -it demo-ecom-app-pod-name -- /bin/sh
npm run user:create -- --email "admin@admin.com" --password "admin123" --name "admin" 
```

### Step 3 - Update boostrap details & run boostrap.sh

Navigate to boostrap folder <br>
Update boostrap.vars with vars where mentioned as ## To be added by user ## <br>
Execute bootstrap.sh to update products data. <br>

You are set to go!!!

## E-COM Demo App
![Demo APP Screenshot](readmeimages/app.png)

This project is based on https://github.com/evershopcommerce/evershop

## Locust load app

Load Generation config
DB CPU - 0.5 ACU TO 1.5 ACU
No of users at concurrency - 200
Ramp up users - 10

![LOAD APP Screenshot](readmeimages/load.png)


## Troubleshooting FAQ'S

1. Demo app is restarting continously <br>
Check db env vars in connections in demo-ecom-app.yaml & db is reachable (check rds sg)

```
        env:
          - name: DB_NAME
            value: ""
          - name: DB_USER
            value: ""
          - name: DB_PASSWORD
            value: ""
          - name: DB_HOST
            value: ""
          - name: DB_PORT
            value: "5432"
```

2. Add new endpoints to locust to simulate load <br>
 add task with new endpoints to hit in confimap of locaust-load.yaml. Restart locust master & workers.

```
        @task
        def get_products(self):
            self.client.get("/men")

        @task
        def get_products_allstar(self):
            self.client.get("/men/allstar")
```

3. Update products data for demo app <br>
Products is bootstrapped using boostrap.sh & updates can be added from it.
