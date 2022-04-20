targetScope = 'subscription'
param location string = 'westeurope'
param registryName string

resource containerAppResGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'container-app-res-group'
  location: location
}

module containerAppEnvironment 'container_env.bicep' = {
  name: 'log_analytics'
  scope: containerAppResGroup
  params: {
    location: location
    sku: 'PerGB2018'
    retentionInDays: 30
    name: 'environment'
  }
}

module containerApp 'container_app.bicep' = {
  name: 'containerapp'
  scope: containerAppResGroup
  params: {
    location: location
    environmentName: containerAppEnvironment.outputs.environmentName
    registryName: registryName
  }
}
