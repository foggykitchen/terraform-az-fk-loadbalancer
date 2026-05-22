# Azure Load Balancer with Terraform / OpenTofu — Examples

This directory contains **hands-on Azure Load Balancer examples** built around the
`terraform-az-fk-loadbalancer` module.

The examples are designed as **progressive building blocks** that introduce how
Azure **Standard Public Load Balancer** works — first with classic Virtual Machines,
and then with **Virtual Machine Scale Sets (VMSS)**.

These examples deliberately focus on **load‑balancing fundamentals** and avoid
enterprise abstractions or platform shortcuts.

They are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used across:

- Azure Fundamentals with Terraform / OpenTofu  
- Azure Compute (VM & VMSS) deep dives  
- AKS and backend traffic patterns  
- Multicloud (Azure + OCI) architectural training  

---

## 🧭 Example Overview

| Example | Title | Key Topics |
|------|------|-----------|
| 01 | **Public Load Balancer with Multiple VMs** | Public frontend IP, backend pool, health probes, traffic distribution |
| 02 | **Public Load Balancer with VM Scale Set (VMSS)** | VMSS integration, autoscaling, backend pool attachment |

Each example introduces **one clear load‑balancing concept** and can be applied
**independently** for learning, experimentation, or reuse.

---

## ⚙️ How to Use

Each example directory contains:

- Terraform / OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the architectural goal
- Architecture diagrams and Azure Portal verification screenshots
- A **fully runnable deployment** (no placeholders, no mock resources)

To run an example:

```bash
cd examples/01_public_lb_multiple_vms
tofu init
tofu plan
tofu apply
```

Examples may be deployed independently, but the **recommended learning path** is:

```
01 → 02
```

This mirrors real‑world Azure design:

- Start with explicit backend VMs and a public Load Balancer
- Then move to VM Scale Sets with autoscaling behind the same LB concepts

---

## 🧩 Design Principles

These examples follow strict design rules:

- One example = one architectural concept
- Explicit modeling of:
  - frontend IP configuration
  - backend address pools
  - health probes
  - load‑balancing rules
- Clear separation of concerns:
  - networking (VNet, subnet, NSG)
  - load balancing (LB module)
  - compute (VM or VMSS module)
- No hidden magic or implicit wiring
- All traffic paths are visible in Terraform

The examples intentionally avoid:

- Enterprise landing zones
- Application Gateways
- Azure Front Door
- Platform‑specific shortcuts
- Kubernetes abstractions (covered in AKS modules)

The goal is **clarity and correctness**, not completeness.

---

## 🔗 Related Modules & Training

- [terraform-az-fk-loadbalancer](https://github.com/mlinxfeld/terraform-az-fk-loadbalancer) (this repository)
- [terraform-az-fk-compute](https://github.com/mlinxfeld/terraform-az-fk-compute)
- [terraform-az-fk-natgw](https://github.com/mlinxfeld/terraform-az-fk-natgw)
- [terraform-az-fk-nsg](https://github.com/mlinxfeld/terraform-az-fk-nsg)
- [terraform-az-fk-vnet](https://github.com/foggykitchen/terraform-az-fk-vnet)
- [terraform-az-fk-aks](https://github.com/mlinxfeld/terraform-az-fk-aks)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See `LICENSE` for details.

---

© 2026 FoggyKitchen.com — Cloud. Code. Clarity.
