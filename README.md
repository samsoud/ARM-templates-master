# ARMtemplates

Nested ARM Templates used to deploy Org IaaS into Azure

## Approach

These template will be organized in the same way as Microsoft organizes the [azure-quickstart-templates](https://github.com/Azure/azure-quickstart-templates).  To the extent possible the standards outlined in [README.md](https://github.com/Azure/azure-quickstart-templates/blob/master/README.md) should be followed.  The most notable exception will be a single nested directory to store "sub-templates".  The reason for this is re-use.


## Template Descriptions
**LinuxVMs.json** - Deploys 1..n Linux VMs, along with a local vnet and storage for diagnostics. Standard extensions and controls are applied to the server(s).

**LinuxVMsNoDataDisk.json** - Deploys 1..n Linux VMs with just the base OS disk, along with a local vnet and storage for diagnostics. Standard extensions and controls are applied to the server(s). This is a common scenario for "Jump boxes" that do not need additional software installed and are only used to connect to other servers on the vnet.

**WindowsVMs.json** - Deploys 1..n Windows VMs, along with a local vnet and storage for diagnostics. Standard extensions and controls are applied to the server(s).

**WindowsVMsNoDataDisk.json** - Deploys 1..n Windows VMs with just the base OS disk, along with a local vnet and storage for diagnostics. Standard extensions and controls are applied to the server(s). This is a common scenario for "Jump boxes" that do not need additional software installed and are only used to connect to other servers on the vnet.

**SqlDatabase.json** - Deploys an Azure PaaS SQL Server database on a single SQL Server instance/server. If the server indicated already exists, it will deploy an additional database to it.

**SqlDatabaseWithFailover.json** - Deploys an Azure PaaS SQL Server database on a Primary SQL Server instance/server in one Azure region and then replicates it to a Secondary SQL Server instance/server in another Azure region.

### Nested Templates
**ApplicationGateWay.json** - Deploys an Azure App Gateway. Requires the vnet be created ahead of time (preferrably with the network.json template). Uses a default, invalid certificate during deployment - SSL configuration with the actual certificate must be done post-deployment.

**network.json** - Creates a vnet with four subnet (application1, application2, application3, and management), along with network security groups for each subnet.

**NIC_pub_False.json** - Creates a network interface for an internal vnet connection only.

**NIC_pub_True.json** - Creates a network interface for both a public IP and internal vnet connection.

**storage.json** - Creates a storage account.


## Standards

Microsoft has quite a lot of documentation.  We will follow their "Best Practices".

Input parameters should **constrained** and **documented** in the template itself using JSON itself.  This way errors can be found prior to deployment.  The description is also available to the person filling in a form during deployment.  For examples:

```json
    "numberOfInstances": {
      "type": "int",
      "defaultValue": 2,
      "minValue": 2,
      "maxValue": 5,
      "metadata": {
        "description": "Number of VMs to deploy, limit 5 since this is using a single storage account"
      }
    }
```

or

```json
      "administratorLoginPassword": {
         "type": "securestring",
         "minLength": 8,
         "maxLength": 128,
         "metadata": {
            "description": "Database administrator password"
         }
      }
```


## Important links

Community Templates  <https://github.com/Azure/azure-quickstart-templates>

Microsoft Doc on ARM Templates <https://docs.microsoft.com/en-us/azure/templates/>

Naming Rules and Restrictions <https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions>

Azure Resource Manager template functions <https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-template-functions>
