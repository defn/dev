{
  inputs.infra.url = github:devn/dev/cmd-infra-0.0.30?dir=m/cmd/infra;
  outputs = inputs: inputs.infra.inputs.app.cdktfMain rec {
    src = ./.;
    infra = inputs.infra;
    infra_cli = "infra";
  };
}
