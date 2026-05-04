#SPDX-License-Identifier: MIT-0
---

# Skill: Conventional Commits

## Workflow

1. Run `git status` to review changed files
2. Run `git diff --cached` to inspect changes
3. Stage changes with `git add <file>` (if not already staged)
4. Generate commit message following format below
5. Execute: `git commit -m "type(scope): description"`

## Commit Format

```
type(scope): description

[optional body]

[optional footer]
```

## Types

| Type | Use Case |
|------|----------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting |
| `refactor` | Code restructuring |
| `perf` | Performance |
| `test` | Tests |
| `chore` | Maintenance |
| `ci` | CI/CD |
| `build` | Build system |
| `template` | Template structure |
| `convention` | Convention docs |

## Scope Detection

| Files Changed | Scope |
|---------------|-------|
| `tasks/*` | `tasks` |
| `handlers/*` | `handlers` |
| `defaults/*` | `defaults` |
| `templates/*` | `templates` |
| `meta/*` | `meta` |
| `molecule/*` | `molecule` |
| `.github/*` | `ci` |
| `Makefile` | `build` |
| `CONVENTIONS-*` | `convention` |
| `AGENTS.md` | `convention` |
| `README.md` | `docs` |

## Rules

- **Type**: Lowercase, required
- **Scope**: One word from table above, required
- **Description**: Imperative mood, lowercase start, no period, max 72 chars
- **Body**: Optional, wrap at 72 chars, explain what/why
- **Breaking**: Use `!` before `:` or `BREAKING CHANGE:` in footer

## Examples

```
feat(tasks): add nginx configuration management
```

```
fix(tasks): correct yum_repository baseurl variable
```

```
ci(workflows): add ubuntu-2604 to test matrix
```

```
docs(readme): update installation instructions
```

```
template(agents): add conventional commits skill
```

```
convention(debian): document deb822_repository patterns
```

```
refactor(defaults)! : rename nginx_port to http_port

BREAKING CHANGE: The nginx_port variable has been renamed to http_port.
```

## Execution

After generating the message, run:

```bash
git commit -m "type(scope): description"
```

Include body/footer only when necessary.
