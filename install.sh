# configure Kind
kind create cluster --config=./config/kind-config.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9/manifests/namespace.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9/manifests/metallb.yaml
sed s/.x/"$(docker network inspect -f '{{.IPAM.Config}}' kind | awk '{print $2}' | grep -Eo '\.[0-9]{2}')"/g ./config/metallb-configmap.yaml |
  kubectl apply -f -

# install istio + addons
istioctl install --set profile=demo --skip-confirmation
# Ignore failure and retry kiali installation due to a known "bug": https://github.com/istio/istio/issues/27417
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/kiali.yaml || true
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/addons/jaeger.yaml

# install bookinfo
kubectl label namespace default istio-injection=enabled
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.10/samples/bookinfo/platform/kube/bookinfo.yaml
