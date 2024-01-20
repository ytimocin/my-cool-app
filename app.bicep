import radius as radius

@description('The Radius Application ID. Injected automatically by the rad CLI.')
param application string

resource demo 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'demo'
  properties: {
    application: application
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}

resource redisContainer 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'redis-container'
  location: 'global'
  properties: {
    application: demo.id
    container: {
      image: 'redis:6.2'
      ports: {
        redis: {
          containerPort: 6379
          port: 80
        }
      }
    }
    connections: {}
  }
}

resource redis 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
  name: 'rds-rds'
  location: 'global'
  properties: {
    environment: '/planes/radius/local/resourcegroups/default/providers/Applications.Core/environments/default'
    application: demo.id
    resourceProvisioning: 'manual'
    host: 'redis-container'
    port: 80
    secrets: {
      connectionString: 'rds-ctnr:6379'
      password: ''
    }
  }
}
