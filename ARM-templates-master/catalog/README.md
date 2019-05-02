# ARMtemplates

Here is a collection of ARM Templates examples which may be used to deploy the Cloud Engineering standard ARM Templates into Azure.  They may be dependant on other templates.  All templates are stored in the CloudEngArtifacts storage account curated by Cloud Engineering.


## WindowsVMDeployment.json
The WindowsVMDeployment.json template can be used to deploy 1..n Windows VMs. VMs are placed in the application1 subnet on the local vnet.

## WindowsVMWithJumpbox.json
The WindowsVMWithJumpbox.json template can be used to deploy 1..n Windows VMs in the application1 subnet on the local vnet, plus a Windows Jumpbox with no data disk on the managment subnet.

## SQLDeployment.json
The SQLDeployment.json template deploys a single SQL database with no replication.

## SQLFailoverDeployment.json
The SQLDeployment.json template deploys a single SQL database with replication to an additional region.

## AppGatewayDeployment.json
The AppGatewayDeployment.json template deploys an application gateway.


# Infrastructure

Create the base Infrastructure resources that every subscription will use.  This currently consists of:

A Storage account (named storage\<unique string\>)<br>
  with Standard_LRS storage

A Virtual Network (named network), with: <br>
  * address range 10.0.0.0/16<br>
  * 4 subnets:<br>
    * managment (10.0.0.0/24)<br>
    * application1 (10.0.1.0/24)<br>
    * application2 (10.0.2.0/24)<br>
    * application3 (10.0.3.0/24)
  * Each of these subnets has a Network Security Group attached to it permitting access from the Org Proxies for:
    * ssh
    * RDP
    * http
    * https

No paramters are necessary.  However, in the future we may want to specify the storage type.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2FOrderDynamics.blob.core.windows.net%2Ftemplates%2FInfrastructure.json" target="_blank">
<img src="https://azuredeploy.net/deploybutton.png"/>
</a>

____

# Linux VMs

Deploy between 1 and 200 Linux VMs.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2FOrderDynamics.blob.core.windows.net%2Ftemplates%2FLinuxVMs.json" target="_blank">
<img src="https://azuredeploy.net/deploybutton.png"/>
</a>

____

# Windows VMs

Deploy between 1 and 200 Windows VMs.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2FOrderDynamics.blob.core.windows.net%2Ftemplates%2FWindowsVMs.json" target="_blank">
<img src="https://azuredeploy.net/deploybutton.png"/>
</a>

____