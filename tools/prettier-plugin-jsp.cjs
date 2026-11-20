const { html } = require("js-beautify");
const prettier = require("prettier");

async function formatScriptlets(text, options) {
    const blocks = [];
    for (const match of text.matchAll(/<%[\s\S]*?%>/g)) {
        const original = match[0];
        let formatted = original;
        if (!/^<%[@!-]/.test(original)) {
            const expression = original.startsWith("<%=");
            const code = original.slice(expression ? 3 : 2, -2).trim();
            try {
                const wrapper = expression
                    ? `class Jsp { Object render() { return ${code}; } }`
                    : `class Jsp { void render() { ${code}\n} }`;
                const result = await prettier.format(wrapper, {
                    ...options,
                    parser: "java",
                    plugins: ["prettier-plugin-java"],
                });
                const body = result.slice(result.indexOf("{", result.indexOf("render(")) + 1,
                    result.lastIndexOf("}", result.lastIndexOf("}") - 1)).trim();
                const indent = options.useTabs ? "\t" : " ".repeat(options.tabWidth);
                const unindented = body.split("\n").map((line, i) =>
                    i === 0 ? line : line.replace(new RegExp(`^${indent}${indent}`), "")
                ).join("\n");
                formatted = expression
                    ? `<%= ${unindented.replace(/^return\s+/, "").replace(/;$/, "")} %>`
                    : `<%\n${unindented}\n%>`;
            } catch {
                // A block may open in one JSP tag and close in another.
                // Preserve these fragments rather than interpreting them as standalone Java.
            }
        }
        blocks.push({ original, formatted });
    }
    let index = 0;
    const masked = text.replace(/<%[\s\S]*?%>/g, () => `<% JSP_FORMAT_${index++} %>`);
    return { masked, blocks };
}

// Mask JSP tags while formatting HTML, then restore the formatted Java blocks.
module.exports = {
    languages: [{ name: "JSP", parsers: ["jsp"], extensions: [".jsp"], vscodeLanguageIds: ["jsp"] }],
    parsers: {
        jsp: {
            parse: async (text, options) => ({ text, ...(await formatScriptlets(text, options)) }),
            astFormat: "jsp-document",
            locStart: () => 0,
            locEnd: (node) => node.text.length,
        },
    },
    printers: {
        "jsp-document": {
            print: (path, options) => html(path.getValue().masked, {
                indent_size: options.tabWidth,
                indent_with_tabs: options.useTabs,
                wrap_line_length: options.printWidth,
                templating: ["erb"],
                end_with_newline: true,
                eol: "\n",
                preserve_newlines: true,
                max_preserve_newlines: 2,
            }).replace(/<% JSP_FORMAT_(\d+) %>/g, (_, index) => path.getValue().blocks[index].formatted),
        },
    },
};
