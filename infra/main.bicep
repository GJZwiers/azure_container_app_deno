targetScope = 'resourceGroup'
param location string = 'westeurope'
param registryName string
param tag string
param registryResourceGroup string
@secure()
param subscriptionId string

module containerAppEnvironment 'container_env.bicep' = {
  name: 'log_analytics'
  params: {
    location: location
    sku: 'PerGB2018'
    retentionInDays: 30
    name: 'environment'
  }
}

module containerApp 'container_app.bicep' = {
  name: 'ctnr_app'
  params: {
    location: location
    environmentName: containerAppEnvironment.outputs.environmentName
    registryName: registryName
    registryResourceGroup: registryResourceGroup
    subscriptionId: subscriptionId
    tag: tag
  }
}
