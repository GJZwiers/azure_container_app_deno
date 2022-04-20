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
    acrName: 'container-app-acr'
    acrSku: 'Basic'
    location: location
  }
}

output registryName string = containerRegistry.outputs.registryName
