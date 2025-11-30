# .buildkite/

Buildkite CI/CD pipeline configuration for automated builds and deployments.

## Contents

### Pipeline Configuration

- **pipeline.yml** - Generated Buildkite pipeline YAML configuration
- **pipeline.cue** - CUE source for pipeline configuration
- **kubernetes.cue** - Kubernetes deployment configuration in CUE

### Build Automation

- **Makefile** - Pipeline generation and GitHub integration
  - `all` - Generate pipeline.yml and show GitHub diff
  - `pipeline.yml` - Generate YAML from CUE configuration

### Workflow

1. **Development**: Edit `pipeline.cue` to modify CI/CD pipeline
2. **Generation**: Run `make` to generate `pipeline.yml` from CUE source
3. **Review**: Automatic GitHub diff display shows changes
4. **Deployment**: Buildkite reads `pipeline.yml` for execution

The pipeline uses CUE for type-safe configuration management, ensuring consistent and validated CI/CD definitions.
