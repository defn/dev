{
  inputs.infra.url = github:defn/m/cmd-infra-0.0.30?dir=cmd/infra;
  outputs = inputs: inputs.infra.inputs.app.cdktfMain rec {
    src = ./.;
    infra = inputs.infra;
    infra_cli = "infra";
  };
}
