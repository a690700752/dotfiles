#!/usr/bin/env -S deno run --allow-read --allow-write

import fs from "node:fs";
import JSON5 from "https://unpkg.com/json5@2/dist/index.min.mjs";

function replaceAll(s, search, replacement) {
  return s.split(search).join(replacement);
}

function findPairEnd(content, startIndex, openChar, closeChar) {
  const stack = [openChar];
  let index = startIndex;
  while (stack.length > 0 && index < content.length) {
    const char = content[index];
    if (char === openChar) {
      stack.push(char);
    } else if (char === closeChar) {
      stack.pop();
    }
    index++;
  }
  return index;
}

function getStyles(content) {
  let styles = [];
  let exp = /[Ss]tyle={({.*?})}/gs;
  let match = exp.exec(content);
  while (match) {
    styles.push(match[1]);
    match = exp.exec(content);
  }

  exp = /[Ss]tyle={\[(.*?)\]}/gs;
  match = exp.exec(content);
  while (match) {
    let split = splitStyle(match[1]).filter((s) => {
      s = s.trim();
      return s.startsWith("{") && s.endsWith("}");
    });

    styles.push(...split);

    match = exp.exec(content);
  }

  styles = styles.filter((s) => s.indexOf("// no extract") === -1);
  // .filter((s) => {
  //   try {
  //     JSON5.parse(s);
  //     return true;
  //   } catch {
  //     return false;
  //   }
  // });

  return styles;
}

/**
 * split "{ flexDirection: 'row', backgroundColor: '#F5F6F7', borderRadius: 2, paddingVertical: 15 }, props.style"
 *  to [{xxx}, props.style]
 */
function splitStyle(style) {
  let result = [];
  let index = 0;
  let stack = [];
  while (index < style.length) {
    const char = style[index];
    if (char === "{") {
      stack.push(char);
    } else if (char === "}") {
      stack.pop();
    } else if (char === "," && stack.length === 0) {
      result.push(style.slice(0, index));
      style = style.slice(index + 1);
      index = 0;
    }
    index++;
  }
  result.push(style);
  return result;
}

function main() {
  const file_path = Deno.args[0];
  let content = fs.readFileSync(file_path, "utf8");

  const blockBegin = "const styles = StyleSheet.create(";
  let beginIndex = content.indexOf(blockBegin);
  if (beginIndex === -1) {
    content = content + "\n" + blockBegin + "{});";
    beginIndex = content.indexOf(blockBegin);
  }

  beginIndex += blockBegin.length;
  const endIndex = findPairEnd(content, beginIndex, "(", ")") + 1;

  let code =
    content.slice(0, beginIndex - blockBegin.length) + content.slice(endIndex);
  let oldStyles = content.slice(beginIndex, endIndex - 2);

  const variable_prefix = "rename_" + Date.now() + "_";

  const styles = getStyles(code);
  if (styles.length === 0) {
    console.log("No styles found");
    return 0;
  }

  for (let i = 0; i < styles.length; i++) {
    code = replaceAll(code, styles[i], "styles." + variable_prefix + i);
    oldStyles = `{\n${variable_prefix + i}: ${styles[i]},` + oldStyles.slice(1);
  }

  content = code + "\n" + blockBegin + oldStyles + ");";

  fs.writeFileSync(file_path, content);
}

main();
