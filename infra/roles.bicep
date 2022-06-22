param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2021-09-30-preview' = {
  name: 'app_mng_id'
  location: location
  tags: {
    'App': 'DenoContainerApp'
  }
}

resource role 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: 'containerapp_registry_read_access'
  // scope: managedIdentity
  properties: {
    permissions: [
      {
        actions: [
          'Microsoft.ContainerRegistry/registries/pull/read'
          'Microsoft.ContainerRegistry/registries/read'
        ]
      }
    ]
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, managedIdentity.id, role.id)
  properties: {
    roleDefinitionId: role.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}
