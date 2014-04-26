Grafana (opsworks) cookbooks
============================

Setup
-----

### App

Create a Static app. Specify `https://github.com/torkelo/grafana` as the repository url. I advise you to specify a tag
or revision.

### Static web server layer

Use a `Static Web Server` layer.

- Add `grafana::deploy` to the **Deploy** custom chef recipes.

### Elastic search layer

Use a `Custom` layer, with a shortname of `elasticsearch`.

- Add `elasticsearch::install` and `elasticsearch::packages` to the **Setup** custom chef recipes.
- Add `elasticsearch` to the **Configure** custom chef recipes.

### Stack configuration

You can configure the [grafana config file][grafana_config] by doing so:

```json
{
    "grafana": {
        "config": {
            "graphiteUrl": "https://www.hostedgraphite.com/xxx/xxx/graphite",
            "default_route": "/dashboard/elasticsearch/Main"
        }
    }
}
```

Note that the elasticsearch url will be automatically configured.

[grafana_config]: https://github.com/torkelo/grafana/blob/master/src/config.sample.js