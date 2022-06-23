targetScope = 'resourceGroup'
param location string = 'westeurope'

module containerRegistry 'container_registry.bicep' = {
  name: 'ctnr_registry'
  params: {
    acrName: 'ctnrAppRegistry'
    acrSku: 'Basic'
    location: location
  }
}

output registryName string = containerRegistry.outputs.registryName
output loginServer string = containerRegistry.outputs.loginServer
