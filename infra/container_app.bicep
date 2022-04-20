param location string = resourceGroup().location
param environmentName string
param registryName string

resource denoContainerApp 'Microsoft.App/containerapps@2022-01-01-preview' = {
  name: 'hello-container-app'
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
          value: 'foo' // acr.listCredentials().passwords[0].value
        }
      ]
      registries: [
        {
          server: 'acr3nre3qrjggrs2.azurecr.io'
          username: 'acr3nre3qrjggrs2'
          passwordSecretRef: 'acr-admin-password'
        }
      ]
    }
    template: {
      containers: [
        {
          image: 'acr3nre3qrjggrs2.azurecr.io/deno/hello:latest'
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
