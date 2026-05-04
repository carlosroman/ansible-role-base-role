# AGENTS.md — Ansible Role

## What this is

An Ansible role. Standard role layout: `tasks/`, `handlers/`, `defaults/`, `vars/`, `templates/`, `files/`, `meta/`.

The role's Galaxy namespace and name are defined in `meta/main.yml`. The fully-qualified role name (e.g., `<namespace>.<role_name>`) is what you reference in playbooks and `molecule/default/converge.yml`.

## Dev commands

All driven by `make`:

| Command | What it does |
|---|---|
| `make lint` | Runs `yamllint .` |
| `make test` | Runs `molecule test` (single distro, defaults to `ubuntu2404`) |
| `make test/ubuntu-2404` | Test against a specific distro |
| `make test/all` | Test against all 7 distros sequentially |

Available distro targets: `ubuntu-2604`, `ubuntu-2404`, `ubuntu-2204`, `debian-12`, `debian-11`, `rocky-9`, `amazonlinux-2023`.

Override distro without a make target: `MOLECULE_DISTRO=debian12 molecule test`.

## Molecule setup

- **Driver**: Docker (uses `geerlingguy/docker-${MOLECULE_DISTRO}-ansible:latest` images)
- **Config**: `molecule/default/molecule.yml`
- **Converge playbook**: `molecule/default/converge.yml` — references the role by its Galaxy name
- Requires Docker running locally. The devcontainer includes docker-in-docker.

## CI workflow (`.github/workflows/ci.yml`)

Two jobs run on push/PR:
1. **Lint** — `make lint`
2. **Test** — `make test` across matrix: `debian11`, `debian12`, `ubuntu2204`, `ubuntu2404`, `ubuntu2604`, `rockylinux9`

## Dependencies

Pinned in `requirements.txt`. Install with `pip install -r requirements.txt` (devcontainer does this automatically on create). Key versions: ansible-core 2.19.0, molecule 25.6.0, yamllint 1.37.1.

## YAML linting

Config in `.yamllint`: extends default, line-length max 120 (warning level). Ignores `venv/` and `.venv/`.

## Conventions

- All YAML files start with `#SPDX-License-Identifier: MIT-0` header
- Standard Ansible role structure; add tasks to `tasks/main.yml`, defaults to `defaults/main.yml`
- `tasks/main.yml` uses `include_tasks: setup-{{ ansible_facts.os_family }}.yml` for OS-family-specific setup
- Placeholder setup files: `tasks/setup-Debian.yml` and `tasks/setup-RedHat.yml`
- `molecule/default/converge.yml` includes a pre-task for updating apt cache on Debian and a post-task placeholder for verification

## License

This role is licensed under MIT. See `LICENSE` file for details.
