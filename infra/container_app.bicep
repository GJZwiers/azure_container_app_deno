param location string = resourceGroup().location
param subscriptionId string
param registryName string
param registryResourceGroup string
param tag string
@allowed([
  'PerGB2018'
  'Free'
  'Standalone'
  'PerNode'
  'Standard'
  'Premium'
])
param sku string

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'ctnr-app-workspace'
  location: location
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: 30
  }
}

resource env 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: 'ctnr-app-env'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: workspace.properties.customerId
        sharedKey: workspace.listKeys().primarySharedKey
      }
    }
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: registryName
  scope: resourceGroup(subscriptionId, registryResourceGroup)
}

resource denoContainerApp 'Microsoft.App/containerapps@2022-03-01' = {
  name: 'deno-ctnr-app'
  location: location
  properties: {
    managedEnvironmentId: resourceId('Microsoft.App/managedEnvironments', env.name)
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
          image: '${acr.properties.loginServer}/server/dev:${tag}'
          name: 'hello-deno'
          resources: {
            cpu: 1
            memory: '2Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
  tags: {
    'App': 'DenoContainerApp'
  }
}
