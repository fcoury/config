alias codex='command codex -m gpt-5 -c model_reasoning_effort="high" --yolo'

function codex_continue
    # Find the most recently modified JSONL file in ~/.codex/sessions (recursively)
    set latest (find ~/.codex/sessions -type f -name '*.jsonl' -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -n 1)

    if test -z "$latest"
        echo "No session files found in ~/.codex/sessions"
        return 1
    end

    echo "Resuming from: $latest"
    codex --config experimental_resume="$latest" $argv
end

function zai
  ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic \
  ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
  claude "$argv" # --dangerously-skip-permissions
end

function zyolo
  ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic \
  ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
  claude "$argv" --dangerously-skip-permissions
end

function k2
    ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic" \
    ANTHROPIC_API_KEY="$MOONSHOT_API_KEY" \
    ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview" \
    ANTHROPIC_MODEL="kimi-k2-turbo-preview" \
    claude "$argv" # --dangerously-skip-permissions
end

function cdx
    OPENAI_API_KEY="" codex
end

function of
    OPENAI_API_KEY="$CHATGPT_KEY" octofriend
end
