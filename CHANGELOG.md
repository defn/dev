# Changelog

## [1.13.0](https://github.com/defn/dev/compare/v1.12.1...v1.13.0) (2025-03-23)


### Features

* switch to ghcr.io registry ([9cf0e6b](https://github.com/defn/dev/commit/9cf0e6bb31a9e3d88fda3eafd46d1fc2bf142590))


### Bug Fixes

* rename quay org to defnnn ([700808d](https://github.com/defn/dev/commit/700808dcc5940c203a25ed9d6de09f4ec3556fe3))

## [1.12.1](https://github.com/defn/dev/compare/v1.12.0...v1.12.1) (2025-03-23)


### Bug Fixes

* git fetch to retrieve latest release tags ([accb133](https://github.com/defn/dev/commit/accb133cb0827bf9070370f79a2c719778e9115e))
* just whitespace ([ccc1ad8](https://github.com/defn/dev/commit/ccc1ad80f216b659266e0eae78a0b2283e2662ba))

## [1.12.0](https://github.com/defn/dev/compare/v1.11.0...v1.12.0) (2025-03-23)


### Features

* coder-server env example documents github teams ([#135](https://github.com/defn/dev/issues/135)) ([1fcf96c](https://github.com/defn/dev/commit/1fcf96c96869b6f71faea8f88828118bac6001db))
* install bat ([#133](https://github.com/defn/dev/issues/133)) ([beff1f1](https://github.com/defn/dev/commit/beff1f1b5e9796bbbbcc1a5113470188d74da6fb))
* install chamber cli ([#128](https://github.com/defn/dev/issues/128)) ([2d78da0](https://github.com/defn/dev/commit/2d78da0c145c446ecfce335f13b021fb5ccfb4cf))
* m adhoc task to create an issue and work on it ([#145](https://github.com/defn/dev/issues/145)) ([3a9914b](https://github.com/defn/dev/commit/3a9914b304948b48ce42c7dae9104f87dac87964))
* m pr task to create a pull-request ([#125](https://github.com/defn/dev/issues/125)) ([cc2715b](https://github.com/defn/dev/commit/cc2715b727c754ba370d3fd9423fe8c8ab84036b))
* m work task to work on an issue ([#123](https://github.com/defn/dev/issues/123)) ([522e8bb](https://github.com/defn/dev/commit/522e8bbb8cc3252c9dc2c82393196756dd9fc12c))
* m work will sync main first before creating branch ([eae263b](https://github.com/defn/dev/commit/eae263b888704e383fe278ffcb4c68046ed23926))
* run fixup at the end of sync ([831c3a5](https://github.com/defn/dev/commit/831c3a5f23b008a0ca79e70c05655b0bf3e47a88))
* tagged release images ([#156](https://github.com/defn/dev/issues/156)) ([81dd7c8](https://github.com/defn/dev/commit/81dd7c8bd814a7aad9c82795292e0c7edbb95494))
* upgrade mise managed tools ([#124](https://github.com/defn/dev/issues/124)) ([0006706](https://github.com/defn/dev/commit/00067069f6977d9d5d36cf5b125cad774e42ac9c))


### Bug Fixes

* always git pull during docker build ([1f5bb33](https://github.com/defn/dev/commit/1f5bb3374dd05bde5855033f36d78fefc551098e))
* check if docker socket exists ([6d643cf](https://github.com/defn/dev/commit/6d643cffac86e762fd3f7e32ed122bee06f734c0))
* comment out GSSAPIAuthentication in ssh client config ([#129](https://github.com/defn/dev/issues/129)) ([bc7b329](https://github.com/defn/dev/commit/bc7b3292eb6c749b2c96edb063ada2942e505780))
* docker socket accessible by ubuntu user ([#134](https://github.com/defn/dev/issues/134)) ([e9ca154](https://github.com/defn/dev/commit/e9ca154cc71665ea3f13060a5fc8b98498ac1b2c))
* hide cloudflare tunnel token from command line ([#137](https://github.com/defn/dev/issues/137)) ([1c9b40e](https://github.com/defn/dev/commit/1c9b40e9a1dea410eb0b49fa2c7b1c46fc68a792))
* install mise if missing ([#147](https://github.com/defn/dev/issues/147)) ([5c4d8bc](https://github.com/defn/dev/commit/5c4d8bcb24169e82d07082921bbbc1e857c67397))
* mount /dev/net/tun for tailscale in m/dc ([#136](https://github.com/defn/dev/issues/136)) ([daf2a6e](https://github.com/defn/dev/commit/daf2a6e45b8f8b2a12d94dca5daeae00148c1802))
* only fix ping if it exists ([ea76bf1](https://github.com/defn/dev/commit/ea76bf1c045b41be29f8babcde968462e223aa60))
* ping capabilities so it can work ([#130](https://github.com/defn/dev/issues/130)) ([5e8f971](https://github.com/defn/dev/commit/5e8f971da61a964858f5cbefa1676fddfa3e71fe))
* remove acme.sh certs, dont provide any ([#126](https://github.com/defn/dev/issues/126)) ([ea65fea](https://github.com/defn/dev/commit/ea65feaf858b3adbfca016fd9cc98246336d4cf6))
* remove docker pass, secretservice credential providers ([#131](https://github.com/defn/dev/issues/131)) ([b756efd](https://github.com/defn/dev/commit/b756efd9ab2d2df13e097162f70aca0eb886db0d))
* tailscale service sleeps forever without /dev/net/tun ([4b82b43](https://github.com/defn/dev/commit/4b82b43f59030f6716e0bfd6107f4c6d812349b0))
* use updated base image at quay.io ([#150](https://github.com/defn/dev/issues/150)) ([b80898f](https://github.com/defn/dev/commit/b80898fff25ff10dca5db4a6693b652126fb5aa1))
* warn if locked-down mode is enabled ([#127](https://github.com/defn/dev/issues/127)) ([fb1eea4](https://github.com/defn/dev/commit/fb1eea45731051b3e2675f5a98d6ded9322049d5))
* wrong path to ping ([15dc9d9](https://github.com/defn/dev/commit/15dc9d90a94fa1f85c9094f61012b9889d4c3a25))

## [1.11.0](https://github.com/defn/dev/compare/v1.10.0...v1.11.0) (2025-03-21)


### Features

* base docker image will update to the latest HEAD ([5349b73](https://github.com/defn/dev/commit/5349b73b21ad88491cfb2b4949e943ad2f5860fc))
* create coder server doc and install dependencies in coder tunnel ([#112](https://github.com/defn/dev/issues/112)) ([d2e55e6](https://github.com/defn/dev/commit/d2e55e6ad0bc13b91d02cca30223f8045de32d07)), closes [#106](https://github.com/defn/dev/issues/106)
* docker workspaces ([#119](https://github.com/defn/dev/issues/119)) ([4e7d25d](https://github.com/defn/dev/commit/4e7d25dc84a224d7119e99044ea667a5b519e18d))


### Bug Fixes

* /usr/local/bin/nix chown with correct username ([cbd0d07](https://github.com/defn/dev/commit/cbd0d07c7bcdaecc17ed813280bd049cb3d2f751))
* always build latest without cache ([36e152b](https://github.com/defn/dev/commit/36e152bbef7519ddab46a7f76e53a21ac24b0bf3))
* base image syncs in latest build ([46c789b](https://github.com/defn/dev/commit/46c789baa0a99b60ba35c691e784b3c4da348a0a))
* bin/t working again for honeycomb traces ([#115](https://github.com/defn/dev/issues/115)) ([2bfe475](https://github.com/defn/dev/commit/2bfe4756c11a106c0f07ce7616876b2d89cc46a4))
* bin/t works without buildevents or api token ([34f0892](https://github.com/defn/dev/commit/34f0892eb488ee5821866ba69aae87e98e417b99))
* coreutils on macos, was missing tac ([e13d8ff](https://github.com/defn/dev/commit/e13d8ff909166ebe8c69830975a4f934a03d04b8))
* move nix garbage collection to rehome ([#117](https://github.com/defn/dev/issues/117)) ([59b2d5e](https://github.com/defn/dev/commit/59b2d5e1b8ef010e48a1ba1f911da0b016d363fe))

## [1.10.0](https://github.com/defn/dev/compare/v1.9.0...v1.10.0) (2025-03-16)


### Features

* coder server default github with allowed teams ([#102](https://github.com/defn/dev/issues/102)) ([6611ec0](https://github.com/defn/dev/commit/6611ec0636e86875e6b16c209638bd792334eab7))
* coder server running under s6 ([#97](https://github.com/defn/dev/issues/97)) ([9bd1ddd](https://github.com/defn/dev/commit/9bd1ddd37cd6213a571513a840dd8110ae9b1d3e))
* helm/ 3.17.1 -&gt; 3.17.2 [skip ci] ([72e60d8](https://github.com/defn/dev/commit/72e60d8aa2ddd89f52986c2c8d95c996c8913dc4))


### Bug Fixes

* remove redundant oci flake, unused docker credential helpers ([#101](https://github.com/defn/dev/issues/101)) ([b2edf81](https://github.com/defn/dev/commit/b2edf81027073d629a870b1f2c2f890383847d63))

## [1.9.0](https://github.com/defn/dev/compare/v1.8.0...v1.9.0) (2025-03-15)


### Features

* install tailscale in docker image builds ([#84](https://github.com/defn/dev/issues/84)) ([f9a8ee2](https://github.com/defn/dev/commit/f9a8ee21d90794cde88525b1f1463889157fa582))
* run tailscaled in docker image ([#88](https://github.com/defn/dev/issues/88)) ([59b1af7](https://github.com/defn/dev/commit/59b1af76cb955f68525062a512ebaf1838df5212)), closes [#86](https://github.com/defn/dev/issues/86)
* simple make up dev environment ([#89](https://github.com/defn/dev/issues/89)) ([8b91e24](https://github.com/defn/dev/commit/8b91e240b5497858b4f1338c553b9c17a5521552)), closes [#85](https://github.com/defn/dev/issues/85)


### Bug Fixes

* install minimal docker config if missing ([#81](https://github.com/defn/dev/issues/81)) ([03b95bc](https://github.com/defn/dev/commit/03b95bcea0fe44028ca8684ddeb3f3ad5e1248ea)), closes [#65](https://github.com/defn/dev/issues/65)
* install pass to base images ([#79](https://github.com/defn/dev/issues/79)) ([d6d201c](https://github.com/defn/dev/commit/d6d201cb6a281cca7eb2f207c6ae030a3b9d085f)), closes [#78](https://github.com/defn/dev/issues/78)
* remove docker pass credential store config ([#87](https://github.com/defn/dev/issues/87)) ([8ce9e4c](https://github.com/defn/dev/commit/8ce9e4cc2bade65e506f6beb71a368d629d3f5eb)), closes [#83](https://github.com/defn/dev/issues/83)
* remove make nix from make sync ([#91](https://github.com/defn/dev/issues/91)) ([5354373](https://github.com/defn/dev/commit/535437379f028f630083e9b49196d403c5140c10)), closes [#90](https://github.com/defn/dev/issues/90)
* wrapper kubectl-oidc_login for kubelogin ([#82](https://github.com/defn/dev/issues/82)) ([ee2b2d2](https://github.com/defn/dev/commit/ee2b2d2e3ff71420c92f51b2923249af76ef40d9))

## [1.8.0](https://github.com/defn/dev/compare/v1.7.0...v1.8.0) (2025-03-14)


### Features

* ansible, pipx via mise ([dc4be1e](https://github.com/defn/dev/commit/dc4be1e94ea86fb53b4aa73551b42d11459998f1))
* base flake is gc ([6f04db7](https://github.com/defn/dev/commit/6f04db7baef21f8cc057005ee3348867dd9d21a8))
* build defn/dev with a tag when theres an exact match ([b5a4831](https://github.com/defn/dev/commit/b5a4831bf0bbf194060e0220bc19d2f58ff6c9a2))
* example gleam project ([3ea6427](https://github.com/defn/dev/commit/3ea64279a50545cf527d6c600586b720c094d322))
* focal-20250127 in docker image ([d316718](https://github.com/defn/dev/commit/d31671899b9a20611c20407904a99b5b5c5062ea))
* mise upgrade: aws, helm, wrangler ([eb6169e](https://github.com/defn/dev/commit/eb6169e5cf5b02c9686a52f30e0205da746993e5))


### Bug Fixes

* add mbpro back to inventory ([a5fb99e](https://github.com/defn/dev/commit/a5fb99ef59ecf86332f6e392198515493b89a0cf))
* ansible in global ([aadf6f6](https://github.com/defn/dev/commit/aadf6f68c7ddc1d89f90eae1329c310b048b7f82))
* clear stats at the end of make home ([19ce2c9](https://github.com/defn/dev/commit/19ce2c9831f4e7b558aa8ad17028972d9d9d389a))
* clh can deflare mem balloon, provide net config for ens2 ([ee6bec3](https://github.com/defn/dev/commit/ee6bec301c64ffb6a56a98a3a54776c74670b4ab))
* less noise by skipping formatting ansible playbooks ([69196e8](https://github.com/defn/dev/commit/69196e860742de09420e9da762e104dd2d42c462))
* make rehome cleans nix correctly ([035b0b2](https://github.com/defn/dev/commit/035b0b2faff43a7d0fddb5473829df559faf565e))
* no memory balloon, more cpu, makes nix happy ([6a7a669](https://github.com/defn/dev/commit/6a7a669a0e645cf67745f2cf3e1ce8a64fe702b6))
* no nix in container, doesnt work well ([c246577](https://github.com/defn/dev/commit/c246577cc5d7c21530849ff4ce882f736d336d51))
* remove all nix dirs in home ([3bc79e8](https://github.com/defn/dev/commit/3bc79e8a5a22b6021b32a769714acf2a9ec0afe3))
* remove bazel builds from home install ([ab86041](https://github.com/defn/dev/commit/ab860416856e63e7179963e92187167e73d9c1a6))
* remove hosts that arent up or are slow from default ansible targets ([b4791e1](https://github.com/defn/dev/commit/b4791e16c7d1427c1b4123fff0bd83d3a4c99e06))
* remove rpi5c as cache server, too slow ([353a70c](https://github.com/defn/dev/commit/353a70cbc45c0256c811a904f7aef6d0025fb92a))
* remove semaphore, not ready to use it ([6c2474b](https://github.com/defn/dev/commit/6c2474b6ecc5f54c27b0b76002315f6749eaf6ff))
* sync various install scripts ([8989de2](https://github.com/defn/dev/commit/8989de21ecf10c930a341456eb359ca24f966ac9))
* update home repo after any docker change ([3a5f50b](https://github.com/defn/dev/commit/3a5f50b88df4e21b691cbcec85d13bf2bc810dab))
* use pipx ([c138770](https://github.com/defn/dev/commit/c138770861b2bb805c13fcaba920d079766dc5a1))

## [1.7.0](https://github.com/defn/dev/compare/v1.6.0...v1.7.0) (2025-03-09)


### Features

* cpu-checker to detect virtualization ([ad153b3](https://github.com/defn/dev/commit/ad153b37066824853a6797c43744ee6759b860c9))
* dev container restarts always ([c2e728f](https://github.com/defn/dev/commit/c2e728f4cf0d70c4d15cef95fd9c760a8261a3d6))
* docker-compose dev env with kvm privileges ([67ff1b2](https://github.com/defn/dev/commit/67ff1b23980d34a089d91942c329e9a4c54d9bf9))
* example docker config for containers ([cad47cf](https://github.com/defn/dev/commit/cad47cf03a5bf2890b64ed47e8d074589321aecd))
* home uses base flake via direnv ([561b588](https://github.com/defn/dev/commit/561b588584ce3586b648ecda3e6c5dfd5980fd73))
* move nix bin outside of home to /usr/local/bin/nix ([b82b261](https://github.com/defn/dev/commit/b82b261d2807cec11905e635958d55b42f191434))
* removed base flake from bazel, provide alternative bin/nix generation ([2c7854f](https://github.com/defn/dev/commit/2c7854f7879ffb1037337959658d4fa61ed2bbf1))
* simpler base with separated os, nix, mise ([3e94b66](https://github.com/defn/dev/commit/3e94b6674e7f3c541d53e41b14d85a250d3da786))
* smaller base nix flake ([c88807a](https://github.com/defn/dev/commit/c88807abe4b373a912fe42767bf2258df65c794a))
* starting to split  m/dc into separate docker containers for the fam ([89aaf56](https://github.com/defn/dev/commit/89aaf560dcb0cf8764a95a22443d7012e4bb1869))
* tailscaled under s6 ([784b6e6](https://github.com/defn/dev/commit/784b6e6559af6370be751b12591703a451b7e151))
* try out the railway railpack build tool ([573d5ec](https://github.com/defn/dev/commit/573d5ec338ddfba9ab0ce136aaf8d06ecc572464))
* wrangler as a standalone tool ([a99c211](https://github.com/defn/dev/commit/a99c211cfb9976909ecebc8253dd3da1c86958e8))


### Bug Fixes

* browser (open) works with mise code-server ([5a04935](https://github.com/defn/dev/commit/5a049354017b74a602a0acde80f05271b39ed05e))
* cloud hypervisor working on chromebook linux dev env ([40a2dbf](https://github.com/defn/dev/commit/40a2dbf766d80287295adaad4802129d6006f88a))
* coder uses a specific .env.coder for secrets ([a29d349](https://github.com/defn/dev/commit/a29d349c01456affbb4cfd0e1086d46210c5ec62))
* coder, code-server sourcing config corrrectly ([c184685](https://github.com/defn/dev/commit/c184685f539b9faacd6a7c85503d866473cab8a4))
* detach s6 in m serve ([61f41c7](https://github.com/defn/dev/commit/61f41c710f6bf0f20b87f99a2cfcf6e6371b3ca4))
* dont activate main s6 service ([fa8f2de](https://github.com/defn/dev/commit/fa8f2de9a766d539d8e0884459bb466bd893a86d))
* dont build attic in bazel, too long ([4567f39](https://github.com/defn/dev/commit/4567f39f1d9e1a7cf3741dd27cef512e39eccd61))
* dont hardcode gh to bin/nix ([73be4ca](https://github.com/defn/dev/commit/73be4cac3546413fc0172275a3d20b8a00e55d05))
* dont install twice ([1bef289](https://github.com/defn/dev/commit/1bef2890093b46ec30f4935ad2e00ae3411ab612))
* dont need m/.envrc if home is not a direnv flake ([97f52a0](https://github.com/defn/dev/commit/97f52a06defecb5daa3f0ce23253e47aa62e51d5))
* dont set LC_ALL, nix bash hates it ([58fa5d7](https://github.com/defn/dev/commit/58fa5d7c14c3d9a9efe1d40889a6093295fddf87))
* dont use SUDO_ASKPASS ([0da8a83](https://github.com/defn/dev/commit/0da8a8308beb2cdaf45bb5c95d39ef49d89582c1))
* empty .envrc in m to reset ([039f488](https://github.com/defn/dev/commit/039f488b9bdd086e92d765b5bb2a76fde2a9cbe9))
* install tailscale when running tailscaled ([c90bb7b](https://github.com/defn/dev/commit/c90bb7b299273e446426243a07dd1fb2c0f2ab00))
* m server waits for s6 to respond ([a936179](https://github.com/defn/dev/commit/a936179f788d389fbc65ffd31ef57ff504e35ffe))
* missing svc dir in docker image ([877ae0f](https://github.com/defn/dev/commit/877ae0f6ab3857cd78aecce574468c48df5d440d))
* no more direnv in home or m ([57fe086](https://github.com/defn/dev/commit/57fe086d278c687d4108ddd3c9420ae306936933))
* no multi-tenant docker-compose ([ef43970](https://github.com/defn/dev/commit/ef43970f1ad03d0b19e6a1c5d76f7ffae70a6abf))
* prompt on macos, load mise before starship ([2660553](https://github.com/defn/dev/commit/2660553581565ab84bf2190dee6d46898d43fa80))
* provide dig, host, ping commands ([12701c3](https://github.com/defn/dev/commit/12701c33822616175673a84a388f6a7b3a74ae1d))
* remove extra bazel ignore tmp file ([7e7fb74](https://github.com/defn/dev/commit/7e7fb7449d68b44b5e41d713a8d02ff47743197f))
* sync before install to remove mise prompt ([8ddfddf](https://github.com/defn/dev/commit/8ddfddf4afe8d03e9c55c4c809c61d36bbc2cd9e))
* trust direnv and mise install in m ([346fb51](https://github.com/defn/dev/commit/346fb51e28e06f8b62ffebd585ea5aae681d745e))

## [1.6.0](https://github.com/defn/dev/compare/v1.5.0...v1.6.0) (2025-02-28)


### Features

* 10gb ebs root ([b90f4ac](https://github.com/defn/dev/commit/b90f4acce5374940ec28e452e52720ad58a519b2))
* amanibhav.am as a s6 service ([638a257](https://github.com/defn/dev/commit/638a25783034c38e359371065276824937d09b0d))
* AMI does not have defn/dev as HOME ([21a59da](https://github.com/defn/dev/commit/21a59dae181f52907be1902a0d4389a23996b0b9))
* awscli/ 2.24.0 -&gt; 2.24.1 [skip ci] ([56ee01e](https://github.com/defn/dev/commit/56ee01e3f3adab659569a2ae2714619c8b267937))
* awscli/ 2.24.1 -&gt; 2.24.4 [skip ci] ([7c4e81a](https://github.com/defn/dev/commit/7c4e81ad72c59511fed033655447de26dd3e3b81))
* awscli/ 2.24.10 -&gt; 2.24.11 [skip ci] ([a6c1283](https://github.com/defn/dev/commit/a6c12835cb46afeaaeb76583743732d5d0587a4e))
* awscli/ 2.24.4 -&gt; 2.24.5 [skip ci] ([65cf65b](https://github.com/defn/dev/commit/65cf65be328e4e23261cde05140fc06aa9b73ab2))
* awscli/ 2.24.5 -&gt; 2.24.7 [skip ci] ([3819e51](https://github.com/defn/dev/commit/3819e515a5e252c863a8e555c5a70f6c7a6f5b8c))
* awscli/ 2.24.7 -&gt; 2.24.8 [skip ci] ([88cb50c](https://github.com/defn/dev/commit/88cb50ca9890fd47863005b34f849ce458f983d3))
* awscli/ 2.24.8 -&gt; 2.24.9 [skip ci] ([c07d3d8](https://github.com/defn/dev/commit/c07d3d8bc5007c99310929f18e4db2a9d2bb34f5))
* awscli/ 2.24.9 -&gt; 2.24.10 [skip ci] ([7539906](https://github.com/defn/dev/commit/7539906bbfb5d01d138b52ccb015e7b0238dddb9))
* base AMI matches base image ([397a7fc](https://github.com/defn/dev/commit/397a7fc4e1fa99ac8266a690255cf9ec17da054f))
* base ubuntu packages in Docker and install.sh ([73b3579](https://github.com/defn/dev/commit/73b3579e56858df6db06522f7e7355e4222b22da))
* coder is a global tool ([4f2f44b](https://github.com/defn/dev/commit/4f2f44b5cee5f037c96f55337945d0c59412226a))
* codeserver/ 4.96.4 -&gt; 4.97.2 [skip ci] ([20f73c8](https://github.com/defn/dev/commit/20f73c894bb110fd2afaf3b5f8190c18a737ca18))
* docker image starts with s6 ([15b3f11](https://github.com/defn/dev/commit/15b3f11a4374caa18186c954d377141c03921608))
* docker in base ([ca3d523](https://github.com/defn/dev/commit/ca3d523e09f5aae822eb1e4b11e8ee48c8cef0d3))
* docker-compose dev env in m/dc ([f844606](https://github.com/defn/dev/commit/f84460613db0e9a73d0e71feecba4238a5fd0c0b))
* dont use flakes for scripts ([a5ad326](https://github.com/defn/dev/commit/a5ad3269b826bbcaf54ff3e0369facedbd642c83))
* enable dedup on docker zvol ([2ba72af](https://github.com/defn/dev/commit/2ba72afb6257392ae92f6b8c9ca08b040a9243ad))
* go 1.24 ([00ce352](https://github.com/defn/dev/commit/00ce3526c53dda2144f99ab2056d6b64910c602f))
* helm/ 3.17.0 -&gt; 3.17.1 [skip ci] ([8dc4877](https://github.com/defn/dev/commit/8dc487709edbb6caa371e03920875e29505c94c0))
* initial m serve to run s6 ([1bef1f0](https://github.com/defn/dev/commit/1bef1f006b217cc5b4fa5cf026a7caf17b05d185))
* initialize ec2 using a repo script ([9e48664](https://github.com/defn/dev/commit/9e48664c4f2ffd457ed48b7b87459dea0d6cdfcf))
* initialize zpools from s3 ([0616533](https://github.com/defn/dev/commit/0616533cb9389ba8e69bd22a449082f3ee6b6e9e))
* j base to build the base image ([a3aba57](https://github.com/defn/dev/commit/a3aba5793e8aad6ce32a81df636f393839b9fa93))
* k3d, kubectl in m ([f69b9d2](https://github.com/defn/dev/commit/f69b9d2185ff51d11df4efc950da24ddcea6c8ed))
* m has a proper workspace activation script ([b5710a4](https://github.com/defn/dev/commit/b5710a4b738986d4440877e283dffcf0c45c61d6))
* m/i image in terms of m base ([a039452](https://github.com/defn/dev/commit/a0394524503ae7ce3a82f2906e6c17a47429d81c))
* make mise-upgrade to bump all versions ([4cca7df](https://github.com/defn/dev/commit/4cca7dfa8d3cf3874327cc00f5de45213e564fe5))
* make reset to build everything from scratch ([c750200](https://github.com/defn/dev/commit/c750200d77a2c81f7bab1c164bca0f09912e95e1))
* marimo notebooks ([2b0636e](https://github.com/defn/dev/commit/2b0636e6da1c15330dae89b8396cf10eb9337f40))
* marimo notebooks from script ([1db8f87](https://github.com/defn/dev/commit/1db8f873e03e60bb99096bafec4b4e921673fc6a))
* mise/ 2025.2.3 -&gt; 2025.2.4 [skip ci] ([1e0b775](https://github.com/defn/dev/commit/1e0b775defe982d72b61393baddf23f55afc3e26))
* mise/ 2025.2.4 -&gt; 2025.2.6 [skip ci] ([5954e37](https://github.com/defn/dev/commit/5954e37786389671abb785d6c2715a6858b572c6))
* mise/ 2025.2.6 -&gt; 2025.2.7 [skip ci] ([128bae0](https://github.com/defn/dev/commit/128bae0709c8c191811ffc9ea45022ea4e1d8714))
* mise/ 2025.2.7 -&gt; 2025.2.8 [skip ci] ([9bbe7e2](https://github.com/defn/dev/commit/9bbe7e2cbd58f3f1c2863a53e7e95511d671e6e5))
* non-k8s sets a wildcard vscode proxy ([54bd544](https://github.com/defn/dev/commit/54bd54435f72330928f3d496f620d94ac92b183f))
* reduce root disk to 20gb, no initialization beyond zfs ([23b1439](https://github.com/defn/dev/commit/23b143955b7e253b2330475a9cced8f69b608859))
* remove all flakes except base from home install ([a1a21f6](https://github.com/defn/dev/commit/a1a21f62266fa40fbd75b6812120e51a57ede99e))
* run coder, code-server under s6 ([4b33fc4](https://github.com/defn/dev/commit/4b33fc433594b16c5d5bc5b2daefd80d1bac063c))
* run s6-svscan on vscode workspace startup ([74a2560](https://github.com/defn/dev/commit/74a2560d4d804a44574811177ea540e3717609a6))
* s6 ([f1fa5f0](https://github.com/defn/dev/commit/f1fa5f02518e0704bfea0ff9ccbc5db0bcb62122))
* s6-svscan for amanibhav.am ([593a132](https://github.com/defn/dev/commit/593a132f3167392fb03500f2a254d72ff98ba63e))
* script registering tailcale node with oauth ([7f6478d](https://github.com/defn/dev/commit/7f6478d38fb96a3713fb64d9944b7e2027112724))
* sempahoreci cli, agent ([1152797](https://github.com/defn/dev/commit/115279717532adbd0b4462274f0bcf84bfdd8d30))
* shell scripts in m/bin ([92ef533](https://github.com/defn/dev/commit/92ef5339483dd674d85e1fb8d7e408fd841281d4))
* single fn tutorial ([c2f4da5](https://github.com/defn/dev/commit/c2f4da5191f56f797d9001e3db8fcabdafd76a64))
* smaller m/i image starting with just docker ([98ccc01](https://github.com/defn/dev/commit/98ccc0166b7857182c3fc697e7781dc2c32487fe))
* spire/ 1.11.1 -&gt; 1.11.2 [skip ci] ([e42e6ec](https://github.com/defn/dev/commit/e42e6ecbe31cd81571925e257277a39985a27911))
* svc, svc.d system for s6 ([abfbcb8](https://github.com/defn/dev/commit/abfbcb8badf34161fa021d11f7cc9e76c49e7379))
* the main service is special, gets linked by default ([8f1cd93](https://github.com/defn/dev/commit/8f1cd93b0c04ed749f762ffedfdca79d6a32a7a2))
* zfs receive in parallel ([3e44c56](https://github.com/defn/dev/commit/3e44c564edb737a7de02c30b46c47babf4057e4e))


### Bug Fixes

* configure root mise.toml in /root ([9287194](https://github.com/defn/dev/commit/9287194759c4c88baa57a7804f0db39a2fbc6249))
* cue is a global tool ([413bb26](https://github.com/defn/dev/commit/413bb2653083cbe9a6a08cc887f48de59fff3795))
* default to r6id family ([2914dfe](https://github.com/defn/dev/commit/2914dfee98c9092b5fcfa2813a28b2eee4cac25d))
* disable k3d and just run code-server ([1b21bf0](https://github.com/defn/dev/commit/1b21bf0972994f79bca4bbcc1093667d01b01399))
* docker compose doesnt care for the version: field ([6d76c34](https://github.com/defn/dev/commit/6d76c34f7547359b1fe52085b4fdd9619f1049f4))
* docker group addition ([76824f0](https://github.com/defn/dev/commit/76824f00a620d7e77fecaceff6fd77907b51c7e1))
* dont cache dirs that arent flakes ([b952b2d](https://github.com/defn/dev/commit/b952b2de650f38e76e15e1b2f055624f2c3da396))
* dont instal all mise tools in sync ([afeb21c](https://github.com/defn/dev/commit/afeb21c20b0ab691bf04809a09ed7a6add376d8b))
* dont install password-store during install ([dcc74e1](https://github.com/defn/dev/commit/dcc74e19ef741eddc8b95dd0caa3bf92f1f92542))
* dont use nix bash ([4d7fe7c](https://github.com/defn/dev/commit/4d7fe7c5cfef5f815220b244d607f69ddd85c76b))
* fetch zfs snapshots serially ([89e45c7](https://github.com/defn/dev/commit/89e45c7f5651fcb0dad6ffc5a65398b0a2fa718e))
* gh in global ([39afc6b](https://github.com/defn/dev/commit/39afc6b4c96fe56eb182df1e5c08207f379153e3))
* go in m ([21bad93](https://github.com/defn/dev/commit/21bad930033e5ea1485212ff803d875c606a6911))
* helm and cue in m ([aec0ad9](https://github.com/defn/dev/commit/aec0ad98235db1838f05a69623989927fe2b769a))
* ignore aws cloud shell files ([4eee7da](https://github.com/defn/dev/commit/4eee7da8263092587e8c780081177ad4726526b9))
* initialize home repo as ubuntu ([42436b3](https://github.com/defn/dev/commit/42436b3b7b69cf513ccfbc9f23647ef425287475))
* jq in m ([2022bc3](https://github.com/defn/dev/commit/2022bc3dd5d32e00dd794368103ff10ccc1bc50e))
* jq, cue in global ([2d219c8](https://github.com/defn/dev/commit/2d219c8d106ddcf962009b48ba84f86dc6ad7b7f))
* just in global ([c281446](https://github.com/defn/dev/commit/c281446cc193d273828623a512395a0228e86e85))
* just in m ([4f5c011](https://github.com/defn/dev/commit/4f5c011d3219a9d29a6f706c392db00c4033e221))
* kustomize, python in m ([9b1b87e](https://github.com/defn/dev/commit/9b1b87e922c0fd6b41f7dfaa8c1b7edce192803c))
* let bazel run how many jobs it wants ([f757dd5](https://github.com/defn/dev/commit/f757dd5095235dc8a1277d21ec595fbb65247670))
* lower replicate parallel to 10 ([e352e74](https://github.com/defn/dev/commit/e352e744e2ef85a17a3396904913201b7288e517))
* lower replicate parallel to 20 ([8842d6a](https://github.com/defn/dev/commit/8842d6a0d1b4de52448720b2bf6ca98353eeca3a))
* m/i make base-nc rebuilds the public base image ([0476c0b](https://github.com/defn/dev/commit/0476c0b774218ee685f98458fe2fe38af56d4a6e))
* make sync twice to install deps ([7aa81b3](https://github.com/defn/dev/commit/7aa81b3aa6ca4498e39d5cc39c871583f8fc32e2))
* mise run server instead of s6-svscan directly ([5954189](https://github.com/defn/dev/commit/5954189560c9b13748644df6c79b7fe1ad20c628))
* no cache base build to pick up gcloud python deps ([5717ef8](https://github.com/defn/dev/commit/5717ef812bb9cd6fca3bbb9d4c967bc1d5f63f3c))
* no gcloud by default ([c3056f7](https://github.com/defn/dev/commit/c3056f7a639730f0c1a5bbaee19cd29fbfa3a644))
* no gcloud, weird python3 dep ([07b9a6d](https://github.com/defn/dev/commit/07b9a6db547192af4970b9caef97a6db639a7e36))
* no parallel zfs, disk too slow ([b126b44](https://github.com/defn/dev/commit/b126b44af25f586264b43a2afaeb0ddc3d316919))
* node in global ([3ac76de](https://github.com/defn/dev/commit/3ac76de2f6d23406b6c8d56e65dc76752de0d92c))
* pc, rpi4c are not cache hosts ([b8e8887](https://github.com/defn/dev/commit/b8e88870360af8b83545a74cc23c9e37c954e6bf))
* put m/bin in path to get n ([ec70cfb](https://github.com/defn/dev/commit/ec70cfb893bdbe62c9fa8b96f810c42b0d696e1e))
* python is global for gcloud ([30ae5ba](https://github.com/defn/dev/commit/30ae5ba8689188cc5b3f56ddb4651b9432bbba65))
* reduce -x output ([c3c051f](https://github.com/defn/dev/commit/c3c051f2d18fa7a8b85261cdaadfdb836265adba))
* remove all python from nix ([35f3f92](https://github.com/defn/dev/commit/35f3f92499c4fec6ba27fd9e2bac84e973fbdeb7))
* remove pnpm ([dcdba1d](https://github.com/defn/dev/commit/dcdba1d73c7078762061de1b1511e7ecd2deb965))
* remove pnpm from mise tasks ([b8a44e9](https://github.com/defn/dev/commit/b8a44e9fb9868fc46c3e222227aeef2b3c3e6177))
* remove redundant build steps from m/i ([f4d898b](https://github.com/defn/dev/commit/f4d898b233f426a0322a27e575b28bca6988a68f))
* remove unused mise nix flake ([f835a5b](https://github.com/defn/dev/commit/f835a5ba2f01ffa03a9ecd12049762106740d6aa))
* replace awscli flake with aws-cli from mise ([38d204e](https://github.com/defn/dev/commit/38d204e6bdbdf743742282a090305bdc57c1657f))
* run coder agent from user-script script again ([9dad419](https://github.com/defn/dev/commit/9dad4194d34d8054a9620b778b5ba4e1784771f1))
* run coder-agent under mise ([506bae1](https://github.com/defn/dev/commit/506bae11ac17c6bd1b57794f277b7be2e0c05282))
* setsid and no || true to detach from bash parent ([12e1836](https://github.com/defn/dev/commit/12e18364d482b34a2056c898fc4cb6668087a079))
* show stats after all ersgan runs ([9078a62](https://github.com/defn/dev/commit/9078a62e967fff9aa8f4ba2085648d429032c099))
* slow down replicate requests to avoid 429 ([7fac081](https://github.com/defn/dev/commit/7fac081fd7a6a17eca8533a0ff639867f9dc2baf))
* ubuntu home ownership ([daca4cb](https://github.com/defn/dev/commit/daca4cb61116f753d6bc65aaebf8dfbc90952cd9))
* unmount and destroy zfs for docker ([cc80434](https://github.com/defn/dev/commit/cc8043417515e72809e3bacf943e624ad05eff16))
* unset coder git ssh helpers in ci ([1c17ea2](https://github.com/defn/dev/commit/1c17ea2704e203f5566abbfe05c5f34ffbca3c0b))
* use n from path; pjg list dep on gh ([2d9dc31](https://github.com/defn/dev/commit/2d9dc3104d8478152f34cb3f2464bab3c65f44a6))
* vscode proxy uri ([f4f566c](https://github.com/defn/dev/commit/f4f566ce816b50c41d25090d451ed3c271b23ad0))

## [1.5.0](https://github.com/defn/dev/compare/v1.4.0...v1.5.0) (2025-02-10)


### Features

* always update dotfiles ([e5ace54](https://github.com/defn/dev/commit/e5ace5434f9c0c0478dda1b426935faa0206cb89))
* argocd/ 2.13.3 -&gt; 2.13.4 [skip ci] ([e6273a7](https://github.com/defn/dev/commit/e6273a7d7fa92264ceb0082de8497977dd17463b))
* argocd/ 2.13.4 -&gt; 2.14.1 [skip ci] ([2eaf579](https://github.com/defn/dev/commit/2eaf5792db9fb709140f5cfa7fdc1d5075d1a5db))
* awscli/ 2.23.10 -&gt; 2.23.11 [skip ci] ([440e692](https://github.com/defn/dev/commit/440e692138724d47215aa2ce0cac191501a84e8a))
* awscli/ 2.23.11 -&gt; 2.23.12 [skip ci] ([ecf1518](https://github.com/defn/dev/commit/ecf15183696bef785d6a2b1535786003327c3df0))
* awscli/ 2.23.12 -&gt; 2.23.13 [skip ci] ([4fe67ff](https://github.com/defn/dev/commit/4fe67ff41f866bc2ab1ab7fa0262cc2ee78767d6))
* awscli/ 2.23.13 -&gt; 2.23.14 [skip ci] ([8bbe371](https://github.com/defn/dev/commit/8bbe371896f167a53b89be20a9c237d81b14e988))
* awscli/ 2.23.14 -&gt; 2.24.0 [skip ci] ([556b980](https://github.com/defn/dev/commit/556b980c97bd06e04301a8e2269043fd83973814))
* awscli/ 2.23.7 -&gt; 2.23.8 [skip ci] ([b073d96](https://github.com/defn/dev/commit/b073d96d822e412fe9c387702477073f78463a44))
* awscli/ 2.23.8 -&gt; 2.23.9 [skip ci] ([38337a3](https://github.com/defn/dev/commit/38337a32e5d86b2976f6658afa7725a938b04ad7))
* awscli/ 2.23.9 -&gt; 2.23.10 [skip ci] ([7e250a2](https://github.com/defn/dev/commit/7e250a201757b0adc84f10f539cff0edf6e82a10))
* bazel 7.5.0 ([3c726f3](https://github.com/defn/dev/commit/3c726f33cfc5f552949bf78eab744e2dad5fa79b))
* buildifier/ 8.0.1 -&gt; 8.0.2 [skip ci] ([d45a578](https://github.com/defn/dev/commit/d45a578821460fa14e43204c9bbd75e5d25e877d))
* buildifier/ 8.0.2 -&gt; 8.0.3 [skip ci] ([25f71fd](https://github.com/defn/dev/commit/25f71fdb8c3a48232a7b27b4f647e2b6cca4714f))
* buildkite/ 3.90.0 -&gt; 3.91.0 [skip ci] ([61be195](https://github.com/defn/dev/commit/61be1956766d73a8aa0b90ddc417493057e40cb8))
* cloudflared/ 2025.1.0 -&gt; 2025.1.1 [skip ci] ([a5057ce](https://github.com/defn/dev/commit/a5057ce8df8e4d0bcbe5cdcc0e8217d6d1a267e0))
* consolidate utilities flakes into one base flake ([8b810f3](https://github.com/defn/dev/commit/8b810f350025a4d2d8151cad1e4d4f2fbabda88c))
* cue/ 0.11.2 -&gt; 0.12.0 [skip ci] ([6f1e8ae](https://github.com/defn/dev/commit/6f1e8aed0c000334c2355b04723e8c846525ef9b))
* feat: coder 2.19.0 [skip ci] ([a60ce81](https://github.com/defn/dev/commit/a60ce81c0c48479cfbddaf93c5024cd5e1d201fd))
* flyctl/ 0.3.69 -&gt; 0.3.70 [skip ci] ([ca24681](https://github.com/defn/dev/commit/ca246814cdd0fd9a23cc5caa0387fafe7d5f3fb2))
* gh/ 2.65.0 -&gt; 2.66.0 [skip ci] ([f149e22](https://github.com/defn/dev/commit/f149e22e78c04d19999be694ad411ad72362dabf))
* gh/ 2.66.0 -&gt; 2.66.1 [skip ci] ([2746f70](https://github.com/defn/dev/commit/2746f702d49f37f2acf8c807b09a0dc25cd83b68))
* gum/ 0.15.1 -&gt; 0.15.2 [skip ci] ([ee72361](https://github.com/defn/dev/commit/ee72361621879b8e07bd489836d57c709ddfa775))
* install.sh updates to latest defn/dev, trusts mise ([880fbdb](https://github.com/defn/dev/commit/880fbdb2ec742d551653e5add44aa389727e202d))
* kubelogin/ 1.32.1 -&gt; 1.32.2 [skip ci] ([1f40ba4](https://github.com/defn/dev/commit/1f40ba4ff2d8cf0e79682f2b9cd7bf1d146d937c))
* mirrord/ 3.131.0 -&gt; 3.131.2 [skip ci] ([b305666](https://github.com/defn/dev/commit/b305666d2885d27b38ac2b4e8b2e9d1ba3046685))
* mise/ 2025.1.15 -&gt; 2025.1.16 [skip ci] ([633ca44](https://github.com/defn/dev/commit/633ca44f63e84719f498b94b7fb7ae6b42bef3ae))
* mise/ 2025.1.16 -&gt; 2025.1.17 [skip ci] ([9905e7b](https://github.com/defn/dev/commit/9905e7b490d9904236050faed328ef5eb7fe59b6))
* mise/ 2025.1.17 -&gt; 2025.2.0 [skip ci] ([ddbe638](https://github.com/defn/dev/commit/ddbe63841353ee74c3e7a4390264469f9c62db3a))
* mise/ 2025.2.0 -&gt; 2025.2.1 [skip ci] ([3bf1575](https://github.com/defn/dev/commit/3bf1575af4ec85b37124df4fd62c6720fe650a50))
* mise/ 2025.2.1 -&gt; 2025.2.3 [skip ci] ([c4f1999](https://github.com/defn/dev/commit/c4f1999f06311e506cad6e3ba33c1f9a3b7aad11))
* multiple buildkite agents ([f9ac081](https://github.com/defn/dev/commit/f9ac08196e8e24c65acd9dd71a71ae835c124580))
* nghiem family recipes ([f6aca35](https://github.com/defn/dev/commit/f6aca35946c81acf7190c8175cd1c2c023766e6a))
* pin mise versions ([df9f3e0](https://github.com/defn/dev/commit/df9f3e085ba7519912914680dd33586d60fb198a))
* replace more nix flakes with mise ([70dad6a](https://github.com/defn/dev/commit/70dad6a935ddf10eb3b4f328549523d6655b0575))
* replace nix flakes with mise ([e24abec](https://github.com/defn/dev/commit/e24abec004c48777939174a9c5d7f51a9caf5a8c))
* replace some nix flakes with mise tools ([35192c9](https://github.com/defn/dev/commit/35192c9fcd50389143f018f7c1107648ceed2322))
* simple install script ([2c051c6](https://github.com/defn/dev/commit/2c051c6ba3d21789938d8c5420f9e7ab7bfaac11))
* tailscale/ 1.78.1 -&gt; 1.80.0 [skip ci] ([bf74c40](https://github.com/defn/dev/commit/bf74c40a1619bb4a1b6bd74f5620e44c776ae808))
* upgrade(cue) mise ([319905d](https://github.com/defn/dev/commit/319905daf7c467b8bd39668278c8e265327829df))
* workerd/ 1.20250124.3 -&gt; 1.20250129.0 [skip ci] ([e758948](https://github.com/defn/dev/commit/e758948799f42939a5bb20f424f3489005c88aaf))


### Bug Fixes

* close window binding ([06e41fa](https://github.com/defn/dev/commit/06e41fa6df8919faf31875c71c495a1c16f07c78))
* coder uses websockets behind cloudflare ([3d5452b](https://github.com/defn/dev/commit/3d5452b42f27d10f0750f75f9aa4d3e722b4e6e3))
* configure buildkite agents with credentials ([ca9bbe5](https://github.com/defn/dev/commit/ca9bbe5d8a665559416e9dfcb92755af67a79c2b))
* correct xz-utils package name ([d9436ff](https://github.com/defn/dev/commit/d9436ffc1ee045951ff200f6f4771e04a01271d5))
* garbage collect registry images after syncing ([2edaf13](https://github.com/defn/dev/commit/2edaf1336751dd3da222c1ce1a97097cf56b59be))
* install needs build-essential ([f1f16eb](https://github.com/defn/dev/commit/f1f16eb20f5f112e888bec89cdc9445c20e85028))
* install needs curl ([94078ef](https://github.com/defn/dev/commit/94078ef0c8c65fe71cdcdc2f9ec96bdb22ac3023))
* install needs dirmgnr, git ([9dc7f3e](https://github.com/defn/dev/commit/9dc7f3edd546d2ef20a49b4aeaf1a76615d652d3))
* install needs rsync ([be03edb](https://github.com/defn/dev/commit/be03edb903982e3d9537e40392c9ab870d932f68))
* install needs xz ([44640ec](https://github.com/defn/dev/commit/44640ecdf3490e16176b304ca55b7548d99807d0))
* oci needded for bazel builds ([94872df](https://github.com/defn/dev/commit/94872df8071838f6521e86f79a08c64539aa7a1a))
* remove deleted flkes from home build ([ef60b41](https://github.com/defn/dev/commit/ef60b413b3bde43f8be5ca7b26c727ea29c3757d))
* remove flakes: buf, cilium, earthly, flyctl, k3sup openfga, teraformdocs, tfo ([5ad9f19](https://github.com/defn/dev/commit/5ad9f19d4d1ea0d2e6b677ac273f8d3c18f4f2c2))
* source profile to use tools during install ([768e575](https://github.com/defn/dev/commit/768e5750c319ce473010f562557ff9c29c1d5324))
* use a script to get the github token ([0170f6c](https://github.com/defn/dev/commit/0170f6c0227088e26757eece92fbff0193b21c91))

## [1.4.0](https://github.com/defn/dev/compare/v1.3.0...v1.4.0) (2025-01-28)


### Features

* add astro joyride config ([5b805d4](https://github.com/defn/dev/commit/5b805d489ee9b8667115f1b4e60a6f212bb44dd4))
* awscli/ 2.23.2 -&gt; 2.23.3 [skip ci] ([221350f](https://github.com/defn/dev/commit/221350f82de1d18b01d39763d89da5b6b5313407))
* awscli/ 2.23.3 -&gt; 2.23.4 [skip ci] ([a264e3c](https://github.com/defn/dev/commit/a264e3c7235a991f3a0c9d21325e78048fa7251b))
* awscli/ 2.23.4 -&gt; 2.23.5 [skip ci] ([7b0b8bb](https://github.com/defn/dev/commit/7b0b8bb950d31a854859cd11606789f611a49921))
* awscli/ 2.23.5 -&gt; 2.23.6 [skip ci] ([2255536](https://github.com/defn/dev/commit/2255536dec3ba7cab6d18f4b3b8c4784c3640bbf))
* awscli/ 2.23.6 -&gt; 2.23.7 [skip ci] ([1d538cc](https://github.com/defn/dev/commit/1d538ccb3473c6194887ddcc7ff037a12c244f28))
* change me link on every website ([fbf01ac](https://github.com/defn/dev/commit/fbf01ace999d130c3c5b188bdcb266e8cbb7951a))
* coder k8s template autostops by default after 1h ([0d78aed](https://github.com/defn/dev/commit/0d78aed4b4bb948222fdb7bfc5a755d325ea062c))
* codeserver/ 4.96.2 -&gt; 4.96.4 [skip ci] ([c0309dc](https://github.com/defn/dev/commit/c0309dcd91196aa644ca5c5b560e7a28cfc13bf2))
* cue/ 0.11.1 -&gt; 0.11.2 [skip ci] ([aa4da01](https://github.com/defn/dev/commit/aa4da01fee03c0d5cf6672e1c999512f880e50c1))
* enable tutorial on amanibhav.am workspace ([d6b7eda](https://github.com/defn/dev/commit/d6b7edacb51de059cbf3f731494d9403600fc5d7))
* flyctl/ 0.3.64 -&gt; 0.3.65 [skip ci] ([037887f](https://github.com/defn/dev/commit/037887f09d7c3d9e04d0ad29afa6456b918829c6))
* flyctl/ 0.3.65 -&gt; 0.3.66 [skip ci] ([b77e5f6](https://github.com/defn/dev/commit/b77e5f60b4ffe7663fa05c28c462701a619a908f))
* flyctl/ 0.3.66 -&gt; 0.3.67 [skip ci] ([22c2976](https://github.com/defn/dev/commit/22c2976b498c02d20767eb15ca1f87fd61831ba7))
* flyctl/ 0.3.67 -&gt; 0.3.68 [skip ci] ([219bb80](https://github.com/defn/dev/commit/219bb80585909188d50c7d6ca53dbb986900716a))
* flyctl/ 0.3.68 -&gt; 0.3.69 [skip ci] ([88e8e0f](https://github.com/defn/dev/commit/88e8e0f7bc90aabe2562d70e48b3a477a5afee1e))
* goreleaser/ 2.5.1 -&gt; 2.6.0 [skip ci] ([668644f](https://github.com/defn/dev/commit/668644ffc298181bd0c7fd70c5e7b5dc3916a3d9))
* goreleaser/ 2.6.0 -&gt; 2.6.1 [skip ci] ([1a07f1a](https://github.com/defn/dev/commit/1a07f1adf12db7df482756d8e977b12e55b68d1c))
* gum/ 0.15.0 -&gt; 0.15.1 [skip ci] ([e392ead](https://github.com/defn/dev/commit/e392eadeeaaf7ddab76f095ba92a3e5393155631))
* hubble/ 1.16.5 -&gt; 1.16.6 [skip ci] ([1a06e9a](https://github.com/defn/dev/commit/1a06e9a9631bd2494cb809ffb2fd9d3065cff3f8))
* joyride runs tutorial ([18bfa13](https://github.com/defn/dev/commit/18bfa130f22e14ae6f07b47aa6f85f06aadfc4ba))
* just/ 1.38.0 -&gt; 1.39.0 [skip ci] ([b45723b](https://github.com/defn/dev/commit/b45723bed48e7693975705dbf5afbd8a24f85377))
* k3sup/ 0.13.6 -&gt; 0.13.8 [skip ci] ([7c45bfa](https://github.com/defn/dev/commit/7c45bfae396f1dee5e427c117d57e845773e5856))
* kn/ 1.16.1 -&gt; 1.17.0 [skip ci] ([7b35cde](https://github.com/defn/dev/commit/7b35cde03a539fad11e8104a6c87cdfb9ffdd100))
* kubelogin/ 1.32.0 -&gt; 1.32.1 [skip ci] ([045138f](https://github.com/defn/dev/commit/045138ffca46630269976d2eeb91d76099901911))
* kuma/ 2.9.2 -&gt; 2.9.3 [skip ci] ([357c79f](https://github.com/defn/dev/commit/357c79fb87746ad5c7706a74f3eb479f9354ff10))
* linkerd/ 25.1.1 -&gt; 25.1.2 [skip ci] ([e1ed142](https://github.com/defn/dev/commit/e1ed1428a31eaf3e76e225400d687ef6bc7c8c03))
* mirrord/ 3.129.0 -&gt; 3.130.0 [skip ci] ([70af09a](https://github.com/defn/dev/commit/70af09a9cdca83ea5fd09f66d09e675f52ba9f06))
* mirrord/ 3.130.0 -&gt; 3.131.0 [skip ci] ([7a222d1](https://github.com/defn/dev/commit/7a222d1246305286b70b78b2a137d01d17b86563))
* mise up for astro takes --open ([6f0a0ad](https://github.com/defn/dev/commit/6f0a0adeebbe06bb99466a89105e5451649053fd))
* mise/ 2025.1.14 -&gt; 2025.1.15 [skip ci] ([746825d](https://github.com/defn/dev/commit/746825d703efdb5b4d0df4b4c59cdceaa2ee89a5))
* mise/ 2025.1.9 -&gt; 2025.1.14 [skip ci] ([efa99ef](https://github.com/defn/dev/commit/efa99ef70c0c1cdcf11824f4ef8b83d622953661))
* openfga/ 0.6.2 -&gt; 0.6.3 [skip ci] ([35ad870](https://github.com/defn/dev/commit/35ad87015a5ea65265109cbd28a98c6ba8e8acb8))
* optional tutorial mode, create the app_tutorial file ([e788498](https://github.com/defn/dev/commit/e788498a0a5de4728363a41e851156a4ddcdc8a3))
* packer/ 1.11.2 -&gt; 1.12.0 [skip ci] ([36b42d7](https://github.com/defn/dev/commit/36b42d763f3eda8bf7279eedac26279a09472d0c))
* stern/ 1.31.0 -&gt; 1.32.0 [skip ci] ([f27a576](https://github.com/defn/dev/commit/f27a57644d982ac59234ed7e8c1c036291903a1c))
* terraform/ 1.10.4 -&gt; 1.10.5 [skip ci] ([e9f879c](https://github.com/defn/dev/commit/e9f879c75d6be6ef89a96814f888d5712f10120b))
* workerd/ 1.20241230.0 -&gt; 1.20250121.0 [skip ci] ([ddc9cf8](https://github.com/defn/dev/commit/ddc9cf8ec70f195e3e30c496fc1e4aa82ee6ae2c))
* workerd/ 1.20250121.0 -&gt; 1.20250124.0 [skip ci] ([20d5f2b](https://github.com/defn/dev/commit/20d5f2bd7538a61ab819e5f7c9186d7777c14c46))
* workerd/ 1.20250124.0 -&gt; 1.20250124.3 [skip ci] ([a3d28f5](https://github.com/defn/dev/commit/a3d28f5a972f422237ebc78bac4de2c50825670f))


### Bug Fixes

* add on-demand tutorial loader ([760f3db](https://github.com/defn/dev/commit/760f3dbd7738bcb7146343330ea5c4735b4caaa8))
* allowlist .defn.run ([e69553c](https://github.com/defn/dev/commit/e69553c5214065de0036ea912679d02d1a2c5b83))
* build github pages again ([6ee5f02](https://github.com/defn/dev/commit/6ee5f029b478831dc99f6a2ff3f048944e706160))
* create the .app_up file asap ([d1de9da](https://github.com/defn/dev/commit/d1de9da78e8779010b31ebd4db6a54a50f699536))
* docs previwing again ([91f9e7e](https://github.com/defn/dev/commit/91f9e7ef85427e76a9e624a469126d31ecf78134))
* fix amanibhav.am joyride link ([40d71a1](https://github.com/defn/dev/commit/40d71a1b47aba24cd7feccfaed4bd756eed0b961))
* m install disables astro telemetry ([c254a18](https://github.com/defn/dev/commit/c254a18bb31b39a56cae04f6c2d807fd3f4c2557))
* manual tutorial trigger working ([9e683c5](https://github.com/defn/dev/commit/9e683c5547ac73deff8047f0b791721ed2db8ceb))
* only backup is online at all times ([12e090e](https://github.com/defn/dev/commit/12e090e4d3c542c76d26ea934d908dadcc4cd33a))
* remove unused flakes: crossplane, devspace, hugo, kn, minikube, zellij ([a32e728](https://github.com/defn/dev/commit/a32e728c745e3f6a3426a6829ad35b20992a11f9))
* use workspace activate scripts to load tutorial ([3499c0e](https://github.com/defn/dev/commit/3499c0ec7265068fdbcb5f8816f167d54970d94d))

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
