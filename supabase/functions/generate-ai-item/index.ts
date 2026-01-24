// supabase/functions/generate-ai-item/index.ts
// AI 物品生成 Edge Function
// 使用阿里云百炼 qwen-flash 模型生成独特的物品名称和故事

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import OpenAI from "npm:openai";

// 阿里云百炼配置（必须用国际版端点，因为 Supabase 在海外）
const openai = new OpenAI({
    apiKey: Deno.env.get("DASHSCOPE_API_KEY"),
    baseURL: "https://dashscope-intl.aliyuncs.com/compatible-mode/v1"
});

// 系统提示词
const SYSTEM_PROMPT = `你是一个末日生存游戏的物品生成器。

根据搜刮地点生成物品列表，每个物品包含：
- name: 独特名称（15字以内）
- category: 分类（医疗/食物/工具/武器/材料）
- rarity: 稀有度（common/uncommon/rare/epic/legendary）
- story: 背景故事（50-100字）

规则：
1. 物品类型要与地点相关
2. 名称要有创意，暗示前主人或来历
3. 故事要有画面感，营造末日氛围
4. 可以有黑色幽默

只返回 JSON 数组，不要其他内容。`;

// 根据危险值生成稀有度分布
function getRarityWeights(dangerLevel: number) {
    switch (dangerLevel) {
        case 1:
        case 2:
            return { common: 70, uncommon: 25, rare: 5, epic: 0, legendary: 0 };
        case 3:
            return { common: 50, uncommon: 30, rare: 15, epic: 5, legendary: 0 };
        case 4:
            return { common: 0, uncommon: 40, rare: 35, epic: 20, legendary: 5 };
        case 5:
            return { common: 0, uncommon: 0, rare: 30, epic: 40, legendary: 30 };
        default:
            return { common: 60, uncommon: 30, rare: 10, epic: 0, legendary: 0 };
    }
}

// CORS 响应头
const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
    // 处理 CORS 预检请求
    if (req.method === "OPTIONS") {
        return new Response("ok", { headers: corsHeaders });
    }

    try {
        const { poi, itemCount = 3 } = await req.json();

        // 参数验证
        if (!poi || !poi.name) {
            return new Response(
                JSON.stringify({ success: false, error: "Missing poi.name" }),
                { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        const dangerLevel = poi.dangerLevel || 3;
        const rarityWeights = getRarityWeights(dangerLevel);

        const userPrompt = `搜刮地点：${poi.name}（${poi.type || "未知"}类型，危险等级 ${dangerLevel}/5）

请生成 ${itemCount} 个物品。

稀有度分布参考：
- 普通(common): ${rarityWeights.common}%
- 优秀(uncommon): ${rarityWeights.uncommon}%
- 稀有(rare): ${rarityWeights.rare}%
- 史诗(epic): ${rarityWeights.epic}%
- 传奇(legendary): ${rarityWeights.legendary}%

返回 JSON 数组格式。`;

        console.log(`[generate-ai-item] Generating ${itemCount} items for ${poi.name}`);

        const completion = await openai.chat.completions.create({
            model: "qwen-flash",
            messages: [
                { role: "system", content: SYSTEM_PROMPT },
                { role: "user", content: userPrompt }
            ],
            max_tokens: 800,
            temperature: 0.8
        });

        const content = completion.choices[0]?.message?.content;

        if (!content) {
            throw new Error("AI returned empty content");
        }

        // 尝试解析 JSON（处理可能的 markdown 代码块）
        let items;
        try {
            // 移除可能的 markdown 代码块标记
            let cleanContent = content.trim();
            if (cleanContent.startsWith("```json")) {
                cleanContent = cleanContent.slice(7);
            } else if (cleanContent.startsWith("```")) {
                cleanContent = cleanContent.slice(3);
            }
            if (cleanContent.endsWith("```")) {
                cleanContent = cleanContent.slice(0, -3);
            }
            items = JSON.parse(cleanContent.trim());
        } catch (parseError) {
            console.error("[generate-ai-item] JSON parse error:", parseError);
            console.error("[generate-ai-item] Raw content:", content);
            throw new Error("Failed to parse AI response as JSON");
        }

        console.log(`[generate-ai-item] Successfully generated ${items.length} items`);

        return new Response(
            JSON.stringify({ success: true, items }),
            { headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );

    } catch (error) {
        console.error("[generate-ai-item] Error:", error);

        // 区分不同类型的错误
        let statusCode = 500;
        let errorMessage = error.message || "Unknown error";

        if (errorMessage.includes("401") || errorMessage.includes("Unauthorized")) {
            statusCode = 401;
            errorMessage = "AI API authentication failed. Check DASHSCOPE_API_KEY.";
        } else if (errorMessage.includes("429")) {
            statusCode = 429;
            errorMessage = "AI API rate limit exceeded. Please try again later.";
        }

        return new Response(
            JSON.stringify({ success: false, error: errorMessage }),
            { status: statusCode, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
    }
});
