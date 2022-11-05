{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    aws-signing-helper-pkg.url = "path:./nix/aws-signing-helper";
    flyctl-pkg.url = "path:./nix/flyctl";
    vcluster-pkg.url = "path:./nix/vcluster";
    gh-pkg.url = "path:./nix/gh";
    earthly-pkg.url = "path:./nix/earthly";
    cue-pkg.url = "path:./nix/cue";
    step-pkg.url = "path:./nix/step";
    kuma-pkg.url = "path:./nix/kuma";
    switch-pkg.url = "path:./nix/switch";
    k3d-pkg.url = "path:./nix/k3d";
    caddy-pkg.url = "path:./nix/caddy";
    temporalite-pkg.url = "path:./nix/temporalite";
    kubebuilder-pkg.url = "path:./nix/kubebuilder";
    steampipe-pkg.url = "path:./nix/steampipe";
    kustomize-pkg.url = "path:./nix/kustomize";
    kubectl-pkg.url = "path:./nix/kubectl";
    krew-pkg.url = "path:./nix/krew";     
    helm-pkg.url = "path:./nix/helm";
    cloudflared-pkg.url = "path:./nix/cloudflared";
    argo-pkg.url = "path:./nix/argo";
    argocd-pkg.url = "path:./nix/argocd";
    hof-pkg.url = "path:./nix/hof";
    tilt-pkg.url = "path:./nix/tilt";
    goreleaser-pkg.url = "path:./nix/goreleaser";
    teller-pkg.url = "path:./nix/teller";
    protoc-pkg.url = "path:./nix/protoc";
    buf-pkg.url = "path:./nix/buf";
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
    , kubectl-pkg
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
      vcluster = vcluster-pkg.defaultPackage.${system};
      gh = gh-pkg.defaultPackage.${system};
      earthly = earthly-pkg.defaultPackage.${system};
      cue = cue-pkg.defaultPackage.${system};
      step = step-pkg.defaultPackage.${system};
      kuma = kuma-pkg.defaultPackage.${system};
      switch = switch-pkg.defaultPackage.${system};
      k3d = k3d-pkg.defaultPackage.${system};
      caddy = caddy-pkg.defaultPackage.${system};
      temporalite = temporalite-pkg.defaultPackage.${system};
      kubebuilder = kubebuilder-pkg.defaultPackage.${system};
      steampipe = steampipe-pkg.defaultPackage.${system};
      kustomize = kustomize-pkg.defaultPackage.${system};
      kubectl = kubectl-pkg.defaultPackage.${system};
      krew = krew-pkg.defaultPackage.${system};
      helm = helm-pkg.defaultPackage.${system};
      cloudflared = cloudflared-pkg.defaultPackage.${system};
      argo = argo-pkg.defaultPackage.${system};
      argocd = argocd-pkg.defaultPackage.${system};
      hof = hof-pkg.defaultPackage.${system};
      tilt = tilt-pkg.defaultPackage.${system};
      goreleaser = goreleaser-pkg.defaultPackage.${system};
      teller = teller-pkg.defaultPackage.${system};
      protoc = protoc-pkg.defaultPackage.${system};
      buf = buf-pkg.defaultPackage.${system};
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
          kubectl
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
