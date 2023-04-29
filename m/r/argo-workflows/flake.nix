{
  inputs.app.url = github:defn/dev/m/app-app-0.0.44?dir=app/app;
  outputs = inputs: inputs.app.kustomizeMain rec { src = ./.; };
}
