Cardano staking pool on Azure
=============================

Step-by-step instructions for configuring a complete Cardano staking pool 
on Azure. By making use of tools like [Terraform](https://www.terraform.io/) and 
Linux containers, our goal is to minimize the amount of manual work involved in setting 
up a pool. 

I am not a Terraform, Azure, container, or Cardano expert, so what you are reading is my learning process. **There are no warranties.** I may be doing things that are bad practice, expensive, overly complicated, or insecure (though I'm hyper-focused on avoiding this last point).

The subtasks are:

1. [Laptop setup](10-laptop-setup.md). Set up tools on my laptop.
1. [Azure and Terraform setup](20-azure-setup.md). Create *just* enough Azure infrastructure to bootstrap Terraform.
1. **Write Terraform file(s) for one node.** Get generic Cardano container running from official image.
1. **Create config files.** Create and push config files for one customized Cardano container.
1. **Scale to cluster.** Expand so that we have 1 block-producing node and 2 relays, with some 
geographic redundancy.

The subtask docs focus heavily on the **HOW** of doing this, without a lot of explanation. This 
is by design. Further, these are all done on Mac OSX; you're mileage will vary if not using Mac, 
especially if on Windows.



References
----------

1. [https://blog.logrocket.com/real-world-azure-resource-management-with-terraform-and-docker/]
