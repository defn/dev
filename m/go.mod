module github.com/defn/dev/m

go 1.24.5

// pin, otherwise something cue + protobuf breaks
/// https://github.com/cue-lang/cue/blob/master/go.mod
replace github.com/protocolbuffers/txtpbfmt => github.com/protocolbuffers/txtpbfmt v0.0.0-20250129171521-feedd8250727

require (
	cuelang.org/go v0.13.2
	github.com/aws/constructs-go/constructs/v10 v10.4.2
	github.com/aws/jsii-runtime-go v1.112.0
	github.com/bitfield/script v0.24.1
	github.com/cdktf/cdktf-provider-aws-go/aws/v19 v19.65.1
	github.com/charmbracelet/bubbles v0.21.0
	github.com/charmbracelet/bubbletea v1.3.6
	github.com/charmbracelet/lipgloss v1.1.0
	github.com/gin-gonic/gin v1.10.1
	github.com/hashicorp/terraform-cdk-go/cdktf v0.21.0
	github.com/jackc/pgx/v5 v5.7.5
	github.com/joho/godotenv v1.5.1
	github.com/lucasb-eyer/go-colorful v1.2.0
	github.com/muesli/gamut v0.3.1
	github.com/noisysockets/noisysockets v0.28.0
	github.com/riverqueue/river v0.23.1
	github.com/riverqueue/river/riverdriver/riverpgxv5 v0.23.1
	github.com/spf13/cobra v1.9.1
	github.com/spf13/viper v1.20.1
	github.com/teilomillet/gollm v0.1.9
	github.com/urfave/cli/v2 v2.27.7
	go.uber.org/fx v1.24.0
	golang.org/x/sys v0.34.0
)

require (
	cuelabs.dev/go/oci/ociregistry v0.0.0-20250718135225-828513beeb65 // indirect
	dario.cat/mergo v1.0.2 // indirect
	github.com/Masterminds/semver/v3 v3.4.0 // indirect
	github.com/atotto/clipboard v0.1.4 // indirect
	github.com/avast/retry-go/v4 v4.6.1 // indirect
	github.com/aymanbagabas/go-osc52/v2 v2.0.1 // indirect
	github.com/bahlo/generic-list-go v0.2.0 // indirect
	github.com/buger/jsonparser v1.1.1 // indirect
	github.com/bytedance/sonic v1.13.3 // indirect
	github.com/bytedance/sonic/loader v0.3.0 // indirect
	github.com/caarlos0/env/v11 v11.3.1 // indirect
	github.com/charmbracelet/colorprofile v0.3.1 // indirect
	github.com/charmbracelet/x/ansi v0.9.3 // indirect
	github.com/charmbracelet/x/cellbuf v0.0.13 // indirect
	github.com/charmbracelet/x/term v0.2.1 // indirect
	github.com/cloudwego/base64x v0.1.5 // indirect
	github.com/cockroachdb/apd/v3 v3.2.1 // indirect
	github.com/cpuguy83/go-md2man/v2 v2.0.7 // indirect
	github.com/davecgh/go-spew v1.1.1 // indirect
	github.com/dlclark/regexp2 v1.11.5 // indirect
	github.com/emicklei/proto v1.14.2 // indirect
	github.com/erikgeiser/coninput v0.0.0-20211004153227-1c3628e74d0f // indirect
	github.com/fatih/color v1.18.0 // indirect
	github.com/fsnotify/fsnotify v1.9.0 // indirect
	github.com/gabriel-vasile/mimetype v1.4.9 // indirect
	github.com/gin-contrib/sse v1.1.0 // indirect
	github.com/go-playground/locales v0.14.1 // indirect
	github.com/go-playground/universal-translator v0.18.1 // indirect
	github.com/go-playground/validator/v10 v10.27.0 // indirect
	github.com/go-viper/mapstructure/v2 v2.4.0 // indirect
	github.com/goccy/go-json v0.10.5 // indirect
	github.com/google/btree v1.1.3 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/invopop/jsonschema v0.13.0 // indirect
	github.com/itchyny/gojq v0.12.17 // indirect
	github.com/itchyny/timefmt-go v0.1.6 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/puddle/v2 v2.2.2 // indirect
	github.com/jinzhu/copier v0.4.0 // indirect
	github.com/json-iterator/go v1.1.12 // indirect
	github.com/klauspost/cpuid/v2 v2.3.0 // indirect
	github.com/leodido/go-urn v1.4.0 // indirect
	github.com/mailru/easyjson v0.9.0 // indirect
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	github.com/mattn/go-localereader v0.0.1 // indirect
	github.com/mattn/go-runewidth v0.0.16 // indirect
	github.com/miekg/dns v1.1.67 // indirect
	github.com/mitchellh/go-wordwrap v1.0.1 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.2 // indirect
	github.com/muesli/ansi v0.0.0-20230316100256-276c6243b2f6 // indirect
	github.com/muesli/cancelreader v0.2.2 // indirect
	github.com/muesli/clusters v0.0.0-20200529215643-2700303c1762 // indirect
	github.com/muesli/kmeans v0.3.1 // indirect
	github.com/muesli/termenv v0.16.0 // indirect
	github.com/noisysockets/netstack v0.9.0 // indirect
	github.com/noisysockets/netutil v0.9.0 // indirect
	github.com/noisysockets/network v0.23.0 // indirect
	github.com/noisysockets/pinger v0.4.3 // indirect
	github.com/noisysockets/resolver v0.14.2 // indirect
	github.com/noisysockets/util v0.1.0 // indirect
	github.com/opencontainers/go-digest v1.0.0 // indirect
	github.com/opencontainers/image-spec v1.1.1 // indirect
	github.com/pelletier/go-toml/v2 v2.2.4 // indirect
	github.com/pkoukk/tiktoken-go v0.1.7 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/protocolbuffers/txtpbfmt v0.0.0-20250627152318-f293424e46b5 // indirect
	github.com/riverqueue/river/riverdriver v0.23.1 // indirect
	github.com/riverqueue/river/rivershared v0.23.1 // indirect
	github.com/riverqueue/river/rivertype v0.23.1 // indirect
	github.com/rivo/uniseg v0.4.7 // indirect
	github.com/rogpeppe/go-internal v1.14.1 // indirect
	github.com/russross/blackfriday/v2 v2.1.0 // indirect
	github.com/sagikazarmark/locafero v0.9.0 // indirect
	github.com/sahilm/fuzzy v0.1.1 // indirect
	github.com/sourcegraph/conc v0.3.0 // indirect
	github.com/spf13/afero v1.14.0 // indirect
	github.com/spf13/cast v1.9.2 // indirect
	github.com/spf13/pflag v1.0.7 // indirect
	github.com/stretchr/objx v0.5.2 // indirect
	github.com/stretchr/testify v1.10.0 // indirect
	github.com/subosito/gotenv v1.6.0 // indirect
	github.com/tidwall/gjson v1.18.0 // indirect
	github.com/tidwall/match v1.1.1 // indirect
	github.com/tidwall/pretty v1.2.1 // indirect
	github.com/tidwall/sjson v1.2.5 // indirect
	github.com/twitchyliquid64/golang-asm v0.15.1 // indirect
	github.com/ugorji/go/codec v1.3.0 // indirect
	github.com/wk8/go-ordered-map/v2 v2.1.8 // indirect
	github.com/xo/terminfo v0.0.0-20220910002029-abceb7e1c41e // indirect
	github.com/xrash/smetrics v0.0.0-20250705151800-55b8f293f342 // indirect
	github.com/yuin/goldmark v1.7.12 // indirect
	go.uber.org/dig v1.19.0 // indirect
	go.uber.org/goleak v1.3.0 // indirect
	go.uber.org/multierr v1.11.0 // indirect
	go.uber.org/zap v1.27.0 // indirect
	golang.org/x/arch v0.19.0 // indirect
	golang.org/x/crypto v0.40.0 // indirect
	golang.org/x/lint v0.0.0-20241112194109-818c5a804067 // indirect
	golang.org/x/mod v0.26.0 // indirect
	golang.org/x/net v0.42.0 // indirect
	golang.org/x/oauth2 v0.30.0 // indirect
	golang.org/x/sync v0.16.0 // indirect
	golang.org/x/text v0.27.0 // indirect
	golang.org/x/time v0.12.0 // indirect
	golang.org/x/tools v0.35.0 // indirect
	google.golang.org/protobuf v1.36.6 // indirect
	gopkg.in/ini.v1 v1.67.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
	mvdan.cc/sh/v3 v3.12.0 // indirect
)
