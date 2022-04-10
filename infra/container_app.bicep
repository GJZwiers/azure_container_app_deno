@minLength(3)
@maxLength(11)
param storagePrefix string
@allowed([
  'Standard_RAGRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_RAGRS'
param location string = resourceGroup().location
param environment_name string

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource nodeapp 'Microsoft.App/containerapps@2022-01-01-preview' = {
  name: 'hello-container-app'
  location: location
  properties: {
    managedEnvironmentId: resourceId('Microsoft.App/managedEnvironments', environment_name)
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
      secrets: [
        {
          name: 'storage-key'
          value: listKeys(stg.id, stg.apiVersion).keys[0].value
        }
      ]
    }
    template: {
      containers: [
        {
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: 'hello-world'
          resources: {
            cpu: 1
            memory: '1Gi'
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
    }
  }
}

