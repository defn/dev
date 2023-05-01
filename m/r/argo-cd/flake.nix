{
  inputs.app.url = github:defn/dev/app-app-0.0.48?dir=m/app/app;
  outputs = inputs: inputs.app.kustomizeMain rec { src = ./.; };
}
