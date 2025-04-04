// ?查询按键说明
// 按Alt-s可以在当前站点开关Surfingkeys。当Surfingkeys处于关闭状态时，除了热键，其它所有按键映射都停止工作。
// 搜索快捷字约定(双键)
/*
    百度 = bd
    必应 = by
    哔哩哔哩 = bb
    Google = gg (由于最常用, 额外添加s作为短快捷字)
    Genspark = gs
    Github = gh
    Luxrity = lx
*/
// s+搜索快捷字: 搜索选中文本(或若未选中则为剪贴板)
// so+搜索快捷字: 添加site:当前域名约束 (o表示only_this_site_key)
// o+搜索快捷字: 打开指定搜索栏 
// m前缀导航, 可快速打开指定地址

// https://github.com/brookhong/Surfingkeys/blob/master/docs/API.md
const { aceVimMap, mapkey, vmapkey, imapkey, map, unmap, unmapAllExcept, imap, iunmap, cmap, vmap, vunmap, getClickableElements, addSearchAlias, removeSearchAlias, tabOpenLink, readText, Clipboard, Front, Hints, Visual, RUNTIME } = api;

//历史记录搜索，不使用默认的按使用次数排序
settings.historyMUOrder = false;

// 移除与浏览器的冲突 查看下载历史，历史记录
unmap("<Ctrl-j>");
iunmap("<Ctrl-j>");
vunmap("<Ctrl-j>");
unmap("<Ctrl-h>");
iunmap("<Ctrl-h>");
vunmap("<Ctrl-h>");

// 选择输入框
map("h", "i");
// 上下滚动目标
map("i", "k");
map("k", "j");

// 可视模式下上下左右
vmap("i", "k");
vmap("k", "j");
vmap("j", "h");
vunmap("h");
vmap("J", "0");
vmap("L", "$");
vunmap("0");
vunmap("$");
// 光标置于屏幕顶部/底部
vmap("zi", "zt");
vmap("zk", "zb");
vunmap("zt");
vunmap("zb");


map("J", "S"); // 历史后退
map("L", "D"); // 历史前进
// 使用垂直标签页
map("I", "E"); // 跳到上个标签页
map("K", "R"); // 跳到下个标签页

map("zk", "zo"); // 缩小页面

// 移除一些不需要的快捷键
const unmaplist = [
    // 鼠标点击
    "gi", "gf", "<Ctrl-i>",
    // 滚动页面/元素
    "0", "U", "P", "j", "l", "$", "u",
    // 标签页
    "E", "R", "<Alt-p>", "gx0", "gxt", "gxT", "gx$", "gxp", "zo",
    // 网页浏览
    "gt", "gT", "B", "F", "<Ctrl-6>", "S", "D",
    // 会话(没用过)
    "ZZ", "ZR",
    // todo: 剪贴板
    // 搜索栏
    "om",
    // 类VIM标签
    "'", "<Ctrl-'>",
    // 设置
    ";v",
    // Chrome内置功能(删除的是不存在于edge中的设置)
    "gc", "gk",
    // 代理
    "cp", ";pa", ";pb", ";pd", ";ps", ";pc", ";cp", ";ap"
];

unmaplist.forEach((u) => { unmap(u); });

// todo: Omnibar 热键无法移除
// const cunmaplist = ["<Ctrl-d>", "<Ctrl-i>", "<Ctrl-j>", "<Ctrl-.>", "<Ctrl-,>"];
// cunmaplist.forEach((u) => { cunmap(u); })

//===================== 搜索快捷字 ================== start
// 移除内置的搜索快捷字
const removeSearchAliasList = ["g", "d", "b", "e", "w", "s", "h", "y"];
removeSearchAliasList.forEach((u) => { removeSearchAlias(u); });
// 新增搜索快捷字
// https://github.com/brookhong/Surfingkeys/blob/master/docs/API.md#addsearchalias
var searchAliasList = [
    {
        alias: "bd",
        prompt: "百度",
        search_url: "https://www.baidu.com/s?wd=",
        search_leader_key: "s",
        favicon_url: "https://www.baidu.com/favicon.ico",
    },
    {
        alias: "by",
        prompt: "必应",
        search_url: "https://www.bing.com/search?q=",
        search_leader_key: "s",
        favicon_url: "https://www.bing.com/favicon.ico",
    },
    {
        alias: "bb",
        prompt: "哔哩哔哩",
        search_url: "https://search.bilibili.com/all?keyword=",
        search_leader_key: "s",
        favicon_url: "https://www.bilibili.com/favicon.ico",
    },
    {
        alias: "gg",
        prompt: "Google",
        search_url: "https://www.google.com/search?q=",
        search_leader_key: "s",
        favicon_url: "https://www.google.com/favicon.ico",
    },
    {
        alias: "s",
        prompt: "Google",
        search_url: "https://www.google.com/search?q=",
        search_leader_key: "s",
        favicon_url: "https://www.google.com/favicon.ico",
    },
    {
        alias: "gs",
        prompt: "Genspark",
        search_url: "https://genspark.com/search?query=",
        search_leader_key: "s",
        favicon_url: "https://www.genspark.com/favicon.ico",
    },
    {
        alias: "gh",
        prompt: "Github",
        search_url: "https://github.com/search?q=",
        search_leader_key: "s",
        favicon_url: "https://www.github.com/favicon.ico",
    },
    {
        alias: "lx",
        prompt: "Luxrity",
        search_url: "https://search.luxirty.com/search?q=",
        search_leader_key: "s",
        favicon_url: "https://search.luxirty.com/favicon.ico",
    }
];
// 暂时均使用 https://duckduckgo.com/ac/?q= 作为搜索建议
default_suggestion_url = "https://duckduckgo.com/ac/?q="
default_callback_to_parse_suggestion = function(response) {
    var res = JSON.parse(response.text);
    return res.map(function(r){
        return r.phrase;
    });
}
searchAliasList = searchAliasList.map(item => ({
    ...item,
    suggestion_url: default_suggestion_url,
    callback_to_parse_suggestion: default_callback_to_parse_suggestion,
    only_this_site_key: 'o'
}));
searchAliasList.forEach((u) => { addSearchAlias(u.alias, u.prompt, u.search_url, u.search_leader_key, u.suggestion_url, u.callback_to_parse_suggestion, u.only_this_site_key, u.favicon_url); });
//===================== 搜索快捷字 ================== end

//=====================faster web index 充当网页导航的功能================== start
var webShortNameConfig = [
    {
        shortName: "bb",
        siteName: "Bilibili",
        url: "https://www.bilibili.com/",
    },
    {
        shortName: "gh",
        siteName: "Github",
        url: "https://github.com/",
    },
    {
        shortName: "yt",
        siteName: "Youtube",
        url: "https://www.youtube.com/",
    },
    {
        shortName: "lc",
        siteName: "Leetcode",
        url: "https://leetcode.cn/problemset/",
    },
    {
        shortName: "gm",
        siteName: "Gmail",
        url: "https://mail.google.com/mail/u/0/#inbox",
    },
    {
        shortName: "ol",
        siteName: "Outlook",
        url: "https://outlook.live.com/mail/0/",
    }
];

var webIndexPrefix = "m";
unmap(webIndexPrefix);

function bindMapKeyForWebIndex() {
    for (var i = webShortNameConfig.length - 1; i >= 0; i--) {
        let webIndexConfig = webShortNameConfig[i];
        mapkey(
            webIndexPrefix + webIndexConfig.shortName,
            "跳转到-> " + webIndexConfig.siteName,
            () => tabOpenLink(webIndexConfig.url)
        );
    }
}

bindMapKeyForWebIndex();
//=====================faster web index ================== end

// 内联翻译查询
// 可视模式下q查询光标下的单词
// 正常模式或可视模式下Q窗口输出查询
Front.registerInlineQuery({
    url: function (q) {
        return `http://dict.youdao.com/w/eng/${q}/#keyfrom=dict2.index`;
    },
    parseResult: function (res) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(res.text, "text/html");
        var collinsResult = doc.querySelector("#collinsResult");
        var authTransToggle = doc.querySelector("#authTransToggle");
        var examplesToggle = doc.querySelector("#examplesToggle");
        if (collinsResult) {
            collinsResult.querySelectorAll("div>span.collinsOrder").forEach(function (span) {
                span.nextElementSibling.prepend(span);
            });
            collinsResult.querySelectorAll("div.examples").forEach(function (div) {
                div.innerHTML = div.innerHTML
                    .replace(/<p/gi, "<span")
                    .replace(/<\/p>/gi, "</span>");
            });
            var exp = collinsResult.innerHTML;
            return exp;
        } else if (authTransToggle) {
            authTransToggle.querySelector("div.via.ar").remove();
            return authTransToggle.innerHTML;
        } else if (examplesToggle) {
            return examplesToggle.innerHTML;
        }
    },
});

// name: Rosé Pine
// author: thuanowa
// license: unlicense
// upstream: https://github.com/rose-pine/surfingkeys/blob/main/dist/rose-pine.conf
// blurb: All natural pine, faux fur and a bit of soho vibes for the classy minimalist

// const hintsCss = "font-size: 13pt; font-family: 'JetBrains Mono NL', 'Cascadia Code', 'Helvetica Neue', Helvetica, Arial, sans-serif; border: 0px; color: #e0def4 !important; background: #191724; background-color: #191724";
// api.Hints.style(hintsCss);
// api.Hints.style(hintsCss, "text");

settings.theme = `
  .sk_theme {
    background: #191724;
    color: #e0def4;
  }
  .sk_theme input {
    color: #e0def4;
  }
  .sk_theme .url {
    color: #c4a7e7;
  }
  .sk_theme .annotation {
    color: #ebbcba;
  }
  .sk_theme kbd {
    background: #26233a;
    color: #e0def4;
  }
  .sk_theme .frame {
    background: #1f1d2e;
  }
  .sk_theme .omnibar_highlight {
    color: #403d52;
  }
  .sk_theme .omnibar_folder {
    color: #e0def4;
  }
  .sk_theme .omnibar_timestamp {
    color: #9ccfd8;
  }
  .sk_theme .omnibar_visitcount {
    color: #9ccfd8;
  }
  .sk_theme .prompt, .sk_theme .resultPage {
    color: #e0def4;
  }
  .sk_theme .feature_name {
    color: #e0def4;
  }
  .sk_theme .separator {
    color: #524f67;
  }
  body {
    margin: 0;

    font-family: "JetBrains Mono NL", "Cascadia Code", "Helvetica Neue", Helvetica, Arial, sans-serif;
    font-size: 12px;
  }
  #sk_omnibar {
    overflow: hidden;
    position: fixed;
    width: 80%;
    max-height: 80%;
    left: 10%;
    text-align: left;
    box-shadow: 0px 2px 10px #21202e;
    z-index: 2147483000;
  }
  .sk_omnibar_middle {
    top: 10%;
    border-radius: 4px;
  }
  .sk_omnibar_bottom {
    bottom: 0;
    border-radius: 4px 4px 0px 0px;
  }
  #sk_omnibar span.omnibar_highlight {
    text-shadow: 0 0 0.01em;
  }
  #sk_omnibarSearchArea .prompt, #sk_omnibarSearchArea .resultPage {
    display: inline-block;
    font-size: 20px;
    width: auto;
  }
  #sk_omnibarSearchArea>input {
    display: inline-block;
    width: 100%;
    flex: 1;
    font-size: 20px;
    margin-bottom: 0;
    padding: 0px 0px 0px 0.5rem;
    background: transparent;
    border-style: none;
    outline: none;
  }
  #sk_omnibarSearchArea {
    display: flex;
    align-items: center;
    border-bottom: 1px solid #524f67;
  }
  .sk_omnibar_middle #sk_omnibarSearchArea {
    margin: 0.5rem 1rem;
  }
  .sk_omnibar_bottom #sk_omnibarSearchArea {
    margin: 0.2rem 1rem;
  }
  .sk_omnibar_middle #sk_omnibarSearchResult>ul {
    margin-top: 0;
  }
  .sk_omnibar_bottom #sk_omnibarSearchResult>ul {
    margin-bottom: 0;
  }
  #sk_omnibarSearchResult {
    max-height: 60vh;
    overflow: hidden;
    margin: 0rem 0.6rem;
  }
  #sk_omnibarSearchResult:empty {
    display: none;
  }
  #sk_omnibarSearchResult>ul {
    padding: 0;
  }
  #sk_omnibarSearchResult>ul>li {
    padding: 0.2rem 0rem;
    display: block;
    max-height: 600px;
    overflow-x: hidden;
    overflow-y: auto;
  }
  .sk_theme #sk_omnibarSearchResult>ul>li:nth-child(odd) {
    background: #1f1d2e;
  }
  .sk_theme #sk_omnibarSearchResult>ul>li.focused {
    background: #26233a;
  }
  .sk_theme #sk_omnibarSearchResult>ul>li.window {
    border: 2px solid #524f67;
    border-radius: 8px;
    margin: 4px 0px;
  }
  .sk_theme #sk_omnibarSearchResult>ul>li.window.focused {
    border: 2px solid #c4a7e7;
  }
  .sk_theme div.table {
    display: table;
  }
  .sk_theme div.table>* {
    vertical-align: middle;
    display: table-cell;
  }
  #sk_omnibarSearchResult li div.title {
    text-align: left;
  }
  #sk_omnibarSearchResult li div.url {
    font-weight: bold;
    white-space: nowrap;
  }
  #sk_omnibarSearchResult li.focused div.url {
    white-space: normal;
  }
  #sk_omnibarSearchResult li span.annotation {
    float: right;
  }
  #sk_omnibarSearchResult .tab_in_window {
    display: inline-block;
    padding: 5px;
    margin: 5px;
    box-shadow: 0px 2px 10px #21202e;
  }
  #sk_status {
    position: fixed;
    bottom: 0;
    right: 20%;
    z-index: 2147483000;
    padding: 4px 8px 0 8px;
    border-radius: 4px 4px 0px 0px;
    border: 1px solid #524f67;
    font-size: 12px;
  }
  #sk_status>span {
    line-height: 16px;
  }
  .expandRichHints span.annotation {
    padding-left: 4px;
    color: #ebbcba;
  }
  .expandRichHints .kbd-span {
    min-width: 30px;
    text-align: right;
    display: inline-block;
  }
  .expandRichHints kbd>.candidates {
    color: #e0def4;
    font-weight: bold;
  }
  .expandRichHints kbd {
    padding: 1px 2px;
  }
  #sk_find {
    border-style: none;
    outline: none;
  }
  #sk_keystroke {
    padding: 6px;
    position: fixed;
    float: right;
    bottom: 0px;
    z-index: 2147483000;
    right: 0px;
    background: #191724;
    color: #e0def4;
  }
  #sk_usage, #sk_popup, #sk_editor {
    overflow: auto;
    position: fixed;
    width: 80%;
    max-height: 80%;
    top: 10%;
    left: 10%;
    text-align: left;
    box-shadow: #21202e;
    z-index: 2147483298;
    padding: 1rem;
  }
  #sk_nvim {
    position: fixed;
    top: 10%;
    left: 10%;
    width: 80%;
    height: 30%;
  }
  #sk_popup img {
    width: 100%;
  }
  #sk_usage>div {
    display: inline-block;
    vertical-align: top;
  }
  #sk_usage .kbd-span {
    width: 80px;
    text-align: right;
    display: inline-block;
  }
  #sk_usage .feature_name {
    text-align: center;
    padding-bottom: 4px;
  }
  #sk_usage .feature_name>span {
    border-bottom: 2px solid #524f67;
  }
  #sk_usage span.annotation {
    padding-left: 32px;
    line-height: 22px;
  }
  #sk_usage * {
    font-size: 10pt;
  }
  kbd {
    white-space: nowrap;
    display: inline-block;
    padding: 3px 5px;
    font: 11px "JetBrains Mono NL", "Cascadia Code", "Helvetica Neue", Helvetica, Arial, sans-serif;
    line-height: 10px;
    vertical-align: middle;
    border: solid 1px #524f67;
    border-bottom-lolor: #524f67;
    border-radius: 3px;
    box-shadow: inset 0 -1px 0 #21202e;
  }
  #sk_banner {
    padding: 0.5rem;
    position: fixed;
    left: 10%;
    top: -3rem;
    z-index: 2147483000;
    width: 80%;
    border-radius: 0px 0px 4px 4px;
    border: 1px solid #524f67;
    border-top-style: none;
    text-align: center;
    background: #191724;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }
  #sk_tabs {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: transparent;
    overflow: auto;
    z-index: 2147483000;
  }
  div.sk_tab {
    display: inline-flex;
    height: 28px;
    width: 202px;
    justify-content: space-between;
    align-items: center;
    flex-direction: row-reverse;
    border-radius: 3px;
    padding: 10px 20px;
    margin: 5px;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#191724), color-stop(100%,#191724));
    box-shadow: 0px 3px 7px 0px #21202e;
  }
  div.sk_tab_wrap {
    display: inline-block;
    flex: 1;
  }
  div.sk_tab_icon {
    display: inline-block;
    vertical-align: middle;
  }
  div.sk_tab_icon>img {
    width: 18px;
  }
  div.sk_tab_title {
    width: 150px;
    display: inline-block;
    vertical-align: middle;
    font-size: 10pt;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    padding-left: 5px;
    color: #e0def4;
  }
  div.sk_tab_url {
    font-size: 10pt;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    color: #c4a7e7;
  }
  div.sk_tab_hint {
    display: inline-block;
    float:right;
    font-size: 10pt;
    font-weight: bold;
    padding: 0px 2px 0px 2px;
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#191724), color-stop(100%,#191724));
    color: #e0def4;
    border: solid 1px #524f67;
    border-radius: 3px;
    box-shadow: #21202e;
  }
  #sk_tabs.vertical div.sk_tab_hint {
    position: initial;
    margin-inline: 0;
  }
  div.tab_rocket {
    display: none;
  }
  #sk_bubble {
    position: absolute;
    padding: 9px;
    border: 1px solid #524f67;
    border-radius: 4px;
    box-shadow: 0 0 20px #21202e;
    color: #e0def4;
    background-color: #191724;
    z-index: 2147483000;
    font-size: 14px;
  }
  #sk_bubble .sk_bubble_content {
    overflow-y: scroll;
    background-size: 3px 100%;
    background-position: 100%;
    background-repeat: no-repeat;
  }
  .sk_scroller_indicator_top {
    background-image: linear-gradient(#191724, transparent);
  }
  .sk_scroller_indicator_middle {
    background-image: linear-gradient(transparent, #191724, transparent);
  }
  .sk_scroller_indicator_bottom {
    background-image: linear-gradient(transparent, #191724);
  }
  #sk_bubble * {
    color: #e0def4 !important;
  }
  div.sk_arrow>div:nth-of-type(1) {
    left: 0;
    position: absolute;
    width: 0;
    border-left: 12px solid transparent;
    border-right: 12px solid transparent;
    background: transparent;
  }
  div.sk_arrow[dir=down]>div:nth-of-type(1) {
    border-top: 12px solid #524f67;
  }
  div.sk_arrow[dir=up]>div:nth-of-type(1) {
    border-bottom: 12px solid #524f67;
  }
  div.sk_arrow>div:nth-of-type(2) {
    left: 2px;
    position: absolute;
    width: 0;
    border-left: 10px solid transparent;
    border-right: 10px solid transparent;
    background: transparent;
  }
  div.sk_arrow[dir=down]>div:nth-of-type(2) {
    border-top: 10px solid #e0def4;
  }
  div.sk_arrow[dir=up]>div:nth-of-type(2) {
    top: 2px;
    border-bottom: 10px solid #e0def4;
  }
  .ace_editor.ace_autocomplete {
    z-index: 2147483300 !important;
    width: 80% !important;
  }
  @media only screen and (max-width: 767px) {
    #sk_omnibar {
      width: 100%;
      left: 0;
    }
    #sk_omnibarSearchResult {
      max-height: 50vh;
      overflow: scroll;
    }
    .sk_omnibar_bottom #sk_omnibarSearchArea {
      margin: 0;
      padding: 0.2rem;
    }
  }
`;
