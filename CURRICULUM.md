# Curriculum Coverage

Exam: Cilium Certified Associate (CCA). Domain: Network Policy (18%).

The [official objectives](https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/) were checked on 2026-10-11. Teaching structure is independently authored and does not add official requirements.

| Section | Official objective | Modules |
| --- | --- | --- |
| 010 | Interpret Cilium Network Polices and Intent | 2 |
| 020 | Understand Cilium's Identity-based Network Security Model | 2 |
| 030 | Policy Enforcement Modes | 2 |
| 040 | Policy Rule Structure | 2 |
| 050 | Kubernetes Network Policies versus Cilium Network Policies | 2 |

| Section / module | Module | Teaching files |
| --- | --- | --- |
| 010 / 01 | Reading A CiliumNetworkPolicy | The Subject And The Direction; Peers, Ports And How Rules Combine; Apply And Test An Ingress Policy |
| 010 / 02 | Effective Policy, Dependencies And Evidence | Egress Dependencies And DNS; Effective Policy And Evidence |
| 020 / 01 | Security Identities And Labels | Why Identity Replaces The IP Address; How Labels Become An Identity; Reading And Changing An Endpoint Identity |
| 020 / 02 | Reserved Identities, Entities And CIDR | Selecting Peers Across Namespaces; Reserved Identities, Entities And CIDR |
| 030 / 01 | Default, Always And Never Enforcement | The Three Enforcement Modes; Reading And Changing The Mode; Apply A Policy And Check The Enforcement State |
| 030 / 02 | Audit Mode And Safe Rollout | Audit Mode; Default Deny Control And Rollout |
| 040 / 01 | Selectors, Peers And Ports | Policy Anatomy And Peer Selectors; Ports And Rule Combination; Apply And Test A Port-Scoped Policy |
| 040 / 02 | Application, DNS And Deny Rules | HTTP And DNS Rules; Deny Rules And Precedence |
| 050 / 01 | Kubernetes NetworkPolicy Semantics On Cilium | The NetworkPolicy API; How Cilium Enforces NetworkPolicy; Apply And Check A Kubernetes NetworkPolicy |
| 050 / 02 | Cilium Extensions And Choosing Between Policy Kinds | Cilium Extensions And Scope; Choosing A Policy Kind And Migrating |

AUTHORING.yaml records measurable goals and adaptation sources. Every objective retains its section ID. All technical readings remain draft. Question banks are separate from the reading manifest and follow their declared summaries. Private playgrounds and independent labs are included. Live verification is recorded separately.

## Hands-On Coverage

This course has 10 ungraded playgrounds, 10 module labs and 5 capstone labs, all draft. Each lab follows the reading part it practises, and each capstone follows the last module of its section. Each section ends with a quiz, and a final domain quiz closes the course. Static checks are separate from live execution. No lab or playground has been run, so every one is UNTESTED.

| Module | Lab in reading order |
| --- | --- |
| 010/01 | Enforce An Endpoint Selected Policy |
| 010/02 | Limit Egress And Keep DNS Working |
| 020/01 | Read An Endpoint Security Identity |
| 020/02 | Select Peers By Label Identity |
| 030/01 | Observe Default Enforcement On Selected Endpoints |
| 030/02 | Add A Rule Without Enabling Default Deny |
| 040/01 | Apply A Port Scoped Cilium Rule |
| 040/02 | Restrict A Request By HTTP Path |
| 050/01 | Enforce A Standard Kubernetes Policy |
| 050/02 | Combine A NetworkPolicy With A CiliumNetworkPolicy |
| 010/capstone | Capstone: Write The Contract For Both Directions |
| 020/capstone | Capstone: Grant Access By Identity Across Namespaces |
| 030/capstone | Capstone: Enforce One Direction Only |
| 040/capstone | Capstone: Combine An Entity Allow With A Deny Rule |
| 050/capstone | Capstone: Block One Client Without Editing The NetworkPolicy |
