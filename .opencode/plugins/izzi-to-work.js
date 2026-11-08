/**
 * Izzi to Work plugin for OpenCode.ai
 *
 * Dual-compatible with OpenCode V1 and V2.
 */

import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const izziSkillsDir = path.resolve(__dirname, '../../skills');

const extractAndStripFrontmatter = (content) => {
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
  if (!match) return { frontmatter: {}, content };

  const frontmatterStr = match[1];
  const body = match[2];
  const frontmatter = {};
  let lastKey = null;

  for (const rawLine of frontmatterStr.split('\n')) {
    const line = rawLine.replace(/\r$/, '');
    const colonIdx = line.indexOf(':');
    if (colonIdx > 0 && !/^\s/.test(line)) {
      const key = line.slice(0, colonIdx).trim();
      const value = line.slice(colonIdx + 1).trim();
      frontmatter[key] = /^(>[+-]?|\|[+-]?)$/.test(value) ? '' : value;
      lastKey = key;
    } else if (lastKey !== null && line.trim() !== '') {
      frontmatter[lastKey] = `${frontmatter[lastKey]} ${line.trim()}`.trim();
    }
  }

  for (const key of Object.keys(frontmatter)) {
    frontmatter[key] = frontmatter[key].replace(/^(["'])([\s\S]*)\1$/, '$2');
  }

  return { frontmatter, content: body };
};

export const V1_MAPPING = `**Tool Mapping for OpenCode:**
When skills request actions, substitute OpenCode equivalents:
- Create or update todos -> \`todowrite\`
- \`Subagent (general-purpose):\` -> \`task\` with \`subagent_type: "general"\`
- Invoke a skill -> OpenCode's native \`skill\` tool
- Read files -> \`read\`
- Create, edit, or delete files -> \`apply_patch\`
- Run shell commands -> \`bash\`
- Search files -> \`grep\`, \`glob\`
- Fetch a URL -> \`webfetch\`

Use OpenCode's native \`skill\` tool to list and load skills.`;

export const V2_MAPPING = `**Tool Mapping for OpenCode:**
When skills request actions, substitute OpenCode equivalents:
- Create or update todos -> Track progress in plan files or markdown checkpoints
- \`Subagent (general-purpose):\` -> \`subagent\` with \`agent: "general"\`
- Invoke a skill -> OpenCode's native \`skill\` tool
- Read files -> \`read\`
- Create, edit, or delete files -> \`patch\` / \`write\` / \`edit\`
- Run shell commands -> \`shell\`
- Search files -> \`grep\`, \`glob\`
- Fetch a URL -> \`webfetch\`
- Search the web -> \`websearch\`

Use OpenCode's native \`skill\` tool to list and load skills.`;

const _bootstrapCache = new Map();

const getBootstrapContent = (toolMapping) => {
  if (_bootstrapCache.has(toolMapping)) return _bootstrapCache.get(toolMapping);

  const skillPath = path.join(izziSkillsDir, 'using-izzi-to-work', 'SKILL.md');
  if (!fs.existsSync(skillPath)) {
    _bootstrapCache.set(toolMapping, null);
    return null;
  }

  const fullContent = fs.readFileSync(skillPath, 'utf8');
  const { content } = extractAndStripFrontmatter(fullContent);

  _bootstrapCache.set(toolMapping, `<EXTREMELY_IMPORTANT>
You have izzi-to-work superpowers.

**IMPORTANT: The using-izzi-to-work skill content is included below. It is ALREADY LOADED - you are currently following it. Do NOT use the skill tool to load "using-izzi-to-work" again.**

${content}

${toolMapping}
</EXTREMELY_IMPORTANT>`);

  return _bootstrapCache.get(toolMapping);
};

export const SuperpowersPlugin = async (ctx) => {
  return {
    name: 'izzi-to-work',
  };
};

export async function setup(ctx) {
  try {
    const skills = [];
    if (fs.existsSync(izziSkillsDir)) {
      const entries = fs.readdirSync(izziSkillsDir, { withFileTypes: true });
      for (const entry of entries) {
        if (!entry.isDirectory()) continue;
        const skillPath = path.join(izziSkillsDir, entry.name, 'SKILL.md');
        if (!fs.existsSync(skillPath)) continue;
        const { frontmatter, content } = extractAndStripFrontmatter(fs.readFileSync(skillPath, 'utf8'));
        skills.push({
          id: entry.name,
          name: frontmatter.name || entry.name,
          ...(frontmatter.description ? { description: frontmatter.description } : {}),
          path: skillPath,
          content,
        });
      }
    }
    if (ctx.skill && typeof ctx.skill.transform === 'function') {
      await ctx.skill.transform((draft) => {
        for (const skill of skills) {
          try {
            draft.add(skill);
          } catch (err) {
            console.error(`[izzi-to-work] skill "${skill.id}" rejected by host:`, err);
          }
        }
      });
    }
  } catch (err) {
    console.error('[izzi-to-work] skill registration failed:', err);
  }

  try {
    if (ctx.session && typeof ctx.session.hook === 'function') {
      await ctx.session.hook('context', async (event) => {
        try {
          const bootstrap = getBootstrapContent(V2_MAPPING);
          if (!bootstrap || !event.messages || !event.messages.length) return;
          const firstUser = event.messages.find(m => m.role === 'user');
          if (firstUser?.content?.some(p => p.type === 'text' && p.text && p.text.includes('EXTREMELY_IMPORTANT'))) return;

          if (firstUser) {
            firstUser.content.unshift({ type: 'text', text: bootstrap });
          } else {
            event.messages.push({ role: 'user', content: [{ type: 'text', text: bootstrap }] });
          }
        } catch (err) {
          console.error('[izzi-to-work] context hook failed:', err);
        }
      });
    }
  } catch (err) {
    console.error('[izzi-to-work] session hook registration failed:', err);
  }
}

export default {
  id: 'izzi-to-work',
  server: SuperpowersPlugin,
  setup,
};
