# CrunchyData PGO with pgvecto.rs Extension

This repository contains container images for [CrunchyData PGO](https://github.com/CrunchyData/postgres-operator) that include the [pgvecto.rs](https://github.com/tensorchord/pgvecto.rs) extension.

## Important Configuration Note

> :warning: **If you are deploying this image on an existing database:** The postgres configuration must be updated to enable the pgvecto.rs extension. 

To enable the extension, you need to set the `shared_preload_libraries` in your Cluster spec. Add the following configuration to your `PostgresCluster` yaml file:

```yaml
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
spec:
  ...
  patroni:
    dynamicConfiguration:
      postgresql:
        synchronous_commit: "on"
        parameters:
          shared_preload_libraries: "vectors.so"
```
