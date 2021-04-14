# Lightning Talk - Demo Istio

## Before apply the Istio rules

### Create a new namespace with sidecar injection enabled

```
kubectl create ns NS_NAME
```


```
kubectl label ns NS_NAME istio-injection=enabled
```

### Apply the Istio bookinfo demo

```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.9/samples/bookinfo/platform/kube/bookinfo.yaml -n NS_NAME
```

