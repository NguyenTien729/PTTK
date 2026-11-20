const assert = require("node:assert/strict");
const fs = require("node:fs");
const prettier = require("prettier");

(async () => {
    let count = 0;
    for (const file of fs.readdirSync("src", { recursive: true })) {
        if (!/\.(java|jsp)$/.test(file)) continue;
        const filepath = `src/${file}`;
        const input = fs.readFileSync(filepath, "utf8");
        const options = { ...(await prettier.resolveConfig(filepath)), filepath };
        const output = await prettier.format(input, options);
        assert.equal(await prettier.format(output, options), output, filepath);
        if (file.endsWith(".jsp")) {
            // Compare Java tokens so whitespace can change without altering strings,
            // comments, identifiers, or operators inside JSP tags.
            const blocks = (text) => (text.match(/<%[\s\S]*?%>/g) || []).map((block) =>
                block.match(/"(?:\\[\s\S]|[^"\\])*"|'(?:\\[\s\S]|[^'\\])*'|\/\/[^\n]*|\/\*[\s\S]*?\*\/|[\w$]+|\S/g)
            );
            assert.deepEqual(blocks(output), blocks(input), filepath);
        }
        count++;
    }
    console.log(`Verified ${count} Java/JSP files: formatting is stable and JSP tokens are preserved.`);
})().catch((error) => { console.error(error); process.exitCode = 1; });
