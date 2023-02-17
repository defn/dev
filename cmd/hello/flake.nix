{
  inputs.lib.url = github:defn/lib/0.0.34;
  outputs = inputs: inputs.lib.goMain rec { src = ./.; };
}
