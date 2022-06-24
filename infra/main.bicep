targetScope = 'resourceGroup'
param location string = 'westeurope'
param registryName string
param tag string
param registryResourceGroup string
@secure()
param subscriptionId string

module containerApp 'container_app.bicep' = {
  name: 'ctnr_app'
  params: {
    location: location
    registryName: registryName
    registryResourceGroup: registryResourceGroup
    subscriptionId: subscriptionId
    tag: tag
    sku: 'PerGB2018'
  }
}
