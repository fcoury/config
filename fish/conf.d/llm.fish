# alias cdx='command codex -m gpt-5.1 -c model_reasoning_effort="high" --search --yolo'
# alias cdx='command codex -m gpt-5.1-codex-max -c model_reasoning_effort="high" --search --yolo'
alias cdx='command codex -m gpt-5.2-codex -c model_reasoning_effort="high" --search --yolo'
alias codex='command codex -m gpt-5.2 --full-auto -c model_reasoning_effort="medium" -c model_reasoning_summary_format=experimental --search'

function localai
  ANTHROPIC_API_KEY="test-key" \
  ANTHROPIC_BASE_URL=http://localhost:3456 \
  claude "$argv"
end

function zai
  ANTHROPIC_DEFAULT_OPUS_MODEL=GLM-4.6 \
  ANTHROPIC_DEFAULT_SONNET_MODEL=GLM-4.6 \
  ANTHROPIC_DEFAULT_HAIKU_MODEL=GLM-4.5-Air \
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

function of
    OPENAI_API_KEY="$CHATGPT_KEY" octofriend
end
