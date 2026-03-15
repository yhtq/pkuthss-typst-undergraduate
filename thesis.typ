#import "template.typ": *
#import "@preview/curryst:0.6.0": rule, prooftree, rule-set
#import "notes-lib/template.typ": *


#show: doc => UndergraduateThesis(
  // ctitle必填
  ctitle: "类型系统的范畴语义",
  doc,
)
#import "@preview/ctheorems:1.1.3": *
#show: thmrules
// 封面修改后位本科生版本
// TitlePage参数全部必填
#TitlePage(
  chinese_title: [类型系统的范畴语义],
  english_title: [The Categorical Semantics of Type Theory],
  name : "郭子荀",
  studentid : "2100012990",
  department : "数学科学学院",
  major : "数据科学与大数据",
  supervisor_name : "夏壁灿",
  year_and_month : "二〇二五年五月"
) <title-page>


// 导师评价
// CheckSheet参数全部必填
#CheckSheet(
  name : "郭子荀",
  studentid : "2100012990",
  school : "数学科学学院",
  major : "数据科学与大数据",
  supervisor : "夏壁灿",
  department : "计算机学院",
  grade : "中等",
  title : "助理教授",
  chinese_title : "类型系统的范畴语义",
  english_title : "The Categorical Semantics of Type Theory",
  sign_pic : image("./images/老师签名.png"),
  year : 2024,
  month : 5,
  day : 15,
)[
这篇文章写得还行
] // end of check comment

// Copyright
#CopyrightClaim <copy-right>

// 中文摘要
#ChineseAbstract(
  keywords : ("Typst", "排版")
)[

类型理论是形式逻辑的延伸，其中的逻辑符号各自具备不同的类型，类型之间也满足一定的规则。历史上，逻辑学家提出了类型理论，并试图将其作为数学的基础。之后，人们逐渐发现建立在类型系统上的逻辑总是与某些范畴之间存在着深刻的联系。计算机诞生并发展之后，类型理论以及其与范畴之间的联系也被计算机科学家们所关注，并且对程序语言理论的发展产生了重要的影响。

本文是《Introduction to Higher Order Categorical Logic》@lambek_introduction_1986 一书的读书报告。该书旨在统一基于类型论的逻辑与范畴，具体而完整的介绍了其中几个经典的对应关系：Typed Lambda Calculus 与 Cartesian Closed Category，Untyped Lambda Calculus 与 C-monoid，Intuitionistic Logic 与 Toposes. 本文也将采用此脉络，详细介绍这些重要的对应关系。
  
]

// English Abstract
#EnglishAbstract(
  keywords : ("Typst", "Formatting")
)[ 

Typst is an emerging typesetting tool designed to offer simple, efficient, and powerful typesetting capabilities. It combines the strengths of traditional typesetting systems while simplifying user operations, allowing users to focus more on content creation rather than typesetting details.

The core advantage of Typst lies in its intuitive syntax and powerful typesetting engine. Users can define document structures, styles, and content using a programming-like approach, making the typesetting of complex documents more straightforward. Additionally, Typst supports real-time preview functionality, enabling users to see the typesetting effects immediately during the editing process, thereby improving work efficiency.

Typst also boasts high extensibility and flexibility. Through a system of plugins and templates, users can customize typesetting rules to meet various needs. Whether it’s academic papers, business reports, or personal projects, Typst can deliver professional-grade typesetting results.

In summary, Typst is a user-friendly yet professional typesetting tool suitable for a wide range of document creation needs. Its introduction provides users with a new typesetting experience, making the typesetting process more enjoyable and efficient.

This paper offers a template for undergraduate thesis in Peking University.
]


// 目录
#TableOfContent

#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let remark = thmbox(
  "remark",
  "Remark"
)
#let definition = thmbox("definition", "Definition", fill: rgb("#fffdee"))

#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")
#let centerProofTree(args) = align(center)[#prooftree(args)]
#let pair(x, y) = $〈#x, #y〉$
// DOCUMENT START: 更改状态，标记了文档的开始
#doc_start()

= 导言
  #lorem(400)
= Lambda 算术与 Cartesian 闭范畴 <lambda-arithmetic>
  == 演绎系统
    在经典的形式逻辑中，最基本的对象是*公式*。根据某些规则和公理，我们可以演绎得到某个公式的*证明*。可被证明的公式就是定理。抽象的，我们可以定义：
    #definition[
      一个*演绎系统*是一个图，其节点是公式，箭头表示公式之间的演绎关系，包括以下运算：
      - 任何节点 $A$ 具备单位 $1_A : A -> A$，也即：  
          R1a: #centerProofTree(
            rule(
              $1_A: A -> A$,
            )
          )
        
      - 任何箭头 $f: A -> B, g: B -> C$ 具备复合 $g f: A -> C$，也即：  
          R1b: #centerProofTree(
            rule(
              $f: A -> B$,
              $g: B -> C$,
              $g f: A -> C$
            )
          )
    ]<dd-sys>
    在 Gentzen 式的证明论之中，人们总是更多关心证明序列，也就是若 $A, B, C, D$ 是一些命题，如何得到一个演绎序列 $A -> B -> C -> D$。而这里，我们还要强调箭头本身的含义，也就是当 $f : A -> B$，$f$ 本身就成为了从 $A$ 推导出 $B$ 的某种“原因”。仅从形式逻辑的视角考察 $f$ 本身似乎显得有些奇怪，但站在范畴的视角，两个对象之间的态射自然是多样的。

    #definition[
      我们称一个*正直觉主义演算*（Positive Intuitionistic Calculus）是一个演绎系统，其中包括：
      - 真值公式 $T$
      - 公式连接符 $and, ->$
      以及以下额外的推导规则：
      - R2: #centerProofTree(
            rule(
              $circle_A : A -> T$,
            )
          )
      - R3a: #centerProofTree(
            rule(
              $pi_A : A and B -> A$,
            )
          )
      - R3b: #centerProofTree(
            rule(
              $pi_B : A and B -> B$,
            )
          )
      - R3c: #centerProofTree(
            rule(
              $f : A -> B$,
              $g : A -> C$,
              $pair(f, g) : A -> B and C$
            )
          )
      - R4a: #centerProofTree(
            rule(
              $epsilon_(A, B): B and (B => A) -> A$
            )
          )
      - R4b: #centerProofTree(
            rule(
              $h: C and B -> A$,
              $h^*: C -> (B => A)$
            )
          )
    ]
    传统上，演绎定理是形式逻辑中非常重要的结论，在通常的证明论中，它被表述为：
    $
        "if" A and B tack C "then" A tack B => C 
    $
    #let scrL = $scr(L)$
    然而，我们可以从更高的角度考虑这个表述：若记原有的演绎系统为 $scrL$，添加一个额外的*假设* $x: T -> A$ 如同在 $scrL$ 中添加了一个新的箭头，并在对应演绎规则下，自由生成了一个新的演绎系统 $scrL(x)$ #footnote[我们使用了类似多项式的记号，直观上可以认为这里添加一个对象自由生成的行为类似于添加未定元得到的多项式空间，之后我们会详细介绍。]。在这样的想法下，演绎定理可以表述为：
    #theorem[演绎定理][
      在正直觉主义演算 $scrL$ 中，任何 $scrL(x : T -> A)$ 中的箭头 $phi(x) : B -> C$ 总对应一个 $scrL$ 中的箭头 $B and A -> C$
    ]
    #remark[这里我们只陈述了正直觉主义演算的情形。当然，对于其他常见的演绎系统，例如添加 $or, bot$ 的直觉主义演算，添加排中律的经典逻辑演算，这样的演绎定理也成立，并且证明也是类似的。]
  #let cat = $cal(C)$
  == 笛卡尔闭范畴
    回顾定义 @dd-sys，不难发现它就是一个图构成一个*范畴*的条件。在这种意义下，只要对演绎系统中的证明做一些形式描述#footnote[也就是将演绎过程 $A -> B$ 的所有证明在某种等价关系下收集为一个集合]，一个演绎系统自然就是一个范畴。更进一步，仿照演算系统中 $T, and$ 的定义，我们规定：
    #definition[笛卡尔闭范畴][
      称一个范畴 $cat$ 是一个*笛卡尔闭范畴（Cartesian Closed Category）*，如果它满足以下条件：
      - 具有所有有限直积（继而具有终对象）
      - 任取对象 $B$，函子 $* times B$ 总有右伴随函子，记作 $*^B$，也即：
        $
        $
    ]
    #example[
      集合范畴 *Set* 是一个笛卡尔闭范畴
    ]

// = 基本功能 <intro>

// == 标题

// Typst 中的标题使用 `=` 表示，其后跟着标题的内容。`=` 的数量对应于标题的级别。

// 除了这一简略方式，也可以通过 `heading` 函数自定义标题的更多属性。具体可以参考#link("https://typst.app/docs/reference/meta/heading/", [文档中的有关内容])。

// 下面是一个示例：

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// #heading(level: 2, numbering: none, outlined: false, "二级标题")
// #heading(level: 3, numbering: none, outlined: false, "三级标题")
// #heading(level: 4, numbering: none, outlined: false, "四级标题")
// #heading(level: 5, numbering: none, outlined: false, "五级标题")
//   ```,
//   [
//     #heading(level: 2, numbering: none, outlined: false, "二级标题")
//     #heading(level: 3, numbering: none, outlined: false, "三级标题")
//     #heading(level: 4, numbering: none, outlined: false, "四级标题")
//     #heading(level: 5, numbering: none, outlined: false, "五级标题")
//   ]
// )\

// 需要注意的是，这里的样式经过了本模板的一些定制，并非 Typst 的默认样式。

// === 三级标题

// ==== 四级标题

// 本模板目录的默认最大深度为 3，即只有前三级标题会出现在目录中。如果需要更深的目录，可以更改 `outlinedepth` 设置。

// == 粗体与斜体

// 与 Markdown 类似，在 Typst 中，使用 `*...*` 表示粗体，使用 `_..._` 表示斜体。下面是一个示例：

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// *bold* and _italic_ are very simple.
//   ```,
//   [
// *bold* and _italic_ are very simple.
//   ]
// )\

// 由于绝大部分中文字体只有单一字形，这里遵循 `PKUTHSS` 的惯例，使用#strong[黑体]表示粗体，#emph[楷体]表示斜体。但需要注意的是，由于语法解析的问题， `*...*` 和 `_..._` 的前后可能需要空格分隔，而这有时会导致不必要的空白。 如果不希望出现这一空白，可以直接采用 `#strong` 或 `#emph`。

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// 对于中文情形，*使用 \* 加粗* 会导致额外的空白，#strong[使用 \#strong 加粗]则不会。
//   ```,
//   [
// 对于中文情形，*使用 \* 加粗* 会导致额外的空白，#strong[使用 \#strong 加粗]则不会。
//   ]
// )\

// == 脚注

// 从 v0.4 版本开始，Typst 原生支持了脚注功能。本模板中，默认每一章节的脚注编号从 1 开始。

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
//   Typst 支持添加脚注#footnote[这是一个脚注。]。
// ```,
// [
//   Typst 支持添加脚注#footnote[这是一个脚注。]。
// ]
// )\

// == 图片

// 在 Typst 中插入图片的默认方式是 `image` 函数。如果需要给图片增加标题，或者在文章中引用图片，则需要将其放置在 `figure` 中，就像下面这样：

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// #figure(
//   image("images/1-writing-app.png", width: 100%),
//   caption: "Typst 网页版界面",
// ) <web>
// ```,
// [
//   #figure(
//   image("images/1-writing-app.png", width: 100%),
//   caption: "Typst 网页版界面",
// ) <web>
// ]
// )\

// @web 展示了 Typst 网页版的界面。更多有关内容，可以参考 @about。@developers 中介绍了 Typst 的主要开发者。代码中的 `<web>` 是这一图片的标签，可以在文中通过 `@web` 来引用。

// == 表格

// 在 Typst 中，定义表格的默认方式是 `table` 函数。但如果需要给表格增加标题，或者在文章中引用表格，则需要将其放置在 `figure` 中，就像下面这样：

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   codeblock(
//   ```typ
// #figure(
//   table(
//     columns: (auto, auto, auto, auto),
//     inset: 10pt,
//     align: horizon,
//       [*姓名*],[*职称*],[*工作单位*],[*职责*],
//       [李四],[教授],[北京大学],[主席],
//       [王五],[教授],[北京大学],[成员],
//       [赵六],[教授],[北京大学],[成员],
//       [钱七],[教授],[北京大学],[成员],
//       [孙八],[教授],[北京大学],[成员],
//   ),
//   caption: "答辩委员会名单",
// ) <table>
// ```,
//     caption: "默认表格",
//   ),
//   [
//     #figure(
//       table(
//         columns: (auto, auto, auto, auto),
//         inset: 10pt,
//         align: horizon,
//           [*姓名*],[*职称*],[*工作单位*],[*职责*],
//           [李四],[教授],[北京大学],[主席],
//           [王五],[教授],[北京大学],[成员],
//           [赵六],[教授],[北京大学],[成员],
//           [钱七],[教授],[北京大学],[成员],
//           [孙八],[教授],[北京大学],[成员],
//       ),
//       caption: "答辩委员会名单",
//     ) <table>
//   ]
// )

// 对应的渲染结果如 @table 所示。代码中的 `<table>` 是这一表格的标签，可以在文中通过 `@table` 来引用。

// 默认的表格不是特别美观，本模板中提供了 `booktab` 函数用于生成三线表， @booktab 是一个示例。代码中的 `<booktab>` 是这一表格的标签，可以在文中通过 `@booktab` 来引用。

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
//   #booktab(
//     width: 100%,
//     aligns: (left, center, right),
//     columns: (1fr, 1fr, 1fr),
//     caption: [`booktab` 示例],
//     [左对齐], [居中], [右对齐],
//     [4], [5], [6],
//     [7], [8], [9],
//     [10], [], [11],
//   ) <booktab>
//   ```,
//   [
//     #booktab(
//       width: 100%,
//       aligns: (left, center, right),
//       columns: (1fr, 1fr, 1fr),
//       caption: [`booktab` 示例],
//       [左对齐], [居中], [右对齐],
//       [4], [5], [6],
//       [7], [8], [9],
//       [10], [], [11],
//     ) <booktab>
//   ]
// )

// == 公式

// @eq 是一个公式。代码中的 `<eq>` 是这一公式的标签，可以在文中通过 `@eq` 来引用。

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// $ E = m c^2 $ <eq>
//   ```,
//   [
//     $ E = m c^2 $ <eq>
//   ]
// )\

// @eq2 是一个多行公式。

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// $ sum_(k=0)^n k
//     &= 1 + ... + n \
//     &= (n(n+1)) / 2 $ <eq2>  ```,
//   [
// $ sum_(k=0)^n k
//     &= 1 + ... + n \
//     &= (n(n+1)) / 2 $ <eq2>
//   ]
// )\

// @eq3 到 @eq6 中给出了更多的示例。

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// $ frac(a^2, 2) $ <eq3>
// $ vec(1, 2, delim: "[") $
// $ mat(1, 2; 3, 4) $
// $ lim_x =
//     op("lim", limits: #true)_x $ <eq6>
//   ```,
//   [
// $ frac(a^2, 2) $ <eq3>
// $ vec(1, 2, delim: "[") $
// $ mat(1, 2; 3, 4) $
// $ lim_x =
//     op("lim", limits: #true)_x $ <eq6>
//   ]
// )

// == 代码块

// 像 Markdown 一样，我们可以在文档中插入代码块：

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ````typ
//   ```c
//   int main() {
//     printf("Hello, world!");
//     return 0;
//   }
//   ```
//   ````,
//   [
//     ```c
//       int main() {
//         printf("Hello, world!");
//         return 0;
//       }
//     ```
//   ]
// )\

// 如果想要给代码块加上标题，并在文章中引用代码块，可以使用本模板中定义的 `codeblock` 命令。其中，`caption` 参数用于指定代码块的标题，`outline` 参数用于指定代码块显示时是否使用边框。下面给出的 @code 是一个简单的 Python 程序。其中的 `<code>` 是这一代码块的标签，意味着这一代码块可以在文档中通过 `@code` 来引用。

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ````typ
// #codeblock(
//   ```python
//   def main():
//       print("Hello, world!")
//   ```,
//   caption: "一个简单的 Python 程序",
//   outline: true,
// ) <code>
//   ````,
//   [
//     #codeblock(
//       ```python
//       def main():
//           print("Hello, world!")
//       ```,
//       caption: "一个简单的 Python 程序",
//       outline: true,
//     ) <code>
//   ]
// )\

// @codeblock_definition 中给出了本模板中定义的 `codeblock` 命令的实现。

// #codeblock(
//   ```typ
// #let codeblock(raw, caption: none, outline: false) = {
//   figure(
//     if outline {
//       rect(width: 100%)[
//         #set align(left)
//         #raw
//       ]
//     } else {
//       set align(left)
//       raw
//     },
//     caption: caption, kind: "code", supplement: ""
//   )
// }
//   ```,
//   caption: [`codeblock` 命令的实现],
// ) <codeblock_definition>

// == 参考文献

// Typst 支持 BibLaTeX 格式的 `.bib` 文件，同时也新定义了一种基于 YAML 的文献引用格式。要想在文档中引用参考文献，需要在文档中通过调用 `bibliography` 函数来引用参考文献文件。下面是一个示例：


// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// 可以像这样引用参考文献： @wang2010guide 和 @kopka2004guide。

// #bibliography("ref.bib",
//   style: "ieee"
// )
//   ```,
//   [
//     可以像这样引用参考文献： @wang2010guide 和 @kopka2004guide。
//   ]
// )

// 注意代码中的 `"ref.bib"` 也可以是一个数组，比如 `("ref1.bib", "ref2.bib")`。

// = 理论

// == 理论一 <theory1>

// 让我们首先回顾一下 @intro 中的部分公式：

// $ frac(a^2, 2) $
// $ vec(1, 2, delim: "[") $
// $ mat(1, 2; 3, 4) $
// $ lim_x =
//     op("lim", limits: #true)_x $

// == 理论二

// 在 @theory1 中，我们回顾了 @intro 中的公式。下面，我们来推导一些新的公式：

// #lorem(500)

// = 展望

// 目前本模板还有一些不足之处，有待进一步完善：

// - 参考文献格式，特别是中文参考文献的格式不完全符合学校有关规定。#link("https://discord.com/channels/1054443721975922748/1094796790559162408/1094928907880386662", "Discord 上的这个对话")显示，Typst 有关功能还在开发中。待有关接口对外开放后，本模板将会进行相应的适配。


// // 这之后的章节都是附录，如无附录可以删掉
// #change_appendix()

// = 关于 Typst <about>

// == 在附录中插入图片和公式等

// 附录中也支持脚注#footnote[这是一个附录中的脚注。]。

// 附录中也可以插入图片，如 @web1。

// #figure(
//   image("images/1-writing-app.png", width: 100%),
//   caption: "Typst 网页版界面",
// ) <web1>

// 附录中也可以插入公式，如 @appendix-eq。

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// $ S = pi r^2 $ <appendix-eq>
// $ mat(
//   1, 2, ..., 10;
//   2, 4, ..., 20;
//   3, 6, ..., 30;
//   dots.v, dots.v, dots.down, dots.v;
//   10, 20, ..., 100
// ) $
// $ cal(A) < bb(B) < frak(C) < mono(D) < sans(E) < serif(F) $
// $ bold(alpha < beta < gamma < delta < epsilon) $
// $ upright(zeta < eta < theta < iota < kappa) $
// $ lambda < mu < nu < xi < omicron $
// $ bold(Sigma < Tau) < italic(Upsilon < Phi) < Chi < Psi < Omega $
//   ```,
//   [
// $ S = pi r^2 $ <appendix-eq>
// $ mat(
//   1, 2, ..., 10;
//   2, 4, ..., 20;
//   3, 6, ..., 30;
//   dots.v, dots.v, dots.down, dots.v;
//   10, 20, ..., 100
// ) $
// $ cal(A) < bb(B) < frak(C) < mono(D) < sans(E) < serif(F) $
// $ bold(alpha < beta < gamma < delta < epsilon) $
// $ upright(zeta < eta < theta < iota < kappa) $
// $ lambda < mu < nu < xi < omicron $
// $ bold(Sigma < Tau) < italic(Upsilon < Phi) < Chi < Psi < Omega $
//   ]
// )\

// @complex 是一个非常复杂的公式的例子：

// #table(
//   columns: (1fr, 1fr),
//   [
//     #set align(center)
//     代码
//   ],
//   [
//     #set align(center)
//     渲染结果
//   ],
//   ```typ
// $ vec(overline(underbracket(underline(1 + 2) + overbrace(3 + dots.c + 10, "large numbers"), underbrace(x + norm(y), y^(w^u) - root(t, z)))), dots.v, u)^(frac(x + 3, y - 2)) $ <complex>
//   ```,
//   [
//     $ vec(overline(underbracket(underline(1 + 2) + overbrace(3 + dots.c + 10, "large numbers"), underbrace(x + norm(y), y^(w^u) - root(t, z)))), dots.v, u)^(frac(x + 3, y - 2)) $ <complex>
//   ]
// )\

// 附录中也可以插入代码块，如 @appendix-code。

// #codeblock(
//   ```rust
//   fn main() {
//       println!("Hello, world!");
//   }
//   ```,
//   caption: "一个简单的 Rust 程序",
//   outline: true,
// ) <appendix-code>

// == Typst 的开发者 <developers>

// #lorem(500)

// = 关于 PKUTHSS <pkuthss>

// #lorem(500)

// = 更新日志 <changelog>

// #include "changelog.typ"


= 参考文献 <reference>

// 参考文献之前需要更改一下语言，因为文章中图表格的中文名称是设置typst为中文得到的
// 如果就是需要中文参考文献格式可以不更改
#set text(lang: "en")
#bibliography(title:none, "ref.bib")


= 致谢 <thanks>

感谢Typst开发者和原PhD论文模板开发者

// DOCUMENT END:标记文章结束，页面计数停止
#doc_end()


// 原创性与版权声明
#Statement(2024, 5, 15, teacher_sign : image("./images/老师签名.png"), my_sign: image("./images/本人签名.png")) <claim>
