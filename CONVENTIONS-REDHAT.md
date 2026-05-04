#SPDX-License-Identifier: MIT-0
---

# Conventions for RedHat/CentOS/Rocky/Amazon Linux

## Repository Management

### Module Choice

Always use `ansible.builtin.yum_repository` for adding YUM/DNF repositories.

### GPG Key Handling

Always fetch GPG keys from the repository URL:

```yaml
gpgkey: "https://repo.example.com/gpg.key"
```

### Required Parameters

Always include these parameters:
- `name`: Repository identifier
- `baseurl`: Repository URL
- `enabled`: `true`
- `gpgcheck`: `true`
- `repo_gpgcheck`: `true` (validates repository metadata signatures)
- `state`: `present` or `absent`
- `description`: Human-readable repository description
- `file`: Base name for the `.repo` file (without extension)

### Critical: repo_gpgcheck

Always set `repo_gpgcheck: true` to validate repository metadata signatures. This ensures:
- The repository metadata itself is signed and verified
- Protection against man-in-the-middle attacks on repo metadata
- Compliance with security best practices

**Never omit `repo_gpgcheck: true`**

### Registering Results

Always register the repository task result to detect changes:

```yaml
register: <repo_name>_repo
```

This enables conditional logic like cache updates or package cleanup when the repo changes.

### Template Example

```yaml
- name: Add <package> repository
  ansible.builtin.yum_repository:
    name: <repo_name>
    baseurl: "https://repo.example.com/{{ <variable> }}/el/{{ ansible_facts.distribution_major_version }}/"
    enabled: true
    gpgcheck: true
    repo_gpgcheck: true
    state: present
    description: <package> repository
    file: <repo_filename>
  register: <repo_name>_repo
```

### Common Variations

**Custom priority (for multiple repos):**
```yaml
priority: 50
```

**Disabled repository (enabled on demand):**
```yaml
enabled: false
```

**Mirrorlist instead of baseurl:**
```yaml
mirrorlist: "https://mirrors.example.com/list?repo=<repo_name>"
```

**SSL client certificates:**
```yaml
sslclientcert: "/etc/pki/client/cert.pem"
sslclientkey: "/etc/pki/client/key.pem"
sslverify: true
```

## Package Installation

Package installation tasks belong in `tasks/main.yml`, not in setup files.

When a repository changes, update the cache:

```yaml
- name: Update cache if repo changed
  ansible.builtin.yum:
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
