{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    aws-signing-helper-pkg.url = "path:/home/ubuntu/nix/aws-signing-helper";
    flyctl-pkg.url = "path:/home/ubuntu/nix/flyctl";
    vcluster-pkg.url = "path:/home/ubuntu/nix/vcluster";
    gh-pkg.url = "path:/home/ubuntu/nix/gh";
    earthly-pkg.url = "path:/home/ubuntu/nix/earthly";
    cue-pkg.url = "path:/home/ubuntu/nix/cue";
    step-pkg.url = "path:/home/ubuntu/nix/step";
    kuma-pkg.url = "path:/home/ubuntu/nix/kuma";
    switch-pkg.url = "path:/home/ubuntu/nix/switch";
    k3d-pkg.url = "path:/home/ubuntu/nix/k3d";
    caddy-pkg.url = "path:/home/ubuntu/nix/caddy";
    temporalite-pkg.url = "path:/home/ubuntu/nix/temporalite";
    kubebuilder-pkg.url = "path:/home/ubuntu/nix/kubebuilder";
    steampipe-pkg.url = "path:/home/ubuntu/nix/steampipe";
    kustomize-pkg.url = "path:/home/ubuntu/nix/kustomize";
    kubectl-pkg.url = "path:/home/ubuntu/nix/kubectl";
    stern-pkg.url = "path:/home/ubuntu/nix/stern";
    helm-pkg.url = "path:/home/ubuntu/nix/helm";
    cloudflared-pkg.url = "path:/home/ubuntu/nix/cloudflared";
    argo-pkg.url = "path:/home/ubuntu/nix/argo";
    argocd-pkg.url = "path:/home/ubuntu/nix/argocd";
    hof-pkg.url = "path:/home/ubuntu/nix/hof";
    tilt-pkg.url = "path:/home/ubuntu/nix/tilt";
    goreleaser-pkg.url = "path:/home/ubuntu/nix/goreleaser";
    teller-pkg.url = "path:/home/ubuntu/nix/teller";
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
    , stern-pkg
    , helm-pkg
    , cloudflared-pkg
    , argo-pkg
    , argocd-pkg
    , hof-pkg
    , tilt-pkg
    , goreleaser-pkg
    , teller-pkg
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
      stern = stern-pkg.defaultPackage.${system};
      helm = helm-pkg.defaultPackage.${system};
      cloudflared = cloudflared-pkg.defaultPackage.${system};
      argo = argo-pkg.defaultPackage.${system};
      argocd = argocd-pkg.defaultPackage.${system};
      hof = hof-pkg.defaultPackage.${system};
      tilt = tilt-pkg.defaultPackage.${system};
      goreleaser = goreleaser-pkg.defaultPackage.${system};
      teller = teller-pkg.defaultPackage.${system};
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
          stern
          helm
          cloudflared
          argo
          argocd
          hof
          tilt
          goreleaser
          teller
        ];
      };
    }
    );
}
