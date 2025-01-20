# Changelog

## [1.3.0](https://github.com/defn/dev/compare/v1.2.3...v1.3.0) (2025-01-20)


### Features

* awscli/ 2.23.0 -&gt; 2.23.1 [skip ci] ([5fbef8f](https://github.com/defn/dev/commit/5fbef8f24ad441936805ac08833b3c8661ced278))
* awscli/ 2.23.1 -&gt; 2.23.2 [skip ci] ([11c92a8](https://github.com/defn/dev/commit/11c92a8798ece3b8a214d21586798bc52c5e199d))
* buf/ 1.49.0 -&gt; 1.50.0 [skip ci] ([33a4205](https://github.com/defn/dev/commit/33a4205b552047aebd0210b8efa59b094a2de893))
* ctrl-shift-l to open tutorial ([2fc5d7c](https://github.com/defn/dev/commit/2fc5d7c1a4ab68066d2db08bbe3c18d4176b90e5))
* docker registry clenaup targets ([7161047](https://github.com/defn/dev/commit/716104793b26b3aa20c68322ae61fef63a34b5ed))
* enable docker registry deletion ([767db2b](https://github.com/defn/dev/commit/767db2be684fcaf4302bddbf67d5a9566c21581d))
* k3d/ 5.7.5 -&gt; 5.8.1 [skip ci] ([87b8049](https://github.com/defn/dev/commit/87b80495f816dae770da09b4e1c33b97953c74cb))
* kubelogin/ 1.31.1 -&gt; 1.32.0 [skip ci] ([6191e6c](https://github.com/defn/dev/commit/6191e6c9b2fce9f3f95155363d300435f8fbc3d2))
* kubeseal/ 0.27.3 -&gt; 0.28.0 [skip ci] ([e1d0f0a](https://github.com/defn/dev/commit/e1d0f0acbc71bf7c880d1560e2dd7acd71bac1d9))
* linkerd/ 24.11.8 -&gt; 25.1.1 [skip ci] ([46140f1](https://github.com/defn/dev/commit/46140f1609fa9830c44516edb0da69ae08cf969b))
* make base-nc to build base from scratch ([fd049ae](https://github.com/defn/dev/commit/fd049ae4d57f5f32a44ac1b39c297879c8e4ef73))
* mise/ 2025.1.7 -&gt; 2025.1.8 [skip ci] ([9d43a2c](https://github.com/defn/dev/commit/9d43a2c617791ef01797e347afea3d6461455e5a))
* mise/ 2025.1.8 -&gt; 2025.1.9 [skip ci] ([72c789f](https://github.com/defn/dev/commit/72c789f0631723347ac8336437146e3ba459497f))
* mount .config/gh to cache github logins ([c77ddf9](https://github.com/defn/dev/commit/c77ddf90e08856f4da1dd49928ca6586a0ebd6ab))
* read dev server port from app_port ([bb0ab41](https://github.com/defn/dev/commit/bb0ab410313d5c095b972f7f3d226968484ae976))
* serve gallery with registry ([02d6b0a](https://github.com/defn/dev/commit/02d6b0a86daf8239af2ae6c0d4b40e5cf76df52e))
* startup scripts for coder agent, code-server sidecars ([9118f04](https://github.com/defn/dev/commit/9118f043e0f61d18c50432b016e7ff4c3d77ba13))
* use mise for a bunch of tools instead of flakes ([3a9319b](https://github.com/defn/dev/commit/3a9319bd91e4425ddc484b6529de76698d23bdae))
* use mise for more tools instead of flakes ([789e52b](https://github.com/defn/dev/commit/789e52b8e0a3355792d74bc65471d4c0b84311c7))
* vcluster/ 0.22.1 -&gt; 0.22.3 [skip ci] ([b15f344](https://github.com/defn/dev/commit/b15f3440365a8c27fc25d99792b037ead1ccb19d))


### Bug Fixes

* add nix, nixpkgs-fmt to shell ([0b11f20](https://github.com/defn/dev/commit/0b11f20bf9e2017f7f300b80c3c7cc88645e6ff8))
* all websites can load joyride tutorials ([73fa17c](https://github.com/defn/dev/commit/73fa17c686a3bab34810eab662850d8f774ff0cf))
* always set git ssh command under coder ([9cfd71d](https://github.com/defn/dev/commit/9cfd71ddef3b5b7261d8081ddb8042dacce1c36c))
* code-server needs coder agent config for git ssh ([e36062a](https://github.com/defn/dev/commit/e36062a957489d0b6636a1685f1ab43c29b2e0ab))
* code-server sidecar gets coder url for proxy rewrite ([f3dd91f](https://github.com/defn/dev/commit/f3dd91f2d4bfa274473914d1becf067f3d2f3a88))
* dont manage bazelisk with nix/bazel ([499fc7f](https://github.com/defn/dev/commit/499fc7faab36557715f1497f7a35ea33d833bd95))
* dont show ports message in vscode ([19bb8d2](https://github.com/defn/dev/commit/19bb8d2708d5225d4b1f7a0f7ccdb23d4a3a9567))
* dont use nix profile ([c5b41df](https://github.com/defn/dev/commit/c5b41dfa8540cd1a895983873ecff5c73a3d07b5))
* flake updates use conventional commits [skip ci] ([b81e9af](https://github.com/defn/dev/commit/b81e9aff6f4ac81609f4bacb76a5d73e521e01d2))
* iframe the external, proxied url ([1dd1263](https://github.com/defn/dev/commit/1dd1263dc8457fc26eb7ffdd89d0aaeba98fff1a))
* in ci, dont mess with git ssh command ([d6f7d95](https://github.com/defn/dev/commit/d6f7d95567264c4f6d7d16be2479d376aa33ca7c))
* make nix bootstraps mise, bazelisk, bazel ([780a199](https://github.com/defn/dev/commit/780a1997b40d37af9ff22685f47dc09436ca1934))
* minimal bazel build for website changes ([71a3a77](https://github.com/defn/dev/commit/71a3a77ce325e1eb09c0182abe225b26e4816ff5))
* only mount code-server extensions ([7fb2f66](https://github.com/defn/dev/commit/7fb2f667a189bddd43bda8827df623185c43170c))
* open calls browser.sh in PATH ([ece63bf](https://github.com/defn/dev/commit/ece63bf1b8a351c690d4c2022029aa2d0f144786))
* pin versions of mise tools ([14a47d4](https://github.com/defn/dev/commit/14a47d4788112ad3f130bb803826989c87d0d33a))
* remove coder-amanibhavam-district ([e30b85c](https://github.com/defn/dev/commit/e30b85ccbcf59a7d52f8a952c7c4a67580772121))
* set GITHUB_TOKEN to increase api limits ([794ebfe](https://github.com/defn/dev/commit/794ebfedeeb09852f33632947f6b7e0d6b0c5e8f))
* switch code-server back to nix ([7f4b59c](https://github.com/defn/dev/commit/7f4b59c7ebb8527c5a271f0f6d527730e89f2fbd))
* tofu github.com ssh host key ([cfc9f6a](https://github.com/defn/dev/commit/cfc9f6a89699278add637fca414cbbd0dfadc744))
* tolerate disk pressure for now ([5c2262f](https://github.com/defn/dev/commit/5c2262fb56bd3b8dacffb4b41c69bdc47cd9ede3))
* use .env for GITHUB_TOKEN, bk secrets not working ([b3a82ca](https://github.com/defn/dev/commit/b3a82ca604bd2ad0052a9cf7c862580750aa9576))
* use aqua nushell instead of ubi, which doesnt work ([2c27707](https://github.com/defn/dev/commit/2c277079d7db552d5fc49419bd296da46b6d6c5f))
* use bazelisk via mise ([2ad2240](https://github.com/defn/dev/commit/2ad2240ed1944b83672feafb1b7f9ea5ff0c3f2d))
* wrong place for the toleration ([44c8381](https://github.com/defn/dev/commit/44c838175b2641876acdc840fc0747955cba1f0f))
* zen mode is once shift-ctrl-z ([250f59c](https://github.com/defn/dev/commit/250f59c748cd31c5273eae67ed03179d9e50df09))
* zen mode is shift-ctrl-z twice ([9e55fbc](https://github.com/defn/dev/commit/9e55fbc888e4eb57167ff7f69091cf7e31313b10))

## [1.2.3](https://github.com/defn/dev/compare/v1.1.5...v1.2.3) (2025-01-16)


### Bug Fixes

* wrote some more stuff ([b145d3b](https://github.com/defn/dev/commit/b145d3b659f74b0bfd187a29af1d49b008a80031))


### Miscellaneous Chores

* release 1.2.3 ([b3cac68](https://github.com/defn/dev/commit/b3cac68d8e1a595af63f5cb5cda7ffc0cba2e2e0))

## [1.1.5](https://github.com/defn/dev/compare/v1.1.4...v1.1.5) (2025-01-16)


### Bug Fixes

* upload amanibhav.am static site ([5c5c481](https://github.com/defn/dev/commit/5c5c481a611bc1d61771652c9aa071c1930c33f2))

## [1.1.4](https://github.com/defn/dev/compare/v1.1.3...v1.1.4) (2025-01-16)


### Bug Fixes

* get the release tag ([23ee1bd](https://github.com/defn/dev/commit/23ee1bd863459b3bb00a3b49c5db32f64f7dc6cd))

## [1.1.3](https://github.com/defn/dev/compare/v1.1.2...v1.1.3) (2025-01-16)


### Bug Fixes

* chain release uploads on release created ([81919cd](https://github.com/defn/dev/commit/81919cd51dd7df9a1561faabfb6bbb837156aac1))
* limit permissions for release-please workflow ([3bd9265](https://github.com/defn/dev/commit/3bd9265be8812fe45897331bfd2347b622ff9391))

## [1.1.2](https://github.com/defn/dev/compare/v1.1.1...v1.1.2) (2025-01-16)


### Bug Fixes

* dont use comfyui git submodule ([c8682c9](https://github.com/defn/dev/commit/c8682c957ff6e26e7ad2b60ea9a797bfb850346d))
* release works on any change in main ([dce51a2](https://github.com/defn/dev/commit/dce51a25379b18fc6714055fa05503f1c422ccaf))

## [1.1.1](https://github.com/defn/dev/compare/v1.1.0...v1.1.1) (2025-01-16)


### Bug Fixes

* accumulating more changes ([adc5530](https://github.com/defn/dev/commit/adc553037d1bda0d5e9c1c61d9034fd9300b9948))
* bump ([25dfdf2](https://github.com/defn/dev/commit/25dfdf2d7f43ff685a810a47a2eb3e908a90108c))
* bump bump bump ([761f625](https://github.com/defn/dev/commit/761f625e007aae005e24431d1c4be10b926a78ca))
* fee fii foo fuum ([d870f68](https://github.com/defn/dev/commit/d870f680f2e9e4503fd733c38736196d57ba85a7))
* use a pat ([9813e81](https://github.com/defn/dev/commit/9813e81bd42f63c9de926acf710fc6102c69d7e5))

## [1.1.0](https://github.com/defn/dev/compare/v1.0.2...v1.1.0) (2025-01-16)


### Features

* configure manifest and configuration for updating version.txt ([#29](https://github.com/defn/dev/issues/29)) ([45caa69](https://github.com/defn/dev/commit/45caa697c6e55b48d5132d873a77f0f2cb06d289))
* minimum release-please workflow ([#26](https://github.com/defn/dev/issues/26)) ([d0b233b](https://github.com/defn/dev/commit/d0b233b63605edf01dbd507881c68913a38f7abd))


### Bug Fixes

* bump ([4ee0181](https://github.com/defn/dev/commit/4ee0181d647254e3cecaca6410a174e4d1ee70b7))
* bump ([11b6453](https://github.com/defn/dev/commit/11b64533733f54a52378f43ab4c3412d365aa801))
* bup ([2c34973](https://github.com/defn/dev/commit/2c34973eef060f7ddee222e75626be9c21a6c137))
* release type is simple, configure extra-files ([#30](https://github.com/defn/dev/issues/30)) ([2960261](https://github.com/defn/dev/commit/2960261623418ee82d5a8bd33b9839f39fdaac60))
* remove gha outputs ([ac762db](https://github.com/defn/dev/commit/ac762db74ac375b9696708bdb89a0c9128c7bbad))
* try a simpler template for version ([#33](https://github.com/defn/dev/issues/33)) ([627bd95](https://github.com/defn/dev/commit/627bd952320a94239f4dc7ba8b7773094acf0577))
* upload a release ([e8dea01](https://github.com/defn/dev/commit/e8dea01c07bdd116d83c19be284758529e2d912b))

## [1.0.2](https://github.com/defn/dev/compare/1.0.1...v1.0.2) (2025-01-16)


### Bug Fixes

* bump ([4ee0181](https://github.com/defn/dev/commit/4ee0181d647254e3cecaca6410a174e4d1ee70b7))
* bump ([11b6453](https://github.com/defn/dev/commit/11b64533733f54a52378f43ab4c3412d365aa801))
* remove gha outputs ([ac762db](https://github.com/defn/dev/commit/ac762db74ac375b9696708bdb89a0c9128c7bbad))
* upload a release ([e8dea01](https://github.com/defn/dev/commit/e8dea01c07bdd116d83c19be284758529e2d912b))

## [1.0.1](https://github.com/defn/dev/compare/1.0.0...v1.0.1) (2025-01-16)


### Bug Fixes

* try a simpler template for version ([#33](https://github.com/defn/dev/issues/33)) ([627bd95](https://github.com/defn/dev/commit/627bd952320a94239f4dc7ba8b7773094acf0577))

## [1.1.0](https://github.com/defn/dev/compare/v1.0.0...v1.1.0) (2025-01-16)


### Features

* configure manifest and configuration for updating version.txt ([#29](https://github.com/defn/dev/issues/29)) ([45caa69](https://github.com/defn/dev/commit/45caa697c6e55b48d5132d873a77f0f2cb06d289))
* minimum release-please workflow ([#26](https://github.com/defn/dev/issues/26)) ([d0b233b](https://github.com/defn/dev/commit/d0b233b63605edf01dbd507881c68913a38f7abd))


### Bug Fixes

* release type is simple, configure extra-files ([#30](https://github.com/defn/dev/issues/30)) ([2960261](https://github.com/defn/dev/commit/2960261623418ee82d5a8bd33b9839f39fdaac60))

## 1.0.0 (2025-01-16)


### Features

* minimum release-please workflow ([#26](https://github.com/defn/dev/issues/26)) ([d0b233b](https://github.com/defn/dev/commit/d0b233b63605edf01dbd507881c68913a38f7abd))
