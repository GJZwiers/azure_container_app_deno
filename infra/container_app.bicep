param location string = resourceGroup().location
param environmentName string
param registryName string
param subscriptionId string
param registryResourceGroup string
param tag string

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: registryName
  scope: resourceGroup(subscriptionId, registryResourceGroup )
}

resource denoContainerApp 'Microsoft.App/containerapps@2022-01-01-preview' = {
  name: 'denocontainerapp'
  location: location
  properties: {
    managedEnvironmentId: resourceId('Microsoft.App/managedEnvironments', environmentName)
    configuration: {
      ingress: {
        external: true
        targetPort: 8080
      }
      secrets: [
        {
          name: 'acr-admin-password'
          value: acr.listCredentials().passwords[0].value
        }
      ]
      registries: [
        {
          server: acr.properties.loginServer
          username: acr.name
          passwordSecretRef: 'acr-admin-password'
        }
      ]
    }
    template: {
      containers: [
        {
          image: '${acr.properties.loginServer}/dev/deno:${tag}'
          name: 'hello-deno'
          resources: {
            cpu: 1
            memory: '2Gi'
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
