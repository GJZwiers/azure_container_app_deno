param location string = resourceGroup().location

@minLength(5)
@maxLength(50)
param acrName string

@description('Provide a tier of your Azure Container Registry.')
param acrSku string = 'Basic'

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
  }
  tags: {
    'App': 'DenoContainerApp'
  }
}

@description('Output the login server property for later use')
output loginServer string = acr.properties.loginServer
output registryName string = acr.name
