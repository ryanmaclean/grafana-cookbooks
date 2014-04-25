Grafana (opsworks) cookbooks
============================

Setup
-----

### Static web server layer

Use a `Static Web Server` layer.

- Add `grafana::configure` to the **Deploy** custom chef recipes.

### Elastic search layer

Use a `Custom` layer.

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

[grafana_config]: https://github.com/torkelo/grafana/blob/master/src/config.sample.js
