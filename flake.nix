{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    aws-signing-helper-pkg.url = "github:defn/pkg?dir=aws-signing-helper";
    flyctl-pkg.url = "github:defn/pkg?dir=flyctl";
    vcluster-pkg.url = "github:defn/pkg?dir=vcluster";
    gh-pkg.url = "github:defn/pkg?dir=gh";
    earthly-pkg.url = "github:defn/pkg?dir=earthly";
    cue-pkg.url = "github:defn/pkg?dir=cue";
    step-pkg.url = "github:defn/pkg?dir=step";
    kuma-pkg.url = "github:defn/pkg?dir=kuma";
    switch-pkg.url = "github:defn/pkg?dir=switch";
    k3d-pkg.url = "github:defn/pkg?dir=k3d";
    caddy-pkg.url = "github:defn/pkg?dir=caddy";
    temporalite-pkg.url = "github:defn/pkg?dir=temporalite";
    kubebuilder-pkg.url = "github:defn/pkg?dir=kubebuilder";
    steampipe-pkg.url = "github:defn/pkg?dir=steampipe";
    kustomize-pkg.url = "github:defn/pkg?dir=kustomize";
    kubectl-pkg.url = "github:defn/pkg?dir=kubectl";
    stern-pkg.url = "github:defn/pkg?dir=stern";
    helm-pkg.url = "github:defn/pkg?dir=helm";
    cloudflared-pkg.url = "github:defn/pkg?dir=cloudflared";
    argo-pkg.url = "github:defn/pkg?dir=argo";
    argocd-pkg.url = "github:defn/pkg?dir=argocd";
    hof-pkg.url = "github:defn/pkg?dir=hof";
    tilt-pkg.url = "github:defn/pkg?dir=tilt";
    goreleaser-pkg.url = "github:defn/pkg?dir=goreleaser";
    teller-pkg.url = "github:defn/pkg?dir=teller";
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
    });
}
