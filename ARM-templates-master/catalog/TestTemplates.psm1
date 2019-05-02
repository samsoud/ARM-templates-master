Function Start-CloudEngTemplateDeployment {
    <#
    .Synopsis
        Downloads the specified file from a blob storage account in Azure.
    .Description
        Connects to indicated Azure Storage Account Container and downloads the indicated file. User will be prompted to log into Azure if not already.
    .Parameter azureEnvironment
        AzureCloud for ROW (defaulted), AzureChinaCloud for China
    .Parameter subscriptionName
        Subscription to deploy to
    .Parameter resourceGroupName
        Resource Group name to deploy to
    .Parameter location
        Azure Region (EastUS, WestUS, ChinaEast, ChinaNorth, etc.) to deploy to
    .Parameter deployTemplatePath
        Local path on PC to the deployment template being used
    .Parameter artifactsBaseLocation
        The URL to the storage account containing the Cloud Engineering ARM templates. Default is the ROW release location https://OrderDynamics.blob.core.windows.net/templates.
    .Parameter FileName
        Optional. Name of file to download. If not specified, the entire contents of the container are downloaded.
    .Example
        Start-CloudEngTemplateDeployment -subscriptionName "Org-CLOUDENG-AUTO-F-POC" -resourceGroupName "myrg" -location "EastUS" -deployTemplatePath "C:\Users\mycdsid\Documents\mytemplate.json" -Verbose
    #>
    
    Param (
        [Parameter()]
        [ValidateSet('AzureCloud','AzureChinaCloud')]
        [String] $azureEnvironment = 'AzureCloud',

        [Parameter(Mandatory = $true)]
        [String] $subscriptionName,

        [Parameter(Mandatory = $true)]
        [String] $resourceGroupName,

        [Parameter(Mandatory = $true)]
        [String] $location,

        [Parameter(Mandatory = $true)]
        [String] $deployTemplatePath,
                
        [Parameter()]
        [ValidateSet('https://OrderDynamics.blob.core.windows.net/templates','https://OrderDynamics.blob.core.windows.net/testtemplates')]
        [String] $artifactsBaseLocation = 'https://OrderDynamics.blob.core.windows.net/templates'
        )

    Write-Verbose -Message "Finding template on path $deployTemplatePath"
    If(Test-Path -Path $deployTemplatePath)
    {
        Write-Verbose -Message "Found template"
    }
    Else
    {
        Write-Verbose -Message "Template not found, exiting script. Please check template path."
        Return
    }

    Write-Verbose -Message "Log into $azureEnvironment"
    Try
    {
        Get-AzureRmContext | Out-Null
    }
    Catch
    {
        Login-AzureRmAccount -EnvironmentName $azureEnvironment
    }

    Write-Verbose -Message "Set subcription to $subscriptionName"
    Try
    {
        Set-AzureRmContext -SubscriptionName $subscriptionName
    }
    Catch
    {
        Write-Verbose -Message "Error encountered trying find and set subscription. Error is " + $_.Exception.Message
        Return
    }

    $resGrp = $null
    Write-Verbose -Message "Checking if resource group $resourceGroupName already exists"
    Try
    {
        $resGrp = Get-AzureRmResourceGroup -Name $resourceGroupName -Location $location -ErrorAction SilentlyContinue
        If($resGrp)
        {
            Write-Verbose -Message "Found resource group $resourceGroupName"
        }
        Else
        {
            Write-Verbose -Message "Resource group $resourceGroupName not found, creating it..."
            $resGrp = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
            Write-Verbose -Message "Resource group $resourceGroupName created successfully"
        }
    }
    Catch
    {
        Write-Verbose -Message "Unexpected error encountered trying to create the resource group. Error is " + $_.Exception.Message
        Return
    }

    $Params = @{

        'artifactsBaseLocation' = $artifactsBaseLocation

    }

    Try
    {
        Write-Verbose -Message "Testing that deployment template has no syntax errors"
        If ($TestResult = Test-AzureRmResourceGroupDeployment -ResourceGroupName $resGrp.ResourceGroupName -TemplateFile $deployTemplatePath -TemplateParameterObject $Params) {
            Write-Verbose -Message "Testing failed, exiting script. To see the errors, check the Activity Log in Azure for Validate operations under the Event Category 'Administrative'"
            Return
        }
        Else
        {
            Write-Verbose -Message "Template is valid. Deploying..."
            New-AzureRmResourceGroupDeployment -ResourceGroupName $resGrp.ResourceGroupName -TemplateFile $deployTemplatePath -TemplateParameterObject $Params -Verbose
        }
    }
    Catch
    {
        Write-Verbose -Message "Unexpected error encountered trying to deploy the template. Error is " + $_.Exception.Message
        Return
    }

}