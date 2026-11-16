# Kubernetes: web app on a local kind cluster

A Deployment of nginx on a local Kubernetes cluster built with kind. It shows four things Kubernetes does for an application: it runs several copies, replaces a lost pod, scales, and rolls out a new version without downtime.

## What is here

| File | Purpose |
|---|---|
| `deployment.yaml` | Deployment `web`: 5 replicas of nginx 1.29, with CPU and memory requests and limits |

## Tools

- kind v0.33.0 (node image: Kubernetes v1.37.0)
- kubectl v1.37
- Docker Desktop

## Run it

```bash
kind create cluster --name lab
kubectl apply -f deployment.yaml
kubectl get deployments
kubectl get pods -o wide
```

## What I tested

### 1. Self-healing

I deleted one pod. The Deployment's controller created a replacement within seconds, with a new name and a new IP. Output trimmed to the main columns:

```
$ kubectl delete pod web-6d8567df8-pz6vb
$ kubectl get pods -o wide
NAME                  READY   STATUS    AGE   IP
web-6d8567df8-bxzws   1/1     Running   48s   10.244.0.8
web-6d8567df8-xbfz2   1/1     Running   15m   10.244.0.7
web-6d8567df8-zzmtj   1/1     Running   15m   10.244.0.6
```

### 2. Scaling

I changed `replicas` from 3 to 5 in the manifest and applied it. Two pods were added, and the three existing pods were left untouched.

### 3. Rolling update

I changed the image from nginx 1.28 to nginx 1.29 and applied it. The pods were replaced in batches, so some were always running. The old ReplicaSet is kept at 0 pods so the change can be rolled back:

```
$ kubectl get replicasets
NAME            DESIRED   CURRENT   READY   AGE
web-6d8567df8   0         0         0       33m
web-c5748c689   5         5         5       4m44s
```

### 4. Resource requests and limits

Each container requests 50m CPU and 64Mi memory, and is limited to 200m CPU and 128Mi memory. The scheduler uses the requests to choose a node. The limits stop one container from starving the others on the same node.

## Notes

- The manifest is the source of truth. Every change was made in the file and applied with `kubectl apply`.
- A pod's IP changes when the pod is replaced, so nothing should depend on a pod IP. A Service solves that, and it is the next addition.

## Clean up

```bash
kind delete cluster --name lab
```

## Next

- A Service in front of the pods
- A rollback with `kubectl rollout undo`
- A CI check of the manifests in GitHub Actions
