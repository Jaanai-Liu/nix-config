// 自动生成文章内部目录 (Table of Contents)
document.addEventListener("DOMContentLoaded", () => {
  // 1. 找到文章主体容器
  const articleContent = document.querySelector(".content-area .card");
  if (!articleContent) return;

  // 2. 找到所有的 h2 和 h3 标题
  const headings = articleContent.querySelectorAll("h2, h3");
  if (headings.length === 0) return;

  // 3. 创建目录容器
  const tocContainer = document.createElement("div");
  tocContainer.className = "article-toc hidden-on-mobile";

  // 目录标题 (支持中英文)
  const lang = document.documentElement.getAttribute("lang") || "zh";
  const tocTitle = lang === "zh" ? "本文目录" : "On this page";
  tocContainer.innerHTML = `<div class="toc-title">${tocTitle}</div>`;

  const ul = document.createElement("ul");
  ul.className = "toc-list";

  // 4. 遍历标题，生成锚点和列表项
  headings.forEach((heading, index) => {
    // 如果标题没有 id，自动给它分配一个
    if (!heading.id) {
      heading.id = `heading-${index}`;
    }

    const li = document.createElement("li");
    // 根据是 h2 还是 h3 添加不同的 class，用来控制缩进
    li.className = `toc-item toc-${heading.tagName.toLowerCase()}`;

    const a = document.createElement("a");
    a.href = `#${heading.id}`;
    // 获取标题文本（去除可能包含的额外 span 标签内容）
    a.textContent = heading.innerText;

    // 点击目录时平滑滚动
    a.addEventListener("click", (e) => {
      e.preventDefault();
      document.querySelector(a.getAttribute("href")).scrollIntoView({
        behavior: "smooth",
      });
    });

    li.appendChild(a);
    ul.appendChild(li);
  });

  tocContainer.appendChild(ul);

  // 5. 将生成的目录挂载到右侧
  const mainLayout = document.querySelector(".main-layout");
  if (mainLayout) {
    mainLayout.appendChild(tocContainer);
  }
});
