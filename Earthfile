VERSION 0.6

defn0:
    FROM registry.fly.io/defn:dev-tower
    RUN --secret FLY_ACCESS_TOKEN ~/bin/e flyctl scale --app defn count 0

defn1:
    FROM registry.fly.io/defn:dev-tower
    RUN --secret FLY_ACCESS_TOKEN ~/bin/e flyctl scale --app defn count 1
