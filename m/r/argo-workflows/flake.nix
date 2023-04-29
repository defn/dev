{
  inputs.app.url = github:devn/dev/app-app-0.0.44?dir=m/app/app;
  outputs = inputs: inputs.app.kustomizeMain rec { src = ./.; };
}
