# Antigravity CLI (`agy`) Tool Mapping

Skills describe actions ("dispatch a subagent", "track tasks", "write file"). On Google Antigravity CLI/IDE (`agy`), map them to the native tools below.

| Action skills request | Antigravity CLI equivalent |
|-----------------------|----------------------------|
| Dispatch a subagent (`Subagent (general-purpose):`) | `invoke_subagent` with built-in `TypeName`: `self` (full-capability coding/testing) or `research` (read-only exploration) |
| Task tracking ("create a todo", "mark complete") | A **task artifact** via `write_to_file` with `IsArtifact: true` and `ArtifactMetadata.ArtifactType: "task"` (or `task` artifact). Updated with `replace_file_content`. Not `manage_task`, which manages background processes. |
| Read file | `read_file` with `Path` |
| Write / Create file | `write_to_file` with `Path` and `Content` |
| Edit file | `replace_file_content` with `Path`, `Target`, and `Replacement` |
| Run commands | `run_command` with `CommandLine` |

## Task Tracking via Task Artifact

Antigravity uses task artifacts rather than todo tool calls:
- Write the initial checklist using `write_to_file` with `ArtifactMetadata` containing `ArtifactType: "task"`.
- As each step completes, update with `replace_file_content` to toggle `- [ ]` to `- [x]`.
- For background agent tasks, dispatch via `invoke_subagent` using `self` or `research`.
