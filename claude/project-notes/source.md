# yobilabs/source — project notes

Personal facts about working this repo that don't belong in the checked-in CLAUDE.md (they're about
the user's shell and workflow, not team convention). Corrections land here, not in memory.

## Running things

- Terraform runs through Bazel. The user drives it with the `:tf` alias: `:tf
  -chdir=terraform/<root> <command>`. Suggest commands in that form.
- **Never run `terraform apply` yourself.** Write the HCL and import blocks, then hand the user
  the `:tf` commands. Everything non-mutating — `init`, `plan`, `state show`/`state list`,
  `output`, `show` — is fine to run directly: `bazelisk run //terraform -- -chdir=terraform/<root>
  <command>` (the `:tf` alias isn't available in the agent shell; plain `bazel` isn't on PATH,
  `bazelisk` is at ~/.nix-profile/bin).
- `terraform fmt` is the exception — the PATH binary demands Azure auth even for fmt, so use `bazel
  run //terraform:fmt`.
- Other hermetic tools run via the `:run` alias: `:run <package>:<target> <args>` — no `--`
  separator, no leading `//`. Example: `:run terraform/clusters/yobi-aks-useast2:cluster.kubectl get
  pods -n yap-production`. The wrappers pin kubeconfig/auth; bare binaries either fail auth or talk
  to the wrong cluster.

## workenv tickets (SRC-*)

- File locally only: `we new ... --repo yobilabs/source`. **Never `we sync push`, never `--mirror`,
  never `gh issue create/edit`** — pushing publishes to the shared tracker and notifies people; the
  user pushes manually.
- If the ask needs a tracker-only field (assignee is the known case), file the ticket, say the field
  needs a push to take effect, and stop.

## Gotchas that caused real damage

- Changing `only_critical_addons_enabled` (or OS type, VM size, etc.) on an existing AKS node pool
  **reimages the nodes**, evicting all pods — it is not just a scheduling taint. Ensure another
  Ready node pool exists and migrate workloads off first. (Caused a brief production outage.)

## Infrastructure conventions (not in the checked-in CLAUDE.md)

Terraform/Helm/Azure conventions the team file doesn't cover yet. Follow them; don't edit the team
file to add them without being asked.

- **Hermetic dev tools**: no `go install`/`brew` for workflow tooling (benchstat, mockgen, ...).
  Wire it as a Bazel target — add the module to the right `go.mod`, let `go_deps`/gazelle pick it
  up, run via `bazel run`. System installs break reproducibility and don't exist in CI.
- **Module layout**: single-consumer terraform modules co-locate with their consuming root in a
  `modules/` subdir (e.g. `terraform/access-control/modules/group`); only genuinely shared modules
  live in top-level `terraform/modules/`. Any directory named `modules/` is module code, never a
  runnable root — Terrateam's `**/modules/**` ignore glob depends on this.
- **Migration blocks**: `import`, `moved`, and `removed` blocks go in one `migrations.tf` per root;
  delete them after a successful apply.
- **Cross-stack references**: prefer a weak reference (an Azure AD group + `data` lookup) over
  `terraform_remote_state`. Remote-state reads create hard ordering edges and have caused Terrateam
  dependency cycles; never embed one in a shared module. Tradeoff to surface: consumers see changes
  only after the owner applies.
- **Helm boundary**: cluster-cadence infra releases (operators, otel-collector) live inside the
  cluster module; app-cadence releases deploy via `helm_release.bzl` targets outside Terraform.
  Place a new release by asking which cadence it changes at.
- **Identity naming**: user-assigned identities are `{cluster}-{role}`, federated credentials
  `{cluster}-{role}-federated`, the k8s service account just `{role}`
  (`yobi-aks-useast2-otel-collector` / `...-federated` / `otel-collector`).
