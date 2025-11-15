# CUE-to-Bazel Build Generation

This directory demonstrates a declarative approach to generating Bazel BUILD files using CUE as a configuration language and template engine.

**Status**: Fully implemented. The [BUILD.bazel](BUILD.bazel) file is generated from [bazel.cue](bazel.cue) and [build.cue](build.cue).

## The Problem This Solves

Writing Bazel BUILD files by hand is repetitive and error-prone. When you have patterns that repeat across many targets—like normalizing configuration files, creating archive bundles, or generating reports—you end up with hundreds of lines of nearly-identical Starlark code. More importantly, the high-level intent (what you're trying to accomplish) gets obscured by low-level Bazel syntax.

This example shows how to use CUE to:
- Define reusable build patterns at a higher level of abstraction
- Generate consistent, correct BUILD files from declarative models
- Separate "what to build" from "how Bazel should build it"

## Architecture Overview

The system has three layers split across two files:

### Layer 1: Schema Definitions

**Basic types** (`bazel.cue`): Fundamental building blocks for Bazel concepts:
- `#Label`: Bazel label validation (must match `^(:|//).+`)
- `#CfgFile`: A configuration file with a name, path, and content
- `#NormalizeStep`: A transformation that processes raw files into normalized ones
- `#Bundle`: A packaging operation that creates archives with prefixes
- `#Info`: Metadata extraction from archives

**Model schema** (`build.cue`): The complete build specification container:
- `#Model`: Defines the structure for tools, loads, rawFiles, normalize steps, bundles, infos, and aggregated outputs

These types describe *what* you want to build in business terms, not *how* Bazel will build it. For example, you don't think about `genrule` attributes; you think about "I have raw config files that need normalization."

### Layer 2: Concrete Instance (`build.cue`)

The same file that defines the `#Model` schema also creates a concrete instance with actual values:

```cue
m: #Model & {
  rawFiles: [
    { name: "app", path: "raw/app.conf", content: "application configuration settings" },
    { name: "database", path: "raw/database.conf", content: "database connection parameters" },
    // ...
  ]

  normalize: [
    { from: ":raw_configs", index: 1, out: "normalized/app.conf" },
    // ...
  ]

  bundles: [
    { name: "production_config_bundle", srcs: ":normalized_configs", prefix: "prod-configs" },
    // ...
  ]
}
```

Notice how readable this is. It's declarative data, not imperative code. You're describing *what* the build produces, not scripting *how* to produce it. The intent is crystal clear: "We have three raw config files, we normalize them, we bundle them for production and staging environments."

### Layer 3: Transform and Render (`bazel.cue`)

The transformation layer converts the high-level model into normalized Bazel target representations:

1. **Transform**: The model is processed into intermediate target structures (still in CUE):
   - `t_raw`: Creates a single multi-output genrule for raw files
   - `t_norm`: Creates individual genrules for each normalization step
   - `t_norm_group`: Creates a filegroup aggregating normalized outputs
   - `t_reports`: Creates genrules for size reports
   - `t_bundles`: Creates macro invocations for archive creation
   - `t_infos`: Creates macro invocations for metadata extraction
   - `t_all`: Creates a final filegroup aggregating everything

2. **Render**: These intermediate targets are rendered into Starlark syntax:
   - `renderGenrule`: Converts target data into `genrule()` syntax
   - `renderFilegroup`: Converts target data into `filegroup()` syntax
   - `renderArchiveDir`: Converts target data into `archive_directory()` macro syntax
   - `renderArchiveInfo`: Converts target data into `archive_info()` macro syntax

The final `BUILD` field contains the complete generated BUILD file text.

## Why This "Weird Combination" Works

### CUE's Strengths

CUE (Configure Unify Execute) is designed for configuration and data validation. It excels at:

1. **Type Safety**: The schema catches errors before generation. If you reference a nonexistent file or use an invalid label format, CUE fails at validation time, not at Bazel build time.

2. **Unification**: CUE's constraint-based type system means you can define what's valid once, and all instances must conform. No need to manually validate that every genrule has required fields.

3. **Template-Free Templating**: Unlike traditional template languages (Jinja, Mustache), CUE doesn't have the template/data split. The data *is* the program. You manipulate structures with comprehensions and constraints, not string interpolation.

4. **Computed Values**: CUE naturally handles derived data. The `t_norm_group.srcs` field automatically computes its value from `t_norm` targets without manual bookkeeping.

### Why Not Just Write Starlark Macros?

You might ask: "Why not just write Bazel macros?" Several reasons:

1. **Abstraction Level**: Bazel macros operate at the rule level. This approach operates at the pattern level—above individual rules, reasoning about entire build workflows.

2. **Data First**: The model in `build.cue` is pure data. It could be generated from databases, APIs, or other tools. Try generating Starlark function calls programmatically—it's messy.

3. **Validation**: CUE validates the entire model before generation. Bazel only discovers errors during build execution.

4. **Transformation Power**: CUE's comprehensions, let you slice, dice, and reshape data in ways that are awkward in Starlark.

5. **Separation of Concerns**: The model (what to build), schema (what's valid), and rendering (Bazel syntax) are cleanly separated. Each can evolve independently.

## How the Magic Happens

Let's trace a single configuration file through the system:

1. **Declaration** (`build.cue`): You declare a raw file:
   ```cue
   { name: "app", path: "raw/app.conf", content: "application configuration settings" }
   ```

2. **Raw Generation** (`bazel.cue` - `t_raw`): A CUE comprehension iterates over `m.rawFiles` and generates:
   - An output path for the raw file
   - An echo command to create it

   These are collected into a single multi-output genrule.

3. **Normalization** (`bazel.cue` - `t_norm`): Another comprehension creates a genrule that:
   - Depends on the raw genrule (`:raw_configs`)
   - Uses positional indexing to select the specific raw file
   - Invokes the uppercase transformation tool
   - Produces a normalized output

4. **Aggregation** (`bazel.cue` - `t_norm_group`): A comprehension collects all normalized targets into a filegroup, automatically building the `srcs` list by iterating over `t_norm`.

5. **Rendering** (`bazel.cue`): The `renderGenrule` function takes each target structure and generates proper Starlark syntax, handling:
   - String quoting
   - List formatting with proper indentation
   - Optional attributes (srcs, tools) that only appear when present
   - Triple-quoted command strings

6. **Output**: The final `BUILD` field contains valid, formatted Bazel BUILD file text that's written to `BUILD.bazel`.

## The Power of Comprehensions

CUE comprehensions are the secret sauce. They let you write once and generate many:

```cue
t_norm: [
  for i, n in m.normalize {
    {
      kind: "genrule"
      name: "normalized_\(m.rawFiles[i].name)_conf"
      // ...
    }
  },
]
```

This single block generates as many genrules as you have normalization steps. Add another config file to the model, and another genrule appears automatically. No copy-paste, no manual updates to multiple locations.

## The Intermediate Representation

The key insight is the intermediate representation (IR). The transforms don't directly generate Starlark strings. Instead, they generate structured data:

```cue
{
  kind: "genrule"
  name: "config_size_report"
  srcs: [":normalized_app_conf"]
  outs: ["reports/app_size.txt"]
  cmd: "$(location //b/ex-genrule:word_count_sh) input=$(location :normalized_app_conf) $@"
  tools: ["//b/ex-genrule:word_count_sh", "//b/lib:lib_sh"]
}
```

This IR is easier to manipulate, validate, and transform than raw text. Only at the final step does `renderGenrule` convert it to Starlark syntax.

## Extending the System

Want to add a new build pattern? You'd:

1. **Extend the Schema** (`build.cue`): Add a new field to the `#Model` definition:
   ```cue
   #Model: {
     // ... existing fields
     testSuites: [...{
       name: string
       srcs: [...#Label]
     }]
   }
   ```

2. **Add a Transform** (`bazel.cue`): Create a new target list:
   ```cue
   t_tests: [
     for t in m.testSuites {
       {
         kind: "test"
         name: t.name
         srcs: t.srcs
       }
     }
   ]
   ```

3. **Add a Renderer** (`bazel.cue`): Implement the rendering function:
   ```cue
   renderTest: {
     #in: { name: string, srcs: [...string] }
     // ... generate sh_test() syntax
   }
   ```

4. **Update the targets list** (`bazel.cue`): Add to the aggregated targets:
   ```cue
   targets: [
     // ... existing targets
     for x in t_tests { x },
   ]
   ```

5. **Update the Model Instance** (`build.cue`): Add test suites to your concrete `m` instance:
   ```cue
   m: #Model & {
     // ... existing fields
     testSuites: [
       { name: "unit_tests", srcs: [":test_sources"] },
     ]
   }
   ```

The rest happens automatically. The existing comprehensions that build the `targets` list and render output will pick up your new pattern.

## Practical Benefits

This approach delivers several practical advantages:

1. **DRY (Don't Repeat Yourself)**: The normalization pattern appears once in the schema and transform. Twenty config files? Still one pattern definition.

2. **Consistency**: All generated targets follow the same conventions. Tool dependencies are always listed. Commands follow the same structure. Naming is systematic.

3. **Refactoring**: Want to change how all normalized files are named? Update one line in `t_norm`. The change propagates everywhere.

4. **Documentation**: The schema *is* documentation. Want to know what fields a bundle supports? Look at `#Bundle`. It's enforced by the type system.

5. **Testing**: You can validate the model without running Bazel. CUE's constraint system catches many errors at generation time.

6. **Composition**: Models can be composed. You could split the model across multiple files, or import common patterns from a shared library.

## When to Use This

This approach shines when:

- You have repetitive BUILD file patterns
- Build logic is complex with many interdependent targets
- Multiple people need to add similar targets without understanding Bazel deeply
- You want to generate BUILD files from external data sources
- Build configuration is itself configuration (meta!)

It's overkill when:
- You have a handful of unique, simple targets
- The team is small and Bazel-fluent
- Patterns don't repeat often enough to justify abstraction

## File Organization

The system uses two CUE files with clear separation of concerns:

- **`bazel.cue`**: The transformation engine
  - Basic schema types (#Label, #CfgFile, #NormalizeStep, #Bundle, #Info)
  - Transformation logic (t_raw, t_norm, t_reports, t_bundles, t_infos, t_all)
  - Rendering functions (renderGenrule, renderFilegroup, renderArchiveDir, renderArchiveInfo)
  - Final BUILD output field

- **`build.cue`**: The declarative model
  - #Model schema definition (what fields are valid)
  - Concrete instance `m` (actual values for this build)

This separation means the transformation engine (`bazel.cue`) is reusable across projects. Only `build.cue` changes for different build configurations.

## Running the Generator

To regenerate `BUILD.bazel` from the CUE files:

```bash
cd b/ex
cue export --out text -e BUILD bazel.cue build.cue > BUILD.bazel
```

The `-e BUILD` flag selects the `BUILD` field from `bazel.cue` as output, and `--out text` produces raw text instead of JSON/YAML.

The generated BUILD file includes a header comment `# auto-generated: bazel.cue` to indicate its origin and discourage manual edits.

In practice, you'd integrate this into your build process, perhaps as a genrule that validates the BUILD file matches the CUE source, or as a pre-commit hook that regenerates BUILD files.

## The Weird Beauty

Yes, it's weird to use a configuration language to generate build system code. But it's the *right* kind of weird. CUE's constraint-based type system, structural typing, and data-oriented design make it surprisingly natural for code generation tasks.

The weirdness comes from breaking free of traditional thinking about build systems. Instead of writing build code, you're declaring build intent. Instead of scripting how targets relate, you're describing what relationships exist. The CUE system figures out the how.

This is declarative infrastructure as code, applied to the build system itself. And once you embrace the weirdness, it's hard to go back to writing BUILD files by hand.
