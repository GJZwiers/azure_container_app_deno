targetScope = 'subscription'
param location string = 'westeurope'

resource registryResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'ctnr_registry_rg'
  location: location
}

resource containerAppResGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'ctnr_app_rg'
  location: location
}

output registryRGName string = registryResourceGroup.name
output ctnrAppRgName string = containerAppResGroup.name
