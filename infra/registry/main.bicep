targetScope = 'subscription'
param location string = 'westeurope'

resource registryResourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'container-registry-resource-group'
  location: location
}

module containerRegistry 'container_registry.bicep' = {
  name: 'container-registry'
  scope: registryResourceGroup
  params: {
    acrName: 'containerappregistry'
    acrSku: 'Basic'
    location: location
  }
}

output registryName string = containerRegistry.outputs.registryName
output loginServer string = containerRegistry.outputs.loginServer
output resourceGroupName string = registryResourceGroup.name
