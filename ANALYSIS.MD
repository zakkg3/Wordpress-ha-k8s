# Analysis

## Reliability
* Use terraform helm provider https://github.com/terraform-providers/terraform-provider-helm
* Use Nginx ingress controller instead of native ELK LoadBalancer service exposure method
* run tests for PHP code before deploy.
* Use an external scalable database service like AWS RDS
* Set up a CDN like CloudFront / Cloudflare.
* Use Persistent volumes. It should be a NFS.
* Set up Prometheus to collect metrics from services and nodes, Alertmanager to have some visibility if something is not working as expected.
* Set up alerts on memory and CPU utilisation which triggers a scale up in the node's autoscaling group.
* Consider using native GitLab’s integration with Kubernetes.
* Use at least 3 nodes and 3 replicaCount.

## Securty

* add security analysis in the cd/ci pipeline (there is a draft with allow_fail)
* run a Gitlab-runner in the k8s cluster. (HELM available)
* Use SSL (https)
* set up a Firewall (network and Security group) and an Application firewall AWS WAF. Make the backend report consecutive login attempt to WAF in order to block the IP address.
* Integrate the WAF with the php code.
* Move the Admin endpoint (/wp-admin) to another service not public exposed. Make it accessible only from "inside" (connected through a VPN) or Beyondcorp like AWS Cognito.
* Set up security alerts and intrusion detect in an ELK stack. Ideal with AI.
* Set up a DDoS protection (Also with CloudFront). Restrict all the traffic only from Cloudfront.
* infra-terraform outputs should be a confd parameter and not printed in plaintext in the bash. Remote State should be a crypt bucket.
* Files with sensitive data in this repo (with the name ~ *NOCIMMIT*) should be crypt with GPG (Blackbox: https://github.com/StackExchange/blackbox) so we can share securely.

### Metrics

* Values: enabled: true for enabling exporters
* Set up an HA Monitoring & Alerting stack Like Prometheus + Alertmanager + Grafana. Exporters already in the stack. (Dashboard with Influxdb and Heapster in infra-terraform/readme.md)

### Logs

* Set up a Log manager alert stack (ELK). Collect logs with beats. Use AI to detect anomalies (nice to have)
