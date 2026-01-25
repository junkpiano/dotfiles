# AGENTS.md

This file provides guidelines for agentic coding agents working in this dotfiles repository.

## Build/Lint/Test Commands

### Shell Script Validation
- **Lint shell scripts**: `shellcheck setup.bash` (as mentioned in README.md)
- **Test setup script**: `./setup.bash` (runs reloadConf by default)
- **Bootstrap environment**: `./setup.bash bootstrap` (first-time setup only)
- **Reload configurations**: `./setup.bash && source ~/.zshrc`

### No Traditional Build System
This is a dotfiles repository, not a software project with compilation. The "build" process involves:
1. Symlinking dotfiles to home directory
2. Installing dependencies via Homebrew
3. Setting up shell environments

## Code Style Guidelines

### Shell Scripting (Primary Language)

#### File Structure and Organization
- Use `#!/usr/bin/env bash` shebang
- Set `set -e` for error handling
- Group related functions together
- Main logic at the bottom of the file

#### Naming Conventions
- **Functions**: snake_case with descriptive names (`append_to_zshrc`, `reloadConf`)
- **Variables**: snake_case, local variables prefixed with `local` in functions
- **Constants**: UPPER_SNAKE_CASE for exports and environment variables
- **Files**: Descriptive names with `.bash` extension for shell scripts

#### Import and Source Style
- Source external files with conditional checks:
  ```bash
  if [[ -f "$HOME/.local/bin/mise" ]]; then
    eval "$(~/.local/bin/mise env zsh)"
  fi
  ```
- Use absolute paths when sourcing external scripts
- Check file existence before sourcing

#### Error Handling
- Always use `set -e` at the top of scripts
- Check command existence before use:
  ```bash
  if ! command -v brew >/dev/null; then
    echo "Installing Homebrew ..."
  fi
  ```
- Use conditional checks for file operations
- Provide meaningful error messages

#### Formatting and Spacing
- Use 2-space indentation for shell scripts
- Place `then` on same line as `if`
- Use `[[ ]]` for conditional tests instead of `[ ]`
- Quote variables: `"$HOME"` not `$HOME`
- Use `printf` over `echo` for better control

#### Configuration Files
- **Zsh**: Use ZSH_THEME="simple", enable syntax highlighting
- **Git**: Use standard git configuration patterns
- **Tmux**: Start window numbering at 1, use xterm-256color
- **Environment**: Export LANG/LC_ALL as UTF-8

### Platform-Specific Code
- Detect OS with `[[ "$(uname)" == "Linux" ]]` or `[[ $(uname) == 'Darwin' ]]`
- Separate platform-specific logic into conditional blocks
- Use appropriate package managers per platform (brew on macOS, apt on Ubuntu)

### Documentation
- Comment complex shell logic
- Provide usage examples in comments
- Document external dependencies
- Keep README.md updated with setup instructions

### Submodule Management
- Initialize with `git submodule init`
- Update with `git submodule update`
- Handle oh-my-zsh as special case (symlink instead of submodule link)

### Security and Best Practices
- Never commit secrets or sensitive configuration
- Use `~/.zshrc.local` for personal overrides
- Validate external downloads with curl
- Use `>/dev/null 2>&1` for suppressing command output when needed
- Prefer absolute paths for system binaries in scripts

### Testing Philosophy
- Scripts should be idempotent (safe to run multiple times)
- Test on both macOS and Ubuntu environments
- Use shellcheck for static analysis
- Verify symlink creation and functionality

## Project Structure Context

This repository manages personal development environment configuration including:
- Shell configurations (Zsh, Bash)
- Development tools (Git, Tmux, Neovim)
- Package management (Homebrew, mise)
- Platform-specific setups (macOS/Linux)

Agents should preserve existing functionality while making improvements that maintain cross-platform compatibility and follow established patterns.