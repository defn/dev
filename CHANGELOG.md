# Changelog

## [1.41.0](https://github.com/defn/dev/compare/v1.40.0...v1.41.0) (2025-11-15)


### Features

* add Bazel bash wrapper examples with lib.sh integration ([34eec96](https://github.com/defn/dev/commit/34eec969b59de01d3284e517bf612683c46cf16e))
* add exclamation to hello message ([f874032](https://github.com/defn/dev/commit/f874032c0bc47a2179aee5980888f519a08babef))
* add hello example CUE module ([2c83708](https://github.com/defn/dev/commit/2c837084bf6d26cd8c3343583fc673187117eda7))
* add iam_user_access_to_billing and role_name to AWS accounts ([1366cb2](https://github.com/defn/dev/commit/1366cb2cb3182af33cfe34151bfff01e00220c55))
* add initial Astro site structure for defn.com ([4c12524](https://github.com/defn/dev/commit/4c1252430d5a3b82f492e0626bc759e81fe33d38))
* add meh example demonstrating CUE-to-Bazel build generation ([47e1745](https://github.com/defn/dev/commit/47e1745c40cc3a2046bfc8191b2f24347d866113))
* add mise task for BUILD.bazel generation in meh example ([40fe4f0](https://github.com/defn/dev/commit/40fe4f08aa9fb0fd97c3267e80bbfb3168206a2a))
* add pkg module with dependency integration ([e62c3e7](https://github.com/defn/dev/commit/e62c3e7393a2d4edec14baf6b44c65880b07206e))
* add site configuration schema and definitions ([7a5ed48](https://github.com/defn/dev/commit/7a5ed48a9412cb260849bc0fd705ab5f3b209719))
* add Terraform moved blocks for SSO assignment resource renames ([2f1ff1d](https://github.com/defn/dev/commit/2f1ff1dbf7b9f045ecc3e687dad8554fbf519e6f))
* add terraform plan change summary to plan task ([93d864d](https://github.com/defn/dev/commit/93d864d8047ecf4e71d66ab60abf31f45d6113cd))
* update hello messages in Rust worker and CUE config ([efd85e1](https://github.com/defn/dev/commit/efd85e1a34584d549d558d36c40f0a8513314bf7))


### Bug Fixes

* add missing moved blocks for old semantic resource names ([a316080](https://github.com/defn/dev/commit/a31608017779e1b8c7b568cbfd33b49e7a57fcd3))
* initialize PROMPT_COMMAND in bash_profile ([0d26b5a](https://github.com/defn/dev/commit/0d26b5a5d05e7bb298069de9c5d604f786cbaa4d))
* update module name from pkg to pub ([6c40c22](https://github.com/defn/dev/commit/6c40c22c4614ee529f8915b38033dfc8503c67fd))

## [1.40.0](https://github.com/defn/dev/compare/v1.39.0...v1.40.0) (2025-11-02)

### Features

- add AWS CLI configuration display to account pages ([78c88b8](https://github.com/defn/dev/commit/78c88b8d35cb999decd87e8e587cebd4bbe2d81e))
- add AWS_REGION environment variable to all AWS account configurations ([c275e56](https://github.com/defn/dev/commit/c275e56b334f9f9984661c35028322af761f0497))
- add bootstrap SSO login to account-level infra READMEs ([ebffeb2](https://github.com/defn/dev/commit/ebffeb2dd7f343a7591bbad8094439e24e2362c0))
- add EBS volume querying to AWS meh task ([ab1bb4c](https://github.com/defn/dev/commit/ab1bb4c0870c11752e7b9477a4455d728b42de1e))
- add libatomic1 dependency for Node.js ([0cbc36f](https://github.com/defn/dev/commit/0cbc36fab4f94de10fadd74531c726d9c6a5664c))
- add meh cobra command for AWS resource querying ([db1c5fe](https://github.com/defn/dev/commit/db1c5feb7a71a7406cc000f5623822c0ba4918f3))
- add mise task for running docs dev server ([9924fac](https://github.com/defn/dev/commit/9924fac32cdea849e926575eb8bc88d7b980e86f))
- add mise task to query AWS EC2 instances and fx tool ([62b5227](https://github.com/defn/dev/commit/62b522795c4e47c72cd9806943fc8cc88cff853f))
- add mise trust to with-env script ([42234a5](https://github.com/defn/dev/commit/42234a58ca4dbe96caff43cc469540b68bc13ead))
- add mise.toml configs for all org accounts and simplify READMEs ([30143a1](https://github.com/defn/dev/commit/30143a143324124ae766aa899f7936e2aad6ad0a))
- add parallel terraform plan task for infrastructure ([b9535ab](https://github.com/defn/dev/commit/b9535aba635de02a3351fb84858793f39745f8dc))
- add per-region permissions check and structured logging to meh command ([155e5d9](https://github.com/defn/dev/commit/155e5d95235a4da4b8d717f303c0758e7b9ecd90))
- add pipx to sync_inner mise install ([e3ba444](https://github.com/defn/dev/commit/e3ba444e27798df436667e1d357bd692665c8041))
- add use function to navigate and display README files ([c61afc8](https://github.com/defn/dev/commit/c61afc81c1b4f3f690f6712e2575aafbc35720d8))
- enable account and IAM service access for chamber organization ([09fef71](https://github.com/defn/dev/commit/09fef71267cca8f4717caf1e46b4dd6c96961191))
- filter auto-generated comments from README display ([d479b3d](https://github.com/defn/dev/commit/d479b3ddac4504de938317b6bda65a73a25c7e3a))
- generate account subdirectory READMEs from CUE schema ([ef575f5](https://github.com/defn/dev/commit/ef575f54ff838dd50772ae7c0d20574a8f5a7f18))
- generate AWS CLI configs and mise.toml for all accounts ([9332c43](https://github.com/defn/dev/commit/9332c43eeb097d7bd847282a890e939fca26068c))

### Bug Fixes

- make mise trust non-fatal in sync_inner ([d1bb3e3](https://github.com/defn/dev/commit/d1bb3e31babf94a9db7c5c700383bbb8d6f887ec))
- update i/ami/mise.toml to use account-specific AWS config ([dd719d5](https://github.com/defn/dev/commit/dd719d589ba44b745d0c4a5d35c481472a839c13))
- use absolute path for mise trust in with-env ([72879b9](https://github.com/defn/dev/commit/72879b90472571f72f47b187972cb5fc830a63db))

### Performance Improvements

- add concurrency throttling to AWS EC2 query task ([f7c38c4](https://github.com/defn/dev/commit/f7c38c49e399e0834bb855e2020777e8fc4dfacb))
- parallelize AWS EC2 queries across regions ([0719780](https://github.com/defn/dev/commit/07197809387e4197887d75b1246da285dd136806))

### Reverts

- change csso_url organization back to curl ([acd1e8c](https://github.com/defn/dev/commit/acd1e8cd787d9d1b9cae82a1b406b534e41b1796))

## [1.39.0](https://github.com/defn/dev/compare/v1.38.0...v1.39.0) (2025-10-25)

### Features

- add Astro.js + Starlight documentation site ([570bb05](https://github.com/defn/dev/commit/570bb0549b9b5e5f988bd9f682431ace0b4c84de))
- add AWS accounts JSON collection with Starlight pages ([25b3758](https://github.com/defn/dev/commit/25b37583b4418226efe75acc42f97cb9c72c3e77))
- add complete AWS organization data to documentation ([d962ab3](https://github.com/defn/dev/commit/d962ab3b2f8a079e8f398748cf5eb4e81f35ad07))
- add Roboto and Roboto Mono web fonts to documentation ([fef0493](https://github.com/defn/dev/commit/fef04934d9bcc2c6196d9edb7bcfcf064ba8e41c))
- add Vite dev server redirect from / and /dev to /dev/ ([997ee33](https://github.com/defn/dev/commit/997ee338e6f6bcf816cdd54b4d7c1552855ab556))
- configure GitHub Pages deployment with /docs directory ([280b5df](https://github.com/defn/dev/commit/280b5dfbcb3723f301da54bd14fee0880f5b834b))

### Bug Fixes

- add HTML redirect page for root path in dev mode ([d818ce4](https://github.com/defn/dev/commit/d818ce45433c5bdbc7ae599b7a3c05e94d64a1fd))
- add missing print.DNXP8c50.css file referenced by HTML ([d8655b0](https://github.com/defn/dev/commit/d8655b021213fc2910b2db529efc424aac707429))
- add site config to enable sitemap generation ([c0a8fa2](https://github.com/defn/dev/commit/c0a8fa249839295e9a575c947871edc80ec48134))
- add trailingSlash always option for consistent URL handling ([61d7295](https://github.com/defn/dev/commit/61d72956a08db848b84ac86f5f2ee2c9f7ebcf66))
- change AWS account links from absolute to relative paths ([d5a57e7](https://github.com/defn/dev/commit/d5a57e7aff829399df75cf76daa2e804df6b38d4))
- change AWS links from absolute to relative for /dev base path ([2b89eff](https://github.com/defn/dev/commit/2b89effcabd2f06dd2b5239b1232e4abf2c9fa60))
- configure site URLs for GitHub Pages deployment ([954dac7](https://github.com/defn/dev/commit/954dac7d9d693dbb8f273847bebfb7d8abe81cfc))
- correct back link to navigate up two levels to /aws/ ([8e0fc5d](https://github.com/defn/dev/commit/8e0fc5d794827de39a63f120d8a46b132e2c8b3c))
- prevent account IDs from wrapping to multiple lines ([1734605](https://github.com/defn/dev/commit/1734605ba1dae74745b63fd9c403b67caa3e8408))
- remove 'm' from .gitignore and add missing chamber/m page ([c8f5a7a](https://github.com/defn/dev/commit/c8f5a7abb15edff938337a78b54e14b2c8db2bb5))
- rename assets directory from \_astro to 'a' for GitHub Pages ([a010c32](https://github.com/defn/dev/commit/a010c327a06b7e94eef78f6a5a4b41f31a55af81))
- suppress Node.js DEP0190 deprecation warning during docs build ([dedaf52](https://github.com/defn/dev/commit/dedaf52160e063d1a3a2efa8a3730d7efebee93c))
- suppress Vite unused import warning from Astro internals ([fd3c4d3](https://github.com/defn/dev/commit/fd3c4d3eb568b8d8fdeade0f856020735478b80c))
- use relative back link in AWS account detail pages ([885d862](https://github.com/defn/dev/commit/885d862176fda1de5a29c342cdac6fab93389ca8))

### Reverts

- remove public/index.html redirect approach ([984ac49](https://github.com/defn/dev/commit/984ac49eb8aa262cdd18af79a738ba47a74c0498))

## [1.38.0](https://github.com/defn/dev/compare/v1.37.1...v1.38.0) (2025-10-22)

### Features

- add AWS organization configuration data ([9192e34](https://github.com/defn/dev/commit/9192e3430a86848db4e453c015bdda625be741ac))
- add CUE ingestion scripts and configuration ([34f7969](https://github.com/defn/dev/commit/34f79698d567217ba9ef94d4a44f1ea74992acf8))
- add custom CUE formatter to trunk configuration ([fcc83c0](https://github.com/defn/dev/commit/fcc83c0ab8015ba2e19d6bc01394b22e61543a93))

### Bug Fixes

- change to original working directory in mise claude task ([5769f0c](https://github.com/defn/dev/commit/5769f0c54672b2d204d7673906de0ad9b6129fb9))
- correct git difftool extcmd to avoid duplicate arguments ([c88a960](https://github.com/defn/dev/commit/c88a960e410a7d9ec1ed06df7610bab47c90eff5))
- enable /home mount before disabling in macOS playbook ([95c31dd](https://github.com/defn/dev/commit/95c31dd85da8794d18e921cbf289ccb698f9ab38))
- improve shell formatting and variable escaping in ingest.sh ([914f10d](https://github.com/defn/dev/commit/914f10da39c9d0cf27436c5ed09ed6c5af68e2da))
- pass arguments to claude command in mise task ([693b6fc](https://github.com/defn/dev/commit/693b6fc5cd03088797bccbc2d556e876f98f341d))

## [1.37.1](https://github.com/defn/dev/compare/v1.37.0...v1.37.1) (2025-10-16)

### Bug Fixes

- improve gallery index layout with dual image display ([3df1ffc](https://github.com/defn/dev/commit/3df1ffc004a9638b8c657d55f4bd25a34ca0ad68))
- replace hardcoded UUID with generic placeholder in gallery image link ([57b199a](https://github.com/defn/dev/commit/57b199a952ac98e8f68f2beaa53c83e07a57927c))
- update gallery index image paths to use subdirectory structure ([ce69cc3](https://github.com/defn/dev/commit/ce69cc36d0e9f037b006e1c342df5326e4737ed4))

## [1.37.0](https://github.com/defn/dev/compare/v1.36.0...v1.37.0) (2025-10-14)

### Features

- add gallery index generation to fem.sh ([a34a62c](https://github.com/defn/dev/commit/a34a62c33162410a075cb34644a71bbbf3db37d1))
- add hello button with text input to Tiltfile and update linter versions ([69963d4](https://github.com/defn/dev/commit/69963d409e5e8248fbeb3a6b3c80c076a7f177af))
- add mise task for claude command ([88e23f8](https://github.com/defn/dev/commit/88e23f852b9da5b2c9ffb7cbb000b349a75603d1))
- add task config to mise.toml ([0366eab](https://github.com/defn/dev/commit/0366eab868072c2d915b2e205957be849c66ccfe))
- enable DERP force websockets for coder server ([5a6e789](https://github.com/defn/dev/commit/5a6e789331e2beb451d9f024ed20fb334bec467d))
- set app as default in Docker Coder template ([e732a0b](https://github.com/defn/dev/commit/e732a0b00845b7fad48cb1fd38ce8a0e6044e804))

### Bug Fixes

- bind Caddy server to specific IP address ([23662f9](https://github.com/defn/dev/commit/23662f9e5996befeb023dc9f9c813710467d7722))

## [1.36.0](https://github.com/defn/dev/compare/v1.35.0...v1.36.0) (2025-09-28)

### Features

- convert mise TOML tasks to bash scripts ([aa630ef](https://github.com/defn/dev/commit/aa630ef771646228e607cce207f622c00a6a40ee))
- enhance mise task conversion script and clean TOML files ([b016f39](https://github.com/defn/dev/commit/b016f39bcf160df31274a6a1df7b27de536c67d4))

## [1.35.0](https://github.com/defn/dev/compare/v1.34.0...v1.35.0) (2025-08-28)

### Features

- add anchor elements to gallery images for direct linking ([0e5220a](https://github.com/defn/dev/commit/0e5220a175aa278b3cd22b553a4025beeee5ba6b))
- add ansible file cleanup to fixup playbook ([78b092e](https://github.com/defn/dev/commit/78b092edb07a3d01222f55d4681aa572ce13fad3))
- add Ansible tasks for package hold/unhold management ([213cfdc](https://github.com/defn/dev/commit/213cfdc45d09a3ba9b93775bf72a74397d693d2c))
- add aws prod in lieu of cde ([f5d7784](https://github.com/defn/dev/commit/f5d77846c397d7e98d1dd7190e87288e703b4038))
- add bind mounts to meh devcontainer ([bfbc4bd](https://github.com/defn/dev/commit/bfbc4bd36e443e73885469347be5b102891395f9))
- add buildkite agent service definitions ([2d051da](https://github.com/defn/dev/commit/2d051da04d8c144228d54664e7d434488b91b69c))
- add cache and work directories to fixup playbook ([bbb5bc5](https://github.com/defn/dev/commit/bbb5bc562397b446c9710acb27da7aee34b773ef))
- add Claude Code authentication helper scripts ([0b478fa](https://github.com/defn/dev/commit/0b478fad0b74aef53b6680ff12fcdc46c2f64ed4))
- add Claude configuration volume to docker template ([18f78c1](https://github.com/defn/dev/commit/18f78c167e3dcd0a8374b0e3411a68624a03e2b9))
- add coder delete tasks task to CLAUDE.md ([e0b7094](https://github.com/defn/dev/commit/e0b7094b44eecc4fb2f9fb2c34b5280de1691f9d))
- add coder-login module to Coder templates ([d431673](https://github.com/defn/dev/commit/d431673a5b8b7e16046bf5e5ab5796bf3c807c0e))
- add Gemini CLI symlink to fixup playbook ([3b76fd2](https://github.com/defn/dev/commit/3b76fd238df99042d1fb3ed0147c7bb9dd7ad4a6))
- add GitHub CLI config mount to Docker template ([0cd97b6](https://github.com/defn/dev/commit/0cd97b66e6acd2dc9cc1c1ed33050f6611e2fe26))
- add GitHub to Coder's trusted domains for link protection ([3bbd08f](https://github.com/defn/dev/commit/3bbd08f0aec01a16bae8835b03b214f044d648bf))
- add htop package to Ubuntu playbook ([b409f90](https://github.com/defn/dev/commit/b409f90bbc38664c7f5ce9b72d875514ad4dfb6e))
- add iputils-ping package to ubuntu playbook ([bab3301](https://github.com/defn/dev/commit/bab330168533b7b33688c33639c3552ac3850cfd))
- add JavaScript-powered gallery links to per-W.sh ([9680395](https://github.com/defn/dev/commit/9680395136db839bf3b5018363f0bc5ae0b60b76))
- add keybinding for terminal editor side panel ([55c197a](https://github.com/defn/dev/commit/55c197ab08babea37de9e42f13d203fb7b7fb6fd))
- add macOS ansible playbook for system configuration ([4acdc46](https://github.com/defn/dev/commit/4acdc4627afadef234af768ce828f6df75ee6eec))
- add meh hosts group to Ansible inventory ([f3c94a6](https://github.com/defn/dev/commit/f3c94a60e90e2a3447e0cc2aa03135b69c8e875a))
- add modal image display for W-gallery mode with x key ([cc01569](https://github.com/defn/dev/commit/cc01569ca7b94b0c51f82cb17ed07a7d39470cc3))
- add nervous task to CLAUDE.md ([5645475](https://github.com/defn/dev/commit/5645475f4244e920d0876d8e1006fbbeddc79173))
- add python, pip, and npm utilities to fixup playbook ([1f888e4](https://github.com/defn/dev/commit/1f888e473fa4aea75dbd3da29d747fb3771373e4))
- add shared environment directory support ([9c88242](https://github.com/defn/dev/commit/9c882421b8449ba2b0911c497f60e33c59cef18b))
- add Ubuntu Noble support to cloud-hypervisor setup ([2f44058](https://github.com/defn/dev/commit/2f440586594c38b16b933cefa80f64b197235d25))
- add W-gallery mode navigation to individual image pages ([dede0b7](https://github.com/defn/dev/commit/dede0b7968ad06c6b3ebf72606b5040bea87851a))
- AskQuestion ([779793f](https://github.com/defn/dev/commit/779793f3175d34db10f5fb7fab23cb5d00e73b15))
- atlas cli ([aeb464d](https://github.com/defn/dev/commit/aeb464d5f53f76e364f6a6fb28cebb121d416f08))
- build defn cli if sources change ([238988c](https://github.com/defn/dev/commit/238988c5739a008dab2aad894fb4a32c6e460a7b))
- cache vsix ([0d9d857](https://github.com/defn/dev/commit/0d9d857bcaef95bb0e93090432f1495bd23be876))
- coder-tunnel s6 is a go program ([7ab6e5d](https://github.com/defn/dev/commit/7ab6e5d87bd8dd5f329717d64f004012e97b053f))
- **coder:** Replace Docker volume with host mount for code-server extensions ([9a5f5dc](https://github.com/defn/dev/commit/9a5f5dcf5fcfb8be9f021c8d895213b40de7a9a5))
- consolidate commands under m/cmd ([1a262d3](https://github.com/defn/dev/commit/1a262d3b386d42f74cfae8cc9d0bdacc6fd9033a))
- coracias-caudatus delts theme ([be4be1b](https://github.com/defn/dev/commit/be4be1b14bd976356448d827c10dda8de63335f7))
- cue adds customizations to argocd ([b89ae5f](https://github.com/defn/dev/commit/b89ae5f056522c0764ff8d69671cf8579066aeb7))
- delta for diffs ([001fb51](https://github.com/defn/dev/commit/001fb51d439733723ab651b119586e7761af3da9))
- example go service ([212240a](https://github.com/defn/dev/commit/212240a41816d526d84c3fcde39c43a73a86456b))
- example runs by default ([a970a51](https://github.com/defn/dev/commit/a970a510435d8715e629bd1bc1416201bd8d1491))
- expand cloud-hypervisor setup for multiple Noble VMs ([e6d8151](https://github.com/defn/dev/commit/e6d81519aaee5882a507afa4ad91f26d64603d61))
- expand trusted domains for code-server link protection ([bcfc0e8](https://github.com/defn/dev/commit/bcfc0e8649877e707d8cb898e0264d347db594ed))
- expand w-html gallery processing to include 3-digit week directories ([4acd5c0](https://github.com/defn/dev/commit/4acd5c0e60903a4a3d691f42820fc447fd2c6b8b))
- fly build with just ansible playbook and entrypoint script ([8c9f13f](https://github.com/defn/dev/commit/8c9f13fd24b647995da7099836f092736e545dbb))
- go runs a sub-shell ([f9caabe](https://github.com/defn/dev/commit/f9caabe110dccf622d9a7a0b6e17700e91c5b426))
- gollm ([ce565f6](https://github.com/defn/dev/commit/ce565f671fb3d41ab1351c75627e34ad32c13d09))
- gollm as a sub-command ([b756c03](https://github.com/defn/dev/commit/b756c0303c0efa4b2382457a3ddb4da5900dd268))
- install docker-ce with ansible ([95cd8b4](https://github.com/defn/dev/commit/95cd8b4122cae836acddbc0d62889fd6989230f8))
- install freeze ([0cf9931](https://github.com/defn/dev/commit/0cf993164dd0be84fe34bca395964c79d1ff9053))
- install glow, update docs for glow ([113412e](https://github.com/defn/dev/commit/113412e66967aca5dec376e96f27a689c583b058))
- k3d ([0fd9f44](https://github.com/defn/dev/commit/0fd9f4461ad3e48ffb0882a1a687aa0c368838f8))
- k3d port forwards as s6 services ([a781353](https://github.com/defn/dev/commit/a781353f9770c20cf7a685a5e3b2d7e4f3a05498))
- load .env in m ([e3b5b06](https://github.com/defn/dev/commit/e3b5b0681f767961da1554014ed53ad3b579e5b8))
- **mise:** add python for stable ansible install ([9f07d58](https://github.com/defn/dev/commit/9f07d58866003005a2b9f11577126e3e108e5647))
- **mise:** install meteor globally ([8025bdf](https://github.com/defn/dev/commit/8025bdf5d722344a6bf753c9b4a1a7958dad0601))
- **mise:** make mise-list shows dry-run ([fffaf94](https://github.com/defn/dev/commit/fffaf94dbd59f6e078f1aff4f9d34f31b2b62b7a))
- **mise:** make mise-list with upgrade commands ([24b7338](https://github.com/defn/dev/commit/24b7338344cf92224b01b155eb2c2fbd3e0e4dc2))
- mount Docker socket in Coder Docker template ([370e7ff](https://github.com/defn/dev/commit/370e7ff0cb203e3f9efe3309d458531546180077))
- mount host Claude auth and copy credentials in Docker template ([f355e2c](https://github.com/defn/dev/commit/f355e2c597dbd94e15dfd371373f64f554289bd4))
- move trusted domains from coder-server to code-server ([f169d1a](https://github.com/defn/dev/commit/f169d1a4308ed2f57d18233ae7b1810cf3ff8d6a))
- output in Markdown ([f8de695](https://github.com/defn/dev/commit/f8de69506e457d688fb68282e95f8fa1e2f1d5b9))
- post-process w-html galleries to set selectMode to W-gallery ([b2bf21a](https://github.com/defn/dev/commit/b2bf21a72749311d50fa0c2dd69db4daefe37081))
- remove devcontainer from Docker template ([3d40eeb](https://github.com/defn/dev/commit/3d40eeb23fe74e0cfe76a678c8ed303f570a8118))
- remove devcontainer from SSH template ([58f1a5a](https://github.com/defn/dev/commit/58f1a5a1f9bd7c8581a2128b1c1258e4a5012c33))
- riverui ([65a98a0](https://github.com/defn/dev/commit/65a98a077af83d6a0ab84fbd5812173377d352dd))
- run bazel bin if go build isnt found ([eb1a6b0](https://github.com/defn/dev/commit/eb1a6b0bc5b972038119a82047684ec1ea749945))
- run bazel bin if go build isnt found ([5504f8f](https://github.com/defn/dev/commit/5504f8f3867282b7618294cd9901d6327371c891))
- **s6:** tailscaled golang run ([8f41012](https://github.com/defn/dev/commit/8f41012b74afacd205eb41316b72a1a64dbb4c4f))
- sals-verifier for some mise packages ([8913186](https://github.com/defn/dev/commit/891318623be65076b42dee133bb1f2f03b6b3665))
- temporal cli ([f64b45c](https://github.com/defn/dev/commit/f64b45c4500dc3a2301e20e01eb1414f3e6c6673))
- **tui:** height tracks terminal resize ([fdaf005](https://github.com/defn/dev/commit/fdaf005c916d11ccb930e2749f208e223c757e1f))
- **tui:** width tracks terminal resizes ([feb6d73](https://github.com/defn/dev/commit/feb6d73b11782bb8c57a78b28b2372024fcf98b8))
- ubuntu 0404 from ([bd9cd14](https://github.com/defn/dev/commit/bd9cd14d166918100a9f5042ba16e8a19560107e))
- update code-server keybindings ([5150caf](https://github.com/defn/dev/commit/5150caf30fcabfcf49c5342c00523b40afb5b760))
- update coder service and ansible playbook ([d04fd86](https://github.com/defn/dev/commit/d04fd8614b2a5bea2a7fe3508bc4cae1264ab1d0))
- update Coder templates and add devcontainers CLI support ([bfc718b](https://github.com/defn/dev/commit/bfc718bbbd521cfd4a1321bafa274432d5a13a7a))
- upgrade claude-code module to version 2.0.3 ([1fc23c2](https://github.com/defn/dev/commit/1fc23c20a1315c1ec6cdcacd313322e5454f6748))
- upgrade claude-code module to version 2.0.3 in SSH template ([3cf04d1](https://github.com/defn/dev/commit/3cf04d1359d53e0416795b36bad5cfbc8adfa770))
- upgrade mise packages to latest versions ([f4eb4d9](https://github.com/defn/dev/commit/f4eb4d912d0e9a087efacb0a08456b757c31a4bf))
- upgrade mise packages to latest versions ([effc9db](https://github.com/defn/dev/commit/effc9dbcf53e0bdeb60ca77701dfe0550f209fea))
- use gotdoenv to load .env ([04a8686](https://github.com/defn/dev/commit/04a86866771ca4a0ab450786fda8eff862e3bee2))
- use uber/fx ([4f6e7b4](https://github.com/defn/dev/commit/4f6e7b4bd90e15b77042c51b1c89f45e7bac6406))
- watchexec ([e6e3b7a](https://github.com/defn/dev/commit/e6e3b7a408b810c1a0de86a50e7c6a0cf4bd7094))
- working river demo ([d57f992](https://github.com/defn/dev/commit/d57f992773c96aaf3cb9b333db8789fc911d57ef))

### Bug Fixes

- /data/ owned by user ([1e6774b](https://github.com/defn/dev/commit/1e6774b9fd0559878858931e686c3268e6dee796))
- /usr/local/bin is ubuntu owned ([b9c376b](https://github.com/defn/dev/commit/b9c376b0570babb33359178709ca149140b21270))
- add git pull before claude-setup.sh in docker template ([8048e9a](https://github.com/defn/dev/commit/8048e9a235ce79d376d4c6d211f9f6e01f683b58))
- add sudo to chown command in claude-setup.sh ([a61ab2c](https://github.com/defn/dev/commit/a61ab2c580a18cc4a321323ad5d869f9a35bd910))
- add URL parameters and anchor to W-gallery navigation ([682abd8](https://github.com/defn/dev/commit/682abd8281ae585404f4692c7def27c7e264568c))
- allow Docker installation tasks to fail gracefully in ubuntu playbook ([2e546c8](https://github.com/defn/dev/commit/2e546c8b94669ede643f0e758c65a1583b4e6526))
- also remove old go, cue links ([7bb1d30](https://github.com/defn/dev/commit/7bb1d30089fe9d6d30da8e8ef55e9acd7038f3dc))
- argocd no longer redirecting ([323e501](https://github.com/defn/dev/commit/323e501841459dbfbb66e1a5fc58a6bfda8823ef))
- be in m to get version context for making symlinks ([50b0cbe](https://github.com/defn/dev/commit/50b0cbef7616d51a4d48cdb223e8e12e6933a86c))
- better names to describe fx ([9186394](https://github.com/defn/dev/commit/9186394f361ea64d6e275e2707f67bb62e19035f))
- brie is working, with persistent extensions ([86080e7](https://github.com/defn/dev/commit/86080e71f369b3cf92322aaf48a90bb575557162))
- **buildkite:** source environment variables and escape token reference ([55c0636](https://github.com/defn/dev/commit/55c0636bb9a2846db14d40ab5b901a1fff72fda6))
- bump base to rebuild for ansible ([d6157c6](https://github.com/defn/dev/commit/d6157c6c817e20a9a86a55c160650c835ed8c78c))
- bump Claude code module version from 2.0.3 to 2.0.5 ([970d929](https://github.com/defn/dev/commit/970d9296c2b9e4493c32ff5b746a6cc3e2699574))
- cmd build with correct directories ([f853ad3](https://github.com/defn/dev/commit/f853ad3e0e85534d3f8ea9430ab5dc793afac371))
- command/infra is the command, infra is the site config ([d1bc4eb](https://github.com/defn/dev/commit/d1bc4eb602721b9b39b66eb4324488dac6ca8e3b))
- configure bridge networking for cloud-hypervisor VMs ([140daca](https://github.com/defn/dev/commit/140dacab7e2fa70511e00a998b34d73220982da2))
- consolidate helm, kubectl, kustomize ([fbb3a5b](https://github.com/defn/dev/commit/fbb3a5bbe2cd949fe62ba1bdc7ee5c3559a6db55))
- correct Docker volume reference in docker template ([17df8cb](https://github.com/defn/dev/commit/17df8cbc321f18b0860bcec44b8098a1ed7aad91))
- correct UUID extraction for W-gallery mode navigation ([f6c1dc1](https://github.com/defn/dev/commit/f6c1dc133fbc1d412ab969a8af905c4e44c98e02))
- disable autoscroll for W-gallery mode ([b2136d7](https://github.com/defn/dev/commit/b2136d7aacbcd3971b5a8891704f22610f2e32b3))
- disable claude-code module in SSH template ([29ade5e](https://github.com/defn/dev/commit/29ade5ea472d9857cc1a093cf4331f65da388e9b))
- disable D-Bus integration in starship to prevent connection errors ([dd0f306](https://github.com/defn/dev/commit/dd0f306e4afc8e5eaf55948daf17ac4a726e502f))
- dont actually talk to registries ([9826860](https://github.com/defn/dev/commit/9826860d557310456a7e49b06b101c41a41245a0))
- dont hairpin to coder when workspace is local ([3803a8f](https://github.com/defn/dev/commit/3803a8f0b5280fa9dfeab90c807171c59d19c2eb))
- dont pull for remote fly builds ([3a7b1f8](https://github.com/defn/dev/commit/3a7b1f8d98e498ffbab003289ddab6a3db5c8e22))
- dont run as root for local symlinks ([699e339](https://github.com/defn/dev/commit/699e339985a72ec71d5298686fe4c1f94dd31cb1))
- dont upload with bazel, dont make my cache dirs with scripts ([2fb61da](https://github.com/defn/dev/commit/2fb61dac95fe660113fea29fd20a2a61fcf75cfa))
- executable entrypoint.sh ([b058d3a](https://github.com/defn/dev/commit/b058d3a4a584913277bb9f6b24f2a55f4feee21c))
- extract w-NN prefix from imageSrc path instead of anchor ([8c5fa1f](https://github.com/defn/dev/commit/8c5fa1fe0b84c29c6baafdada2ea5eda5a582210))
- fix dyff between by removing namespace ([b0f23d0](https://github.com/defn/dev/commit/b0f23d06ccd068329622fa139fcc08bb495e00d3))
- fq t ([27ca532](https://github.com/defn/dev/commit/27ca532ea0fb0222f97a9367a10e7a8ce2bac259))
- generate bazel for new go programs ([b24551a](https://github.com/defn/dev/commit/b24551aedf17432ae39979cbffdc5bbb5b6e8b37))
- global ansible tasks ([2c8c055](https://github.com/defn/dev/commit/2c8c055919e4161d4311a2848b170a2d982d33fe))
- glow is global, always link gitconfig ([c9dc949](https://github.com/defn/dev/commit/c9dc94970a3be99d0cef784d15641eb5b0f18ddc))
- gollm build ([7ab403e](https://github.com/defn/dev/commit/7ab403ea36b133b2696ab298913532397742be0a))
- improve dummy target with sudo and error handling ([3b105ea](https://github.com/defn/dev/commit/3b105eab0e99fd8f310a80566f90eee534f531d9))
- include joyride vsix, no platform specific extensions ([ae297df](https://github.com/defn/dev/commit/ae297df4300e190f66c0fbd2ef37d81f6151e67f))
- isolate cdktf to m/infra ([884d768](https://github.com/defn/dev/commit/884d768d4fb8dfa500c5363972426366742821d7))
- m start work on macos, on not services activated ([792ad40](https://github.com/defn/dev/commit/792ad408e2397c75f74ea35f493acbeaef075622))
- m/dc tailscaled startup and docker permissions ([045aaf3](https://github.com/defn/dev/commit/045aaf38e35d25ffdb0803359ca215119576ec3d))
- **mise:** show unique mise updates ([4a54faa](https://github.com/defn/dev/commit/4a54faaed90b39d5d28bf8bed6605e182463ad91))
- more tools for k3d ([60eef20](https://github.com/defn/dev/commit/60eef20d60b47c999df4aa4cbfed43d2bbd987c7))
- move command up for defn cli build ([c978655](https://github.com/defn/dev/commit/c9786555abbac003580bad81f24415cdd8f2d7d6))
- move mise fixups after sync ([29debda](https://github.com/defn/dev/commit/29debdab955103c7e212595f9092a37edc3f1277))
- move tasks to m to hide completely ([b6b6b21](https://github.com/defn/dev/commit/b6b6b2153dbeb3aebf8e5309cec5eb6388d55dad))
- no .env, mise parses it bad ([d818d20](https://github.com/defn/dev/commit/d818d20d2f522bf94d51258acced2626980be41b))
- no demo ([e1f8288](https://github.com/defn/dev/commit/e1f8288b4903a18696703505ed6168a357098bf4))
- no gleam, the generated js is awkward to use ([01528b6](https://github.com/defn/dev/commit/01528b68c870795eabde0621b0f54766ae1c1078))
- no global tasks, mise deadlocks ([e71b6b9](https://github.com/defn/dev/commit/e71b6b90d8bdbde831fcf5c10e29e9970e8bfc62))
- no temporal try riverqueue ([3802da5](https://github.com/defn/dev/commit/3802da547c91811ca66febf382a6ba7974eb84de))
- no temporal, pepr ([f1e30b2](https://github.com/defn/dev/commit/f1e30b204ca42ba14789f4c979dbab0cf57c65af))
- no yaegi ([00b38a3](https://github.com/defn/dev/commit/00b38a3f9fd4d0b4a3b5d9aa45a1ac80e41b544c))
- node in m ([0daf75d](https://github.com/defn/dev/commit/0daf75d2418a45c3a24eee9c6f6d8e853fa3fd8d))
- nodejs is global, too many tools use it ([12fb3a9](https://github.com/defn/dev/commit/12fb3a96b778f7e03f8079333ab6ff54eb48c29c))
- one function to return a value from embed.FS ([15e90ae](https://github.com/defn/dev/commit/15e90aee6cfaea709fb3b20a51745d6ec79df21f))
- only include regular files ([57e3380](https://github.com/defn/dev/commit/57e33806334643efe763b06ebb34b6188ea87bb3))
- os test to run ansible ([fe17e83](https://github.com/defn/dev/commit/fe17e83e7824095dae9ad9b4a11a2e27bfad08a6))
- other way: config.toml is global ([4afdd8e](https://github.com/defn/dev/commit/4afdd8e2bded1e80f68ef03f8a7f3b7888b3763d))
- persist extentions in m/dc ([f293d8d](https://github.com/defn/dev/commit/f293d8dea853187dcdaf80be1c31bb79fd31efe8))
- prefer Cousine font in code-server ([495283c](https://github.com/defn/dev/commit/495283cb1dcbc92dfd1388cdcf23604ad3cb8c1c))
- relax go.mod version base ([7c622b6](https://github.com/defn/dev/commit/7c622b6036eaf2e09fd35007a17a2cff43313e26))
- remove .png extension removal from UUID extraction ([f0380b1](https://github.com/defn/dev/commit/f0380b138164b134b0347538aa503ddef54c9828))
- remove bazel link, make mise links for go, cue ([dd835a7](https://github.com/defn/dev/commit/dd835a7b6adcf4e434df0e43e13b20453761ee49))
- remove feh dev container from SSH template ([d45cc3a](https://github.com/defn/dev/commit/d45cc3a050f7ddbeef20b546ab1583b4a7960052))
- remove hardcoded homedir from playbook tasks ([f27c651](https://github.com/defn/dev/commit/f27c651a602d8c866ce237b8459fd07128957184))
- remove hosts ending in -dev from Ansible inventory ([d853fb8](https://github.com/defn/dev/commit/d853fb8f0597a124879f9c73483a1bcdd550d16f))
- rename mise build task to make for macOS compatibility ([378e88f](https://github.com/defn/dev/commit/378e88f410da5399e684fee37bc042afb820da84))
- reuse context ([973ae0a](https://github.com/defn/dev/commit/973ae0a973d287d5c7d0be817de1c1cbe72e78bf))
- run as non-root when looking up mise paths ([4ad5dde](https://github.com/defn/dev/commit/4ad5ddecd03cb05c376884b88b2755e57f48e3d9))
- set original agent url for proxy uri ([9b4a358](https://github.com/defn/dev/commit/9b4a358c3bd5da6b0bca8c2df4136acc178fe780))
- source .env in bash, quiet initial svscan ([c50683f](https://github.com/defn/dev/commit/c50683ff3d090a577c82e5d52a1b5a593c367502))
- stay around long enough for jobs to finish ([2170c51](https://github.com/defn/dev/commit/2170c51f6246ca79fa701ed2d3037a9b1421c576))
- stick around until quit ([6162ede](https://github.com/defn/dev/commit/6162ede9aad2e1ea9a9a9746fbaddbf4246adddd))
- strip embedded prefix ([bd80f06](https://github.com/defn/dev/commit/bd80f06c6849323b0bb83f5d5dbbefc93a9915cd))
- **tui:** calculate heights correctly ([cd0c291](https://github.com/defn/dev/commit/cd0c2916901c69794f8e539150baacbafa8d51d0))
- **tui:** ctrl-c exits ([163eee0](https://github.com/defn/dev/commit/163eee01230e4ccbbed39711a1a8a841a423e323))
- **tui:** toggle quit screens ([aea0c02](https://github.com/defn/dev/commit/aea0c027d35211c816e0630493ff1e677c98c10f))
- typo ([fba74e3](https://github.com/defn/dev/commit/fba74e3435234e023060a79ca5ab46e2fa2ddfb5))
- typo smal-step inventory ([e84883b](https://github.com/defn/dev/commit/e84883b8a6b4d57c8ce500ce9b5efa600955f4b4))
- update claude-setup.sh to properly handle .claude directory ([d45d0ea](https://github.com/defn/dev/commit/d45d0ea9dfd374f5f4f7a79efa587513ced94abe))
- update code wrapper paths ([3167d70](https://github.com/defn/dev/commit/3167d70de055d3563d7ddf20f85446c8b900c03e))
- use defn wrapper ([3560418](https://github.com/defn/dev/commit/3560418f03837393474a941675f19cff4ef46a95))
- use examples and directives ([9195f7b](https://github.com/defn/dev/commit/9195f7b3ba2a5e5fecc4bce18ba9b018a36972db))
- use fly remote builders ([c7aeb77](https://github.com/defn/dev/commit/c7aeb77cab0ef37744979c1b7343a78418d8f38f))
- use Go 1.24.6 in MODULE.bazel for Bazel compatibility ([4ecdaae](https://github.com/defn/dev/commit/4ecdaae879d700de54df7d1310999c7ee7cab3c6))
- use mise.toml for global config ([cbf24bd](https://github.com/defn/dev/commit/cbf24bd5141f145f5e9749aff99f6c3f699a3125))
- use sorted order instead of shuffle for w-gallery global view ([8f25d7c](https://github.com/defn/dev/commit/8f25d7c76d7b146225a11defe1a923e47da82225))
- validate cue inputs ([5f5c0ad](https://github.com/defn/dev/commit/5f5c0ad10924d0d821affeffd73c2e9a597edb95))
- with-env to load inner targets ([a3eac50](https://github.com/defn/dev/commit/a3eac50842d7704280caa61e7a8ec92c5ac0a099))
- zdiff3 doesnt work everywhere ([788c2c7](https://github.com/defn/dev/commit/788c2c765629fc9a18413df597d2f35ceeac9473))

## [1.34.0](https://github.com/defn/dev/compare/v1.33.0...v1.34.0) (2025-08-18)

### Features

- add anchor elements to gallery images for direct linking ([0e5220a](https://github.com/defn/dev/commit/0e5220a175aa278b3cd22b553a4025beeee5ba6b))
- add ansible file cleanup to fixup playbook ([78b092e](https://github.com/defn/dev/commit/78b092edb07a3d01222f55d4681aa572ce13fad3))
- add JavaScript-powered gallery links to per-W.sh ([9680395](https://github.com/defn/dev/commit/9680395136db839bf3b5018363f0bc5ae0b60b76))
- add modal image display for W-gallery mode with x key ([cc01569](https://github.com/defn/dev/commit/cc01569ca7b94b0c51f82cb17ed07a7d39470cc3))
- add python, pip, and npm utilities to fixup playbook ([1f888e4](https://github.com/defn/dev/commit/1f888e473fa4aea75dbd3da29d747fb3771373e4))
- add W-gallery mode navigation to individual image pages ([dede0b7](https://github.com/defn/dev/commit/dede0b7968ad06c6b3ebf72606b5040bea87851a))
- expand w-html gallery processing to include 3-digit week directories ([4acd5c0](https://github.com/defn/dev/commit/4acd5c0e60903a4a3d691f42820fc447fd2c6b8b))
- post-process w-html galleries to set selectMode to W-gallery ([b2bf21a](https://github.com/defn/dev/commit/b2bf21a72749311d50fa0c2dd69db4daefe37081))

### Bug Fixes

- add URL parameters and anchor to W-gallery navigation ([682abd8](https://github.com/defn/dev/commit/682abd8281ae585404f4692c7def27c7e264568c))
- correct UUID extraction for W-gallery mode navigation ([f6c1dc1](https://github.com/defn/dev/commit/f6c1dc133fbc1d412ab969a8af905c4e44c98e02))
- disable autoscroll for W-gallery mode ([b2136d7](https://github.com/defn/dev/commit/b2136d7aacbcd3971b5a8891704f22610f2e32b3))
- extract w-NN prefix from imageSrc path instead of anchor ([8c5fa1f](https://github.com/defn/dev/commit/8c5fa1fe0b84c29c6baafdada2ea5eda5a582210))
- remove .png extension removal from UUID extraction ([f0380b1](https://github.com/defn/dev/commit/f0380b138164b134b0347538aa503ddef54c9828))
- use Go 1.24.6 in MODULE.bazel for Bazel compatibility ([4ecdaae](https://github.com/defn/dev/commit/4ecdaae879d700de54df7d1310999c7ee7cab3c6))
- use sorted order instead of shuffle for w-gallery global view ([8f25d7c](https://github.com/defn/dev/commit/8f25d7c76d7b146225a11defe1a923e47da82225))

## [1.33.0](https://github.com/defn/dev/compare/v1.32.0...v1.33.0) (2025-08-03)

### Features

- add buildkite agent service definitions ([2d051da](https://github.com/defn/dev/commit/2d051da04d8c144228d54664e7d434488b91b69c))
- add cache and work directories to fixup playbook ([bbb5bc5](https://github.com/defn/dev/commit/bbb5bc562397b446c9710acb27da7aee34b773ef))
- add Gemini CLI symlink to fixup playbook ([3b76fd2](https://github.com/defn/dev/commit/3b76fd238df99042d1fb3ed0147c7bb9dd7ad4a6))
- add meh hosts group to Ansible inventory ([f3c94a6](https://github.com/defn/dev/commit/f3c94a60e90e2a3447e0cc2aa03135b69c8e875a))
- add nervous task to CLAUDE.md ([5645475](https://github.com/defn/dev/commit/5645475f4244e920d0876d8e1006fbbeddc79173))
- add Ubuntu Noble support to cloud-hypervisor setup ([2f44058](https://github.com/defn/dev/commit/2f440586594c38b16b933cefa80f64b197235d25))
- expand cloud-hypervisor setup for multiple Noble VMs ([e6d8151](https://github.com/defn/dev/commit/e6d81519aaee5882a507afa4ad91f26d64603d61))

### Bug Fixes

- bump Claude code module version from 2.0.3 to 2.0.5 ([970d929](https://github.com/defn/dev/commit/970d9296c2b9e4493c32ff5b746a6cc3e2699574))
- configure bridge networking for cloud-hypervisor VMs ([140daca](https://github.com/defn/dev/commit/140dacab7e2fa70511e00a998b34d73220982da2))

## [1.32.0](https://github.com/defn/dev/compare/v1.31.0...v1.32.0) (2025-07-27)

### Features

- add coder-login module to Coder templates ([d431673](https://github.com/defn/dev/commit/d431673a5b8b7e16046bf5e5ab5796bf3c807c0e))
- add GitHub to Coder's trusted domains for link protection ([3bbd08f](https://github.com/defn/dev/commit/3bbd08f0aec01a16bae8835b03b214f044d648bf))
- **coder:** Replace Docker volume with host mount for code-server extensions ([9a5f5dc](https://github.com/defn/dev/commit/9a5f5dcf5fcfb8be9f021c8d895213b40de7a9a5))
- expand trusted domains for code-server link protection ([bcfc0e8](https://github.com/defn/dev/commit/bcfc0e8649877e707d8cb898e0264d347db594ed))
- mount Docker socket in Coder Docker template ([370e7ff](https://github.com/defn/dev/commit/370e7ff0cb203e3f9efe3309d458531546180077))
- move trusted domains from coder-server to code-server ([f169d1a](https://github.com/defn/dev/commit/f169d1a4308ed2f57d18233ae7b1810cf3ff8d6a))
- remove devcontainer from Docker template ([3d40eeb](https://github.com/defn/dev/commit/3d40eeb23fe74e0cfe76a678c8ed303f570a8118))
- remove devcontainer from SSH template ([58f1a5a](https://github.com/defn/dev/commit/58f1a5a1f9bd7c8581a2128b1c1258e4a5012c33))
- update coder service and ansible playbook ([d04fd86](https://github.com/defn/dev/commit/d04fd8614b2a5bea2a7fe3508bc4cae1264ab1d0))
- upgrade claude-code module to version 2.0.3 ([1fc23c2](https://github.com/defn/dev/commit/1fc23c20a1315c1ec6cdcacd313322e5454f6748))
- upgrade claude-code module to version 2.0.3 in SSH template ([3cf04d1](https://github.com/defn/dev/commit/3cf04d1359d53e0416795b36bad5cfbc8adfa770))
- upgrade mise packages to latest versions ([f4eb4d9](https://github.com/defn/dev/commit/f4eb4d912d0e9a087efacb0a08456b757c31a4bf))

### Bug Fixes

- **buildkite:** source environment variables and escape token reference ([55c0636](https://github.com/defn/dev/commit/55c0636bb9a2846db14d40ab5b901a1fff72fda6))
- improve dummy target with sudo and error handling ([3b105ea](https://github.com/defn/dev/commit/3b105eab0e99fd8f310a80566f90eee534f531d9))

## [1.31.0](https://github.com/defn/dev/compare/v1.30.0...v1.31.0) (2025-07-24)

### Features

- add Ansible tasks for package hold/unhold management ([213cfdc](https://github.com/defn/dev/commit/213cfdc45d09a3ba9b93775bf72a74397d693d2c))
- add coder delete tasks task to CLAUDE.md ([e0b7094](https://github.com/defn/dev/commit/e0b7094b44eecc4fb2f9fb2c34b5280de1691f9d))
- add GitHub CLI config mount to Docker template ([0cd97b6](https://github.com/defn/dev/commit/0cd97b66e6acd2dc9cc1c1ed33050f6611e2fe26))
- mount host Claude auth and copy credentials in Docker template ([f355e2c](https://github.com/defn/dev/commit/f355e2c597dbd94e15dfd371373f64f554289bd4))
- upgrade mise packages to latest versions ([effc9db](https://github.com/defn/dev/commit/effc9dbcf53e0bdeb60ca77701dfe0550f209fea))

### Bug Fixes

- remove hosts ending in -dev from Ansible inventory ([d853fb8](https://github.com/defn/dev/commit/d853fb8f0597a124879f9c73483a1bcdd550d16f))

## [1.30.0](https://github.com/defn/dev/compare/v1.29.0...v1.30.0) (2025-07-19)

### Features

- add bind mounts to meh devcontainer ([bfbc4bd](https://github.com/defn/dev/commit/bfbc4bd36e443e73885469347be5b102891395f9))
- add Claude Code authentication helper scripts ([0b478fa](https://github.com/defn/dev/commit/0b478fad0b74aef53b6680ff12fcdc46c2f64ed4))
- add Claude configuration volume to docker template ([18f78c1](https://github.com/defn/dev/commit/18f78c167e3dcd0a8374b0e3411a68624a03e2b9))
- add htop package to Ubuntu playbook ([b409f90](https://github.com/defn/dev/commit/b409f90bbc38664c7f5ce9b72d875514ad4dfb6e))
- add iputils-ping package to ubuntu playbook ([bab3301](https://github.com/defn/dev/commit/bab330168533b7b33688c33639c3552ac3850cfd))
- add shared environment directory support ([9c88242](https://github.com/defn/dev/commit/9c882421b8449ba2b0911c497f60e33c59cef18b))
- update Coder templates and add devcontainers CLI support ([bfc718b](https://github.com/defn/dev/commit/bfc718bbbd521cfd4a1321bafa274432d5a13a7a))

### Bug Fixes

- add git pull before claude-setup.sh in docker template ([8048e9a](https://github.com/defn/dev/commit/8048e9a235ce79d376d4c6d211f9f6e01f683b58))
- add sudo to chown command in claude-setup.sh ([a61ab2c](https://github.com/defn/dev/commit/a61ab2c580a18cc4a321323ad5d869f9a35bd910))
- allow Docker installation tasks to fail gracefully in ubuntu playbook ([2e546c8](https://github.com/defn/dev/commit/2e546c8b94669ede643f0e758c65a1583b4e6526))
- correct Docker volume reference in docker template ([17df8cb](https://github.com/defn/dev/commit/17df8cbc321f18b0860bcec44b8098a1ed7aad91))
- disable D-Bus integration in starship to prevent connection errors ([dd0f306](https://github.com/defn/dev/commit/dd0f306e4afc8e5eaf55948daf17ac4a726e502f))
- remove feh dev container from SSH template ([d45cc3a](https://github.com/defn/dev/commit/d45cc3a050f7ddbeef20b546ab1583b4a7960052))
- update claude-setup.sh to properly handle .claude directory ([d45d0ea](https://github.com/defn/dev/commit/d45d0ea9dfd374f5f4f7a79efa587513ced94abe))

## [1.29.0](https://github.com/defn/dev/compare/v1.28.0...v1.29.0) (2025-05-20)

### Features

- install freeze ([0cf9931](https://github.com/defn/dev/commit/0cf993164dd0be84fe34bca395964c79d1ff9053))

### Bug Fixes

- consolidate helm, kubectl, kustomize ([fbb3a5b](https://github.com/defn/dev/commit/fbb3a5bbe2cd949fe62ba1bdc7ee5c3559a6db55))
- no .env, mise parses it bad ([d818d20](https://github.com/defn/dev/commit/d818d20d2f522bf94d51258acced2626980be41b))
- no temporal, pepr ([f1e30b2](https://github.com/defn/dev/commit/f1e30b204ca42ba14789f4c979dbab0cf57c65af))
- node in m ([0daf75d](https://github.com/defn/dev/commit/0daf75d2418a45c3a24eee9c6f6d8e853fa3fd8d))
- nodejs is global, too many tools use it ([12fb3a9](https://github.com/defn/dev/commit/12fb3a96b778f7e03f8079333ab6ff54eb48c29c))

## [1.28.0](https://github.com/defn/dev/compare/v1.27.0...v1.28.0) (2025-05-04)

### Features

- AskQuestion ([779793f](https://github.com/defn/dev/commit/779793f3175d34db10f5fb7fab23cb5d00e73b15))
- atlas cli ([aeb464d](https://github.com/defn/dev/commit/aeb464d5f53f76e364f6a6fb28cebb121d416f08))
- cache vsix ([0d9d857](https://github.com/defn/dev/commit/0d9d857bcaef95bb0e93090432f1495bd23be876))
- go runs a sub-shell ([f9caabe](https://github.com/defn/dev/commit/f9caabe110dccf622d9a7a0b6e17700e91c5b426))
- gollm ([ce565f6](https://github.com/defn/dev/commit/ce565f671fb3d41ab1351c75627e34ad32c13d09))
- gollm as a sub-command ([b756c03](https://github.com/defn/dev/commit/b756c0303c0efa4b2382457a3ddb4da5900dd268))
- install docker-ce with ansible ([95cd8b4](https://github.com/defn/dev/commit/95cd8b4122cae836acddbc0d62889fd6989230f8))
- load .env in m ([e3b5b06](https://github.com/defn/dev/commit/e3b5b0681f767961da1554014ed53ad3b579e5b8))
- **mise:** add python for stable ansible install ([9f07d58](https://github.com/defn/dev/commit/9f07d58866003005a2b9f11577126e3e108e5647))
- output in Markdown ([f8de695](https://github.com/defn/dev/commit/f8de69506e457d688fb68282e95f8fa1e2f1d5b9))
- riverui ([65a98a0](https://github.com/defn/dev/commit/65a98a077af83d6a0ab84fbd5812173377d352dd))
- run bazel bin if go build isnt found ([eb1a6b0](https://github.com/defn/dev/commit/eb1a6b0bc5b972038119a82047684ec1ea749945))
- sals-verifier for some mise packages ([8913186](https://github.com/defn/dev/commit/891318623be65076b42dee133bb1f2f03b6b3665))
- temporal cli ([f64b45c](https://github.com/defn/dev/commit/f64b45c4500dc3a2301e20e01eb1414f3e6c6673))
- use uber/fx ([4f6e7b4](https://github.com/defn/dev/commit/4f6e7b4bd90e15b77042c51b1c89f45e7bac6406))
- watchexec ([e6e3b7a](https://github.com/defn/dev/commit/e6e3b7a408b810c1a0de86a50e7c6a0cf4bd7094))
- working river demo ([d57f992](https://github.com/defn/dev/commit/d57f992773c96aaf3cb9b333db8789fc911d57ef))

### Bug Fixes

- /usr/local/bin is ubuntu owned ([b9c376b](https://github.com/defn/dev/commit/b9c376b0570babb33359178709ca149140b21270))
- be in m to get version context for making symlinks ([50b0cbe](https://github.com/defn/dev/commit/50b0cbef7616d51a4d48cdb223e8e12e6933a86c))
- better names to describe fx ([9186394](https://github.com/defn/dev/commit/9186394f361ea64d6e275e2707f67bb62e19035f))
- dont hairpin to coder when workspace is local ([3803a8f](https://github.com/defn/dev/commit/3803a8f0b5280fa9dfeab90c807171c59d19c2eb))
- dont pull for remote fly builds ([3a7b1f8](https://github.com/defn/dev/commit/3a7b1f8d98e498ffbab003289ddab6a3db5c8e22))
- dont run as root for local symlinks ([699e339](https://github.com/defn/dev/commit/699e339985a72ec71d5298686fe4c1f94dd31cb1))
- gollm build ([7ab403e](https://github.com/defn/dev/commit/7ab403ea36b133b2696ab298913532397742be0a))
- include joyride vsix, no platform specific extensions ([ae297df](https://github.com/defn/dev/commit/ae297df4300e190f66c0fbd2ef37d81f6151e67f))
- move mise fixups after sync ([29debda](https://github.com/defn/dev/commit/29debdab955103c7e212595f9092a37edc3f1277))
- move tasks to m to hide completely ([b6b6b21](https://github.com/defn/dev/commit/b6b6b2153dbeb3aebf8e5309cec5eb6388d55dad))
- no global tasks, mise deadlocks ([e71b6b9](https://github.com/defn/dev/commit/e71b6b90d8bdbde831fcf5c10e29e9970e8bfc62))
- no temporal try riverqueue ([3802da5](https://github.com/defn/dev/commit/3802da547c91811ca66febf382a6ba7974eb84de))
- one function to return a value from embed.FS ([15e90ae](https://github.com/defn/dev/commit/15e90aee6cfaea709fb3b20a51745d6ec79df21f))
- only include regular files ([57e3380](https://github.com/defn/dev/commit/57e33806334643efe763b06ebb34b6188ea87bb3))
- prefer Cousine font in code-server ([495283c](https://github.com/defn/dev/commit/495283cb1dcbc92dfd1388cdcf23604ad3cb8c1c))
- reuse context ([973ae0a](https://github.com/defn/dev/commit/973ae0a973d287d5c7d0be817de1c1cbe72e78bf))
- run as non-root when looking up mise paths ([4ad5dde](https://github.com/defn/dev/commit/4ad5ddecd03cb05c376884b88b2755e57f48e3d9))
- set original agent url for proxy uri ([9b4a358](https://github.com/defn/dev/commit/9b4a358c3bd5da6b0bca8c2df4136acc178fe780))
- source .env in bash, quiet initial svscan ([c50683f](https://github.com/defn/dev/commit/c50683ff3d090a577c82e5d52a1b5a593c367502))
- stay around long enough for jobs to finish ([2170c51](https://github.com/defn/dev/commit/2170c51f6246ca79fa701ed2d3037a9b1421c576))
- stick around until quit ([6162ede](https://github.com/defn/dev/commit/6162ede9aad2e1ea9a9a9746fbaddbf4246adddd))
- strip embedded prefix ([bd80f06](https://github.com/defn/dev/commit/bd80f06c6849323b0bb83f5d5dbbefc93a9915cd))
- use examples and directives ([9195f7b](https://github.com/defn/dev/commit/9195f7b3ba2a5e5fecc4bce18ba9b018a36972db))
- validate cue inputs ([5f5c0ad](https://github.com/defn/dev/commit/5f5c0ad10924d0d821affeffd73c2e9a597edb95))
- zdiff3 doesnt work everywhere ([788c2c7](https://github.com/defn/dev/commit/788c2c765629fc9a18413df597d2f35ceeac9473))

## [1.27.0](https://github.com/defn/dev/compare/v1.26.0...v1.27.0) (2025-04-21)

### Features

- add aws prod in lieu of cde ([f5d7784](https://github.com/defn/dev/commit/f5d77846c397d7e98d1dd7190e87288e703b4038))
- build defn cli if sources change ([238988c](https://github.com/defn/dev/commit/238988c5739a008dab2aad894fb4a32c6e460a7b))
- coder-tunnel s6 is a go program ([7ab6e5d](https://github.com/defn/dev/commit/7ab6e5d87bd8dd5f329717d64f004012e97b053f))
- coracias-caudatus delts theme ([be4be1b](https://github.com/defn/dev/commit/be4be1b14bd976356448d827c10dda8de63335f7))
- cue adds customizations to argocd ([b89ae5f](https://github.com/defn/dev/commit/b89ae5f056522c0764ff8d69671cf8579066aeb7))
- delta for diffs ([001fb51](https://github.com/defn/dev/commit/001fb51d439733723ab651b119586e7761af3da9))
- example go service ([212240a](https://github.com/defn/dev/commit/212240a41816d526d84c3fcde39c43a73a86456b))
- example runs by default ([a970a51](https://github.com/defn/dev/commit/a970a510435d8715e629bd1bc1416201bd8d1491))
- install glow, update docs for glow ([113412e](https://github.com/defn/dev/commit/113412e66967aca5dec376e96f27a689c583b058))
- k3d ([0fd9f44](https://github.com/defn/dev/commit/0fd9f4461ad3e48ffb0882a1a687aa0c368838f8))
- k3d port forwards as s6 services ([a781353](https://github.com/defn/dev/commit/a781353f9770c20cf7a685a5e3b2d7e4f3a05498))
- **mise:** install meteor globally ([8025bdf](https://github.com/defn/dev/commit/8025bdf5d722344a6bf753c9b4a1a7958dad0601))
- **mise:** make mise-list shows dry-run ([fffaf94](https://github.com/defn/dev/commit/fffaf94dbd59f6e078f1aff4f9d34f31b2b62b7a))
- **mise:** make mise-list with upgrade commands ([24b7338](https://github.com/defn/dev/commit/24b7338344cf92224b01b155eb2c2fbd3e0e4dc2))
- run bazel bin if go build isnt found ([5504f8f](https://github.com/defn/dev/commit/5504f8f3867282b7618294cd9901d6327371c891))
- **s6:** tailscaled golang run ([8f41012](https://github.com/defn/dev/commit/8f41012b74afacd205eb41316b72a1a64dbb4c4f))
- **tui:** height tracks terminal resize ([fdaf005](https://github.com/defn/dev/commit/fdaf005c916d11ccb930e2749f208e223c757e1f))
- **tui:** width tracks terminal resizes ([feb6d73](https://github.com/defn/dev/commit/feb6d73b11782bb8c57a78b28b2372024fcf98b8))
- ubuntu 0404 from ([bd9cd14](https://github.com/defn/dev/commit/bd9cd14d166918100a9f5042ba16e8a19560107e))
- use gotdoenv to load .env ([04a8686](https://github.com/defn/dev/commit/04a86866771ca4a0ab450786fda8eff862e3bee2))

### Bug Fixes

- also remove old go, cue links ([7bb1d30](https://github.com/defn/dev/commit/7bb1d30089fe9d6d30da8e8ef55e9acd7038f3dc))
- argocd no longer redirecting ([323e501](https://github.com/defn/dev/commit/323e501841459dbfbb66e1a5fc58a6bfda8823ef))
- cmd build with correct directories ([f853ad3](https://github.com/defn/dev/commit/f853ad3e0e85534d3f8ea9430ab5dc793afac371))
- command/infra is the command, infra is the site config ([d1bc4eb](https://github.com/defn/dev/commit/d1bc4eb602721b9b39b66eb4324488dac6ca8e3b))
- dont actually talk to registries ([9826860](https://github.com/defn/dev/commit/9826860d557310456a7e49b06b101c41a41245a0))
- dont upload with bazel, dont make my cache dirs with scripts ([2fb61da](https://github.com/defn/dev/commit/2fb61dac95fe660113fea29fd20a2a61fcf75cfa))
- executable entrypoint.sh ([b058d3a](https://github.com/defn/dev/commit/b058d3a4a584913277bb9f6b24f2a55f4feee21c))
- fix dyff between by removing namespace ([b0f23d0](https://github.com/defn/dev/commit/b0f23d06ccd068329622fa139fcc08bb495e00d3))
- fq t ([27ca532](https://github.com/defn/dev/commit/27ca532ea0fb0222f97a9367a10e7a8ce2bac259))
- generate bazel for new go programs ([b24551a](https://github.com/defn/dev/commit/b24551aedf17432ae39979cbffdc5bbb5b6e8b37))
- glow is global, always link gitconfig ([c9dc949](https://github.com/defn/dev/commit/c9dc94970a3be99d0cef784d15641eb5b0f18ddc))
- m start work on macos, on not services activated ([792ad40](https://github.com/defn/dev/commit/792ad408e2397c75f74ea35f493acbeaef075622))
- m/dc tailscaled startup and docker permissions ([045aaf3](https://github.com/defn/dev/commit/045aaf38e35d25ffdb0803359ca215119576ec3d))
- **mise:** show unique mise updates ([4a54faa](https://github.com/defn/dev/commit/4a54faaed90b39d5d28bf8bed6605e182463ad91))
- more tools for k3d ([60eef20](https://github.com/defn/dev/commit/60eef20d60b47c999df4aa4cbfed43d2bbd987c7))
- move command up for defn cli build ([c978655](https://github.com/defn/dev/commit/c9786555abbac003580bad81f24415cdd8f2d7d6))
- no gleam, the generated js is awkward to use ([01528b6](https://github.com/defn/dev/commit/01528b68c870795eabde0621b0f54766ae1c1078))
- no yaegi ([00b38a3](https://github.com/defn/dev/commit/00b38a3f9fd4d0b4a3b5d9aa45a1ac80e41b544c))
- other way: config.toml is global ([4afdd8e](https://github.com/defn/dev/commit/4afdd8e2bded1e80f68ef03f8a7f3b7888b3763d))
- relax go.mod version base ([7c622b6](https://github.com/defn/dev/commit/7c622b6036eaf2e09fd35007a17a2cff43313e26))
- remove bazel link, make mise links for go, cue ([dd835a7](https://github.com/defn/dev/commit/dd835a7b6adcf4e434df0e43e13b20453761ee49))
- **tui:** calculate heights correctly ([cd0c291](https://github.com/defn/dev/commit/cd0c2916901c69794f8e539150baacbafa8d51d0))
- **tui:** ctrl-c exits ([163eee0](https://github.com/defn/dev/commit/163eee01230e4ccbbed39711a1a8a841a423e323))
- **tui:** toggle quit screens ([aea0c02](https://github.com/defn/dev/commit/aea0c027d35211c816e0630493ff1e677c98c10f))
- typo smal-step inventory ([e84883b](https://github.com/defn/dev/commit/e84883b8a6b4d57c8ce500ce9b5efa600955f4b4))
- update code wrapper paths ([3167d70](https://github.com/defn/dev/commit/3167d70de055d3563d7ddf20f85446c8b900c03e))
- use mise.toml for global config ([cbf24bd](https://github.com/defn/dev/commit/cbf24bd5141f145f5e9749aff99f6c3f699a3125))
- with-env to load inner targets ([a3eac50](https://github.com/defn/dev/commit/a3eac50842d7704280caa61e7a8ec92c5ac0a099))

## [1.26.0](https://github.com/defn/dev/compare/v1.25.0...v1.26.0) (2025-04-13)

### Features

- consolidate commands under m/cmd ([1a262d3](https://github.com/defn/dev/commit/1a262d3b386d42f74cfae8cc9d0bdacc6fd9033a))
- fly build with just ansible playbook and entrypoint script ([8c9f13f](https://github.com/defn/dev/commit/8c9f13fd24b647995da7099836f092736e545dbb))

### Bug Fixes

- /data/ owned by user ([1e6774b](https://github.com/defn/dev/commit/1e6774b9fd0559878858931e686c3268e6dee796))
- brie is working, with persistent extensions ([86080e7](https://github.com/defn/dev/commit/86080e71f369b3cf92322aaf48a90bb575557162))
- bump base to rebuild for ansible ([d6157c6](https://github.com/defn/dev/commit/d6157c6c817e20a9a86a55c160650c835ed8c78c))
- isolate cdktf to m/infra ([884d768](https://github.com/defn/dev/commit/884d768d4fb8dfa500c5363972426366742821d7))
- no demo ([e1f8288](https://github.com/defn/dev/commit/e1f8288b4903a18696703505ed6168a357098bf4))
- os test to run ansible ([fe17e83](https://github.com/defn/dev/commit/fe17e83e7824095dae9ad9b4a11a2e27bfad08a6))
- persist extentions in m/dc ([f293d8d](https://github.com/defn/dev/commit/f293d8dea853187dcdaf80be1c31bb79fd31efe8))
- remove hardcoded homedir from playbook tasks ([f27c651](https://github.com/defn/dev/commit/f27c651a602d8c866ce237b8459fd07128957184))
- typo ([fba74e3](https://github.com/defn/dev/commit/fba74e3435234e023060a79ca5ab46e2fa2ddfb5))
- use defn wrapper ([3560418](https://github.com/defn/dev/commit/3560418f03837393474a941675f19cff4ef46a95))
- use fly remote builders ([c7aeb77](https://github.com/defn/dev/commit/c7aeb77cab0ef37744979c1b7343a78418d8f38f))

## [1.25.0](https://github.com/defn/dev/compare/v1.24.0...v1.25.0) (2025-04-11)

### Features

- fixup.sh is a playbook ([e7da5a6](https://github.com/defn/dev/commit/e7da5a6454d0aac2a3c64d8524c9696872e19f14))
- m/v just to see what versions changed ([4391f6b](https://github.com/defn/dev/commit/4391f6b3584825bbe5e56c9d08dc69651aea5981))
- make fast since sync is slower ([bbee2b2](https://github.com/defn/dev/commit/bbee2b2dea4aa45cca5a296e9214e07a5e8c49e8))
- make sync runs os playbooks ([8743b4b](https://github.com/defn/dev/commit/8743b4b8a7e8789c119430d239e16287e613b0e6))
- put everthing into make sync ([55cc566](https://github.com/defn/dev/commit/55cc5665075ad71381dab08e9bea68361ea8cbd5))
- remove install.sh ([ad08eeb](https://github.com/defn/dev/commit/ad08eeb88af89aa3d92346c2a30000857257c464))

### Bug Fixes

- ami builder uses make sync ([e8bf6d3](https://github.com/defn/dev/commit/e8bf6d3ddfcfefe4cf5c24e34ac5a4ec742e475d))
- another fq mise ([512ace3](https://github.com/defn/dev/commit/512ace39f0eee141b73a2722df0abaeb953c0f6d))
- bazel wrapper calls bazelisk ([a5ed314](https://github.com/defn/dev/commit/a5ed31465991b2b8e3272e4554f5c810d46aaf78))
- brew s6 on macos, remove mise managed tools ([2b98423](https://github.com/defn/dev/commit/2b98423a45ae37d8c27b4318960e077b74052dac))
- cache docker apt repo key ([5ce8fcb](https://github.com/defn/dev/commit/5ce8fcb7e756c9f85c32e6befaed2cc46f35366c))
- dont hardcode ubuntu in ssh entrypoint ([b03de5f](https://github.com/defn/dev/commit/b03de5fe06dc9a93c4abf429acd714c88e658935))
- dont make /nix for bazel ([491b77d](https://github.com/defn/dev/commit/491b77d8054b2f671280058a9f929b8973c2c724))
- dont use install.sh in docker image ([e1c4032](https://github.com/defn/dev/commit/e1c4032286d270e1a538bd7422c8b189588b010c))
- dont use setsid, not available on macos ([09c5e1c](https://github.com/defn/dev/commit/09c5e1ce03fdfe40644dbae198cd622e7c376c2c))
- downgrade ansible to 11.3.0 because macos x86 ([08dcfdf](https://github.com/defn/dev/commit/08dcfdff3bd5556bacbae6834290cb0b8f0f8938))
- dry apt package installs ([535fa0d](https://github.com/defn/dev/commit/535fa0d2c3b43da09d91d5dcb64c2284e3f96ed2))
- fixup: tighter permissions, skip docker socket ([6ee9f1f](https://github.com/defn/dev/commit/6ee9f1f5b8a11f2ec7d1247d5cf8db626cd07c9c))
- fq path to mise ([ceb6780](https://github.com/defn/dev/commit/ceb678059570074600b8d68d17492d9d3e0970fd))
- fq runmany, try without bash_profile ([4dbf5e8](https://github.com/defn/dev/commit/4dbf5e8bcaba01f8c9d2f73bdfbe60fdfa4561d9))
- install venv earlier ([97bbf78](https://github.com/defn/dev/commit/97bbf7840612bbff72e228a9afe63fed2140ff31))
- line continuation ([adf2a2e](https://github.com/defn/dev/commit/adf2a2e205ae3797d8cca2259620f7543af851c4))
- line continuation in dockerfile ([f64cb52](https://github.com/defn/dev/commit/f64cb52619a2938f405761a6d590e9c7e9d5c8f4))
- make install-package like Dockerfile ([491dc62](https://github.com/defn/dev/commit/491dc621ed848f6ac8aaf351b9c5758241550267))
- make targets should source .bash_profile ([48f244f](https://github.com/defn/dev/commit/48f244fc983bc6446b226f5c2fcc7b0390c5ac88))
- more fq mise ([eac51fa](https://github.com/defn/dev/commit/eac51fa466f07b34cb8df34ef4e2b883e27905f4))
- more fq mise paths ([b54b88b](https://github.com/defn/dev/commit/b54b88be1547cc69e51c259b4c2a8653918263e4))
- need python venv ([7d3d6dc](https://github.com/defn/dev/commit/7d3d6dccb5a09c872af51445eb2ed0938c696fda))
- python3.12-venv for mise python tooling ([3c87b6d](https://github.com/defn/dev/commit/3c87b6d806ef746bc4c738d0c99c8561e289a2f3))
- remove /nix from bazelrc ([bd7182a](https://github.com/defn/dev/commit/bd7182abf442862b60b4111a69a1e38b64f6f164))
- remove bazel-watcher, not available on macos x86 ([a4886db](https://github.com/defn/dev/commit/a4886dbc38ab0a562e24090e1e4c7e7963186665))
- rework fixup.sh and sudo ([5eb689d](https://github.com/defn/dev/commit/5eb689d9075688977058877692ff580a508b5a85))
- run fixup if mise is available ([3e707f1](https://github.com/defn/dev/commit/3e707f19789395cd7da03e286673f8f4c0ad8936))
- run os upgrade, install first ([f43ffa2](https://github.com/defn/dev/commit/f43ffa2dfe454dc12d234fe4f6225195c2c7f1d7))
- separate ami config for m/i docker build ([6a14ea2](https://github.com/defn/dev/commit/6a14ea2c1f194ee7520967239b81be27a5aa0445))
- separate base os, docker, etc installs ([f918f28](https://github.com/defn/dev/commit/f918f28d08e7098f41cd1d487775304624b12979))
- typo in fixup.sh ([90b2895](https://github.com/defn/dev/commit/90b289558078d918eb326af4f8b6482da5d0df70))
- typo mise ([f29c7c2](https://github.com/defn/dev/commit/f29c7c23d872cd775a650b0a58dccf68e2dcc53a))
- working ami build using make sync ([2ee0eb1](https://github.com/defn/dev/commit/2ee0eb1455b2470d91f1bf3cefa30690de6501df))

## [1.24.0](https://github.com/defn/dev/compare/v1.23.0...v1.24.0) (2025-04-08)

### Features

- ansible is global, no language toolchains ([d60d076](https://github.com/defn/dev/commit/d60d076b44bc45172c9b48fbaa835da9b1ca1712))
- ansible m tasks can run from anywhere ([07c1c56](https://github.com/defn/dev/commit/07c1c568f0f007849d155df5e84548168afb7cda))
- bazel 8.1.1 ([6fe68ee](https://github.com/defn/dev/commit/6fe68eefa785dcf32194c2acdf2e43f5bbb9a8fe))
- coder-server playbook ([765cc0d](https://github.com/defn/dev/commit/765cc0dff10048b8960be2210b81c8ebc55e2ecc))
- docker-compose dev shares host docker ([9949a60](https://github.com/defn/dev/commit/9949a6016068b192cca952bb02ca98165dac768e))
- m local to run playbook locally ([d6d8a7e](https://github.com/defn/dev/commit/d6d8a7e0644a5fb34acda06d687c0d8882fd44d3))
- m play, m remote ansible tasks ([2ecc6d2](https://github.com/defn/dev/commit/2ecc6d29e611b87acd38c9358bf3b45d33b9106e))
- m play, remote runs fzf to select inventory ([cd61b4f](https://github.com/defn/dev/commit/cd61b4f33a22e3e440ad75d8fd9edce037651ad4))
- m shell to enter a dockercompose workarea ([0a066b1](https://github.com/defn/dev/commit/0a066b1ab77ea25469b160e85220da4a7c36a255))
- m/dc has an /app/entrypoint.sh ([02a68d8](https://github.com/defn/dev/commit/02a68d8e6c5017a9c39412b051d49255e184a91b))
- m/dc has j down ([e318322](https://github.com/defn/dev/commit/e318322e7af7bedc3987e8ec253de6ef33a2a538))
- m/dc running as s6 service ([81cf693](https://github.com/defn/dev/commit/81cf6932e0bf8ba9f3ddb7d6a363692a530112d4))
- make menu for playbooks ([7d2a63a](https://github.com/defn/dev/commit/7d2a63a3586b8e4cb1bd17010a49a0d3b58789cf))
- move playbooks into m/pb directly ([2626482](https://github.com/defn/dev/commit/262648291d10de43edd0b247211f7c87c562c6c8))
- tasks in their workarea, linked globally ([126ed88](https://github.com/defn/dev/commit/126ed889628a481867a8540729d97a888459d0ee))

### Bug Fixes

- bazel needs golang and python ([dc8cc45](https://github.com/defn/dev/commit/dc8cc45b2e11cfaf64796c6e519e64481972a1a0))
- be sudo to mess with sudo ([40eeea7](https://github.com/defn/dev/commit/40eeea7d4801099a4a5401fa77cba5b3a5bbaaf2))
- dont need redundant server_name ([b04f486](https://github.com/defn/dev/commit/b04f486923c0432122eb16948fe365d85f3f1d77))
- explicit server_name to s6 playbook ([a4840bb](https://github.com/defn/dev/commit/a4840bb2a1a98a83449e39547af2205bf86045ac))
- fail os on ubuntu/debian only playbooks ([3fc02fd](https://github.com/defn/dev/commit/3fc02fd5134f330dfbedf1e7a3efee20d6d9619a))
- fake helm chart version ([7ea7612](https://github.com/defn/dev/commit/7ea7612024c0f260d32cd2ef5e36a4693a463495))
- fall back to /bin/open if browser.sh not found ([631c791](https://github.com/defn/dev/commit/631c791d96d874b261f252c1b7d0c13cffa1c547))
- global ansible.cfg ([8e79ce0](https://github.com/defn/dev/commit/8e79ce0f9175e512b65ca82c6303e786de0cabdb))
- m shell use fzf to select which service ([92b4318](https://github.com/defn/dev/commit/92b4318d9586f9a924c2b0e7fa543cdbcddfb433))
- m/dc j up moved to s6 ([a220cbb](https://github.com/defn/dev/commit/a220cbbc3a7e7c6d21f6ba838f562db3db36f21f))
- m/dc ownership of .config/coderv2 ([8a04c13](https://github.com/defn/dev/commit/8a04c13dd58b356ba9dcd33371ec81a4229cecd8))
- mise upgrades: aws, fzf, cloudflared, wrangler ([1d7254f](https://github.com/defn/dev/commit/1d7254ff6bf33adf10352e3397853706d28de3b2))
- python3 is python ([917ab93](https://github.com/defn/dev/commit/917ab93970f8f3228d7cd1a4cb20e766fb22df52))
- reduce image size by remmoving python ([1c08afd](https://github.com/defn/dev/commit/1c08afd9ea7f8ea05b55a109d6c0914396c5fa7d))
- remove aws config from tool workareas ([82b853d](https://github.com/defn/dev/commit/82b853db55e380613b92a4b077dc35ee08a7d9ff))
- set aws config with profile ([f6e0814](https://github.com/defn/dev/commit/f6e0814f5e263a8559eb8a29e721928dc74ed894))
- start s6-svscan if not running ([c8616c8](https://github.com/defn/dev/commit/c8616c87e1df03a5deee20e4286e42351f87d1e8))
- use /bin/open to prevent loop ([71b0c3e](https://github.com/defn/dev/commit/71b0c3e66696fd4a6b5ac86b41501741a7d92a25))
- vivify m/dc/svc ([0dcdb5d](https://github.com/defn/dev/commit/0dcdb5d5a372f7e6d7dc367e247ac1daa33f30a9))

## [1.23.0](https://github.com/defn/dev/compare/v1.22.0...v1.23.0) (2025-04-06)

### Features

- all aws accounts ([be9519e](https://github.com/defn/dev/commit/be9519edc4eca7ea269a4c40adc8edb522f71f58))
- bazel 7.6.1 ([a230549](https://github.com/defn/dev/commit/a23054938efc2a1173537e56de09862c597790fe))
- build ami with full /home/ubuntu ([7d760bc](https://github.com/defn/dev/commit/7d760bcc482277ed360b99eea369cdce3bd05276))
- chamber aws accounts ([822d711](https://github.com/defn/dev/commit/822d711e8b362142d1b1b82d722aaa73f84af49e))
- configure tailscale ssh devices to ansible ([d73c292](https://github.com/defn/dev/commit/d73c292c1f088b69dd537731285370414ee02005))
- defn-org profile as mise config ([ebbe271](https://github.com/defn/dev/commit/ebbe2715f6146219fd66566a412276cd29999865))
- git files as cue ([f659b9a](https://github.com/defn/dev/commit/f659b9a2f2f807a08b0b639accbd557c4ecb14ce))
- reworking ami image ([b86c51f](https://github.com/defn/dev/commit/b86c51fa9c796d4f12ea2f87d8221f50b27ad80b))

### Bug Fixes

- configure playbooks with defn org aws ([343dc8a](https://github.com/defn/dev/commit/343dc8afac3069032f5900950adf79d68a2b8d73))
- escape id command in make perms ([ca7661e](https://github.com/defn/dev/commit/ca7661e7e33cda52189aa6b036e9d77a0eb1ff39))
- everything is a schema for files ([dcb389d](https://github.com/defn/dev/commit/dcb389d2f3092f6a2dc82078f52990fd67e6a016))
- home is not a bazel config ([1238784](https://github.com/defn/dev/commit/123878407c03dfc600bd5fb5fa26201c0e1d9589))
- move ansible to m/pb to save 500mb ([fb888d7](https://github.com/defn/dev/commit/fb888d7967a90856d81ff218fb279fecda1d0f14))
- move some utils from Brewfile to mise ([d8e0d98](https://github.com/defn/dev/commit/d8e0d9828416afa2bbb822088fd424ae872019eb))
- point aws config at bazel build ([d6382de](https://github.com/defn/dev/commit/d6382de91972b25e886f9c3ce1d5cb3a03bfc79f))
- prototypes are the wrong model for mise ([12cde8c](https://github.com/defn/dev/commit/12cde8c8d101a076d879ea30774a02864e436054))
- remove aichat ([c167a3e](https://github.com/defn/dev/commit/c167a3ec7b30f640c1e235ceb636f95cd80cf2ab))
- remove cookiecutters ([fa59322](https://github.com/defn/dev/commit/fa59322cf938036a8402e72f04e0e692d4274d8b))
- remove godot-game ([50df931](https://github.com/defn/dev/commit/50df9319b0737653156771e8778b7a494a7a1455))
- remove home build ([d1bc353](https://github.com/defn/dev/commit/d1bc35316405e131fa9af5f5adf521ebc8b33a4d))
- remove linkerd demos, local registries ([946b3b4](https://github.com/defn/dev/commit/946b3b449e28b0890f4738e4786ffc9651732c7a))
- remove m/nix ([7a65182](https://github.com/defn/dev/commit/7a6518268642e65128420eacd4e67cd9af770a32))
- remove openvpn, tailscale works on chromebooks ([8ca8a46](https://github.com/defn/dev/commit/8ca8a468e498033c3e325c27547b0b98404e483a))
- remove wut python flake experiment ([06c7de3](https://github.com/defn/dev/commit/06c7de3adf179c74f3079f56ca8cb159a39ababa))
- rename make coder to make ami ([eb465c8](https://github.com/defn/dev/commit/eb465c86675976743e9b6e8294501005fbde9f86))
- reset home in ami ([2104392](https://github.com/defn/dev/commit/21043921ee37d7fb93463778e03f784e71dba386))
- sorting inventory ([a881b08](https://github.com/defn/dev/commit/a881b083368dc7ddb77240234ecbb32204b9f1bf))
- sts on aws sso login ([d6842d3](https://github.com/defn/dev/commit/d6842d38233564fa20a33edae872be0f8aa5a821))
- support open on github codespace ([47f5a96](https://github.com/defn/dev/commit/47f5a96e297fab901db043a54d335ee8eb968f55))

## [1.22.0](https://github.com/defn/dev/compare/v1.21.0...v1.22.0) (2025-04-04)

### Features

- profile, region functions for aws ([f43b866](https://github.com/defn/dev/commit/f43b86651c9a04995d4794569421ccb07d59af37))
- s6 playbook to symlink and write .env file for s6 service ([8728b3b](https://github.com/defn/dev/commit/8728b3baf5bf2bf593720bccf4220f8de5f77cd6))

### Bug Fixes

- aws config is only aws sso profiles ([c730b21](https://github.com/defn/dev/commit/c730b212409e15ec8aa138f60f8dc1301107672e))
- dont show gcloud in prompt ([82f0624](https://github.com/defn/dev/commit/82f0624ba6943674ba871845416cce7a1535d74e))
- get parameters in check mode ([47af2fe](https://github.com/defn/dev/commit/47af2fec6fd554dc3b52744d84e4cc8662273c19))
- let environment setup the links and storage ([2a98a30](https://github.com/defn/dev/commit/2a98a307acea96f1682e63a864bf196fba9a5f9e))
- mise exec fly ([64a10d0](https://github.com/defn/dev/commit/64a10d0816260ea29ecc5f010940e30e984201d4))
- mise upgrades ([ddca603](https://github.com/defn/dev/commit/ddca6039834f21c5fac6664a14ad4cc42d531bce))
- no default region ([be44a0c](https://github.com/defn/dev/commit/be44a0c4769b4d67e8ddb59f8038d9314f8ca1d5))
- no tailscale on fly ([c40eac7](https://github.com/defn/dev/commit/c40eac7e74495c5f75b3fbd7a922501dec4de961))
- pull the latest docker image before building flies ([f599813](https://github.com/defn/dev/commit/f59981300a81814334c25ca21a82bb9faad30537))
- s6 playbook applies to all ([60497ce](https://github.com/defn/dev/commit/60497cedcb85b4d1f7a622b2ea3b45f7ee818786))
- sudo for tailscale dirs ([9744739](https://github.com/defn/dev/commit/974473999003206c7d67c7d2f37b280f29f9a323))
- trunk upgrade ([7a3194e](https://github.com/defn/dev/commit/7a3194e08a9451392e3e85b617dfce8b31dce942))
- unset region with profile ([f024ddb](https://github.com/defn/dev/commit/f024ddbe16f4bb36bca67b750a7329b18fef1205))
- upgrade aws, flyctl ([dce3b96](https://github.com/defn/dev/commit/dce3b96460c1d365dcc417e570e4c3844fbbbe84))
- use /app for workspace ([5384cc7](https://github.com/defn/dev/commit/5384cc791ea8dc58fcb37119e23e9b2d70cfa24c))

## [1.21.0](https://github.com/defn/dev/compare/v1.20.0...v1.21.0) (2025-04-01)

### Features

- brie, so, the, defn flies are coder servers ([e792560](https://github.com/defn/dev/commit/e7925608d7af75c7fd92107195e84a4b74c4d0b9))
- brie.fly dot io ([89ec8b2](https://github.com/defn/dev/commit/89ec8b267dfb6a8031928c75122b85f3cecc0d14))
- coder templates have subdomain option ([24dd30a](https://github.com/defn/dev/commit/24dd30a9d39cdd23a2494897bcdfb9b8b276a185))
- coder-server config for fly ([91099d4](https://github.com/defn/dev/commit/91099d43c45768e9dc371dccdfad41500d1271ac))
- prefer and link to /data for state ([4d01cde](https://github.com/defn/dev/commit/4d01cde27f586895f24cc8c338397ddbc15fb3c0))
- try using fly.io again ([8761cc8](https://github.com/defn/dev/commit/8761cc81287cd88d718224de8b066b2ca14ebc57))
- Update Coder server docs ([7eebfef](https://github.com/defn/dev/commit/7eebfef85aee4d7f43ce3a731afe6a2bc485e204))

### Bug Fixes

- all the flies are the same ([e0b09dd](https://github.com/defn/dev/commit/e0b09dd8665a6fe94ec9352b9813c43b753ac1fc))
- brie at 2cpu, 4gb, minimum for code-server ([f2d00a4](https://github.com/defn/dev/commit/f2d00a4482d47321291ab40189729adc933ded8a))
- fix hostnames for so, the flies ([b6c783f](https://github.com/defn/dev/commit/b6c783f19e529bd9fe0cb84c6d5bbfddc07bdeb0))
- generate locale in fixup ([813ef84](https://github.com/defn/dev/commit/813ef840cb65fc7481fb3fbdffe789574f215de6))
- start s6 and bring up tailscale client ([d4c9314](https://github.com/defn/dev/commit/d4c93141ae3e9f193f8d413fd68ef4b0655427fd))
- test for /data ([b37fa30](https://github.com/defn/dev/commit/b37fa306ac9dc3ef46d7c6d2db5b8b1739ec9182))

## [1.20.0](https://github.com/defn/dev/compare/v1.19.0...v1.20.0) (2025-03-30)

### Features

- defn cli symlink to bazel build ([cad53f2](https://github.com/defn/dev/commit/cad53f2313fd4369e807180df1591f0f207e4d23))
- Dockerfile syntax at 1.14.0 ([460eb05](https://github.com/defn/dev/commit/460eb050c6ec323dc7b16ad986465e022bc0984c))
- entrypoint.sh setup will start services ([6c7b5b8](https://github.com/defn/dev/commit/6c7b5b89689392e98295aa6880f465546ebd0092))
- install docker-ce ([418f632](https://github.com/defn/dev/commit/418f6325a6b108ebc2bb8ea92727f084f180429c))
- main run script in go ([5c3bd2b](https://github.com/defn/dev/commit/5c3bd2b7244b4974ead0b46ee4fc974d273dbecc))
- remove direnv ([c6263f4](https://github.com/defn/dev/commit/c6263f43f1d2061f9b5060105ad3ec2b05a743be))
- remove nix from Docker build ([863f1ea](https://github.com/defn/dev/commit/863f1ea47d7dc15093ca53eb6e78c1505ec8414d))
- remove ubuntu docker.io, making way for docker-ce ([0750e65](https://github.com/defn/dev/commit/0750e6553ff219f5735d3b828992cfea01c95bb0))
- trying using ibazel/bazel-watcher again ([6f25bc1](https://github.com/defn/dev/commit/6f25bc12115ce002804868dffbe0632b507c26fd))
- use latest dockerfile secrets mounts as env ([24497b8](https://github.com/defn/dev/commit/24497b8898ebfd47329e36364a602402a91fd777))
- use yaegi, keep trying to make it work ([f7d6ab5](https://github.com/defn/dev/commit/f7d6ab5df30e14e5334129a77d14a287d60cd3d6))
- yaegi, dive ([7a0428e](https://github.com/defn/dev/commit/7a0428e5ab4b91e44debecce4921baa1033d5630))

### Bug Fixes

- bazel needs /nix, maybe a cache thing ([f993588](https://github.com/defn/dev/commit/f9935880f04a4aa4fcd59171dfc69a0b2723675b))
- bazel: install skopeo, make cue symlink ([8a3d329](https://github.com/defn/dev/commit/8a3d329e0da9ca2f833cbb619f4b36fc057e4e50))
- cue into $HOME/bin, ignore bin/coder ([8dbd29a](https://github.com/defn/dev/commit/8dbd29ac9ef812fec57cb248e139c50049967195))
- defn points to generic cli ([62c2664](https://github.com/defn/dev/commit/62c2664bc091426926e04080f2e9a6bde6d512fd))
- dont call make home ([ba1f49c](https://github.com/defn/dev/commit/ba1f49c9a38cec342ace45467bbee66d0b6b4f1a))
- download coder to /usr/local/bin ([e20d241](https://github.com/defn/dev/commit/e20d2412f1a0d76242fc48998f4a39087efa10d2))
- mise links in /usr/local/bin ([830b710](https://github.com/defn/dev/commit/830b7109f2e56dbb2f6983be62ee430853aaddf4))
- no bat, something weird about its github release ([2493cd9](https://github.com/defn/dev/commit/2493cd9d6ebe36b08d14cf7bf3d8155e7689cc0d))
- remove docker from base flake ([767ff00](https://github.com/defn/dev/commit/767ff0076a969f192c3fa311e8d8a8945b084693))
- remove nix from bazel builds ([57ae64a](https://github.com/defn/dev/commit/57ae64a27adcdec9d95270b029e1343a06143577))
- remove nix from make install ([22517b5](https://github.com/defn/dev/commit/22517b55c2067b4fa657a022bd7659b06130074e))
- remove nix from Makefiles ([e6f3617](https://github.com/defn/dev/commit/e6f36177d5f0da57d8a238f6763f293f27ae8ac9))
- remove unused coder scripts ([b9541dd](https://github.com/defn/dev/commit/b9541dd7241cb8fff612ede468e959cc4fed1ca5))
- remove yaegi, going with golang ([407909e](https://github.com/defn/dev/commit/407909e421785775833096c02cee909bf0ad5665))
- Revert "fix: no bat, something weird about its github release" ([1092e91](https://github.com/defn/dev/commit/1092e918512648b8f835f4aa22c6cc5bd67d7e8f))
- run yaegi from a well known path ([74a138a](https://github.com/defn/dev/commit/74a138a78f628ea10f6bcc9e4a4e9ee2650e7a45))
- s6 activate in svc dir ([8ea8f89](https://github.com/defn/dev/commit/8ea8f8936e0c72ba576391286c1b6988c2927908))
- ssh workspace template uses entrypoint.sh setup ([e2513ed](https://github.com/defn/dev/commit/e2513ed3ec8f1f114499b44889dbfa313c58a38b))
- symlinks at the end of sync ([62feabd](https://github.com/defn/dev/commit/62feabde4c1807edcd12207987542eaec21d04e8))

## [1.19.0](https://github.com/defn/dev/compare/v1.18.1...v1.19.0) (2025-03-28)

### Features

- mise upgrades: aws, dyff, buildkite-agent, terraform, wrangler, aichat ([79edbd6](https://github.com/defn/dev/commit/79edbd6582ee100e28e022a8d064a18909c09d07))

### Bug Fixes

- sync continues if mise self-update fails ([82aa0f1](https://github.com/defn/dev/commit/82aa0f10f536cfc8ad09d7878a7942cfcb016e40))

## [1.18.1](https://github.com/defn/dev/compare/v1.18.0...v1.18.1) (2025-03-28)

### Bug Fixes

- default to 1000 uid if no sudo user ([a8fd3c4](https://github.com/defn/dev/commit/a8fd3c4a114e0748b8c4f8f2aa66a3873826782f))

## [1.18.0](https://github.com/defn/dev/compare/v1.17.0...v1.18.0) (2025-03-27)

### Features

- ./install.sh works on github codespaces ([dfa21a2](https://github.com/defn/dev/commit/dfa21a232fd828a1c35c86ba2bb1e64f55ba8a30))
- devcontainer ([26726db](https://github.com/defn/dev/commit/26726db7da680620a8a641bae8a45c5dc0762010))
- github codespaces: post-create-command init ([62ff1ce](https://github.com/defn/dev/commit/62ff1ce88e5bf0d0f9d2cbc7f6970f586809497b))
- mise prototypes: go, js, py, k8s, k3d, coder-server, ansible ([6c1599e](https://github.com/defn/dev/commit/6c1599edc2ca9c943a647086c811af38088a94ce))
- persistent dotfiles, coder-extensions in workspaces ([71edc37](https://github.com/defn/dev/commit/71edc37ee7e9c6b371a585d9c7bb51eb1c8d63c1))

### Bug Fixes

- bazel needs k8s tools ([a90da6c](https://github.com/defn/dev/commit/a90da6c1ff279515378c3fb72bec3f111d706643))
- buildkite-agent exe name ([d4aec80](https://github.com/defn/dev/commit/d4aec80f229bb86540b8406d7dd6cacd2af0353e))
- dont return error during post create ([437746d](https://github.com/defn/dev/commit/437746de0a50905f69114b5ddf65ff54314cbb18))
- explicit bash shell for just ([f351b06](https://github.com/defn/dev/commit/f351b065a25973e867c4347f953e69ec6ba2be5d))
- explicit workspaceconfig ([883a8a5](https://github.com/defn/dev/commit/883a8a553bc1ac807e1ed5546718ca9dc217ca65))
- install buildkite agent ([d0602c4](https://github.com/defn/dev/commit/d0602c4c48302e4b4fb4ffbf943eb59125c92169))
- revert back to /workspace ([c87ba0d](https://github.com/defn/dev/commit/c87ba0d08d760df52fa6af9d56618c8360ad7a13))
- set git env vars in docker workspace ([35edcc3](https://github.com/defn/dev/commit/35edcc3d1a50122a708cf787afde5bd2c3bb208e))
- trust workspace before sourcing profile ([6a3a546](https://github.com/defn/dev/commit/6a3a5466cba32d0f52669de03c0df0f68c7ecf30))
- typo exec ([73bf7f8](https://github.com/defn/dev/commit/73bf7f8a5097b619e50c71ffeee3789840a3ca72))
- use bash in post create command ([47c858c](https://github.com/defn/dev/commit/47c858ccd88001910f41f28d3e1d13f132b8354c))
- workspace is under home ([e255a79](https://github.com/defn/dev/commit/e255a79e2393150cd52676cf8edabc8a7fbe2c09))

## [1.17.0](https://github.com/defn/dev/compare/v1.16.0...v1.17.0) (2025-03-26)

### Features

- configure and run s6 services in docker entrypoint ([#184](https://github.com/defn/dev/issues/184)) ([966621d](https://github.com/defn/dev/commit/966621d4abd35f21bfec1f52fa8ec9a49cb23c8f))
- latest images built in m/i ([#186](https://github.com/defn/dev/issues/186)) ([2cd6162](https://github.com/defn/dev/commit/2cd616202c454fbaa695e540822b06763e7c7e62))
- shut up already npm ([afdc41c](https://github.com/defn/dev/commit/afdc41cc9cee4c9a265169984a935bba0327ba9d))
- use latest tag for workspaces ([a222759](https://github.com/defn/dev/commit/a222759c1ac8fd599da0afd7b91af5cc9ae7b5e2))

### Bug Fixes

- bad manifest argument: no dot ([270392d](https://github.com/defn/dev/commit/270392d9a4687e28fe95b6e897e20646ebfc7a5a))
- broken manifest generation command ([bb12765](https://github.com/defn/dev/commit/bb12765dbf704292651435b12ce950365d04619d))
- delete then create manifest ([7675bae](https://github.com/defn/dev/commit/7675bae2f5c41c498b2d9cfe008729eb7a8e58f7))
- dont ammend floating latest manifest ([cdb271e](https://github.com/defn/dev/commit/cdb271e9d0b5cecedf228ae67f39983151e988f3))
- dont delete local image on destroy ([91a6635](https://github.com/defn/dev/commit/91a663597a67caaee535f6cb6450781960dd48f3))
- entrypoint.sh is executable ([914cfdd](https://github.com/defn/dev/commit/914cfddc4867da2e58dcb687e9807db9e13dc215))
- export vars for docker build ([1e923bb](https://github.com/defn/dev/commit/1e923bba2e0094ed7227d0acbc6a3ea11accc42e))
- force image replacement using digest ([0d073f8](https://github.com/defn/dev/commit/0d073f8e41c243386ed7f392df8ddaaf95fb5608))
- force pull with docker_registry to look up sha256 ([e4f975c](https://github.com/defn/dev/commit/e4f975cf6ae150079444c812bfee6254ff6e8501))
- force update: floating tags point to specific tags ([ff97e06](https://github.com/defn/dev/commit/ff97e063cef6f3373b1e75b93a67c2120522ea86))
- wrong image digest name ([b88dcf9](https://github.com/defn/dev/commit/b88dcf9814c544eac45d9949ab14baa2f9bc50d1))

## [1.16.0](https://github.com/defn/dev/compare/v1.15.2...v1.16.0) (2025-03-25)

### Features

- arm64 docker images ([#181](https://github.com/defn/dev/issues/181)) ([c6ea064](https://github.com/defn/dev/commit/c6ea0644501da9e4b9930ba7da9d828adc58a7c9)), closes [#77](https://github.com/defn/dev/issues/77)
- manage s6 from parent dir of svc ([#177](https://github.com/defn/dev/issues/177)) ([91572c1](https://github.com/defn/dev/commit/91572c132248f6637ecc78b4767865cdf18cab7b)), closes [#176](https://github.com/defn/dev/issues/176)

### Bug Fixes

- alt-w on chromeos can close tabs ([566cafb](https://github.com/defn/dev/commit/566cafb2027ed49836df825d7643657b7ae5cd27))
- better caching by moving build args to incremental layers ([#180](https://github.com/defn/dev/issues/180)) ([9fa3a04](https://github.com/defn/dev/commit/9fa3a0484c52c08e2f6478380f485e83af80722a))

## [1.15.2](https://github.com/defn/dev/compare/v1.15.1...v1.15.2) (2025-03-24)

### Bug Fixes

- separate sudo from install scripts ([#174](https://github.com/defn/dev/issues/174)) ([a93dce5](https://github.com/defn/dev/commit/a93dce5752ad0a1dc8756800ca90c25206ddb270))

## [1.15.1](https://github.com/defn/dev/compare/v1.15.0...v1.15.1) (2025-03-24)

### Bug Fixes

- wait for release-tag to be created ([#172](https://github.com/defn/dev/issues/172)) ([d245d0c](https://github.com/defn/dev/commit/d245d0cff7842dac9b63c990328ae18df6c59c85))

## [1.15.0](https://github.com/defn/dev/compare/v1.14.0...v1.15.0) (2025-03-24)

### Features

- m remove to remove an s6 service ([#169](https://github.com/defn/dev/issues/169)) ([1ba5d3e](https://github.com/defn/dev/commit/1ba5d3e936c6de1a1b7b94044a3209a7beecc40b))

## [1.14.0](https://github.com/defn/dev/compare/v1.13.0...v1.14.0) (2025-03-23)

### Features

- m tasks to manage s6 ([#164](https://github.com/defn/dev/issues/164)) ([3df9294](https://github.com/defn/dev/commit/3df9294386c54ab2c54a3564150b1ca19fd03bd7))
- node lts 22, shuffle mise tools ([99c0b75](https://github.com/defn/dev/commit/99c0b7569ea9057afdc1047c43d04a7b2c410048))
- trunk: upgrade cli, yamllint ([4f79cc9](https://github.com/defn/dev/commit/4f79cc9407cc9652507cb890399e5b765c285ea6))
- upgrade mise when running make sync ([#167](https://github.com/defn/dev/issues/167)) ([44fa680](https://github.com/defn/dev/commit/44fa68090040d757f38d475d0b436483609f93a4))

### Bug Fixes

- push release-tagged docker images ([#160](https://github.com/defn/dev/issues/160)) ([e998276](https://github.com/defn/dev/commit/e99827664d44427869e65e8fb494311237ebfc54))
- starship prompt: turn off git icon ([1c7375e](https://github.com/defn/dev/commit/1c7375ee4835b4b236f0436a324c8f7d8d9feaa2))

## [1.13.0](https://github.com/defn/dev/compare/v1.12.1...v1.13.0) (2025-03-23)

### Features

- switch to ghcr.io registry ([9cf0e6b](https://github.com/defn/dev/commit/9cf0e6bb31a9e3d88fda3eafd46d1fc2bf142590))

### Bug Fixes

- rename quay org to defnnn ([700808d](https://github.com/defn/dev/commit/700808dcc5940c203a25ed9d6de09f4ec3556fe3))

## [1.12.1](https://github.com/defn/dev/compare/v1.12.0...v1.12.1) (2025-03-23)

### Bug Fixes

- git fetch to retrieve latest release tags ([accb133](https://github.com/defn/dev/commit/accb133cb0827bf9070370f79a2c719778e9115e))
- just whitespace ([ccc1ad8](https://github.com/defn/dev/commit/ccc1ad80f216b659266e0eae78a0b2283e2662ba))

## [1.12.0](https://github.com/defn/dev/compare/v1.11.0...v1.12.0) (2025-03-23)

### Features

- coder-server env example documents github teams ([#135](https://github.com/defn/dev/issues/135)) ([1fcf96c](https://github.com/defn/dev/commit/1fcf96c96869b6f71faea8f88828118bac6001db))
- install bat ([#133](https://github.com/defn/dev/issues/133)) ([beff1f1](https://github.com/defn/dev/commit/beff1f1b5e9796bbbbcc1a5113470188d74da6fb))
- install chamber cli ([#128](https://github.com/defn/dev/issues/128)) ([2d78da0](https://github.com/defn/dev/commit/2d78da0c145c446ecfce335f13b021fb5ccfb4cf))
- m adhoc task to create an issue and work on it ([#145](https://github.com/defn/dev/issues/145)) ([3a9914b](https://github.com/defn/dev/commit/3a9914b304948b48ce42c7dae9104f87dac87964))
- m pr task to create a pull-request ([#125](https://github.com/defn/dev/issues/125)) ([cc2715b](https://github.com/defn/dev/commit/cc2715b727c754ba370d3fd9423fe8c8ab84036b))
- m work task to work on an issue ([#123](https://github.com/defn/dev/issues/123)) ([522e8bb](https://github.com/defn/dev/commit/522e8bbb8cc3252c9dc2c82393196756dd9fc12c))
- m work will sync main first before creating branch ([eae263b](https://github.com/defn/dev/commit/eae263b888704e383fe278ffcb4c68046ed23926))
- run fixup at the end of sync ([831c3a5](https://github.com/defn/dev/commit/831c3a5f23b008a0ca79e70c05655b0bf3e47a88))
- tagged release images ([#156](https://github.com/defn/dev/issues/156)) ([81dd7c8](https://github.com/defn/dev/commit/81dd7c8bd814a7aad9c82795292e0c7edbb95494))
- upgrade mise managed tools ([#124](https://github.com/defn/dev/issues/124)) ([0006706](https://github.com/defn/dev/commit/00067069f6977d9d5d36cf5b125cad774e42ac9c))

### Bug Fixes

- always git pull during docker build ([1f5bb33](https://github.com/defn/dev/commit/1f5bb3374dd05bde5855033f36d78fefc551098e))
- check if docker socket exists ([6d643cf](https://github.com/defn/dev/commit/6d643cffac86e762fd3f7e32ed122bee06f734c0))
- comment out GSSAPIAuthentication in ssh client config ([#129](https://github.com/defn/dev/issues/129)) ([bc7b329](https://github.com/defn/dev/commit/bc7b3292eb6c749b2c96edb063ada2942e505780))
- docker socket accessible by ubuntu user ([#134](https://github.com/defn/dev/issues/134)) ([e9ca154](https://github.com/defn/dev/commit/e9ca154cc71665ea3f13060a5fc8b98498ac1b2c))
- hide cloudflare tunnel token from command line ([#137](https://github.com/defn/dev/issues/137)) ([1c9b40e](https://github.com/defn/dev/commit/1c9b40e9a1dea410eb0b49fa2c7b1c46fc68a792))
- install mise if missing ([#147](https://github.com/defn/dev/issues/147)) ([5c4d8bc](https://github.com/defn/dev/commit/5c4d8bcb24169e82d07082921bbbc1e857c67397))
- mount /dev/net/tun for tailscale in m/dc ([#136](https://github.com/defn/dev/issues/136)) ([daf2a6e](https://github.com/defn/dev/commit/daf2a6e45b8f8b2a12d94dca5daeae00148c1802))
- only fix ping if it exists ([ea76bf1](https://github.com/defn/dev/commit/ea76bf1c045b41be29f8babcde968462e223aa60))
- ping capabilities so it can work ([#130](https://github.com/defn/dev/issues/130)) ([5e8f971](https://github.com/defn/dev/commit/5e8f971da61a964858f5cbefa1676fddfa3e71fe))
- remove acme.sh certs, dont provide any ([#126](https://github.com/defn/dev/issues/126)) ([ea65fea](https://github.com/defn/dev/commit/ea65feaf858b3adbfca016fd9cc98246336d4cf6))
- remove docker pass, secretservice credential providers ([#131](https://github.com/defn/dev/issues/131)) ([b756efd](https://github.com/defn/dev/commit/b756efd9ab2d2df13e097162f70aca0eb886db0d))
- tailscale service sleeps forever without /dev/net/tun ([4b82b43](https://github.com/defn/dev/commit/4b82b43f59030f6716e0bfd6107f4c6d812349b0))
- use updated base image at quay.io ([#150](https://github.com/defn/dev/issues/150)) ([b80898f](https://github.com/defn/dev/commit/b80898fff25ff10dca5db4a6693b652126fb5aa1))
- warn if locked-down mode is enabled ([#127](https://github.com/defn/dev/issues/127)) ([fb1eea4](https://github.com/defn/dev/commit/fb1eea45731051b3e2675f5a98d6ded9322049d5))
- wrong path to ping ([15dc9d9](https://github.com/defn/dev/commit/15dc9d90a94fa1f85c9094f61012b9889d4c3a25))

## [1.11.0](https://github.com/defn/dev/compare/v1.10.0...v1.11.0) (2025-03-21)

### Features

- base docker image will update to the latest HEAD ([5349b73](https://github.com/defn/dev/commit/5349b73b21ad88491cfb2b4949e943ad2f5860fc))
- create coder server doc and install dependencies in coder tunnel ([#112](https://github.com/defn/dev/issues/112)) ([d2e55e6](https://github.com/defn/dev/commit/d2e55e6ad0bc13b91d02cca30223f8045de32d07)), closes [#106](https://github.com/defn/dev/issues/106)
- docker workspaces ([#119](https://github.com/defn/dev/issues/119)) ([4e7d25d](https://github.com/defn/dev/commit/4e7d25dc84a224d7119e99044ea667a5b519e18d))

### Bug Fixes

- /usr/local/bin/nix chown with correct username ([cbd0d07](https://github.com/defn/dev/commit/cbd0d07c7bcdaecc17ed813280bd049cb3d2f751))
- always build latest without cache ([36e152b](https://github.com/defn/dev/commit/36e152bbef7519ddab46a7f76e53a21ac24b0bf3))
- base image syncs in latest build ([46c789b](https://github.com/defn/dev/commit/46c789baa0a99b60ba35c691e784b3c4da348a0a))
- bin/t working again for honeycomb traces ([#115](https://github.com/defn/dev/issues/115)) ([2bfe475](https://github.com/defn/dev/commit/2bfe4756c11a106c0f07ce7616876b2d89cc46a4))
- bin/t works without buildevents or api token ([34f0892](https://github.com/defn/dev/commit/34f0892eb488ee5821866ba69aae87e98e417b99))
- coreutils on macos, was missing tac ([e13d8ff](https://github.com/defn/dev/commit/e13d8ff909166ebe8c69830975a4f934a03d04b8))
- move nix garbage collection to rehome ([#117](https://github.com/defn/dev/issues/117)) ([59b2d5e](https://github.com/defn/dev/commit/59b2d5e1b8ef010e48a1ba1f911da0b016d363fe))

## [1.10.0](https://github.com/defn/dev/compare/v1.9.0...v1.10.0) (2025-03-16)

### Features

- coder server default github with allowed teams ([#102](https://github.com/defn/dev/issues/102)) ([6611ec0](https://github.com/defn/dev/commit/6611ec0636e86875e6b16c209638bd792334eab7))
- coder server running under s6 ([#97](https://github.com/defn/dev/issues/97)) ([9bd1ddd](https://github.com/defn/dev/commit/9bd1ddd37cd6213a571513a840dd8110ae9b1d3e))
- helm/ 3.17.1 -&gt; 3.17.2 [skip ci] ([72e60d8](https://github.com/defn/dev/commit/72e60d8aa2ddd89f52986c2c8d95c996c8913dc4))

### Bug Fixes

- remove redundant oci flake, unused docker credential helpers ([#101](https://github.com/defn/dev/issues/101)) ([b2edf81](https://github.com/defn/dev/commit/b2edf81027073d629a870b1f2c2f890383847d63))

## [1.9.0](https://github.com/defn/dev/compare/v1.8.0...v1.9.0) (2025-03-15)

### Features

- install tailscale in docker image builds ([#84](https://github.com/defn/dev/issues/84)) ([f9a8ee2](https://github.com/defn/dev/commit/f9a8ee21d90794cde88525b1f1463889157fa582))
- run tailscaled in docker image ([#88](https://github.com/defn/dev/issues/88)) ([59b1af7](https://github.com/defn/dev/commit/59b1af76cb955f68525062a512ebaf1838df5212)), closes [#86](https://github.com/defn/dev/issues/86)
- simple make up dev environment ([#89](https://github.com/defn/dev/issues/89)) ([8b91e24](https://github.com/defn/dev/commit/8b91e240b5497858b4f1338c553b9c17a5521552)), closes [#85](https://github.com/defn/dev/issues/85)

### Bug Fixes

- install minimal docker config if missing ([#81](https://github.com/defn/dev/issues/81)) ([03b95bc](https://github.com/defn/dev/commit/03b95bcea0fe44028ca8684ddeb3f3ad5e1248ea)), closes [#65](https://github.com/defn/dev/issues/65)
- install pass to base images ([#79](https://github.com/defn/dev/issues/79)) ([d6d201c](https://github.com/defn/dev/commit/d6d201cb6a281cca7eb2f207c6ae030a3b9d085f)), closes [#78](https://github.com/defn/dev/issues/78)
- remove docker pass credential store config ([#87](https://github.com/defn/dev/issues/87)) ([8ce9e4c](https://github.com/defn/dev/commit/8ce9e4cc2bade65e506f6beb71a368d629d3f5eb)), closes [#83](https://github.com/defn/dev/issues/83)
- remove make nix from make sync ([#91](https://github.com/defn/dev/issues/91)) ([5354373](https://github.com/defn/dev/commit/535437379f028f630083e9b49196d403c5140c10)), closes [#90](https://github.com/defn/dev/issues/90)
- wrapper kubectl-oidc_login for kubelogin ([#82](https://github.com/defn/dev/issues/82)) ([ee2b2d2](https://github.com/defn/dev/commit/ee2b2d2e3ff71420c92f51b2923249af76ef40d9))

## [1.8.0](https://github.com/defn/dev/compare/v1.7.0...v1.8.0) (2025-03-14)

### Features

- ansible, pipx via mise ([dc4be1e](https://github.com/defn/dev/commit/dc4be1e94ea86fb53b4aa73551b42d11459998f1))
- base flake is gc ([6f04db7](https://github.com/defn/dev/commit/6f04db7baef21f8cc057005ee3348867dd9d21a8))
- build defn/dev with a tag when theres an exact match ([b5a4831](https://github.com/defn/dev/commit/b5a4831bf0bbf194060e0220bc19d2f58ff6c9a2))
- example gleam project ([3ea6427](https://github.com/defn/dev/commit/3ea64279a50545cf527d6c600586b720c094d322))
- focal-20250127 in docker image ([d316718](https://github.com/defn/dev/commit/d31671899b9a20611c20407904a99b5b5c5062ea))
- mise upgrade: aws, helm, wrangler ([eb6169e](https://github.com/defn/dev/commit/eb6169e5cf5b02c9686a52f30e0205da746993e5))

### Bug Fixes

- add mbpro back to inventory ([a5fb99e](https://github.com/defn/dev/commit/a5fb99ef59ecf86332f6e392198515493b89a0cf))
- ansible in global ([aadf6f6](https://github.com/defn/dev/commit/aadf6f68c7ddc1d89f90eae1329c310b048b7f82))
- clear stats at the end of make home ([19ce2c9](https://github.com/defn/dev/commit/19ce2c9831f4e7b558aa8ad17028972d9d9d389a))
- clh can deflare mem balloon, provide net config for ens2 ([ee6bec3](https://github.com/defn/dev/commit/ee6bec301c64ffb6a56a98a3a54776c74670b4ab))
- less noise by skipping formatting ansible playbooks ([69196e8](https://github.com/defn/dev/commit/69196e860742de09420e9da762e104dd2d42c462))
- make rehome cleans nix correctly ([035b0b2](https://github.com/defn/dev/commit/035b0b2faff43a7d0fddb5473829df559faf565e))
- no memory balloon, more cpu, makes nix happy ([6a7a669](https://github.com/defn/dev/commit/6a7a669a0e645cf67745f2cf3e1ce8a64fe702b6))
- no nix in container, doesnt work well ([c246577](https://github.com/defn/dev/commit/c246577cc5d7c21530849ff4ce882f736d336d51))
- remove all nix dirs in home ([3bc79e8](https://github.com/defn/dev/commit/3bc79e8a5a22b6021b32a769714acf2a9ec0afe3))
- remove bazel builds from home install ([ab86041](https://github.com/defn/dev/commit/ab860416856e63e7179963e92187167e73d9c1a6))
- remove hosts that arent up or are slow from default ansible targets ([b4791e1](https://github.com/defn/dev/commit/b4791e16c7d1427c1b4123fff0bd83d3a4c99e06))
- remove rpi5c as cache server, too slow ([353a70c](https://github.com/defn/dev/commit/353a70cbc45c0256c811a904f7aef6d0025fb92a))
- remove semaphore, not ready to use it ([6c2474b](https://github.com/defn/dev/commit/6c2474b6ecc5f54c27b0b76002315f6749eaf6ff))
- sync various install scripts ([8989de2](https://github.com/defn/dev/commit/8989de21ecf10c930a341456eb359ca24f966ac9))
- update home repo after any docker change ([3a5f50b](https://github.com/defn/dev/commit/3a5f50b88df4e21b691cbcec85d13bf2bc810dab))
- use pipx ([c138770](https://github.com/defn/dev/commit/c138770861b2bb805c13fcaba920d079766dc5a1))

## [1.7.0](https://github.com/defn/dev/compare/v1.6.0...v1.7.0) (2025-03-09)

### Features

- cpu-checker to detect virtualization ([ad153b3](https://github.com/defn/dev/commit/ad153b37066824853a6797c43744ee6759b860c9))
- dev container restarts always ([c2e728f](https://github.com/defn/dev/commit/c2e728f4cf0d70c4d15cef95fd9c760a8261a3d6))
- docker-compose dev env with kvm privileges ([67ff1b2](https://github.com/defn/dev/commit/67ff1b23980d34a089d91942c329e9a4c54d9bf9))
- example docker config for containers ([cad47cf](https://github.com/defn/dev/commit/cad47cf03a5bf2890b64ed47e8d074589321aecd))
- home uses base flake via direnv ([561b588](https://github.com/defn/dev/commit/561b588584ce3586b648ecda3e6c5dfd5980fd73))
- move nix bin outside of home to /usr/local/bin/nix ([b82b261](https://github.com/defn/dev/commit/b82b261d2807cec11905e635958d55b42f191434))
- removed base flake from bazel, provide alternative bin/nix generation ([2c7854f](https://github.com/defn/dev/commit/2c7854f7879ffb1037337959658d4fa61ed2bbf1))
- simpler base with separated os, nix, mise ([3e94b66](https://github.com/defn/dev/commit/3e94b6674e7f3c541d53e41b14d85a250d3da786))
- smaller base nix flake ([c88807a](https://github.com/defn/dev/commit/c88807abe4b373a912fe42767bf2258df65c794a))
- starting to split m/dc into separate docker containers for the fam ([89aaf56](https://github.com/defn/dev/commit/89aaf560dcb0cf8764a95a22443d7012e4bb1869))
- tailscaled under s6 ([784b6e6](https://github.com/defn/dev/commit/784b6e6559af6370be751b12591703a451b7e151))
- try out the railway railpack build tool ([573d5ec](https://github.com/defn/dev/commit/573d5ec338ddfba9ab0ce136aaf8d06ecc572464))
- wrangler as a standalone tool ([a99c211](https://github.com/defn/dev/commit/a99c211cfb9976909ecebc8253dd3da1c86958e8))

### Bug Fixes

- browser (open) works with mise code-server ([5a04935](https://github.com/defn/dev/commit/5a049354017b74a602a0acde80f05271b39ed05e))
- cloud hypervisor working on chromebook linux dev env ([40a2dbf](https://github.com/defn/dev/commit/40a2dbf766d80287295adaad4802129d6006f88a))
- coder uses a specific .env.coder for secrets ([a29d349](https://github.com/defn/dev/commit/a29d349c01456affbb4cfd0e1086d46210c5ec62))
- coder, code-server sourcing config corrrectly ([c184685](https://github.com/defn/dev/commit/c184685f539b9faacd6a7c85503d866473cab8a4))
- detach s6 in m serve ([61f41c7](https://github.com/defn/dev/commit/61f41c710f6bf0f20b87f99a2cfcf6e6371b3ca4))
- dont activate main s6 service ([fa8f2de](https://github.com/defn/dev/commit/fa8f2de9a766d539d8e0884459bb466bd893a86d))
- dont build attic in bazel, too long ([4567f39](https://github.com/defn/dev/commit/4567f39f1d9e1a7cf3741dd27cef512e39eccd61))
- dont hardcode gh to bin/nix ([73be4ca](https://github.com/defn/dev/commit/73be4cac3546413fc0172275a3d20b8a00e55d05))
- dont install twice ([1bef289](https://github.com/defn/dev/commit/1bef2890093b46ec30f4935ad2e00ae3411ab612))
- dont need m/.envrc if home is not a direnv flake ([97f52a0](https://github.com/defn/dev/commit/97f52a06defecb5daa3f0ce23253e47aa62e51d5))
- dont set LC_ALL, nix bash hates it ([58fa5d7](https://github.com/defn/dev/commit/58fa5d7c14c3d9a9efe1d40889a6093295fddf87))
- dont use SUDO_ASKPASS ([0da8a83](https://github.com/defn/dev/commit/0da8a8308beb2cdaf45bb5c95d39ef49d89582c1))
- empty .envrc in m to reset ([039f488](https://github.com/defn/dev/commit/039f488b9bdd086e92d765b5bb2a76fde2a9cbe9))
- install tailscale when running tailscaled ([c90bb7b](https://github.com/defn/dev/commit/c90bb7b299273e446426243a07dd1fb2c0f2ab00))
- m server waits for s6 to respond ([a936179](https://github.com/defn/dev/commit/a936179f788d389fbc65ffd31ef57ff504e35ffe))
- missing svc dir in docker image ([877ae0f](https://github.com/defn/dev/commit/877ae0f6ab3857cd78aecce574468c48df5d440d))
- no more direnv in home or m ([57fe086](https://github.com/defn/dev/commit/57fe086d278c687d4108ddd3c9420ae306936933))
- no multi-tenant docker-compose ([ef43970](https://github.com/defn/dev/commit/ef43970f1ad03d0b19e6a1c5d76f7ffae70a6abf))
- prompt on macos, load mise before starship ([2660553](https://github.com/defn/dev/commit/2660553581565ab84bf2190dee6d46898d43fa80))
- provide dig, host, ping commands ([12701c3](https://github.com/defn/dev/commit/12701c33822616175673a84a388f6a7b3a74ae1d))
- remove extra bazel ignore tmp file ([7e7fb74](https://github.com/defn/dev/commit/7e7fb7449d68b44b5e41d713a8d02ff47743197f))
- sync before install to remove mise prompt ([8ddfddf](https://github.com/defn/dev/commit/8ddfddf4afe8d03e9c55c4c809c61d36bbc2cd9e))
- trust direnv and mise install in m ([346fb51](https://github.com/defn/dev/commit/346fb51e28e06f8b62ffebd585ea5aae681d745e))

## [1.6.0](https://github.com/defn/dev/compare/v1.5.0...v1.6.0) (2025-02-28)

### Features

- 10gb ebs root ([b90f4ac](https://github.com/defn/dev/commit/b90f4acce5374940ec28e452e52720ad58a519b2))
- amanibhav.am as a s6 service ([638a257](https://github.com/defn/dev/commit/638a25783034c38e359371065276824937d09b0d))
- AMI does not have defn/dev as HOME ([21a59da](https://github.com/defn/dev/commit/21a59dae181f52907be1902a0d4389a23996b0b9))
- awscli/ 2.24.0 -&gt; 2.24.1 [skip ci] ([56ee01e](https://github.com/defn/dev/commit/56ee01e3f3adab659569a2ae2714619c8b267937))
- awscli/ 2.24.1 -&gt; 2.24.4 [skip ci] ([7c4e81a](https://github.com/defn/dev/commit/7c4e81ad72c59511fed033655447de26dd3e3b81))
- awscli/ 2.24.10 -&gt; 2.24.11 [skip ci] ([a6c1283](https://github.com/defn/dev/commit/a6c12835cb46afeaaeb76583743732d5d0587a4e))
- awscli/ 2.24.4 -&gt; 2.24.5 [skip ci] ([65cf65b](https://github.com/defn/dev/commit/65cf65be328e4e23261cde05140fc06aa9b73ab2))
- awscli/ 2.24.5 -&gt; 2.24.7 [skip ci] ([3819e51](https://github.com/defn/dev/commit/3819e515a5e252c863a8e555c5a70f6c7a6f5b8c))
- awscli/ 2.24.7 -&gt; 2.24.8 [skip ci] ([88cb50c](https://github.com/defn/dev/commit/88cb50ca9890fd47863005b34f849ce458f983d3))
- awscli/ 2.24.8 -&gt; 2.24.9 [skip ci] ([c07d3d8](https://github.com/defn/dev/commit/c07d3d8bc5007c99310929f18e4db2a9d2bb34f5))
- awscli/ 2.24.9 -&gt; 2.24.10 [skip ci] ([7539906](https://github.com/defn/dev/commit/7539906bbfb5d01d138b52ccb015e7b0238dddb9))
- base AMI matches base image ([397a7fc](https://github.com/defn/dev/commit/397a7fc4e1fa99ac8266a690255cf9ec17da054f))
- base ubuntu packages in Docker and install.sh ([73b3579](https://github.com/defn/dev/commit/73b3579e56858df6db06522f7e7355e4222b22da))
- coder is a global tool ([4f2f44b](https://github.com/defn/dev/commit/4f2f44b5cee5f037c96f55337945d0c59412226a))
- codeserver/ 4.96.4 -&gt; 4.97.2 [skip ci] ([20f73c8](https://github.com/defn/dev/commit/20f73c894bb110fd2afaf3b5f8190c18a737ca18))
- docker image starts with s6 ([15b3f11](https://github.com/defn/dev/commit/15b3f11a4374caa18186c954d377141c03921608))
- docker in base ([ca3d523](https://github.com/defn/dev/commit/ca3d523e09f5aae822eb1e4b11e8ee48c8cef0d3))
- docker-compose dev env in m/dc ([f844606](https://github.com/defn/dev/commit/f84460613db0e9a73d0e71feecba4238a5fd0c0b))
- dont use flakes for scripts ([a5ad326](https://github.com/defn/dev/commit/a5ad3269b826bbcaf54ff3e0369facedbd642c83))
- enable dedup on docker zvol ([2ba72af](https://github.com/defn/dev/commit/2ba72afb6257392ae92f6b8c9ca08b040a9243ad))
- go 1.24 ([00ce352](https://github.com/defn/dev/commit/00ce3526c53dda2144f99ab2056d6b64910c602f))
- helm/ 3.17.0 -&gt; 3.17.1 [skip ci] ([8dc4877](https://github.com/defn/dev/commit/8dc487709edbb6caa371e03920875e29505c94c0))
- initial m serve to run s6 ([1bef1f0](https://github.com/defn/dev/commit/1bef1f006b217cc5b4fa5cf026a7caf17b05d185))
- initialize ec2 using a repo script ([9e48664](https://github.com/defn/dev/commit/9e48664c4f2ffd457ed48b7b87459dea0d6cdfcf))
- initialize zpools from s3 ([0616533](https://github.com/defn/dev/commit/0616533cb9389ba8e69bd22a449082f3ee6b6e9e))
- j base to build the base image ([a3aba57](https://github.com/defn/dev/commit/a3aba5793e8aad6ce32a81df636f393839b9fa93))
- k3d, kubectl in m ([f69b9d2](https://github.com/defn/dev/commit/f69b9d2185ff51d11df4efc950da24ddcea6c8ed))
- m has a proper workspace activation script ([b5710a4](https://github.com/defn/dev/commit/b5710a4b738986d4440877e283dffcf0c45c61d6))
- m/i image in terms of m base ([a039452](https://github.com/defn/dev/commit/a0394524503ae7ce3a82f2906e6c17a47429d81c))
- make mise-upgrade to bump all versions ([4cca7df](https://github.com/defn/dev/commit/4cca7dfa8d3cf3874327cc00f5de45213e564fe5))
- make reset to build everything from scratch ([c750200](https://github.com/defn/dev/commit/c750200d77a2c81f7bab1c164bca0f09912e95e1))
- marimo notebooks ([2b0636e](https://github.com/defn/dev/commit/2b0636e6da1c15330dae89b8396cf10eb9337f40))
- marimo notebooks from script ([1db8f87](https://github.com/defn/dev/commit/1db8f873e03e60bb99096bafec4b4e921673fc6a))
- mise/ 2025.2.3 -&gt; 2025.2.4 [skip ci] ([1e0b775](https://github.com/defn/dev/commit/1e0b775defe982d72b61393baddf23f55afc3e26))
- mise/ 2025.2.4 -&gt; 2025.2.6 [skip ci] ([5954e37](https://github.com/defn/dev/commit/5954e37786389671abb785d6c2715a6858b572c6))
- mise/ 2025.2.6 -&gt; 2025.2.7 [skip ci] ([128bae0](https://github.com/defn/dev/commit/128bae0709c8c191811ffc9ea45022ea4e1d8714))
- mise/ 2025.2.7 -&gt; 2025.2.8 [skip ci] ([9bbe7e2](https://github.com/defn/dev/commit/9bbe7e2cbd58f3f1c2863a53e7e95511d671e6e5))
- non-k8s sets a wildcard vscode proxy ([54bd544](https://github.com/defn/dev/commit/54bd54435f72330928f3d496f620d94ac92b183f))
- reduce root disk to 20gb, no initialization beyond zfs ([23b1439](https://github.com/defn/dev/commit/23b143955b7e253b2330475a9cced8f69b608859))
- remove all flakes except base from home install ([a1a21f6](https://github.com/defn/dev/commit/a1a21f62266fa40fbd75b6812120e51a57ede99e))
- run coder, code-server under s6 ([4b33fc4](https://github.com/defn/dev/commit/4b33fc433594b16c5d5bc5b2daefd80d1bac063c))
- run s6-svscan on vscode workspace startup ([74a2560](https://github.com/defn/dev/commit/74a2560d4d804a44574811177ea540e3717609a6))
- s6 ([f1fa5f0](https://github.com/defn/dev/commit/f1fa5f02518e0704bfea0ff9ccbc5db0bcb62122))
- s6-svscan for amanibhav.am ([593a132](https://github.com/defn/dev/commit/593a132f3167392fb03500f2a254d72ff98ba63e))
- script registering tailcale node with oauth ([7f6478d](https://github.com/defn/dev/commit/7f6478d38fb96a3713fb64d9944b7e2027112724))
- sempahoreci cli, agent ([1152797](https://github.com/defn/dev/commit/115279717532adbd0b4462274f0bcf84bfdd8d30))
- shell scripts in m/bin ([92ef533](https://github.com/defn/dev/commit/92ef5339483dd674d85e1fb8d7e408fd841281d4))
- single fn tutorial ([c2f4da5](https://github.com/defn/dev/commit/c2f4da5191f56f797d9001e3db8fcabdafd76a64))
- smaller m/i image starting with just docker ([98ccc01](https://github.com/defn/dev/commit/98ccc0166b7857182c3fc697e7781dc2c32487fe))
- spire/ 1.11.1 -&gt; 1.11.2 [skip ci] ([e42e6ec](https://github.com/defn/dev/commit/e42e6ecbe31cd81571925e257277a39985a27911))
- svc, svc.d system for s6 ([abfbcb8](https://github.com/defn/dev/commit/abfbcb8badf34161fa021d11f7cc9e76c49e7379))
- the main service is special, gets linked by default ([8f1cd93](https://github.com/defn/dev/commit/8f1cd93b0c04ed749f762ffedfdca79d6a32a7a2))
- zfs receive in parallel ([3e44c56](https://github.com/defn/dev/commit/3e44c564edb737a7de02c30b46c47babf4057e4e))

### Bug Fixes

- configure root mise.toml in /root ([9287194](https://github.com/defn/dev/commit/9287194759c4c88baa57a7804f0db39a2fbc6249))
- cue is a global tool ([413bb26](https://github.com/defn/dev/commit/413bb2653083cbe9a6a08cc887f48de59fff3795))
- default to r6id family ([2914dfe](https://github.com/defn/dev/commit/2914dfee98c9092b5fcfa2813a28b2eee4cac25d))
- disable k3d and just run code-server ([1b21bf0](https://github.com/defn/dev/commit/1b21bf0972994f79bca4bbcc1093667d01b01399))
- docker compose doesnt care for the version: field ([6d76c34](https://github.com/defn/dev/commit/6d76c34f7547359b1fe52085b4fdd9619f1049f4))
- docker group addition ([76824f0](https://github.com/defn/dev/commit/76824f00a620d7e77fecaceff6fd77907b51c7e1))
- dont cache dirs that arent flakes ([b952b2d](https://github.com/defn/dev/commit/b952b2de650f38e76e15e1b2f055624f2c3da396))
- dont instal all mise tools in sync ([afeb21c](https://github.com/defn/dev/commit/afeb21c20b0ab691bf04809a09ed7a6add376d8b))
- dont install password-store during install ([dcc74e1](https://github.com/defn/dev/commit/dcc74e19ef741eddc8b95dd0caa3bf92f1f92542))
- dont use nix bash ([4d7fe7c](https://github.com/defn/dev/commit/4d7fe7c5cfef5f815220b244d607f69ddd85c76b))
- fetch zfs snapshots serially ([89e45c7](https://github.com/defn/dev/commit/89e45c7f5651fcb0dad6ffc5a65398b0a2fa718e))
- gh in global ([39afc6b](https://github.com/defn/dev/commit/39afc6b4c96fe56eb182df1e5c08207f379153e3))
- go in m ([21bad93](https://github.com/defn/dev/commit/21bad930033e5ea1485212ff803d875c606a6911))
- helm and cue in m ([aec0ad9](https://github.com/defn/dev/commit/aec0ad98235db1838f05a69623989927fe2b769a))
- ignore aws cloud shell files ([4eee7da](https://github.com/defn/dev/commit/4eee7da8263092587e8c780081177ad4726526b9))
- initialize home repo as ubuntu ([42436b3](https://github.com/defn/dev/commit/42436b3b7b69cf513ccfbc9f23647ef425287475))
- jq in m ([2022bc3](https://github.com/defn/dev/commit/2022bc3dd5d32e00dd794368103ff10ccc1bc50e))
- jq, cue in global ([2d219c8](https://github.com/defn/dev/commit/2d219c8d106ddcf962009b48ba84f86dc6ad7b7f))
- just in global ([c281446](https://github.com/defn/dev/commit/c281446cc193d273828623a512395a0228e86e85))
- just in m ([4f5c011](https://github.com/defn/dev/commit/4f5c011d3219a9d29a6f706c392db00c4033e221))
- kustomize, python in m ([9b1b87e](https://github.com/defn/dev/commit/9b1b87e922c0fd6b41f7dfaa8c1b7edce192803c))
- let bazel run how many jobs it wants ([f757dd5](https://github.com/defn/dev/commit/f757dd5095235dc8a1277d21ec595fbb65247670))
- lower replicate parallel to 10 ([e352e74](https://github.com/defn/dev/commit/e352e744e2ef85a17a3396904913201b7288e517))
- lower replicate parallel to 20 ([8842d6a](https://github.com/defn/dev/commit/8842d6a0d1b4de52448720b2bf6ca98353eeca3a))
- m/i make base-nc rebuilds the public base image ([0476c0b](https://github.com/defn/dev/commit/0476c0b774218ee685f98458fe2fe38af56d4a6e))
- make sync twice to install deps ([7aa81b3](https://github.com/defn/dev/commit/7aa81b3aa6ca4498e39d5cc39c871583f8fc32e2))
- mise run server instead of s6-svscan directly ([5954189](https://github.com/defn/dev/commit/5954189560c9b13748644df6c79b7fe1ad20c628))
- no cache base build to pick up gcloud python deps ([5717ef8](https://github.com/defn/dev/commit/5717ef812bb9cd6fca3bbb9d4c967bc1d5f63f3c))
- no gcloud by default ([c3056f7](https://github.com/defn/dev/commit/c3056f7a639730f0c1a5bbaee19cd29fbfa3a644))
- no gcloud, weird python3 dep ([07b9a6d](https://github.com/defn/dev/commit/07b9a6db547192af4970b9caef97a6db639a7e36))
- no parallel zfs, disk too slow ([b126b44](https://github.com/defn/dev/commit/b126b44af25f586264b43a2afaeb0ddc3d316919))
- node in global ([3ac76de](https://github.com/defn/dev/commit/3ac76de2f6d23406b6c8d56e65dc76752de0d92c))
- pc, rpi4c are not cache hosts ([b8e8887](https://github.com/defn/dev/commit/b8e88870360af8b83545a74cc23c9e37c954e6bf))
- put m/bin in path to get n ([ec70cfb](https://github.com/defn/dev/commit/ec70cfb893bdbe62c9fa8b96f810c42b0d696e1e))
- python is global for gcloud ([30ae5ba](https://github.com/defn/dev/commit/30ae5ba8689188cc5b3f56ddb4651b9432bbba65))
- reduce -x output ([c3c051f](https://github.com/defn/dev/commit/c3c051f2d18fa7a8b85261cdaadfdb836265adba))
- remove all python from nix ([35f3f92](https://github.com/defn/dev/commit/35f3f92499c4fec6ba27fd9e2bac84e973fbdeb7))
- remove pnpm ([dcdba1d](https://github.com/defn/dev/commit/dcdba1d73c7078762061de1b1511e7ecd2deb965))
- remove pnpm from mise tasks ([b8a44e9](https://github.com/defn/dev/commit/b8a44e9fb9868fc46c3e222227aeef2b3c3e6177))
- remove redundant build steps from m/i ([f4d898b](https://github.com/defn/dev/commit/f4d898b233f426a0322a27e575b28bca6988a68f))
- remove unused mise nix flake ([f835a5b](https://github.com/defn/dev/commit/f835a5ba2f01ffa03a9ecd12049762106740d6aa))
- replace awscli flake with aws-cli from mise ([38d204e](https://github.com/defn/dev/commit/38d204e6bdbdf743742282a090305bdc57c1657f))
- run coder agent from user-script script again ([9dad419](https://github.com/defn/dev/commit/9dad4194d34d8054a9620b778b5ba4e1784771f1))
- run coder-agent under mise ([506bae1](https://github.com/defn/dev/commit/506bae11ac17c6bd1b57794f277b7be2e0c05282))
- setsid and no || true to detach from bash parent ([12e1836](https://github.com/defn/dev/commit/12e18364d482b34a2056c898fc4cb6668087a079))
- show stats after all ersgan runs ([9078a62](https://github.com/defn/dev/commit/9078a62e967fff9aa8f4ba2085648d429032c099))
- slow down replicate requests to avoid 429 ([7fac081](https://github.com/defn/dev/commit/7fac081fd7a6a17eca8533a0ff639867f9dc2baf))
- ubuntu home ownership ([daca4cb](https://github.com/defn/dev/commit/daca4cb61116f753d6bc65aaebf8dfbc90952cd9))
- unmount and destroy zfs for docker ([cc80434](https://github.com/defn/dev/commit/cc8043417515e72809e3bacf943e624ad05eff16))
- unset coder git ssh helpers in ci ([1c17ea2](https://github.com/defn/dev/commit/1c17ea2704e203f5566abbfe05c5f34ffbca3c0b))
- use n from path; pjg list dep on gh ([2d9dc31](https://github.com/defn/dev/commit/2d9dc3104d8478152f34cb3f2464bab3c65f44a6))
- vscode proxy uri ([f4f566c](https://github.com/defn/dev/commit/f4f566ce816b50c41d25090d451ed3c271b23ad0))

## [1.5.0](https://github.com/defn/dev/compare/v1.4.0...v1.5.0) (2025-02-10)

### Features

- always update dotfiles ([e5ace54](https://github.com/defn/dev/commit/e5ace5434f9c0c0478dda1b426935faa0206cb89))
- argocd/ 2.13.3 -&gt; 2.13.4 [skip ci] ([e6273a7](https://github.com/defn/dev/commit/e6273a7d7fa92264ceb0082de8497977dd17463b))
- argocd/ 2.13.4 -&gt; 2.14.1 [skip ci] ([2eaf579](https://github.com/defn/dev/commit/2eaf5792db9fb709140f5cfa7fdc1d5075d1a5db))
- awscli/ 2.23.10 -&gt; 2.23.11 [skip ci] ([440e692](https://github.com/defn/dev/commit/440e692138724d47215aa2ce0cac191501a84e8a))
- awscli/ 2.23.11 -&gt; 2.23.12 [skip ci] ([ecf1518](https://github.com/defn/dev/commit/ecf15183696bef785d6a2b1535786003327c3df0))
- awscli/ 2.23.12 -&gt; 2.23.13 [skip ci] ([4fe67ff](https://github.com/defn/dev/commit/4fe67ff41f866bc2ab1ab7fa0262cc2ee78767d6))
- awscli/ 2.23.13 -&gt; 2.23.14 [skip ci] ([8bbe371](https://github.com/defn/dev/commit/8bbe371896f167a53b89be20a9c237d81b14e988))
- awscli/ 2.23.14 -&gt; 2.24.0 [skip ci] ([556b980](https://github.com/defn/dev/commit/556b980c97bd06e04301a8e2269043fd83973814))
- awscli/ 2.23.7 -&gt; 2.23.8 [skip ci] ([b073d96](https://github.com/defn/dev/commit/b073d96d822e412fe9c387702477073f78463a44))
- awscli/ 2.23.8 -&gt; 2.23.9 [skip ci] ([38337a3](https://github.com/defn/dev/commit/38337a32e5d86b2976f6658afa7725a938b04ad7))
- awscli/ 2.23.9 -&gt; 2.23.10 [skip ci] ([7e250a2](https://github.com/defn/dev/commit/7e250a201757b0adc84f10f539cff0edf6e82a10))
- bazel 7.5.0 ([3c726f3](https://github.com/defn/dev/commit/3c726f33cfc5f552949bf78eab744e2dad5fa79b))
- buildifier/ 8.0.1 -&gt; 8.0.2 [skip ci] ([d45a578](https://github.com/defn/dev/commit/d45a578821460fa14e43204c9bbd75e5d25e877d))
- buildifier/ 8.0.2 -&gt; 8.0.3 [skip ci] ([25f71fd](https://github.com/defn/dev/commit/25f71fdb8c3a48232a7b27b4f647e2b6cca4714f))
- buildkite/ 3.90.0 -&gt; 3.91.0 [skip ci] ([61be195](https://github.com/defn/dev/commit/61be1956766d73a8aa0b90ddc417493057e40cb8))
- cloudflared/ 2025.1.0 -&gt; 2025.1.1 [skip ci] ([a5057ce](https://github.com/defn/dev/commit/a5057ce8df8e4d0bcbe5cdcc0e8217d6d1a267e0))
- consolidate utilities flakes into one base flake ([8b810f3](https://github.com/defn/dev/commit/8b810f350025a4d2d8151cad1e4d4f2fbabda88c))
- cue/ 0.11.2 -&gt; 0.12.0 [skip ci] ([6f1e8ae](https://github.com/defn/dev/commit/6f1e8aed0c000334c2355b04723e8c846525ef9b))
- feat: coder 2.19.0 [skip ci] ([a60ce81](https://github.com/defn/dev/commit/a60ce81c0c48479cfbddaf93c5024cd5e1d201fd))
- flyctl/ 0.3.69 -&gt; 0.3.70 [skip ci] ([ca24681](https://github.com/defn/dev/commit/ca246814cdd0fd9a23cc5caa0387fafe7d5f3fb2))
- gh/ 2.65.0 -&gt; 2.66.0 [skip ci] ([f149e22](https://github.com/defn/dev/commit/f149e22e78c04d19999be694ad411ad72362dabf))
- gh/ 2.66.0 -&gt; 2.66.1 [skip ci] ([2746f70](https://github.com/defn/dev/commit/2746f702d49f37f2acf8c807b09a0dc25cd83b68))
- gum/ 0.15.1 -&gt; 0.15.2 [skip ci] ([ee72361](https://github.com/defn/dev/commit/ee72361621879b8e07bd489836d57c709ddfa775))
- install.sh updates to latest defn/dev, trusts mise ([880fbdb](https://github.com/defn/dev/commit/880fbdb2ec742d551653e5add44aa389727e202d))
- kubelogin/ 1.32.1 -&gt; 1.32.2 [skip ci] ([1f40ba4](https://github.com/defn/dev/commit/1f40ba4ff2d8cf0e79682f2b9cd7bf1d146d937c))
- mirrord/ 3.131.0 -&gt; 3.131.2 [skip ci] ([b305666](https://github.com/defn/dev/commit/b305666d2885d27b38ac2b4e8b2e9d1ba3046685))
- mise/ 2025.1.15 -&gt; 2025.1.16 [skip ci] ([633ca44](https://github.com/defn/dev/commit/633ca44f63e84719f498b94b7fb7ae6b42bef3ae))
- mise/ 2025.1.16 -&gt; 2025.1.17 [skip ci] ([9905e7b](https://github.com/defn/dev/commit/9905e7b490d9904236050faed328ef5eb7fe59b6))
- mise/ 2025.1.17 -&gt; 2025.2.0 [skip ci] ([ddbe638](https://github.com/defn/dev/commit/ddbe63841353ee74c3e7a4390264469f9c62db3a))
- mise/ 2025.2.0 -&gt; 2025.2.1 [skip ci] ([3bf1575](https://github.com/defn/dev/commit/3bf1575af4ec85b37124df4fd62c6720fe650a50))
- mise/ 2025.2.1 -&gt; 2025.2.3 [skip ci] ([c4f1999](https://github.com/defn/dev/commit/c4f1999f06311e506cad6e3ba33c1f9a3b7aad11))
- multiple buildkite agents ([f9ac081](https://github.com/defn/dev/commit/f9ac08196e8e24c65acd9dd71a71ae835c124580))
- nghiem family recipes ([f6aca35](https://github.com/defn/dev/commit/f6aca35946c81acf7190c8175cd1c2c023766e6a))
- pin mise versions ([df9f3e0](https://github.com/defn/dev/commit/df9f3e085ba7519912914680dd33586d60fb198a))
- replace more nix flakes with mise ([70dad6a](https://github.com/defn/dev/commit/70dad6a935ddf10eb3b4f328549523d6655b0575))
- replace nix flakes with mise ([e24abec](https://github.com/defn/dev/commit/e24abec004c48777939174a9c5d7f51a9caf5a8c))
- replace some nix flakes with mise tools ([35192c9](https://github.com/defn/dev/commit/35192c9fcd50389143f018f7c1107648ceed2322))
- simple install script ([2c051c6](https://github.com/defn/dev/commit/2c051c6ba3d21789938d8c5420f9e7ab7bfaac11))
- tailscale/ 1.78.1 -&gt; 1.80.0 [skip ci] ([bf74c40](https://github.com/defn/dev/commit/bf74c40a1619bb4a1b6bd74f5620e44c776ae808))
- upgrade(cue) mise ([319905d](https://github.com/defn/dev/commit/319905daf7c467b8bd39668278c8e265327829df))
- workerd/ 1.20250124.3 -&gt; 1.20250129.0 [skip ci] ([e758948](https://github.com/defn/dev/commit/e758948799f42939a5bb20f424f3489005c88aaf))

### Bug Fixes

- close window binding ([06e41fa](https://github.com/defn/dev/commit/06e41fa6df8919faf31875c71c495a1c16f07c78))
- coder uses websockets behind cloudflare ([3d5452b](https://github.com/defn/dev/commit/3d5452b42f27d10f0750f75f9aa4d3e722b4e6e3))
- configure buildkite agents with credentials ([ca9bbe5](https://github.com/defn/dev/commit/ca9bbe5d8a665559416e9dfcb92755af67a79c2b))
- correct xz-utils package name ([d9436ff](https://github.com/defn/dev/commit/d9436ffc1ee045951ff200f6f4771e04a01271d5))
- garbage collect registry images after syncing ([2edaf13](https://github.com/defn/dev/commit/2edaf1336751dd3da222c1ce1a97097cf56b59be))
- install needs build-essential ([f1f16eb](https://github.com/defn/dev/commit/f1f16eb20f5f112e888bec89cdc9445c20e85028))
- install needs curl ([94078ef](https://github.com/defn/dev/commit/94078ef0c8c65fe71cdcdc2f9ec96bdb22ac3023))
- install needs dirmgnr, git ([9dc7f3e](https://github.com/defn/dev/commit/9dc7f3edd546d2ef20a49b4aeaf1a76615d652d3))
- install needs rsync ([be03edb](https://github.com/defn/dev/commit/be03edb903982e3d9537e40392c9ab870d932f68))
- install needs xz ([44640ec](https://github.com/defn/dev/commit/44640ecdf3490e16176b304ca55b7548d99807d0))
- oci needded for bazel builds ([94872df](https://github.com/defn/dev/commit/94872df8071838f6521e86f79a08c64539aa7a1a))
- remove deleted flkes from home build ([ef60b41](https://github.com/defn/dev/commit/ef60b413b3bde43f8be5ca7b26c727ea29c3757d))
- remove flakes: buf, cilium, earthly, flyctl, k3sup openfga, teraformdocs, tfo ([5ad9f19](https://github.com/defn/dev/commit/5ad9f19d4d1ea0d2e6b677ac273f8d3c18f4f2c2))
- source profile to use tools during install ([768e575](https://github.com/defn/dev/commit/768e5750c319ce473010f562557ff9c29c1d5324))
- use a script to get the github token ([0170f6c](https://github.com/defn/dev/commit/0170f6c0227088e26757eece92fbff0193b21c91))

## [1.4.0](https://github.com/defn/dev/compare/v1.3.0...v1.4.0) (2025-01-28)

### Features

- add astro joyride config ([5b805d4](https://github.com/defn/dev/commit/5b805d489ee9b8667115f1b4e60a6f212bb44dd4))
- awscli/ 2.23.2 -&gt; 2.23.3 [skip ci] ([221350f](https://github.com/defn/dev/commit/221350f82de1d18b01d39763d89da5b6b5313407))
- awscli/ 2.23.3 -&gt; 2.23.4 [skip ci] ([a264e3c](https://github.com/defn/dev/commit/a264e3c7235a991f3a0c9d21325e78048fa7251b))
- awscli/ 2.23.4 -&gt; 2.23.5 [skip ci] ([7b0b8bb](https://github.com/defn/dev/commit/7b0b8bb950d31a854859cd11606789f611a49921))
- awscli/ 2.23.5 -&gt; 2.23.6 [skip ci] ([2255536](https://github.com/defn/dev/commit/2255536dec3ba7cab6d18f4b3b8c4784c3640bbf))
- awscli/ 2.23.6 -&gt; 2.23.7 [skip ci] ([1d538cc](https://github.com/defn/dev/commit/1d538ccb3473c6194887ddcc7ff037a12c244f28))
- change me link on every website ([fbf01ac](https://github.com/defn/dev/commit/fbf01ace999d130c3c5b188bdcb266e8cbb7951a))
- coder k8s template autostops by default after 1h ([0d78aed](https://github.com/defn/dev/commit/0d78aed4b4bb948222fdb7bfc5a755d325ea062c))
- codeserver/ 4.96.2 -&gt; 4.96.4 [skip ci] ([c0309dc](https://github.com/defn/dev/commit/c0309dcd91196aa644ca5c5b560e7a28cfc13bf2))
- cue/ 0.11.1 -&gt; 0.11.2 [skip ci] ([aa4da01](https://github.com/defn/dev/commit/aa4da01fee03c0d5cf6672e1c999512f880e50c1))
- enable tutorial on amanibhav.am workspace ([d6b7eda](https://github.com/defn/dev/commit/d6b7edacb51de059cbf3f731494d9403600fc5d7))
- flyctl/ 0.3.64 -&gt; 0.3.65 [skip ci] ([037887f](https://github.com/defn/dev/commit/037887f09d7c3d9e04d0ad29afa6456b918829c6))
- flyctl/ 0.3.65 -&gt; 0.3.66 [skip ci] ([b77e5f6](https://github.com/defn/dev/commit/b77e5f60b4ffe7663fa05c28c462701a619a908f))
- flyctl/ 0.3.66 -&gt; 0.3.67 [skip ci] ([22c2976](https://github.com/defn/dev/commit/22c2976b498c02d20767eb15ca1f87fd61831ba7))
- flyctl/ 0.3.67 -&gt; 0.3.68 [skip ci] ([219bb80](https://github.com/defn/dev/commit/219bb80585909188d50c7d6ca53dbb986900716a))
- flyctl/ 0.3.68 -&gt; 0.3.69 [skip ci] ([88e8e0f](https://github.com/defn/dev/commit/88e8e0f7bc90aabe2562d70e48b3a477a5afee1e))
- goreleaser/ 2.5.1 -&gt; 2.6.0 [skip ci] ([668644f](https://github.com/defn/dev/commit/668644ffc298181bd0c7fd70c5e7b5dc3916a3d9))
- goreleaser/ 2.6.0 -&gt; 2.6.1 [skip ci] ([1a07f1a](https://github.com/defn/dev/commit/1a07f1adf12db7df482756d8e977b12e55b68d1c))
- gum/ 0.15.0 -&gt; 0.15.1 [skip ci] ([e392ead](https://github.com/defn/dev/commit/e392eadeeaaf7ddab76f095ba92a3e5393155631))
- hubble/ 1.16.5 -&gt; 1.16.6 [skip ci] ([1a06e9a](https://github.com/defn/dev/commit/1a06e9a9631bd2494cb809ffb2fd9d3065cff3f8))
- joyride runs tutorial ([18bfa13](https://github.com/defn/dev/commit/18bfa130f22e14ae6f07b47aa6f85f06aadfc4ba))
- just/ 1.38.0 -&gt; 1.39.0 [skip ci] ([b45723b](https://github.com/defn/dev/commit/b45723bed48e7693975705dbf5afbd8a24f85377))
- k3sup/ 0.13.6 -&gt; 0.13.8 [skip ci] ([7c45bfa](https://github.com/defn/dev/commit/7c45bfae396f1dee5e427c117d57e845773e5856))
- kn/ 1.16.1 -&gt; 1.17.0 [skip ci] ([7b35cde](https://github.com/defn/dev/commit/7b35cde03a539fad11e8104a6c87cdfb9ffdd100))
- kubelogin/ 1.32.0 -&gt; 1.32.1 [skip ci] ([045138f](https://github.com/defn/dev/commit/045138ffca46630269976d2eeb91d76099901911))
- kuma/ 2.9.2 -&gt; 2.9.3 [skip ci] ([357c79f](https://github.com/defn/dev/commit/357c79fb87746ad5c7706a74f3eb479f9354ff10))
- linkerd/ 25.1.1 -&gt; 25.1.2 [skip ci] ([e1ed142](https://github.com/defn/dev/commit/e1ed1428a31eaf3e76e225400d687ef6bc7c8c03))
- mirrord/ 3.129.0 -&gt; 3.130.0 [skip ci] ([70af09a](https://github.com/defn/dev/commit/70af09a9cdca83ea5fd09f66d09e675f52ba9f06))
- mirrord/ 3.130.0 -&gt; 3.131.0 [skip ci] ([7a222d1](https://github.com/defn/dev/commit/7a222d1246305286b70b78b2a137d01d17b86563))
- mise up for astro takes --open ([6f0a0ad](https://github.com/defn/dev/commit/6f0a0adeebbe06bb99466a89105e5451649053fd))
- mise/ 2025.1.14 -&gt; 2025.1.15 [skip ci] ([746825d](https://github.com/defn/dev/commit/746825d703efdb5b4d0df4b4c59cdceaa2ee89a5))
- mise/ 2025.1.9 -&gt; 2025.1.14 [skip ci] ([efa99ef](https://github.com/defn/dev/commit/efa99ef70c0c1cdcf11824f4ef8b83d622953661))
- openfga/ 0.6.2 -&gt; 0.6.3 [skip ci] ([35ad870](https://github.com/defn/dev/commit/35ad87015a5ea65265109cbd28a98c6ba8e8acb8))
- optional tutorial mode, create the app_tutorial file ([e788498](https://github.com/defn/dev/commit/e788498a0a5de4728363a41e851156a4ddcdc8a3))
- packer/ 1.11.2 -&gt; 1.12.0 [skip ci] ([36b42d7](https://github.com/defn/dev/commit/36b42d763f3eda8bf7279eedac26279a09472d0c))
- stern/ 1.31.0 -&gt; 1.32.0 [skip ci] ([f27a576](https://github.com/defn/dev/commit/f27a57644d982ac59234ed7e8c1c036291903a1c))
- terraform/ 1.10.4 -&gt; 1.10.5 [skip ci] ([e9f879c](https://github.com/defn/dev/commit/e9f879c75d6be6ef89a96814f888d5712f10120b))
- workerd/ 1.20241230.0 -&gt; 1.20250121.0 [skip ci] ([ddc9cf8](https://github.com/defn/dev/commit/ddc9cf8ec70f195e3e30c496fc1e4aa82ee6ae2c))
- workerd/ 1.20250121.0 -&gt; 1.20250124.0 [skip ci] ([20d5f2b](https://github.com/defn/dev/commit/20d5f2bd7538a61ab819e5f7c9186d7777c14c46))
- workerd/ 1.20250124.0 -&gt; 1.20250124.3 [skip ci] ([a3d28f5](https://github.com/defn/dev/commit/a3d28f5a972f422237ebc78bac4de2c50825670f))

### Bug Fixes

- add on-demand tutorial loader ([760f3db](https://github.com/defn/dev/commit/760f3dbd7738bcb7146343330ea5c4735b4caaa8))
- allowlist .defn.run ([e69553c](https://github.com/defn/dev/commit/e69553c5214065de0036ea912679d02d1a2c5b83))
- build github pages again ([6ee5f02](https://github.com/defn/dev/commit/6ee5f029b478831dc99f6a2ff3f048944e706160))
- create the .app_up file asap ([d1de9da](https://github.com/defn/dev/commit/d1de9da78e8779010b31ebd4db6a54a50f699536))
- docs previwing again ([91f9e7e](https://github.com/defn/dev/commit/91f9e7ef85427e76a9e624a469126d31ecf78134))
- fix amanibhav.am joyride link ([40d71a1](https://github.com/defn/dev/commit/40d71a1b47aba24cd7feccfaed4bd756eed0b961))
- m install disables astro telemetry ([c254a18](https://github.com/defn/dev/commit/c254a18bb31b39a56cae04f6c2d807fd3f4c2557))
- manual tutorial trigger working ([9e683c5](https://github.com/defn/dev/commit/9e683c5547ac73deff8047f0b791721ed2db8ceb))
- only backup is online at all times ([12e090e](https://github.com/defn/dev/commit/12e090e4d3c542c76d26ea934d908dadcc4cd33a))
- remove unused flakes: crossplane, devspace, hugo, kn, minikube, zellij ([a32e728](https://github.com/defn/dev/commit/a32e728c745e3f6a3426a6829ad35b20992a11f9))
- use workspace activate scripts to load tutorial ([3499c0e](https://github.com/defn/dev/commit/3499c0ec7265068fdbcb5f8816f167d54970d94d))

## [1.3.0](https://github.com/defn/dev/compare/v1.2.3...v1.3.0) (2025-01-20)

### Features

- awscli/ 2.23.0 -&gt; 2.23.1 [skip ci] ([5fbef8f](https://github.com/defn/dev/commit/5fbef8f24ad441936805ac08833b3c8661ced278))
- awscli/ 2.23.1 -&gt; 2.23.2 [skip ci] ([11c92a8](https://github.com/defn/dev/commit/11c92a8798ece3b8a214d21586798bc52c5e199d))
- buf/ 1.49.0 -&gt; 1.50.0 [skip ci] ([33a4205](https://github.com/defn/dev/commit/33a4205b552047aebd0210b8efa59b094a2de893))
- ctrl-shift-l to open tutorial ([2fc5d7c](https://github.com/defn/dev/commit/2fc5d7c1a4ab68066d2db08bbe3c18d4176b90e5))
- docker registry clenaup targets ([7161047](https://github.com/defn/dev/commit/716104793b26b3aa20c68322ae61fef63a34b5ed))
- enable docker registry deletion ([767db2b](https://github.com/defn/dev/commit/767db2be684fcaf4302bddbf67d5a9566c21581d))
- k3d/ 5.7.5 -&gt; 5.8.1 [skip ci] ([87b8049](https://github.com/defn/dev/commit/87b80495f816dae770da09b4e1c33b97953c74cb))
- kubelogin/ 1.31.1 -&gt; 1.32.0 [skip ci] ([6191e6c](https://github.com/defn/dev/commit/6191e6c9b2fce9f3f95155363d300435f8fbc3d2))
- kubeseal/ 0.27.3 -&gt; 0.28.0 [skip ci] ([e1d0f0a](https://github.com/defn/dev/commit/e1d0f0acbc71bf7c880d1560e2dd7acd71bac1d9))
- linkerd/ 24.11.8 -&gt; 25.1.1 [skip ci] ([46140f1](https://github.com/defn/dev/commit/46140f1609fa9830c44516edb0da69ae08cf969b))
- make base-nc to build base from scratch ([fd049ae](https://github.com/defn/dev/commit/fd049ae4d57f5f32a44ac1b39c297879c8e4ef73))
- mise/ 2025.1.7 -&gt; 2025.1.8 [skip ci] ([9d43a2c](https://github.com/defn/dev/commit/9d43a2c617791ef01797e347afea3d6461455e5a))
- mise/ 2025.1.8 -&gt; 2025.1.9 [skip ci] ([72c789f](https://github.com/defn/dev/commit/72c789f0631723347ac8336437146e3ba459497f))
- mount .config/gh to cache github logins ([c77ddf9](https://github.com/defn/dev/commit/c77ddf90e08856f4da1dd49928ca6586a0ebd6ab))
- read dev server port from app_port ([bb0ab41](https://github.com/defn/dev/commit/bb0ab410313d5c095b972f7f3d226968484ae976))
- serve gallery with registry ([02d6b0a](https://github.com/defn/dev/commit/02d6b0a86daf8239af2ae6c0d4b40e5cf76df52e))
- startup scripts for coder agent, code-server sidecars ([9118f04](https://github.com/defn/dev/commit/9118f043e0f61d18c50432b016e7ff4c3d77ba13))
- use mise for a bunch of tools instead of flakes ([3a9319b](https://github.com/defn/dev/commit/3a9319bd91e4425ddc484b6529de76698d23bdae))
- use mise for more tools instead of flakes ([789e52b](https://github.com/defn/dev/commit/789e52b8e0a3355792d74bc65471d4c0b84311c7))
- vcluster/ 0.22.1 -&gt; 0.22.3 [skip ci] ([b15f344](https://github.com/defn/dev/commit/b15f3440365a8c27fc25d99792b037ead1ccb19d))

### Bug Fixes

- add nix, nixpkgs-fmt to shell ([0b11f20](https://github.com/defn/dev/commit/0b11f20bf9e2017f7f300b80c3c7cc88645e6ff8))
- all websites can load joyride tutorials ([73fa17c](https://github.com/defn/dev/commit/73fa17c686a3bab34810eab662850d8f774ff0cf))
- always set git ssh command under coder ([9cfd71d](https://github.com/defn/dev/commit/9cfd71ddef3b5b7261d8081ddb8042dacce1c36c))
- code-server needs coder agent config for git ssh ([e36062a](https://github.com/defn/dev/commit/e36062a957489d0b6636a1685f1ab43c29b2e0ab))
- code-server sidecar gets coder url for proxy rewrite ([f3dd91f](https://github.com/defn/dev/commit/f3dd91f2d4bfa274473914d1becf067f3d2f3a88))
- dont manage bazelisk with nix/bazel ([499fc7f](https://github.com/defn/dev/commit/499fc7faab36557715f1497f7a35ea33d833bd95))
- dont show ports message in vscode ([19bb8d2](https://github.com/defn/dev/commit/19bb8d2708d5225d4b1f7a0f7ccdb23d4a3a9567))
- dont use nix profile ([c5b41df](https://github.com/defn/dev/commit/c5b41dfa8540cd1a895983873ecff5c73a3d07b5))
- flake updates use conventional commits [skip ci] ([b81e9af](https://github.com/defn/dev/commit/b81e9aff6f4ac81609f4bacb76a5d73e521e01d2))
- iframe the external, proxied url ([1dd1263](https://github.com/defn/dev/commit/1dd1263dc8457fc26eb7ffdd89d0aaeba98fff1a))
- in ci, dont mess with git ssh command ([d6f7d95](https://github.com/defn/dev/commit/d6f7d95567264c4f6d7d16be2479d376aa33ca7c))
- make nix bootstraps mise, bazelisk, bazel ([780a199](https://github.com/defn/dev/commit/780a1997b40d37af9ff22685f47dc09436ca1934))
- minimal bazel build for website changes ([71a3a77](https://github.com/defn/dev/commit/71a3a77ce325e1eb09c0182abe225b26e4816ff5))
- only mount code-server extensions ([7fb2f66](https://github.com/defn/dev/commit/7fb2f667a189bddd43bda8827df623185c43170c))
- open calls browser.sh in PATH ([ece63bf](https://github.com/defn/dev/commit/ece63bf1b8a351c690d4c2022029aa2d0f144786))
- pin versions of mise tools ([14a47d4](https://github.com/defn/dev/commit/14a47d4788112ad3f130bb803826989c87d0d33a))
- remove coder-amanibhavam-district ([e30b85c](https://github.com/defn/dev/commit/e30b85ccbcf59a7d52f8a952c7c4a67580772121))
- set GITHUB_TOKEN to increase api limits ([794ebfe](https://github.com/defn/dev/commit/794ebfedeeb09852f33632947f6b7e0d6b0c5e8f))
- switch code-server back to nix ([7f4b59c](https://github.com/defn/dev/commit/7f4b59c7ebb8527c5a271f0f6d527730e89f2fbd))
- tofu github.com ssh host key ([cfc9f6a](https://github.com/defn/dev/commit/cfc9f6a89699278add637fca414cbbd0dfadc744))
- tolerate disk pressure for now ([5c2262f](https://github.com/defn/dev/commit/5c2262fb56bd3b8dacffb4b41c69bdc47cd9ede3))
- use .env for GITHUB_TOKEN, bk secrets not working ([b3a82ca](https://github.com/defn/dev/commit/b3a82ca604bd2ad0052a9cf7c862580750aa9576))
- use aqua nushell instead of ubi, which doesnt work ([2c27707](https://github.com/defn/dev/commit/2c277079d7db552d5fc49419bd296da46b6d6c5f))
- use bazelisk via mise ([2ad2240](https://github.com/defn/dev/commit/2ad2240ed1944b83672feafb1b7f9ea5ff0c3f2d))
- wrong place for the toleration ([44c8381](https://github.com/defn/dev/commit/44c838175b2641876acdc840fc0747955cba1f0f))
- zen mode is once shift-ctrl-z ([250f59c](https://github.com/defn/dev/commit/250f59c748cd31c5273eae67ed03179d9e50df09))
- zen mode is shift-ctrl-z twice ([9e55fbc](https://github.com/defn/dev/commit/9e55fbc888e4eb57167ff7f69091cf7e31313b10))

## [1.2.3](https://github.com/defn/dev/compare/v1.1.5...v1.2.3) (2025-01-16)

### Bug Fixes

- wrote some more stuff ([b145d3b](https://github.com/defn/dev/commit/b145d3b659f74b0bfd187a29af1d49b008a80031))

### Miscellaneous Chores

- release 1.2.3 ([b3cac68](https://github.com/defn/dev/commit/b3cac68d8e1a595af63f5cb5cda7ffc0cba2e2e0))

## [1.1.5](https://github.com/defn/dev/compare/v1.1.4...v1.1.5) (2025-01-16)

### Bug Fixes

- upload amanibhav.am static site ([5c5c481](https://github.com/defn/dev/commit/5c5c481a611bc1d61771652c9aa071c1930c33f2))

## [1.1.4](https://github.com/defn/dev/compare/v1.1.3...v1.1.4) (2025-01-16)

### Bug Fixes

- get the release tag ([23ee1bd](https://github.com/defn/dev/commit/23ee1bd863459b3bb00a3b49c5db32f64f7dc6cd))

## [1.1.3](https://github.com/defn/dev/compare/v1.1.2...v1.1.3) (2025-01-16)

### Bug Fixes

- chain release uploads on release created ([81919cd](https://github.com/defn/dev/commit/81919cd51dd7df9a1561faabfb6bbb837156aac1))
- limit permissions for release-please workflow ([3bd9265](https://github.com/defn/dev/commit/3bd9265be8812fe45897331bfd2347b622ff9391))

## [1.1.2](https://github.com/defn/dev/compare/v1.1.1...v1.1.2) (2025-01-16)

### Bug Fixes

- dont use comfyui git submodule ([c8682c9](https://github.com/defn/dev/commit/c8682c957ff6e26e7ad2b60ea9a797bfb850346d))
- release works on any change in main ([dce51a2](https://github.com/defn/dev/commit/dce51a25379b18fc6714055fa05503f1c422ccaf))

## [1.1.1](https://github.com/defn/dev/compare/v1.1.0...v1.1.1) (2025-01-16)

### Bug Fixes

- accumulating more changes ([adc5530](https://github.com/defn/dev/commit/adc553037d1bda0d5e9c1c61d9034fd9300b9948))
- bump ([25dfdf2](https://github.com/defn/dev/commit/25dfdf2d7f43ff685a810a47a2eb3e908a90108c))
- bump bump bump ([761f625](https://github.com/defn/dev/commit/761f625e007aae005e24431d1c4be10b926a78ca))
- fee fii foo fuum ([d870f68](https://github.com/defn/dev/commit/d870f680f2e9e4503fd733c38736196d57ba85a7))
- use a pat ([9813e81](https://github.com/defn/dev/commit/9813e81bd42f63c9de926acf710fc6102c69d7e5))

## [1.1.0](https://github.com/defn/dev/compare/v1.0.2...v1.1.0) (2025-01-16)

### Features

- configure manifest and configuration for updating version.txt ([#29](https://github.com/defn/dev/issues/29)) ([45caa69](https://github.com/defn/dev/commit/45caa697c6e55b48d5132d873a77f0f2cb06d289))
- minimum release-please workflow ([#26](https://github.com/defn/dev/issues/26)) ([d0b233b](https://github.com/defn/dev/commit/d0b233b63605edf01dbd507881c68913a38f7abd))

### Bug Fixes

- bump ([4ee0181](https://github.com/defn/dev/commit/4ee0181d647254e3cecaca6410a174e4d1ee70b7))
- bump ([11b6453](https://github.com/defn/dev/commit/11b64533733f54a52378f43ab4c3412d365aa801))
- bup ([2c34973](https://github.com/defn/dev/commit/2c34973eef060f7ddee222e75626be9c21a6c137))
- release type is simple, configure extra-files ([#30](https://github.com/defn/dev/issues/30)) ([2960261](https://github.com/defn/dev/commit/2960261623418ee82d5a8bd33b9839f39fdaac60))
- remove gha outputs ([ac762db](https://github.com/defn/dev/commit/ac762db74ac375b9696708bdb89a0c9128c7bbad))
- try a simpler template for version ([#33](https://github.com/defn/dev/issues/33)) ([627bd95](https://github.com/defn/dev/commit/627bd952320a94239f4dc7ba8b7773094acf0577))
- upload a release ([e8dea01](https://github.com/defn/dev/commit/e8dea01c07bdd116d83c19be284758529e2d912b))

## [1.0.2](https://github.com/defn/dev/compare/1.0.1...v1.0.2) (2025-01-16)

### Bug Fixes

- bump ([4ee0181](https://github.com/defn/dev/commit/4ee0181d647254e3cecaca6410a174e4d1ee70b7))
- bump ([11b6453](https://github.com/defn/dev/commit/11b64533733f54a52378f43ab4c3412d365aa801))
- remove gha outputs ([ac762db](https://github.com/defn/dev/commit/ac762db74ac375b9696708bdb89a0c9128c7bbad))
- upload a release ([e8dea01](https://github.com/defn/dev/commit/e8dea01c07bdd116d83c19be284758529e2d912b))

## [1.0.1](https://github.com/defn/dev/compare/1.0.0...v1.0.1) (2025-01-16)

### Bug Fixes

- try a simpler template for version ([#33](https://github.com/defn/dev/issues/33)) ([627bd95](https://github.com/defn/dev/commit/627bd952320a94239f4dc7ba8b7773094acf0577))

## [1.1.0](https://github.com/defn/dev/compare/v1.0.0...v1.1.0) (2025-01-16)

### Features

- configure manifest and configuration for updating version.txt ([#29](https://github.com/defn/dev/issues/29)) ([45caa69](https://github.com/defn/dev/commit/45caa697c6e55b48d5132d873a77f0f2cb06d289))
- minimum release-please workflow ([#26](https://github.com/defn/dev/issues/26)) ([d0b233b](https://github.com/defn/dev/commit/d0b233b63605edf01dbd507881c68913a38f7abd))

### Bug Fixes

- release type is simple, configure extra-files ([#30](https://github.com/defn/dev/issues/30)) ([2960261](https://github.com/defn/dev/commit/2960261623418ee82d5a8bd33b9839f39fdaac60))

## 1.0.0 (2025-01-16)

### Features

- minimum release-please workflow ([#26](https://github.com/defn/dev/issues/26)) ([d0b233b](https://github.com/defn/dev/commit/d0b233b63605edf01dbd507881c68913a38f7abd))
