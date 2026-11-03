---
draft: true
exam_objectives:
- Understand Cilium's Identity-based Network Security Model
---
# Summary

Cilium does not store IP addresses in its policy rules. It derives a numeric security identity from the labels of a pod, and all pods with the same relevant labels share one identity. A policy rule names identities, so a new pod joins an existing identity without any rule change on other nodes.

The relevant labels are the pod labels without the labels that Cilium ignores, plus the namespace of the pod and its service account. Labels such as `pod-template-hash` are ignored so that replicas of one Deployment keep one identity. A selector in a policy matches every identity whose label set contains the selector labels.

The identity is a network-layer concept. It is not a Kubernetes service account and not an application credential. Whoever can set labels on a pod can choose the identity of that pod, so label control is part of the security design.

Key facts:

- Pods with the same relevant labels and namespace share one identity.
- Changing a relevant label changes the identity. Changing an ignored label does not.
- The `CiliumEndpoint` resource and `CiliumIdentity` resource show the identity.
- The kernel datapath compares identities, and the IP-to-identity map links addresses to them.

<!-- astrona:playground:destroy -->
