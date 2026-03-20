#import "template.typ": *
#import "@preview/curryst:0.6.0": rule, prooftree, rule-set
#import "notes-lib/template.typ": *
#import "@preview/commute:0.3.0": *


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

#let theorem = thmbox("theorem", "定理", fill: rgb("#eeffee"))
#let corollary = thmbox(
  "corollary",
  "推论",
  base: "theorem",
  titlefmt: strong,
  fill: rgb("#eeffee")
)
#let remark = thmbox(
  "remark",
  "备注"
)
#let definition = thmbox("definition", "定义",breakable: true, fill: rgb("#fffdee"))

#let example = thmplain("example", "例子").with(numbering: none)
#let proof = thmproof("proof", "证明")
#let proposition = thmbox("proposition", "命题", fill: rgb("#eeffff"))
#let centerProofTree(args) = align(center)[#prooftree(args)]
#let pair(x, y) = $〈#x, #y〉$
// DOCUMENT START: 更改状态，标记了文档的开始
#doc_start()

= 导言
  *类型（Type*）的概念最早由 Russell @Whitehead1910-WHIPM-8 引入，以解决当时人们所面临的朴素集合论的悖论。之后，类型理论被发展成为一个重要的研究对象，并随着计算机科学的发展，成为了程序语言理论的核心工具之一 @pierce_types_2002 。粗略地说，一个类型系统中包含着一些类型和项，在一定上下文下，一个结构良好的项应该具有唯一的类型。同时，系统中有着一些规则，规定了类型和项的可能构造方式，以及判定项的类型的方法。

  *范畴（Category*）是近现代数学中非常重要的工具之一。最早，它作为描述数学中广泛存在自然关系的工具被引入@eilenberg_general_1945 ，后来被广泛应用于数学的各个分支。它的核心思想是将数学对象抽象为一些对象（Object）和态射（Morphism），并且规定了态射之间的复合关系。

  尽管两个领域的起源完全不同，但随着人们研究的深入，它们之间的关系也逐渐被发现。Lawvere 为了使用范畴语言描述逻辑中常见的替换（Substitution）操作，引入了笛卡尔闭范畴（Cartesian Closed Category）的概念 @38b76542-b771-32c2-a3ea-ba3f392713d3。由于形式上的相似性，它与简单类型 Lambda 演算@church_formulation_1940 之间的等价关系迅速被发现。逻辑学家为了增强类型的表达能力，逐渐发展出了更强的类型系统，例如 Martin-Löf 类型理论。独立地，局部笛卡尔闭范畴（Locally Cartesian Closed Category）被范畴学家提出，之后，它被发现与 Martin-Löf 类型理论之间存在着深刻的联系 @seely_locally_1984。之后，随着研究的深入，更多的类型系统与范畴之间的联系也被发现。

  本文大体上按照 《Introduction to Higher Order Categorical Logic》 的脉络，首先介绍一些基础的范畴工具。之后，我们将着重介绍两个重要的对应关系：简单类型 Lambda 演算与笛卡尔闭范畴，topoes 与直觉主义类型系统。主要理论和工具基本与原书一致，但引入顺序和方式可能会做出一些调整，许多记号也被调整为更接近近期文献的习惯。

  原书以及诸多其他文献 @jacobs_categorical_nodate @girard_proofs_1989 @pierce_types_2002 @pierce_types_2002 共同强调了一个重要的观点：*类型系统*，*演绎逻辑*与*范畴*之间存在着高度的一致性。本文也将贯彻这一思想。例如，我们重新引入了演绎系统来作为笛卡尔闭范畴和简单类型 Lambda 演算的模板。为了服从这一目的，我们定义演绎系统时采用的规则、公理和记号等可能并不符合传统的形式逻辑习惯，以便更好地强调它与类型论、范畴之间对应关系。

  
= 简单类型 Lambda 演算与笛卡尔闭范畴 <lambda-arithmetic>
  == 演绎系统<dd-sys-s>
    尽管本文的重点是类型系统与范畴，这节我们还是从形式逻辑的角度引入，使用接近类型系统与范畴的语言重新描述形式逻辑中的演绎操作，从而使得后面的内容更容易理解。#footnote[
      当然，演绎系统与类型系统，范畴之间同样有着深刻的关联，包括著名的 Curry-Howard 同构 @Curry1959-CURCLV @Howard1980-HOWTFN-2。这方面进一步的介绍还可以参考 @seely_hyperdoctrines_1983 @girard_proofs_1989
    ]

    在经典的形式逻辑中，最基本的对象是*公式*。根据某些规则和公理，我们可以演绎得到某个公式的*证明*。可被证明的公式就是定理。抽象的，我们可以定义：
    #definition[
      一个*演绎系统*是一个图，其节点是公式，箭头表示公式之间的演绎关系，包括以下运算：
      - 任何节点 $A$ 具备单位 $1_A : A -> A$，也即 

          R1a: #centerProofTree(
            rule(
              $1_A: A -> A$,
            )
          )
        
      - 任何箭头 $f: A -> B, g: B -> C$ 具备复合 $g f: A -> C$，也即

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
              $pi_1 : A and B -> A$,
            )
          )
      - R3b: #centerProofTree(
            rule(
              $pi_2 : A and B -> B$,
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
              $epsilon_(A, B): (B => A) and B -> A$
            )
          )
      - R4b: #centerProofTree(
            rule(
              $h: C and B -> A$,
              $h^*: C -> (B => A)$
            )
          )
    ]<def-pic>
    传统上，演绎定理是形式逻辑中非常重要的结论，在通常的证明论中，它被表述为：
    $
        "if" A and B tack C "then" A tack B => C 
    $
    #let scrL = $scr(L)$
    然而，我们可以从更高的角度考虑这个表述：若记原有的演绎系统为 $scrL$，添加一个额外的*假设* $x: T -> A$ 如同在 $scrL$ 中添加了一个新的箭头，并在对应演绎规则下，自由生成了一个新的演绎系统 $scrL(x)$ #footnote[我们使用了类似多项式的记号，直观上可以认为这里添加一个对象自由生成的行为类似于添加未定元得到的多项式空间，之后我们会详细介绍。]。在这样的想法下，演绎定理可以表述为：
    #theorem[演绎定理][
      在正直觉主义演算 $scrL$ 中，任何 $scrL(x : T -> A)$ 中的箭头 $phi(x) : B -> C$ 总对应一个 $scrL$ 中的箭头 $B and A -> C$
    ]<dd-theorem>
    #remark[这里我们只陈述了正直觉主义演算的情形。当然，对于其他常见的演绎系统，例如添加 $or, bot$ 的直觉主义演算，添加排中律的经典逻辑演算，这样的演绎定理也成立，并且证明也是类似的。]
  #let cat = $cal(C)$
  == 笛卡尔闭范畴
    回顾@dd-sys，不难发现它就是一个图构成一个*范畴*的条件。在这种意义下，只要对演绎系统中的证明做一些形式描述#footnote[也就是将演绎过程 $A -> B$ 的所有证明在某种意义下定义为一个集合]，一个演绎系统自然就是一个范畴。更进一步，仿照演算系统中 $and, ->$ 的定义，我们规定：
    #definition[笛卡尔闭范畴][
      称一个范畴 $cat$ 是一个*笛卡尔闭范畴（Cartesian Closed Category）*，如果它满足以下条件：
      - 具有所有有限直积（继而具有终对象）
      - 任取对象 $B$，函子 $* times B$ 总有右伴随函子，记作 $*^B$，也即：
        $
          Hom(A times B, C) eqv Hom(A, C^B)
        $<dd-ccc>
        同时，上式对于 $A, B, C$ 都是自然的
    ]<def-ccc>
    #definition[
      笛卡尔闭范畴之间保持直积，指数对象结构的函子称为笛卡尔闭函子。
    ]
    #example[
      - 集合范畴 *Set* 是一个笛卡尔闭范畴，其中 $C^B$ 实际就是 $Hom(B, C)$
      - 对任何小范畴 #cat，函子范畴 $FunctorCat(cat, SetCat)$ 是笛卡尔闭范畴。其中：
        $
          H^G X = Hom(G X, H X)
        $
        验证定义即可。特别的，预层范畴 @ai_jabr $cat^(\^)$  是一个笛卡尔闭范畴。
      - 一个*半格*（Semilattice）是一个范畴。其中，对象是半格中所有元素，$Hom(x, y)$ 是一个单元素集合当且仅当 $x <= y$，否则是空集合。$x times y$ 是 $x$ 和 $y$ 的下确界。如果这个范畴是笛卡尔闭的，则称这个半格是一个*Heyting 半格*，并往往将 $x^y$ 记作 $y => x$。在 Heyting 半格中，$a and b <= c$ 当且仅当 $a <= b => c$。
    ]
    这样定义的笛卡尔闭范畴中，记@dd-ccc 中给出的自然同构为 $eta$，将 $A times B$ 解释为 $A and B$，将 $C^B$ 解释为 $B => C$，并且定义：
    $
      epsilon &: (B => A) and B -> A = A^B times B -> A\
      epsilon &:= Inv(eta)(id: A^B -> A^B)
    $<def-epsilon>
    $
      forall h: C and B -> A, h^*: C -> (B => A) = eta(h)
    $<def-duel>
    
    #proposition[
      在由笛卡尔闭范畴给出的正直觉主义演算中，有：
      - E1: $f 1 = 1 f = f, (h g) f = h (g f)$
      - E2: $forall f: A -> T, f = circle_A$
      - E3a: $pi_1 inner(f, g) = f$
      - E3b: $pi_2 inner(f, g) = g$
      - E3c: $inner(pi_1 h, pi_2 h) = h$
      - E4a: $epsilon compose inner(duel(h) pi_1, pi_2) = epsilon compose (duel(h) times id) = h$
      - E4b: $duel(epsilon compose inner(k pi_1, pi_2)) = duel(epsilon compose (k times id)) = k$
    ]<prop-ccc>
    #proof[
      基本直接验证定义即可。这里只验证比较复杂的 E4a：
      $
      epsilon compose inner(duel(h) pi_1, pi_2) = Inv(eta)(id) compose inner(eta(h) pi_1, pi_2)
      $
      根据自然性，我们有交换图：
      #align(center)[#commutative-diagram(
      node((0, 0), $Hom(A^B, A^B)$, 1),
      node((0, 1), $Hom(A^B times B, A)$, 2),
      node((1, 0), $Hom(C, A^B)$, 3),
      node((1, 1), $Hom(C times B, A)$, 4),
      arr(1, 2, $Inv(eta)$),
      arr(1, 3, $Hom(eta(h) , A^B)$),
      arr(2, 4, $Hom(eta(h) times B, A)$),
      arr(3, 4, $Inv(eta)$),)]
      将 $id$ 代入就有：
      $
        Hom((eta(h) times id), A)  (Inv(eta) (id)) = Inv(eta)(id) (eta(h) times id)\
        Inv(eta) (Hom(eta(h) , A^B)) = Inv(eta) ((x |-> x eta(h)) id) = h
      $
      因此交换图就给出了需要的等式。
      
      #footnote[
        这里的 $epsilon$ 通常被称为伴随函子的余单位 @ai_jabr，这个等式也是余单位的常见性质
      ]
    ]
    上面的命题也再次解释了演绎系统与范畴之间的关系：*一个范畴就是一个演绎系统加上一些"证明"之间的等式。*
    #corollary[有等式：
      $
        duel(h) compose k = duel(h compose (k times id)) 
      $
      它可以视作某种分配关系。
    ]
    #proof[
      $
        duel(h) compose k  &= duel(epsilon compose (duel(h) k times id)))\
        &= duel(epsilon compose (duel(h) times id) compose (k times id))\
        &= duel(h compose (k times id))
      $
    ]
    #corollary[
      设 $x : 1 -> A, g : A -> B$，有等式：
      $
        epsilon compose inner(duel(g'), x) = g compose x where g' : 1 times A -> B = g compose pi_2
      $
      这表明 $epsilon$ 的含义就是某种意义上的“函数应用”
    ]<ccc-e-app>
    #proof[
      $
        epsilon compose inner(duel(g'), x) &= epsilon compose (duel(g') times A) compose inner(id : 1 -> 1, x)\
        &= g' compose inner(id, x)\
        &= g compose pi_2 compose inner(id, x)\
        &= g compose x
      $
    ]
    #remark[
      在笛卡尔闭范畴中，我们总有：
      $
        Hom(A, B) eqv Hom(1, B^A)
      $
      这表明，一定程度上可以认为态射集本身是一个对象。但在这里的场景下，不能模糊它们之间的差别。考虑将之视为推理系统，前者的含义是：
      #align(center)[从 $A$ 命题演绎得到 $B$ 命题的所有证明]
      而后者的含义是：
      #align(center)[从真值命题 $T$ 演绎得到 $A => B$ 命题的所有证明]
      它们的等价性是通常意义上演绎定理的内容，并不是一个平凡的结果。
    ]
  #let Type = $bold("Type")$
  #let STLC = [简单类型 $lambda$ 演算]
  == #STLC 
    #let subst(x, a) = $#x arrow.tail #a$
    #STLC （Simple type $lambda$ calculus）@church_formulation_1940 @pierce_types_2002 @curry_combinatory_nodate 是逻辑学和计算机科学中非常重要的研究对象。接下来，我们将简单介绍它的定义。
    #set enum(numbering: "(a)") 
    #definition[#STLC ][
      我们定义一个*#STLC*是一个形式系统，其中包含如下几类对象：
      + 类型（Type），满足规则：
        - 包含基本类型 $1, N$
          #align(center)[#rule-set(
            prooftree(
              rule(
                $1: Type$,
              )
            ),
            prooftree(
              rule(
                $N: Type$,
              )
            )
          )
          ]
        - 如果 $A, B$ 是类型，则 $A times B, A => B$ 都是类型，分别称为乘积类型和函数类型
          #align(center)[#rule-set(
            prooftree(
              rule(
                $A: Type$,
                $B: Type$,
                $A times B: Type$
              )
            ),
            prooftree(
              rule(
                $A: Type$,
                $B: Type$,
                $A => B: Type$
              )
            )
          )
          ]
        如无特殊说明，我们用 $A, B$ 等大写字母时，它们默认代表一个类型。
      + 项（Term），使用：
        $
          Gamma x_1 : A, x_2 : B, ... tack t : C
        $
        表示项 $t$ 在上下文 $Gamma$ 下具有类型 $C$。$Gamma$ 是一些变量及其类型的集合，称为*上下文*，其中包含所有可以在 $t$ 中自由出现的变量。我们总是假设上下文中，相同的变量不能重复出现。我们有以下的项构造规则：
        - 对于每个类型 $A$，存在可数多的变量#footnote[
            无歧义时我们直接使用 $x_i$ 表示，若可能有歧义，使用 $x_i : A$ 表示 $A$ 类型的变量
          ]
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack x_i : A$
              )
            )
          )
          ]
        - 单位类型包含单位项
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack * : 1$
              )
            )
          )
          ]
        - 乘积类型包含投影项和配对项
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack x : A times B$,
                $tack pi_1 x : A$
              )
            ),
            prooftree(
              rule(
                $tack x : A times B$,
                $tack pi_2 x : B$
              )
            ),
            prooftree(
              rule(
                $tack x : A$,
                $tack y : B$,
                $tack pair(x, y) : A times B$
              )
            )
          )
          ]
        - 函数类型满足应用规则#footnote[
            在对符号清晰性没有影响时，也使用 $sep(f, x)$ 表示函数应用
          ]：
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack f : A => B$,
                $tack x : A$,
                $tack epsilon(f, x) : B$
              )
            )
          )
          ]
        - 抽象规则：
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack x : A$,
                $x : A tack t : B$,
                $tack lambda x. space t : A => B$
              )
            )
          )
          ]
        - 自然数的皮亚诺公理：
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack 0 : N$
              )
            ),
            prooftree(
              rule(
                $tack n : N$,
                $tack S(n) : N$
              )
            )
          )
          ]
        - 函数迭代规则：
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack f : A -> A$,
                $tack a : A$,
                $tack n : N$,
                $tack I(f, a, n) : A$
              )
            )
          )
          ]
      + 等价性规则#footnote[在更关心计算性时，这些规则最好看作有向的化简关系，可以参考 @thompson_type_1991 @pierce_types_2002]。我们用：
          $
            a =^Gamma b 
          $
          或者
          $
            Gamma tack a = b
          $
          表示在上下文 $Gamma$ 下，项 $a$ 和 $b$ 是相等的。其中，我们要求在 $Gamma$ 下 $a, b$ 有相同的类型。等价性规则满足自反型，对称性和传递性，并且对上下文是单调的，也即：
          #align(center)[#rule-set(
            prooftree(
              rule(
                $Gamma_1 subset Gamma_2$,
                $Gamma_1 tack a = b$,
                $Gamma_2 tack a = b$
              )
            )
          )]
          我们要求以下符合直觉的等价规则：
          #align(center)[#rule-set(
            prooftree(
              rule(
                $Gamma tack a = b$,
                $Gamma tack sep(f, a) = sep(f, b)$
              )
            ),
            prooftree(
              rule(
                $Gamma union {x : A} tack a = b$,
                $Gamma tack lambda x:A . space a = lambda x:A . space b$
              )
            ),
            prooftree(
              rule(
                $Gamma tack a : 1$,
                $Gamma tack a = *$
              ),
            ),
            prooftree(
              rule(
                $Gamma tack a : A, b : B$,
                $Gamma tack pi_1 (pair(a, b)) = a$
              ),
            ),
            prooftree(
              rule(
                $Gamma tack a : A, b : B$,
                $Gamma tack pi_2 (pair(a, b)) = b$
              )
            ),
            prooftree(
              rule(
                $Gamma tack c : A times B$,
                $Gamma tack pair(pi_1 (pair(a, b)), pi_2 (pair(a, b))) = pair(a, b)$
              )
            ),
            prooftree(
              rule(
                $Gamma union {x : A} tack t : B$,
                [$t$ 中不包含 $a$ 的自由出现],
                $Gamma tack (lambda x:A. t) a = t[subst(x, a)]$
              )
            ),
            prooftree(
              rule(
                $Gamma tack f : A => B$,
                $Gamma tack.not x$,
                $Gamma tack lambda x:A. sep(f, x) = f$
              )
            ),
            prooftree(
              rule(
                $Gamma tack a : A$,
                $Gamma tack I(f, a, 0) = a$
              )
            ),
            prooftree(
              rule(
                $Gamma tack a : A$,
                $Gamma tack n : N$,
                $Gamma tack f : A -> A$,
                $Gamma tack I(f, a, S(n)) = sep(f, I(f, a, n))$
              )
            ),
            prooftree(
              rule(
                [$t(x)$ 中不包含 $x$ 的自由出现，且 $x$ 可被 $x'$ 替换],
                $Gamma tack lambda (x : A). t(x) = lambda (x' : A). t(x')$
              )
            ),
          )]
    ]<lambda-calculus>
    上面的等价性规则说明，我们总是可以自由的扩大上下文。而之后的命题表明，如果变量没有自由出现，我们将这个变量删去以缩小上下文。
    #proposition[
      我们可以使用如下的规则化简上下文：
      #centerProofTree(rule(
        $Gamma union {x : A} tack a(x) = b(x)$,
        $Gamma tack y : A$,
        $Gamma tack a(y) = b(y)$
      ))
    ]
    #proof[
      #TODO
    ]
    #corollary[
      #centerProofTree(rule(
        $Gamma union {x : A} tack a = b$,
        [$a, b$ 中不含 $x$ 的自由出现],
        $Gamma tack a = b$
      ))
    ]
    #remark[
      在项的构造规则中，我们简化了上下文 $Gamma$。事实上：*上下文 $Gamma$ 中的项无非是将其中的内容全部作为常量产生的新#(STLC)中无上下文的项*。这种做法符合逻辑学的传统，也与之后我们的代数操作更加对应。当然，更常见的做法是在所有构造规则中允许一个任意（只要不产生冲突）的上下文 $Gamma$。
    ]
    #definition[#(STLC)之间的态射][
      设 $scrL, scrL'$ 是两个#(STLC)，称 $F : scrL -> scrL'$ 是它们之间的态射，如果：
      - $F$ 将 $scrL$ 中的类型映射到 $scrL'$ 中的类型，$scrL$ 中的项映射到 $scrL'$ 中的项，并且保持项的类型。
      - $F$ 将基本变元 $x_i$ 映到基本变元，并且保持闭项。
      - $F$ 保持单位类型，乘积类型，函数类型的结构
      - $F$ 保持等价关系
    ]
    #let lamCalc = $lambda-bold("Calc")$
    #definition[#(STLC)构成的范畴][
      称 #lamCalc 为#(STLC)构成的范畴，其中对象是所有的#(STLC)，态射是它们之间的态射。
    ]
    @lambda-calculus 给出的是#(STLC)的基本性质。也就是说，形式系统中可能包含没有出现在规则中，或者并非按照规则被构造的常量项，类型等等。这与逻辑学和计算机科学中的其他相关材料  @pierce_types_2002 @thompson_type_1991 @church_formulation_1940 的习惯，也即将其定义为由某些推导规则自由生成的形式系统并不一致。然而，此种意义下的#(STLC)只不过特指本文定义下的始对象而已。
    #proposition[
      #lamCalc 中存在始对象
    ]
    #proof[
      很容易证明，所有项，类型，等价关系都按照@lambda-calculus 自由生成，不含其他元素的#(STLC)就构成了一个始对象。 
    ]
    #example[
      #TODO (给出一些具体例子，例如：#(STLC) 中的某些项，类型，以及它们之间的等价关系)
    ]
    直观上看，@lambda-calculus 中的类型和项的构造规则与@def-ccc 中笛卡尔闭范畴的定义非常相似。其中大部分结构，包括单位类型与终对象，乘积类型与有限直积，都有着很好的对应关系。然而，至此为止，仍有以下问题未被范畴语言解决：
    - 在定义#(STLC)时，我们按照逻辑学的通常习惯，在讨论一个项时，往往要基于某个*上下文*。在使用函数抽象和函数应用时，上下文也会发生变化。然而，一个特定的笛卡尔闭范畴并不能很好的描述上下文的变化。
    - 在定义#(STLC)时，为了方便起见我们要求了自然数类型的存在。我们还没有在范畴中刻画自然数。
    接下来两节将解决这两个问题。
  == 自然数对象
    在@lambda-calculus 中，我们对自然数类型的要求基本和经典的皮亚诺公理是一致的。在范畴中，我们也可以类似叙述皮亚诺公理：
    #definition[自然数对象][
      在一个范畴 $cat$ 中，称一个对象 $N$ 是一个*自然数对象*，如果存在态射 $0 : 1 -> N$ 和 $S : N -> N$，使得对于任意对象 $A$ 和态射 $a : 1 -> A, f : A -> A$，存在唯一的态射 $I(f, a) : N -> A$ 使得以下图交换：
      #align(center)[#commutative-diagram(
      node((0, 0), $1$, 1),
      node((0, 1), $N$, 2),
      node((0, 2), $N$, 3),
      node((1, 0), $1$, 4),
      node((1, 1), $A$, 5),
      node((1, 2), $A$, 6),
      arr(1, 2, $0$),
      arr(2, 3, $S$),
      arr(4, 5, $a$),
      arr(5, 6, $f$),
      arr(1, 4, $$, bij_str),
      arr(2, 5, $I(f, a)$),
      arr(3, 6, $I(f, a)$),)]
      事实上，它是所有形如 $1 ->^a A ->^f A$ 的图表中的始对象，因此若存在则一定是唯一的。
    ]<def-nat>
    #example[
      在 #SetCat 中，自然数集合 $NN$ 自然应该是一个自然数对象。检查定义，给定：
      $
        1 ->^a A ->^f A 
      $
      只需要按照如下标准的方式进行递归定义：
      $
        I(f, a)(0) = a(*), I(f, a)(S(n)) = f(I(f, a)(n))
      $
      不难看出，$I(f, a)$ 就是唯一的满足定义中图表交换的态射。
    ]
    在本文的范围内，@def-nat 中的唯一性略显多余。因此，我们称 $N$ 是*弱自然数对象*，如果存在（但未必唯一）满足@def-nat 中图表的 $I(f, a)$。

    #let CartN = $bold("Cart")_N$
    #definition[
      定义 #CartN 为所有含有弱自然数对象的笛卡尔闭范畴构成的范畴，其中态射是保持笛卡尔闭结构和自然数对象结构的函子。
    ]
  == 多项式范畴
    在 @dd-sys-s 中，我们提到这样一个思想：在假设 $x : A -> B$ 下进行演绎，可以视作在原有演绎系统中，添加一个箭头 $x : A -> B$，并按照演绎系统的规则自由生成一个新的演绎系统。这样的想法可以很容易的代数化，这就是我们要给出的*多项式范畴*的定义。
    #definition[多项式范畴][
      设 $cat$ 是一个笛卡尔闭范畴，$A, B$ 是其中对象，$x : A -> B$ 是一个未定元。称一个范畴 $cat[x]$ 是 $cat$ 关于 $x$ 的*多项式范畴*，如果它满足以下条件：
      - 存在笛卡尔闭函子 $H : cat -> cat[x]$
      - 对于任何笛卡尔闭范畴 $cat'$，函子 $F : cat -> cat'$ 和态射 $b : F A -> F B$，存在唯一函子 $F'$ 使得：
        #align(center)[#commutative-diagram(
        node((0, 0), $cat$, 1),
        node((0, 1), $cat'$, 2),
        node((1, 0), $cat[x]$, 3),
        arr(1, 2, $F$),
        arr(3, 2, $exists! F'$, dashed_str),
        arr(1, 3, $H_x$),)]
    ]
    #proposition[
      对于任何笛卡尔闭范畴 $cat$ 和对象 $A, B$，以及态射 $x : A -> B$，多项式范畴 $cat[x]$ 都存在且唯一。
    ]
    #proof[
      #TODO
    ]
    #proposition[
      对于两个未定元 $x_1, x_2$，我们有：
      $
        cat[x_1][x_2] eqv cat[x_2][x_1]
      $
      进而，我们可以忽略其顺序，定义 $cat[x_1, x_2] := cat[x_1][x_2]$
    ]
    #proof[
      #TODO
    ]

    定义了多项式范畴之后，自然会想到@dd-theorem 能否推广到多项式范畴中。答案是肯定的。
    #theorem[函数完备性][
      设未定元 $x : 1 -> A$，对于所有多项式 $phi(x) : B -> C$（也即 $cat[X]$ 中的一个态射），存在 $cat$ 中唯一一个态射 $f : A times B -> C$ 使得：
      $
        f compose ((x compose circle : A -> A) times B) = phi(x)
      $
    ]<func-completeness>
    #proof[
      #TODO
    ]
    #corollary[
      设未定元 $x : 1 -> A$，对于任何多项式 $phi(x): 1 -> C$，$cat$ 中存在唯一的态射 $g : A -> C$ 使得 $g compose x = phi(x)$，或者存在唯一 $h : 1 -> C^A$ 使得：
      $
        epsilon compose inner(h, x) = phi(x)
      $ 
    ]<cor-abs>
    #proof[
      套用@func-completeness 并注意到 $A times 1 eqv A$ 立刻得到需要的 $g$。至于 $h$ 只需使用@def-ccc 中的自然同构即可。所求等式就是@ccc-e-app 的结论。
    ]
    上面的结论表明，要得到一个 $1 -> C^A$ 的态射，我们只需要设一个未定元 $x : 1 -> A$，在多项式范畴 $cat[x]$ 中找到一个 $1 -> A$ 的态射，这个态射就可以自然地对应回 $cat$ 中一个 $1 -> C^A$ 的态射。这个过程就精确地描述了#(STLC)中“函数抽象”的过程。
    #proposition[
      设 $cat$ 是一个含有弱自然数对象 $N$ 的笛卡尔闭范畴，则对任何未定元 $x : 1 -> A$，$N$ 也是 $cat[x]$ 中的弱自然数对象。
    ]
    #proof[
      #TODO
    ]
    #let bL = $bold(L)$

    对于不同的类型系统，上下文的范畴化处理是一个重要话题。本文采用的多项式范畴技术来自 @Deductive_systems_and_categories。随着对范畴与类型系统的研究逐渐深入，*纤维范畴*（fiber category）等更为精细的工具也被引入到这一领域中来，可以参考@jacobs_categorical_nodate 中的相关介绍。
  == #lamCalc 与 #CartN 的范畴同构
    最后，我们可以开始着手进行本章的最终结论了。我们将证明，#(STLC)构成的范畴 #lamCalc 与所有含有弱自然数对象的笛卡尔闭范畴构成的范畴 #CartN 是范畴同构的。为此，我们分别构造两个方向上的函子。

    #definition[
      称一个带弱自然数对象的笛卡尔闭范畴 $cat$ 的*内语言*（internal language）为如下定义的#(STLC) $bL(cat)$:
      - 其类型为 $cat$ 中的对象，$1, N, * times *, * => *$ 分别就是 $cat$ 中的 $1, N, * times *, *^*$
      - 在上下文 $Gamma$ 中，具有 $A$ 类型的项就是 $cat[Gamma]$ 中 $1 -> A$ 的态射。其中 $cat[Gamma]$ 的含义是将 $Gamma$ 中所有的 $x_i : A_i$ 视作未定元 $x_i : 1 -> A_i$，构造相应的多项式范畴。

        单位类型，乘积类型，自然数类型的构造规则是自明的。函数类型的应用规则：
        #align(center)[#rule-set(
            prooftree(
              rule(
                $tack f : A => B$,
                $tack x : A$,
                $tack epsilon(f, x) : B$
              )
            )
          )
          ]
        由 $epsilon compose inner(f, x)$ 给出，其中 $epsilon$ 就是 @def-epsilon 中给出的 $epsilon$

        函数的抽象规则：
        #align(center)[#rule-set(
            prooftree(
              rule(
                $tack x : A$,
                $x : A tack t : B$,
                $tack lambda x. space t : A => B$
              )
            )
          )
          ]
        由上节对@cor-abs 的解释给出
      - 等式规则就是范畴中的等式，也即 $Gamma tack a = b$ 解释为在范畴 $cat[Gamma]$ 中，有态射间的等式 $a = b$ 

        容易检验，@lambda-calculus 中的等价性规则在我们给出的内语言中都成立。
    ]
    #proposition[
      $scrL(*)$ 是 $CartN -> lamCalc$ 的函子。具体来说，对于笛卡尔闭范畴之间的函子 $F : cat_1 -> cat_2$，我们按照如下方式定义 $scrL(F) : scrL(cat_1) -> scrL(cat_2)$：
      - 对于所有 $scrL(cat_1)$ 中的类型 $A$，定义 $scrL(F)(A) := F A$
      - 对于任意的上下文 $Gamma tack t : A$，定义 $Gamma' := scrL(F)(Gamma)$ 为将自由变量映到自由变量，将类型映到类型。同时，令 $F_Gamma$ 为唯一的使下表交换的态射：
      #align(center)[#commutative-diagram(
      node((0, 0), $cat_1[Gamma]$, 1),
      node((0, 1), $cat_2[Gamma']$, 2),
      node((1, 0), $cat_1$, 3),
      node((1, 1), $cat_2$, 4),
      arr(1, 2, $F_Gamma$, dashed_str),
      arr(3, 1, $$),
      arr(4, 2, $$),
      arr(3, 4, $F$),)]
        定义 $scrL(F)(t) := F_Gamma (t)$
      则它具有函子性。
    ]
    #proof[
      #TODO
    ]
    #definition[
      称一个#(STLC) $scrL$ 的*语法范畴*（Syntactic Category）是如下定义的范畴 $cat(scrL)$：
      - 其对象就是 $scrL$ 中的类型
      - 其中一个态射 $A -> B$ 就是满足条件的：
        $
          tack x : A\
          x : A tack t : B
        $
        的二元组 $(x, t)$ 的等价类，其等价关系定义为：
        $
          (x, t) = (x', t') := x : A tack t = t'[subst(x', x)]
        $
      - 态射 $(x, t), (y, s)$ 的复合定义为：
        $
          (x, s[subst(y, t)])
        $
      - 笛卡尔闭结构由以下给出：
        $
          circle_A &= (x, *) \
          pi_1 &= (x, pi_1 compose x) \
          pi_2 &= (x, pi_2 compose x) \
          inner((z, t_1), (z, t_2)) &= (z, pair(t_1, t_2)) \
          duel((z, t)) &= (x, lambda y: B. t[subst(z, inner(x, y))])\
          epsilon &= (y, epsilon(pi_1 compose y, pi_2 compose y))\
        $
    ]
    #proposition[
      $N$ 是 $cat(scrL)$ 中的一个弱自然数对象
    ]
    #proposition[
      $cat(*)$ 是 $lamCalc -> CartN$ 的函子
    ]
    之前提到过，我们用多项式范畴来处理在#(STLC)中引入未定常量的操作。下面的定理再次严格说明了这一点：
    #theorem[
      $cat(scrL)[x : 1 -> A] eqv cat(scrL[x : 1 -> A])$
    ]
    #proof[
      #TODO
    ]
    最终，我们可以着手证明#lamCalc 与 #CartN 的范畴同构了。
    #theorem[
      $cat(*), scrL(*)$ 构成了一对范畴同构 $lamCalc eqv CartN$
    ]
    #proof[
      也就是要验证 $cat(*) scrL(*) eqv id$ 和 $scrL(*) cat(*) eqv id$ #TODO
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
