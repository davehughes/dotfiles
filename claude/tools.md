# Tools

## workenv

- File locally by default (`we new ...`). Mirror or push (`--mirror`, `we sync push KEY ...`) only
  when the user asks, and only the named keys — a bare `we sync push` sends every pending local
  change. Pushing publishes to the shared tracker and notifies people.
- Never `gh issue create/edit`; tracker changes go through `we`.
