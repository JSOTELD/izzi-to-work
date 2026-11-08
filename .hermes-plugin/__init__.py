import os
import re
from pathlib import Path

BOOTSTRAP_MARKER = "izzi-to-work:using-izzi-to-work bootstrap for hermes"


def _skills_dir() -> str:
    here = os.path.dirname(os.path.realpath(__file__))
    candidates = (
        os.path.realpath(os.path.join(here, "..", "skills")),
        os.path.realpath(os.path.join(here, "skills")),
    )
    for cand in candidates:
        if os.path.isfile(os.path.join(cand, "using-izzi-to-work", "SKILL.md")):
            return cand
    raise RuntimeError(
        "izzi-to-work plugin: cannot find the skills/ tree "
        f"(looked at {candidates})."
    )


def _strip_frontmatter(content: str) -> str:
    match = re.match(r"^---\n[\s\S]*?\n---\n([\s\S]*)$", content)
    return (match.group(1) if match else content).strip()


def _frontmatter_value(content: str, key: str) -> str:
    match = re.match(r"^---\n([\s\S]*?)\n---\n", content)
    if not match:
        return ""
    for line in match.group(1).splitlines():
        name, sep, value = line.partition(":")
        if sep and name.strip() == key:
            return value.strip().strip("\"'")
    return ""


def _build_bootstrap(skills_dir: str) -> str:
    with open(
        os.path.join(skills_dir, "using-izzi-to-work", "SKILL.md"),
        encoding="utf-8",
    ) as f:
        body = _strip_frontmatter(f.read())

    tools_path = os.path.join(
        skills_dir, "using-izzi-to-work", "references", "hermes-tools.md"
    )
    tool_mapping = ""
    if os.path.isfile(tools_path):
        with open(tools_path, encoding="utf-8") as f:
            tool_mapping = f.read().strip()

    return (
        f"<EXTREMELY_IMPORTANT>\n"
        f"{BOOTSTRAP_MARKER}\n\n"
        f"You have izzi-to-work superpowers.\n\n"
        f"The using-izzi-to-work skill content is included below and is already "
        f"loaded for this Hermes session. Follow it now. "
        f"Do not try to load using-izzi-to-work again.\n\n"
        f"{body}\n\n"
        f"## Loading Izzi to Work Skills on Hermes\n\n"
        f"Izzi to Work skills are registered with Hermes' native skill loader: "
        f'invoke one with `skill_view("izzi-to-work:skill-name")` '
        f'(for example `skill_view("izzi-to-work:mutation-testing")`). '
        f"If a namespaced lookup returns 'not found', read the skill file directly instead:\n"
        f'`read_file("{skills_dir}/skill-name/SKILL.md")`\n\n'
        f"The izzi-to-work skills directory is: `{skills_dir}`\n\n"
        f"{tool_mapping}\n"
        f"</EXTREMELY_IMPORTANT>"
    )


def register(ctx):
    skills_dir = _skills_dir()
    bootstrap = _build_bootstrap(skills_dir)

    for name in sorted(os.listdir(skills_dir)):
        skill_md = os.path.join(skills_dir, name, "SKILL.md")
        if os.path.isfile(skill_md):
            with open(skill_md, encoding="utf-8") as f:
                description = _frontmatter_value(f.read(), "description")
            ctx.register_skill(name, Path(skill_md), description=description)

    def pre_llm_call(
        session_id=None,
        user_message=None,
        conversation_history=None,
        is_first_turn=None,
        model=None,
        platform=None,
        **kwargs,
    ):
        if is_first_turn:
            return {"context": bootstrap}
        return None

    ctx.register_hook("pre_llm_call", pre_llm_call)

