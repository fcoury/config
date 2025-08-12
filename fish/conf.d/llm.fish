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
