{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    aws-signing-helper-pkg.url = "path:./nix/aws-signing-helper";
    flyctl.url = "path:./nix/flyctl";
    vcluster-pkg = "path:./nix/vcluster";
    gh-pkg = "path:./nix/gh";
    earthly-pkg = "path:./nix/earthly";
    cue-pkg = "path:./nix/cue";
    step-pkg = "path:./nix/step";
    kuma-pkg = "path:./nix/kuma";
    switch-pkg = "path:./nix/switch";
    k3d-pkg = "path:./nix/k3d";
    caddy-pkg = "path:./nix/caddy";
    temporalite-pkg = "path:./nix/temporalite";
    kubebuilder-pkg = "path:./nix/kubebuilder";
    steampipe-pkg = "path:./nix/steampipe";
    kustomize-pkg = "path:./nix/kustomize";
    krew-pkg = "path:./nix/krew";
    helm-pkg = "path:./nix/helm";
    cloudflared-pkg = "path:./nix/cloudflared";
    argo-pkg = "path:./nix/argo";
    argocd-pkg = "path:./nix/argocd";
    hof-pkg = "path:./nix/hof";
    tilt-pkg = "path:./nix/tilt";
    goreleaser-pkg = "path:./nix/goreleaser";
    teller-pkg = "path:./nix/teller";
    protoc-pkg = "path:./nix/protoc";
    buf-pkg = "path:./nix/buf";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , aws-signing-helper-pkg
    , flyctl-pkg
    , vcluster-pkg
    , gh-pkg
    , earthly-pkg
    , cue-pkg
    , step-pkg
    , kuma-pkg
    , switch-pkg
    , k3d-pkg
    , caddy-pkg
    , temporalite-pkg
    , kubebuilder-pkg
    , steampipe-pkg
    , kustomize-pkg
    , krew-pkg
    , helm-pkg
    , cloudflared-pkg
    , argo-pkg
    , argocd-pkg
    , hof-pkg
    , tilt-pkg
    , goreleaser-pkg
    , teller-pkg
    , protoc-pkg
    , buf-pkg
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      aws-signing-helper = aws-signing-helper-pkg.defaultPackage.${system};
      flyctl = flyctl-pkg.defaultPackage.${system};
      vcluster = vcluster-pkg.default.${system};
      gh = gh-pkg.default.${system};
      earthly = earthly-pkg.default.${system};
      cue = cue-pkg.default.${system};
      step = step-pkg.default.${system};
      kuma = kuma-pkg.default.${system};
      switch = switch-pkg.default.${system};
      k3d = k3d-pkg.default.${system};
      caddy = caddy-pkg.default.${system};
      temporalite = temporalite-pkg.default.${system};
      kubebuilder = kubebuilder-pkg.default.${system};
      steampipe = steampipe-pkg.default.${system};
      kustomize = kustomize-pkg.default.${system};
      krew = krew-pkg.default.${system};
      helm = helm-pkg.default.${system};
      cloudflared = cloudflared-pkg.default.${system};
      argo = argo-pkg.default.${system};
      argocd = argocd-pkg.default.${system};
      hof = hof-pkg.default.${system};
      tilt = tilt-pkg.default.${system};
      goreleaser = goreleaser-pkg.default.${system};
      teller = teller-pkg.default.${system};
      protoc = protoc-pkg.default.${system};
      buf = buf-pkg.default.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.go
          pkgs.gotools
          pkgs.go-tools
          pkgs.golangci-lint
          pkgs.gopls
          pkgs.go-outline
          pkgs.gopkgs
          pkgs.delve
          pkgs.nodejs-18_x
          aws-signing-helper
          flyctl
          vcluster
          gh
          earthly
          cue
          step
          kuma
          switch
          k3d
          caddy
          temporalite
          kubebuilder
          steampipe
          kustomize
          krew
          helm
          cloudflared
          argo
          argocd
          hof
          tilt
          goreleaser
          teller
          protoc
          buf
        ];
      };
    }
    );
}
