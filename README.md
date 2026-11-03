# Network Policy (ATS053)

Cilium Certified Associate (CCA): Network Policy, worth 18% of the official curriculum. This course belongs to ATP011.

Developed reading explains mechanisms, responsible components, examples and limits. Every section has an introduction and every module closes with a summary. Each section has a quiz of 10 questions and a final domain quiz of 15 questions, written as YAML question banks. Technical content remains draft. Private playgrounds, draft graded labs and section capstones are included.

## Course Outline

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

## Author Review

See [curriculum coverage](CURRICULUM.md), [primary sources](SOURCES.md), [question-bank documentation](ASSESSMENTS.md) and [contribution instructions](CONTRIBUTING.md). No runtime execution is claimed.

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
