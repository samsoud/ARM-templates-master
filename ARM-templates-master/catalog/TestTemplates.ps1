Login-AzureRmAccount -EnvironmentName AzureCloud
Set-AzureRmContext -SubscriptionName 'Research and Development'
$templateLoc = "C:\ARMtemplates-master1\WindowsVMs.json"
$resourceGroupName = 'CloudEngArtifacts'
$location = "Canada central"

#$ResGrp = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location -verbose
$ResGrp = Get-AzureRmResourceGroup -Name $resourceGroupName -Location $location -verbose

$Params = @{

"artifactsBaseLocation" = "https://samsoudstorage123.blob.core.windows.net/testtemplates"
"storageAccountName"="strgcloudengartifacts"
"adminPassword"="@EastN0rth321"
"vmSize"= "Standard_DS2_v2"
"environment"="dev"
"needsPublicIP"="yes"
}




Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResGrp.ResourceGroupName -TemplateFile $templateLoc -TemplateParameterObject $Params -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResGrp.ResourceGroupName -TemplateFile $templateLoc -TemplateParameterObject $Params -Verbose


#Get-AzureRmResourceGroupDeployment -ResourceGroupName 'ianwintest36'
