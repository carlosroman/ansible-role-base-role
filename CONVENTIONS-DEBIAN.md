#SPDX-License-Identifier: MIT-0
---

# Conventions for Debian/Ubuntu

## Repository Management

### Module Choice

Always use `ansible.builtin.deb822_repository` for adding APT repositories. This is the modern approach that creates `.sources` files in `/etc/apt/sources.list.d/`.

**Why not `apt_repository`?**
- `deb822_repository` is the modern standard (Ansible 2.10+)
- Creates structured `.sources` files instead of legacy `.list` files
- Better support for complex repository configurations
- Future-proof as Debian/Ubuntu move to deb822 format

### GPG Key Handling

Always fetch GPG keys from the repository URL rather than using local files:

```yaml
signed_by: "https://repo.example.com/gpg.key"
```

**Why not local key files?**
- Simpler (no need to download and manage key files separately)
- Keys are automatically retrieved and stored in `/etc/apt/keyrings/`
- Reduces file management overhead in the role

### Required Parameters

Always include these parameters:
- `name`: Repository identifier
- `uris`: Repository URL (as a list)
- `types`: Usually `deb`
- `enabled`: `true`
- `suites`: Distribution codename (e.g., `{{ ansible_facts.distribution_release }}`)
- `components`: At least one component (e.g., `main`)
- `signed_by`: GPG key URL
- `state`: `present` or `absent`

### Registering Results

Always register the repository task result to detect changes:

```yaml
register: <repo_name>_repo
```

This enables conditional logic like cleanup when the repo changes.

### Template Example

```yaml
- name: Add <package> repository
  ansible.builtin.deb822_repository:
    name: <repo_name>
    uris:
      - "https://repo.example.com/{{ <variable> }}/ubuntu"
    types: deb
    enabled: true
    suites: "{{ ansible_facts.distribution_release }}"
    components:
      - main
    signed_by: "https://repo.example.com/gpg.key"
    state: present
  register: <repo_name>_repo
```

### Common Variations

**Multiple components:**
```yaml
components:
  - main
  - contrib
  - non-free
```

**Multiple suites:**
```yaml
suites:
  - "{{ ansible_facts.distribution_release }}"
  - "{{ ansible_facts.distribution_release }}-updates"
```

**Different repository types:**
```yaml
types:
  - deb
  - deb-src  # For source packages
```

## Package Installation

Package installation tasks belong in `tasks/main.yml`, not in setup files.

When a repository changes, update the cache:

```yaml
- name: Update cache if repo changed
  ansible.builtin.apt:
    update_cache: true
  when: <repo_name>_repo.changed
```

Install packages using `ansible.builtin.package` in `tasks/main.yml`:

```yaml
- name: Install <package>
  ansible.builtin.package:
    name: <package_name>
    state: present
```

## Service Management

For services managed by the installed package in `tasks/main.yml`:

```yaml
- name: Ensure <service> is running and enabled
  ansible.builtin.service:
    name: <service_name>
    state: started
    enabled: true
```
