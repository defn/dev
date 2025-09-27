#!/usr/bin/env python3

import os
import sys
import subprocess
from pathlib import Path
try:
    import tomllib  # Python 3.11+
except ImportError:
    import tomli as tomllib  # Fallback for older Python

def get_git_managed_mise_files():
    """Get all git-managed mise.toml files."""
    result = subprocess.run(
        ["git", "ls-files"],
        cwd="/Users/ubuntu",
        capture_output=True,
        text=True
    )

    mise_files = []
    for line in result.stdout.splitlines():
        if line.endswith("mise.toml") or line.endswith(".config/mise/config.toml"):
            mise_files.append(Path("/Users/ubuntu") / line)

    return mise_files

def parse_mise_file(filepath):
    """Parse a mise.toml file and extract tasks."""
    try:
        with open(filepath, 'rb') as f:
            data = tomllib.load(f)

        tasks = {}
        # Look for tasks in the toml structure
        if 'tasks' in data:
            for task_name, task_config in data.get('tasks', {}).items():
                tasks[task_name] = task_config

        # Also check for [tasks.taskname] sections
        for key in data.keys():
            if key.startswith('tasks.'):
                task_name = key[6:]  # Remove 'tasks.' prefix
                tasks[task_name] = data[key]

        return tasks
    except Exception as e:
        print(f"Error parsing {filepath}: {e}", file=sys.stderr)
        return {}

def create_bash_script(task_name, task_config, tasks_dir):
    """Create a bash script for a mise task."""
    script_path = tasks_dir / task_name

    # Build the script content
    lines = ['#!/usr/bin/env bash', '']

    # Add description if present
    if 'description' in task_config:
        lines.append(f'#MISE description="{task_config["description"]}"')
        lines.append('')

    # Add depends if present
    if 'depends' in task_config:
        depends = task_config['depends']
        if isinstance(depends, list):
            depends_str = ' '.join(f'"{d}"' for d in depends)
        else:
            depends_str = f'"{depends}"'
        lines.append(f'#MISE depends=[{depends_str}]')
        lines.append('')

    # Add sources if present
    if 'sources' in task_config:
        sources = task_config['sources']
        if isinstance(sources, list):
            sources_str = ' '.join(f'"{s}"' for s in sources)
        else:
            sources_str = f'"{sources}"'
        lines.append(f'#MISE sources=[{sources_str}]')
        lines.append('')

    # Add outputs if present
    if 'outputs' in task_config:
        outputs = task_config['outputs']
        if isinstance(outputs, list):
            outputs_str = ' '.join(f'"{o}"' for o in outputs)
        else:
            outputs_str = f'"{outputs}"'
        lines.append(f'#MISE outputs=[{outputs_str}]')
        lines.append('')

    # Add the actual command(s)
    if 'run' in task_config:
        run_cmd = task_config['run']
        if isinstance(run_cmd, list):
            for cmd in run_cmd:
                lines.append(cmd)
        else:
            lines.append(run_cmd)
    elif 'cmd' in task_config:
        cmd = task_config['cmd']
        if isinstance(cmd, list):
            lines.append(' '.join(cmd))
        else:
            lines.append(cmd)
    else:
        lines.append(f'echo "Task {task_name} has no run or cmd specified"')
        lines.append('exit 1')

    # Write the script
    script_content = '\n'.join(lines) + '\n'
    script_path.write_text(script_content)

    # Make it executable
    script_path.chmod(0o755)

    return script_path

def create_alias_symlinks(task_name, task_config, tasks_dir, script_path):
    """Create symlinks for task aliases."""
    aliases = task_config.get('alias', [])
    if isinstance(aliases, str):
        aliases = [aliases]

    created_symlinks = []
    for alias in aliases:
        symlink_path = tasks_dir / alias
        if symlink_path.exists():
            if symlink_path.is_symlink():
                symlink_path.unlink()
            else:
                print(f"Warning: {symlink_path} exists and is not a symlink, skipping", file=sys.stderr)
                continue

        # Create relative symlink
        symlink_path.symlink_to(script_path.name)
        created_symlinks.append(symlink_path)

    return created_symlinks

def process_mise_file(mise_file):
    """Process a single mise.toml file."""
    print(f"Processing: {mise_file}")

    # Determine the tasks directory location
    mise_file = Path(mise_file)
    if mise_file.name == "config.toml" and ".config/mise" in str(mise_file):
        # Global config - use .config/mise/tasks
        tasks_dir = mise_file.parent / "tasks"
    else:
        # Local mise.toml - create tasks subdirectory
        tasks_dir = mise_file.parent / "tasks"

    # Parse tasks from the file
    tasks = parse_mise_file(mise_file)

    if not tasks:
        print(f"  No tasks found in {mise_file}")
        return None

    # Create tasks directory if needed
    created_new_dir = False
    if not tasks_dir.exists():
        tasks_dir.mkdir(parents=True, exist_ok=True)
        print(f"  Created directory: {tasks_dir}")
        created_new_dir = True

    # Process each task
    for task_name, task_config in tasks.items():
        print(f"  Converting task: {task_name}")

        # Create the bash script
        script_path = create_bash_script(task_name, task_config, tasks_dir)
        print(f"    Created script: {script_path}")

        # Create alias symlinks if any
        symlinks = create_alias_symlinks(task_name, task_config, tasks_dir, script_path)
        for symlink in symlinks:
            print(f"    Created symlink: {symlink} -> {script_path.name}")

    return tasks_dir if created_new_dir else None

def main():
    """Main function to process all mise.toml files."""
    print("Converting mise TOML tasks to bash scripts...")
    print()

    # Get all mise files
    mise_files = get_git_managed_mise_files()
    print(f"Found {len(mise_files)} mise configuration files")
    print()

    # Track created directories for git add
    created_dirs = set()

    # Process each file
    for mise_file in mise_files:
        try:
            tasks_dir = process_mise_file(mise_file)
            if tasks_dir:
                created_dirs.add(tasks_dir)
        except Exception as e:
            print(f"Error processing {mise_file}: {e}", file=sys.stderr)
        print()

    # Add created directories to git
    if created_dirs:
        print("Adding created task directories to git...")
        for task_dir in created_dirs:
            subprocess.run(["git", "add", str(task_dir)], cwd="/Users/ubuntu")
            print(f"  Added: {task_dir}")
        print()

    print("Conversion complete!")

if __name__ == "__main__":
    main()