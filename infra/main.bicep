targetScope = 'subscription'
param location string = 'westeurope'

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

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: 'container-app-key-vault'
  scope: containerAppResGroup
}

module containerApp 'container_app.bicep' = {
  name: 'containerapp'
  scope: containerAppResGroup
  params: {
    location: location
    storagePrefix: 'cterstore'
    environment_name: containerAppEnvironment.outputs.environmentName
    acr_admin_password: kv.getSecret('acr-admin-password')
  }
}

module containerRegistry 'container_registry.bicep' = {
  name: 'container_registry'
  scope: containerAppResGroup
  params: {
    location: location
  }
}
