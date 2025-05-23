---
tags:
  - kubernetes
  - raspberry-pi
  - homelab
  - k3s
  - p4ndalab
  - k8s
author: Salim
categories:
  - Projects
cover:
  alt: Kubernetes Architecture
  hidden: false
  hiddenInList: false
  hiddenInSingle: false
  image: k8s-core-landscape.png
  relative: true
  responsiveImages: true
date: 2025-05-11
series:
  - P4ndaLab
summary: Dive into the core concepts and architecture of Kubernetes as I explain what makes it the industry standard for container orchestration and why K3s is perfect for a Raspberry Pi homelab. This post breaks down the control plane components, worker nodes, networking principles, and fundamental Kubernetes objects, setting the foundation for our upcoming hands-on implementation.
title: "P4ndaLab: Understanding Kubernetes - Core Concepts and Architecture"
---

## Introduction

Welcome to the second post in my P4ndaLab series! Last time, I introduced you to my Raspberry Pi Kubernetes homelab project and outlined my learning journey. Today, we're diving into Kubernetes itself - what it is, why it matters, and how it's structured. This post combines both theoretical concepts and architectural details to give you a solid foundation before we get our hands dirty with the implementation.

As I mentioned in my first post, I believe in learning by doing. But to do effectively, we first need to understand what we're working with. So let's unpack this powerful technology that's reshaping how we deploy and manage applications.

## What is Kubernetes?

At its core, Kubernetes (often abbreviated as K8s - 8 letters between 'K' and 's') is an open-source container orchestration platform. But what does that actually mean?

Think of it this way: if containers (like Docker) are a better way to package and run individual applications, Kubernetes is a better way to manage many containers across multiple machines. It automates the deployment, scaling, and management of containerized applications, handling all the complex logistics so you don't have to.

Originally developed by Google based on their internal system called Borg, Kubernetes was released as an open-source project in 2014 and is now maintained by the Cloud Native Computing Foundation (CNCF). It has since become the industry standard for container orchestration.

## Why Kubernetes Matters

You might wonder why we need something as complex as Kubernetes, especially for a homelab. Here's why it's worth learning:

1. **Automation at scale**: Kubernetes automates many manual processes involved in deploying and scaling applications.
2. **Self-healing capabilities**: If a container fails, Kubernetes can automatically restart it or replace it.
3. **Service discovery and load balancing**: Kubernetes can expose containers using DNS names or IP addresses and distribute network traffic.
4. **Storage orchestration**: You can mount storage systems of your choice, whether local or cloud-based.
5. **Declarative configuration**: You tell Kubernetes what you want your deployed application to look like, and it figures out how to make it happen.
6. **Portable across environments**: Whether running on-premises, in a public cloud, or a hybrid setup, Kubernetes works the same way.

For my P4ndaLab, Kubernetes provides a consistent platform to experiment with modern application deployment patterns and technologies that are widely used in the industry.

## Kubernetes vs. Traditional Deployment

To better understand Kubernetes, let's compare it with traditional deployment methods:

### Traditional Deployment

- Applications run directly on physical servers
- One application per server to avoid resource conflicts
- Results in underutilized hardware and high maintenance costs
- Scaling requires provisioning new servers
- Disaster recovery is manual and time-consuming

### Virtualized Deployment

- Multiple VMs run on a single physical server
- Applications isolated within VMs
- Better resource utilization than traditional deployment
- Scaling still relatively complex
- VM provisioning and maintenance overhead

### Container Deployment

- Lightweight and portable
- Share OS kernel but isolated at process level
- Fast startup and lower overhead than VMs
- Easy to build and deploy
- Still need container orchestration for production use

### Kubernetes Deployment

- Automates container management across multiple nodes
- Declarative approach to application deployment
- Built-in scaling, load balancing, and self-healing
- Infrastructure abstraction - you work with logical resources
- Consistent environment from development to production

## The Kubernetes Architecture

Now that we understand what Kubernetes is and why it matters, let's look at how it's built. Kubernetes follows a master-worker architecture that's both elegant and robust.

### High-Level View

At a high level, a Kubernetes cluster consists of two types of nodes:

1. **Control Plane (Master) Nodes**: Manage the cluster
2. **Worker Nodes**: Run the actual workloads (your applications)

Here's a simplified view of what this looks like:

```
┌─────────────────────────────────────────────────────────────┐
│                     Kubernetes Cluster                      │
│                                                             │
│  ┌───────────────────────┐      ┌──────────────────────┐    │
│  │    Control Plane      │      │     Worker Node 1    │    │
│  │                       │      │                      │    │
│  │  ┌─────────────────┐  │      │  ┌───────────────┐   │    │
│  │  │   API Server    │  │      │  │    Kubelet    │   │    │
│  │  └─────────────────┘  │      │  └───────────────┘   │    │
│  │                       │      │                      │    │
│  │  ┌─────────────────┐  │      │  ┌───────────────┐   │    │
│  │  │  Scheduler      │  │      │  │   Kube-proxy  │   │    │
│  │  └─────────────────┘  │      │  └───────────────┘   │    │
│  │                       │      │                      │    │
│  │  ┌─────────────────┐  │      │  ┌───────────────┐   │    │
│  │  │ Controller Mgr  │  │      │  │ Container RT  │   │    │
│  │  └─────────────────┘  │      │  └───────────────┘   │    │
│  │                       │      │                      │    │
│  │  ┌─────────────────┐  │      │  ┌───────────────┐   │    │
│  │  │      etcd       │  │      │  │     Pods      │   │    │
│  │  └─────────────────┘  │      │  └───────────────┘   │    │
│  └───────────────────────┘      └──────────────────────┘    │
│                                                             │
│                                  ┌──────────────────────┐   │
│                                  │     Worker Node 2    │   │
│                                  │         ...          │   │
│                                  └──────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

Let's break down each component in detail.

### Control Plane Components

The control plane is the brain of Kubernetes. Its components make global decisions about the cluster and detect and respond to events. In a production environment, control plane components are typically run across multiple computers for high availability, but for our P4ndaLab, they'll run on a single node.

#### API Server (kube-apiserver)

The API server is the front door to the Kubernetes control plane. All external communication with the cluster goes through the API server - whether it's from users running `kubectl` commands, other parts of the control plane, or external systems.

**Key responsibilities:**

- Validates and processes API requests
- Acts as a gateway for the control plane
- Serves as the connection point for all components
- Performs authentication and authorization
- Provides RESTful API operations

The API server is designed to scale horizontally, meaning you can run multiple instances to distribute load.

#### etcd

Think of etcd as the cluster's database. It's a consistent, distributed key-value store that reliably stores all of Kubernetes' configuration data and cluster state.

**Key responsibilities:**

- Stores all cluster data
- Provides watch-based notification of changes
- Offers strong consistency guarantees
- Provides the single source of truth for the cluster

When you execute a command like `kubectl get pods`, the API server reads data from etcd. When you create a new deployment, that configuration is stored in etcd.

#### Scheduler (kube-scheduler)

The scheduler's job is to assign newly created pods to nodes. It's like an intelligent dispatcher that decides where each workload should run.

**Key responsibilities:**

- Watches for newly created pods with no assigned node
- Selects the best node for each pod based on various factors
- Considers resource requirements, hardware/software constraints, and affinity/anti-affinity specifications
- Makes binding decisions (assigns pods to nodes)

The scheduler doesn't actually place the pod on the node; it simply updates the pod definition with the node assignment, and the kubelet on that node does the rest.

#### Controller Manager (kube-controller-manager)

The controller manager runs controller processes that regulate the state of the cluster. A controller is a control loop that watches the shared state of the cluster and makes changes to move the current state towards the desired state.

**Key controllers:**

- **Node Controller**: Notices and responds when nodes go down
- **Replication Controller**: Maintains the correct number of pods for each ReplicaSet
- **Endpoints Controller**: Populates Endpoint objects (joins Services & Pods)
- **Service Account & Token Controllers**: Create default accounts and API access tokens

#### Cloud Controller Manager

This component links your cluster with your cloud provider's API. For a homelab setup like ours, this component isn't particularly relevant since we're not running in a cloud environment. But it's worth knowing about for completeness.

### Worker Node Components

Worker nodes are the machines where your applications actually run. Each node includes the services necessary to run pods and is managed by the control plane.

#### Kubelet

The kubelet is an agent that runs on each node in the cluster. It's responsible for making sure that containers are running in a pod.

**Key responsibilities:**

- Communicates with the API server
- Takes a set of PodSpecs and ensures the containers described are running and healthy
- Reports node and pod status to the master
- Runs container health checks
- Manages container lifecycle based on PodSpecs

#### Kube-proxy

Kube-proxy is a network proxy that runs on each node, implementing part of the Kubernetes Service concept.

**Key responsibilities:**

- Maintains network rules on nodes
- Handles network communications inside or outside of your cluster
- Performs connection forwarding
- Implements services abstraction

Kube-proxy uses the operating system packet filtering layer if available, otherwise, it forwards the traffic itself.

#### Container Runtime

The container runtime is the software responsible for running containers. Kubernetes supports several container runtimes including Docker, containerd, and CRI-O.

For our P4ndaLab, we'll be using K3s, which includes containerd as its container runtime by default.

## K3s: Kubernetes for Resource-Constrained Environments

Speaking of K3s, let's talk about what makes it special and why I've chosen it for P4ndaLab.

### What is K3s?

K3s is a certified Kubernetes distribution designed for resource-constrained environments like IoT devices, edge computing, and in our case, a Raspberry Pi. Created by Rancher Labs (now part of SUSE), K3s packages Kubernetes as a single binary less than 100MB in size.

### K3s vs Standard Kubernetes (K8s)

| Feature               | Standard K8s     | K3s                                   |
| --------------------- | ---------------- | ------------------------------------- |
| Binary size           | ~200MB+          | <100MB                                |
| Memory footprint      | 2GB+ recommended | 512MB minimum                         |
| Setup complexity      | High             | Low (single command)                  |
| External dependencies | Multiple         | Minimal                               |
| Default components    | Minimal          | Includes storage, load balancer, etc. |
| Storage backend       | etcd             | SQLite (default) or etcd              |

### K3s Architecture Specifics

K3s modifies the standard Kubernetes architecture to be more lightweight:

1. **Single Binary**: Combines control plane components for efficiency
2. **Embedded Components**: Includes containerd, Flannel, CoreDNS, local storage provider, Traefik ingress, and more
3. **Simplified Management**: Automatic TLS certificate generation and rotation
4. **Storage Options**: Uses SQLite by default for single-node deployments, with etcd available for HA clusters

For our Raspberry Pi setup, these optimizations are crucial. K3s gives us a fully compliant Kubernetes experience while respecting the hardware limitations of our Pi.

## Kubernetes Core Objects and Concepts

Now that we understand the architecture, let's explore some key Kubernetes objects that we'll be working with:

### Pods

A Pod is the smallest deployable unit in Kubernetes. It represents a single instance of a running process in your cluster and can contain one or more containers that are tightly coupled.

**Key characteristics:**

- Pods are ephemeral (they can be deleted and replaced at any time)
- All containers in a Pod share the same network namespace (IP and port space)
- Containers within a Pod can communicate via localhost
- Pods are scheduled onto nodes as complete units

### Deployments

A Deployment provides declarative updates for Pods and ReplicaSets. You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate.

**Key benefits:**

- Describe your desired application state
- Deployments can scale up or down the number of replicas
- Perform rolling updates without downtime
- Roll back to earlier Deployment versions if necessary

### Services

A Service is an abstraction that defines a logical set of Pods and a policy to access them. Since Pods are ephemeral, Services provide a stable endpoint to connect to the application.

**Types of Services:**

- **ClusterIP**: Exposes the Service on an internal IP (default)
- **NodePort**: Exposes the Service on each Node's IP at a static port
- **LoadBalancer**: Exposes the Service externally using a cloud provider's load balancer
- **ExternalName**: Maps the Service to a DNS name

### Volumes

Volumes enable data persistence beyond the lifecycle of a Pod. Kubernetes supports many types of volumes, from local storage to cloud provider offerings.

For our P4ndaLab, we'll primarily use local persistent volumes backed by our USB SSD.

### ConfigMaps and Secrets

These objects help separate configuration from application code:

- **ConfigMaps**: Store non-confidential configuration data
- **Secrets**: Store sensitive information like passwords and tokens

## Working with Kubernetes: The Workflow

Understanding how to interact with Kubernetes is as important as knowing its components. Here's a typical workflow:

1. **Define your application**: Create YAML manifests describing your desired state
2. **Apply manifests**: Submit these definitions to the API server
3. **Kubernetes processes the request**: The control plane schedules your workloads
4. **Monitor and manage**: Use kubectl to interact with your application

All of this is based on a declarative approach: you tell Kubernetes what you want, not how to do it.

## Kubernetes Networking

Networking is a crucial aspect of Kubernetes. Here's what you need to know:

### Basic Principles

- Every Pod gets its own IP address
- Pods on a node can communicate with all Pods on all nodes without NAT
- Agents on a node can communicate with all Pods on that node

### Cluster Networking Components

1. **Pod Network**: Enabled by CNI plugins (like Flannel in K3s)
2. **Services**: Provide stable endpoints for pod access
3. **Ingress Controllers**: Manage external access to services (HTTP/HTTPS)
4. **CoreDNS**: Provides DNS-based service discovery

For our P4ndaLab, K3s comes with Flannel for Pod networking and Traefik as the Ingress controller, making our setup much simpler.

## Kubernetes on Raspberry Pi: Considerations

Running Kubernetes on a Raspberry Pi comes with some special considerations:

### Hardware Limitations

- **ARM Architecture**: Requires ARM-compatible container images
- **Memory Constraints**: 8GB is sufficient but requires careful resource management
- **Storage Performance**: USB SSD significantly outperforms SD cards
- **Network Performance**: Gigabit Ethernet is preferred over Wi-Fi

### Software Adaptations

- **Lightweight Distribution**: K3s instead of full Kubernetes
- **Resource Limits**: Set appropriate CPU/memory limits for workloads
- **Node Features**: Some advanced features may be limited or unavailable
- **Image Selection**: Choose lightweight, ARM-compatible images

Despite these limitations, a Raspberry Pi is perfectly capable of running a functional Kubernetes environment for learning and small projects.

## What's Coming Next

Now that we've covered the theory, in the next post we'll dive into the hands-on implementation of our Kubernetes cluster on the Raspberry Pi. We'll walk through:

1. Setting up persistent storage with our USB SSD
2. Configuring networking for our cluster
3. Creating our first deployments
4. Exposing services to our network

I'm excited to move from concepts to concrete implementation, and I hope you'll join me as we continue building our P4ndaLab!

## Conclusion

Kubernetes may seem complex at first glance, and truthfully, it is. But by breaking it down into its component parts and understanding how they work together, we can begin to appreciate its elegant design and powerful capabilities.

For our P4ndaLab project, Kubernetes provides a platform that mirrors what's used in production environments worldwide, giving us valuable hands-on experience that translates directly to real-world skills.

Whether you're following along to build your own homelab or just curious about Kubernetes, I hope this post has demystified some of the core concepts and architecture. Remember, the best way to learn is by doing - so in the next post, we'll roll up our sleeves and start building!

Until then, happy hacking!

---

_Have questions or suggestions for the P4ndaLab project? Suggest your changes using the link at the top of the post under the title_
