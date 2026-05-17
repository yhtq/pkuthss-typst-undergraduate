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
  year_and_month : "二〇二六年五月"
) <title-page>


// 导师评价
// CheckSheet参数全部必填
#CheckSheet(
  name : "郭子荀",
  studentid : "2100012990",
  school : "数学科学学院",
  major : "数据科学与大数据",
  supervisor : "夏壁灿",
  department : "数学科学学院",
  grade : "",
  title : "教授",
  chinese_title : "类型系统的范畴语义",
  english_title : "The Categorical Semantics of Type Theory",
  sign_pic : image("asset/pkulogo.svg"),
  year : 2026,
  month : 5,
  day : 15,
)[

] // end of check comment

#let where = math.serif([其中])


// Copyright
#CopyrightClaim <copy-right>

// 中文摘要
#ChineseAbstract(
  keywords : ("类型论", "范畴论", "范畴语义", "形式逻辑", "程序语言")
)[

类型理论是形式逻辑的延伸，其中的逻辑符号各自具备不同的类型，类型之间也满足一定的规则。历史上，逻辑学家提出了类型理论，并试图将其作为数学的基础。之后，人们逐渐发现建立在类型系统上的逻辑总是与某些范畴之间存在着深刻的联系。计算机诞生并发展之后，类型理论以及其与范畴之间的联系也被计算机科学家们所关注，并且对程序语言理论的发展产生了重要的影响。

本文是《Introduction to Higher Order Categorical Logic》@lambek_introduction_1986 一书的读书报告，目标是统一基于类型论的逻辑与范畴，具体介绍其中几个经典的对应关系：简单类型 Lambda 演算与笛卡尔闭范畴，topoes 与直觉主义类型系统。

]

// English Abstract
#EnglishAbstract(
  keywords : ("Type Theory", "Category Theory", "Formal Logic", "Programming Language")
)[
  Type theory is an extension of formal logic, where logical symbols have different types and there are certain rules governing the relationships between types. Historically, logicians proposed type theory and attempted to use it as a foundation for mathematics. Later, it was gradually discovered that there are profound connections between logics based on type systems and certain categories. With the advent and development of computers, type theory and its connections with category theory have also attracted the attention of computer scientists and have had a significant impact on the development of programming language theory.

  This article is a reading report on the book "Introduction to Higher Order Categorical Logic" @lambek_introduction_1986, aiming to unify type-theoretic logic and category theory, specifically introducing several classic correspondences: simply typed lambda calculus and Cartesian closed categories, toposes and intuitionistic type systems.
]


// 目录
#TableOfContent

#let theorem = thmbox("theorem", "定理", fill: rgb("#eeffee"))
#let lemma = thmbox("lemma", "引理", titlefmt: strong, fill: rgb("#eeffee"))
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
  *类型（Type*）的概念最早由 Russell 和 Whitehead @Whitehead1910-WHIPM-8 引入，以解决当时人们所面临的朴素集合论的悖论。之后，类型理论被发展成为一个重要的研究对象，并随着计算机科学的发展，成为了程序语言理论的核心工具之一 @pierce_types_2002 。粗略地说，一个类型系统中包含着一些类型和项，在一定上下文下，一个结构良好的项应该具有唯一的类型。同时，系统中有着一些规则，规定了类型和项的可能构造方式，以及判定项的类型的方法。

  *范畴（Category*）是近现代数学中非常重要的工具之一。最早，它作为描述数学中广泛存在自然关系的工具被引入@eilenberg_general_1945 ，后来被广泛应用于数学的各个分支。它的核心思想是将数学对象抽象为一些对象（Object）和态射（Morphism），并且规定了态射之间的复合关系。

  尽管两个领域的起源完全不同，但随着人们研究的深入，它们之间的关系也逐渐被发现。Lawvere 首先尝试使用范畴论作为数学的逻辑基础，并为了使用范畴语言描述逻辑中常见的替换（Substitution）操作，引入了笛卡尔闭范畴（Cartesian Closed Category）的概念 @38b76542-b771-32c2-a3ea-ba3f392713d3。由于形式上的相似性，它与简单类型 Lambda 演算@church_formulation_1940 之间的等价关系迅速被发现。逻辑学家为了增强类型的表达能力，逐渐发展出了更强的类型系统，例如 Martin-Löf 类型理论。独立地，局部笛卡尔闭范畴（Locally Cartesian Closed Category）被范畴学家提出，之后，它被发现与 Martin-Löf 类型理论之间存在着深刻的联系 @seely_locally_1984。Lawvere 与 Tierney 从代数几何的工具中发展出了 topos 的概念以作为集合论的替代@history_of_topos，与其相关联的类型理论 Mitchell–Bénabou 语言也被提出。
  本文大体上按照 《Introduction to Higher Order Categorical Logic》 的脉络，首先介绍一些基础的范畴工具。之后，我们将着重介绍两个重要的对应关系：简单类型 Lambda 演算与笛卡尔闭范畴，topoes 与直觉主义类型系统。主要理论和工具基本与原书一致，但引入顺序和方式可能会做出一些调整，许多记号也被调整为更接近近期文献的习惯。

  原书以及诸多其他文献 @jacobs_categorical_nodate @girard_proofs_1989 @pierce_types_2002 @pierce_types_2002 共同强调了一个重要的观点：*类型系统*，*演绎逻辑*与*范畴*之间存在着高度的一致性（经常被代数化的表示为，存在一对双向的函子构成范畴同构或者伴随对）。本文也将贯彻这一思想。例如，我们重新引入了演绎系统来作为笛卡尔闭范畴和简单类型 Lambda 演算的模板。为了服从这一目的，我们定义演绎系统时采用的规则、公理和记号等可能并不符合传统的形式逻辑习惯，以便更好地强调它与类型论、范畴理论之间的对应关系。

#let cat = $cal(C)$
= 预备知识
  == 范畴
    本文中，我们采用标准的范畴论概念。
    #definition[范畴][
      一个*范畴* $cat$ 包含以下数据：
      - 一类对象 $Ob(cat)$
      - 对任意两个对象 $A, B$，一个态射集合 $Hom(A, B)$，其中元素通常记作 $f: A -> B$，也称为从 $A$ 到 $B$ 的箭头。
      - 对任意三个对象 $A, B, C$，一个复合运算 $Hom(B, C) times Hom(A, B) -> Hom(A, C)$，满足结合律。
      - 对任意对象 $A$，一个单位态射 $1_A : A -> A$，满足单位律。
    ]<def-cat>
    #definition[同构][
      范畴 $cat$ 中的两个对象 $A$ 和 $B$ 是同构的，如果存在态射 $f: A -> B$ 和 $g: B -> A$，使得 $g f = 1_A$ 和 $f g = 1_B$。
    ]
    #definition[始对象][
      设 $cat$ 是一个范畴，如果存在一个对象 $0$，使得对于任意对象 $A$，$Hom(0, A)$ 是恰有一个元素，则称 $0$ 是 $cat$ 的*始对象*。始对象若存在，则在同构意义下是唯一的。
    ]
  == 函子
    #definition[
      一个*函子* $F: cat_1 -> cat_2$ 是一个对象函数 $F: Ob(cat_1) -> Ob(cat_2)$ 和一个态射函数 $F: Hom_(cat_1)(A, B) -> Hom_(cat_2)(F A, F B)$，满足保持复合和单位态射的性质。
    ]<def-functor>
    #definition[自然变换][
      给定两个函子 $F, G: cat_1 -> cat_2$，一个*自然变换* $alpha: F => G$ 是一个态射族 $alpha_A : F A -> G A$，满足对于任意态射 $f: A -> B$，有交换图：
      #align(center)[#commutative-diagram(
        node((0, 0), $F A$, 1),
        node((0, 1), $G A$, 2),
        node((1, 0), $F B$, 3),
        node((1, 1), $G B$, 4),
        arr(1, 2, $alpha_A$),
        arr(1, 3, $F f$),
        arr(2, 4, $G f$),
        arr(3, 4, $alpha_B$),)]
    ]
    #definition[伴随函子][
      设 $F, G$ 是两个函子，如果有自然同构 $Hom (F *, -) eqv Hom (*, G -)$，则称 $F$ 是 $G$ 的*左伴随函子*，$G$ 是 $F$ 的*右伴随函子*。
    ]
  == 直积/直和
    #definition[直积对象][
      范畴 $cat$ 中对象 $A, B$ 的一个*直积对象*是一个对象 $A times B$，以及两个态射 $pi_1: A times B -> A, pi_2: A times B -> B$，满足以下性质：对于任意对象 $C$ 和态射 $f: C -> A, g: C -> B$，存在唯一的态射 $pair(f, g): C -> A times B$，使得 $pi_1 pair(f, g) = f, pi_2 pair(f, g) = g$
    ]
    #let copair(f, g) = $#f + #g$
    #definition[直和对象][
      范畴 $cat$ 中对象 $A, B$ 的一个*直和对象*是一个对象 $A + B$，以及两个态射 $iota_1: A -> A + B, iota_2: B -> A + B$，满足以下性质：对于任意对象 $C$ 和态射 $f: A -> C, g: B -> C$，存在唯一的态射 $copair(f, g): A + B -> C$，使得 $(copair(f, g)) compose iota_1 = f, (copair(f, g)) compose iota_2 = g$
    ]

= 简单类型 Lambda 演算与笛卡尔闭范畴 <lambda-arithmetic>
  == 演绎系统<dd-sys-s>
    尽管本文的重点是类型系统与范畴，这节我们还是从形式逻辑的角度引入，使用一个代数化的语言来重新描述推理系统，从而使得后面的内容更容易理解。#footnote[
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
    在我们的设置下，它已经由公理 R4b 所包含。然而，我们可以从更高的角度重新考虑这个问题：若记原有的演绎系统为 $scrL$，添加一个额外的*假设* $x: T -> A$ 如同在 $scrL$ 中添加了一个新的箭头，并在对应演绎规则下，自由生成了一个新的演绎系统 $scrL(x)$ #footnote[我们使用了类似多项式的记号，直观上可以认为这里添加一个对象自由生成的行为类似于添加未定元得到的多项式空间，之后我们会使用范畴的语言详细介绍。]。在这样的想法下，演绎定理可以表述为：
    #theorem[演绎定理][
      在正直觉主义演算 $scrL$ 中，任何 $scrL(x : T -> A)$ 中的箭头 $phi(x) : B -> C$ 总对应一个 $scrL$ 中的箭头 $B and A -> C$
    ]<dd-theorem>
    #proof[
      忽略一些形式化的细节，应当只需要对以下几种 $scrL(x)$ 中的箭头的构造方式进行归纳：
      - $scrL$ 中的箭头 $phi(x) = psi : B -> C$，此时我们要找的 $X and A -> C$ 的箭头自然的就是 $psi compose pi_1$
      - 由 R3c 产生的箭头 $phi(x) = inner(psi_1(x), psi_2(x))$，此时我们设 $C = C_1 and C_2$. 由归纳假设，存在 $scrL$ 中的箭头：
        $
          psi'_1: B and A -> C_1, psi'_2: B and A -> C_2
        $
        自然的，$inner(psi'_1, psi'_2)$ 就是我们要找的箭头。
      - 由 R4b 产生的箭头：
        $
          phi(x) = duel(psi(x)) where psi(x): (B and C_1) -> C_2
        $
        此时设 $C = C_1 => C_2$。由归纳假设，存在 $scrL$ 中的箭头：
        $
          psi': (B and C_1) and A -> C_2
        $
        直观上，我们需要一个 $(B and A) and C_1 -> C_2$ 的箭头之后，才能利用 R4b 得到我们所希望的，$B and A -> C$。逻辑学的直觉告诉我们，$and$ 构造符应当满足结合性，也即：
        $
          (A and B) and C eqv A and (B and C)
        $
        其证明#footnote[
          这里，我们说两个命题 $A, B$ 是等价的是指存在一对箭头 $f: A -> B, g: B -> A$，但不要求其他性质，也就是通常的逻辑连接词 $<=>$，它比范畴意义的同构（往往要求 $f compose g = 1, g compose f = 1$）略弱一点，因为我们暂时还没有讨论什么样的箭头之间是相等的。
        ]来自于：
        $
          inner(pi_1 compose pi_1, inner(pi_2 compose pi_1, pi_2)), inner(inner(pi_1, pi_1 compose pi_2), pi_2 compose pi_2)
        $
        以及交换性：
        $
          A and B eqv B and A
        $
        其证明来自于：
        $
          inner(pi_2, pi_1), inner(pi_2, pi_1)
        $
        如此，我们就可以根据交换结合性得到箭头：
        $
          eta: (B and C_1) and A eqv (B and A) and C_1\
        $
        进而：
        $
          psi' compose Inv(eta) : (B and A) and C_1 -> C_2\
          duel(psi' compose Inv(eta)) : B and A -> (C_1 => C_2) = C
        $
        这就得到了我们想要的结果。

    ]
    #remark[这里我们只陈述了正直觉主义演算的情形。当然，对于其他常见的演绎系统，例如添加 $or, bot$ 的直觉主义演算，添加排中律的经典逻辑演算，这样的演绎定理也成立，并且证明也是类似的。]
  == 笛卡尔闭范畴
    回顾@dd-sys，不难发现它就是一个图构成一个*范畴*的条件。在这种意义下，只要对演绎系统中的证明做一些形式描述#footnote[也就是将演绎过程 $A -> B$ 的所有证明，在商掉某个等价关系的意义下，组成一个集合]，一个演绎系统自然就是一个范畴。更进一步，仿照演算系统中 $and, ->$ 的定义，我们规定：
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
    ]<duel-distribute>
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
      它们的等价性是通常意义上演绎定理的内容，并不是一个可以忽略的平凡结果。
    ]
  #let Type = $bold("Type")$
  #let STLC = [简单类型 $lambda$ 演算]
  == #STLC
    #let subst(x, a) = $#x arrow.tail #a$
    *#STLC （Simply typed $lambda$ calculus）*@church_formulation_1940 @pierce_types_2002 @curry_combinatory_nodate 是逻辑学和计算机科学中非常重要的研究对象。接下来，我们将简单介绍它的定义。
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
          Gamma = x_1 : A, x_2 : B, ... tack t : C
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
          ]
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
        - 抽象规则
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
        - 自然数的皮亚诺公理
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
        - 函数迭代规则
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
        - 扩大上下文规则
          #align(center)[#rule-set(
            prooftree(
              rule(
                $Gamma subset Gamma'$,
                $Gamma tack t : A$,
                $Gamma' tack t : A$
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
                $Gamma tack f : A => A$,
                $Gamma tack I(f, a, 0) = a$
              )
            ),
            prooftree(
              rule(
                $Gamma tack a : A$,
                $Gamma tack n : N$,
                $Gamma tack f : A => A$,
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
      #centerProofTree(rule(
        rule(rule(
          $Gamma union {x : A} tack a(x) = b(x)$,
          $Gamma tack lambda x. a(x) = lambda x. b(x)$
        ),
        $Gamma tack y : A$,
        $Gamma tack (lambda x. a(x)) y = (lambda x. b(x)) y$),
        $Gamma tack a(y) = b(y)$

      ))
    ]
    上面的证明中，我们使用了*证明树*的写法，清晰地展示了每一步的推导关系。其中，长横线上方的是（零个或多个）前提，下方的是结论，每个横线都明确地对应一个推导规则。
    #corollary[
      #centerProofTree(rule(
        $Gamma union {x : A} tack a = b$,
        [$a, b$ 中不含 $x$ 的自由出现],
        $Gamma tack a = b$
      ))
    ]
    // #remark[
    //   在项的构造规则中，我们简化了上下文 $Gamma$。事实上：*上下文 $Gamma$ 中的项无非是将其中的内容全部作为常量产生的新#(STLC)中无上下文的项*。这种做法符合逻辑学的传统，也与之后我们的代数操作更加对应。当然，更常见的做法是在所有构造规则中允许一个任意（只要不产生冲突）的上下文 $Gamma$。
    // ]
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
      #lamCalc 中存在始对象，记为 $lamCalc_0$
    ]
    #proof[
      很容易证明，所有项，类型，等价关系都按照@lambda-calculus 自由生成，不含其他元素的#(STLC)就构成了一个始对象。
    ]
    #example[
      所谓 $lamCalc_0$ 中的项/类型，直观来说，就是存在于所有#(STLC)中的项/类型。例如：
      - $N: Type, N times N: Type, N => N: Type$
      - $S(0): N, S(S(0)): N, ...$
      我们还可以定义一些具有熟悉语义的函数，例如：
      - $"ite"_(A): N => A => A => A$，定义为：
        $
          "ite"_A := lambda n. lambda a_1. lambda a_2. I(lambda x. a_1, a_2, n)
        $
        也即：当 $n$ 是 $0$ 时返回 $a_2$，当 $n$ 是 $S(m)$ 时返回 $a_1$。
      - $"prev" : N => N$，定义为：
        $
          "prev" := lambda n. I(sep(lambda x. "ite"_N, x, 0, S(n) ) , 0, n)
        $
        也即：当 $n$ 是 $0$ 时返回 $0$，当 $n$ 是 $S(m)$ 时返回 $m$。
    ]
    直观上看，@lambda-calculus 中的类型和项的构造规则与@def-ccc 中笛卡尔闭范畴的定义非常相似。其中大部分结构，包括单位类型与终对象，乘积类型与有限直积，都有着很好的对应关系。然而，至此为止，仍有以下问题未被范畴语言解决：
    - 在定义#(STLC)时，我们按照逻辑学的通常习惯，在讨论一个项时，往往要基于某个*上下文*。在使用函数抽象和函数应用时，上下文也会发生变化。然而，一个特定的笛卡尔闭范畴并不能很好的描述上下文的变化。
    - 在定义#(STLC)时，为了方便起见，我们要求了自然数类型的存在。我们还没有在范畴中刻画自然数。
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
    #lemma[
      设 $N$ 是自然数对象，$f : N -> N$ 满足：
      $
        f compose S = S compose f and f compose 0 = 0
      $
      则 $f = id$
    ]<nat-id-lemma>
    #proof[
      在泛性质中：
            #align(center)[#commutative-diagram(
      node((0, 0), $1$, 1),
      node((0, 1), $N$, 2),
      node((0, 2), $N$, 3),
      node((1, 0), $1$, 4),
      node((1, 1), $N$, 5),
      node((1, 2), $N$, 6),
      arr(1, 2, $0$),
      arr(2, 3, $S$),
      arr(4, 5, $0$),
      arr(5, 6, $S$),
      arr(1, 4, $$, bij_str),
      arr(2, 5, $exists! i$),
      arr(3, 6, $exists! i$),)]
      显然 $i = id$ 和 $i = f$ 都满足交换图，因此由唯一性可得 $f = id$
    ]
    #proposition[
      设 $N$ 是自然数对象，则有：
      $
        N eqv 1 + N
      $
    ]<nat-coproduct>
    #proof[
      我们验证 $N$ 满足 $1 + N$ 的泛性质，也即对于任何 $A$ 若有图表：
      #align(center)[#commutative-diagram(
      node((0, 0), $N$, 1),
      node((0, 1), $1$, 2),
      node((1, 0), $N$, 3),
      node((1, 1), $A$, 4),
      arr(2, 1, $0$),
      arr(3, 1, $S$),
      arr(2, 4, $a$),
      arr(3, 4, $f$),)]
      我们应用如下的自然数对象的泛性质：
            #align(center)[#commutative-diagram(
      node((0, 0), $1$, 1),
      node((0, 1), $N$, 2),
      node((0, 2), $N$, 3),
      node((1, 0), $1$, 4),
      node((1, 1), $N times A$, 5),
      node((1, 2), $N times A$, 6),
      arr(1, 2, $0$),
      arr(2, 3, $S$),
      arr(4, 5, $inner(0, a)$),
      arr(5, 6, $inner(S pi_1, f pi_1)$),
      arr(1, 4, $$, bij_str),
      arr(2, 5, $exists! i$),
      arr(3, 6, $exists! i$),)]
      断言以下图表交换：
      #align(center)[#commutative-diagram(
      node((0, 0), $N$, 1),
      node((0, 1), $1$, 2),
      node((1, 0), $N$, 3),
      node((1, 1), $A$, 4),
      arr(2, 1, $0$),
      arr(3, 1, $S$),
      arr(2, 4, $a$),
      arr(3, 4, $f$),
      arr(1, 4, $pi_2 compose i$)
      )]
      这是因为：
      $
        pi_2 compose i compose 0 = pi_2 compose inner(0, a) = a\
        pi_2 compose i compose S = pi_2 compose inner(S pi_1, f pi_1) compose i = f compose pi_1 compose i
      $
      同时：
      $
        pi_1 compose i compose S = pi_1 compose inner(S pi_1, f pi_1) compose i = S compose pi_1 compose i\
        pi_i compose i compose 0 = pi_1 compose inner(0, a) = 0
      $
      根据@nat-id-lemma 可得 $pi_1 compose i = id$，因此就得到：
      $
        pi_2 compose i compose S = f
      $
      这就表明上图交换。至于唯一性，设 $j : N -> A$ 也满足上面的余积交换图，返回验证：
      $
        inner(id, j) : N -> N times A
      $
      可以在自然数交换图中替代 $i$ 的位置即可。具体来说：
      $
        inner(id, j) compose 0 = inner(0, j compose 0) = inner(0, a)\
        inner(id, j) compose S = inner(S, j compose S) = inner(S, f) = inner(S pi_1, f pi_1) compose inner(id, j)
      $
      再由 $i$ 的唯一性，立得：
      $
        inner(id, j) = i\
        j = pi_2 compose inner(id, j) = pi_2 compose i
      $
      证毕。
    ]
    @nat-coproduct 也可以被解释为某种*递归原理*：对于任何类型 $A$，想要定义一个 $N -> A$ 的态射 $f$，只需要一个 $1 -> A$ 的态射作为递归起点，以及另一个 描述 $f compose S$ 的态射 $N -> A$，如此一来，$f$ 就被余积的性质唯一决定了。

    在本文的范围内，有时@def-nat 中的唯一性略显多余。因此，我们称 $N$ 是*弱自然数对象*，如果存在（但未必唯一）满足@def-nat 中图表的 $I(f, a)$。

    #let CartN = $bold("Cart")_N$
    #let Cart = $bold("Cart")$
    #definition[
      定义 #CartN 为所有含有弱自然数对象的笛卡尔闭范畴构成的范畴，其中态射是保持笛卡尔闭结构和自然数对象结构的函子。
    ]
  == 多项式范畴
    在 @dd-sys-s 中，我们提到这样一个思想：在假设 $x : A -> B$ 下进行演绎，可以视作在原有演绎系统中，添加一个箭头 $x : A -> B$，并按照演绎系统的规则自由生成一个新的演绎系统。这样的想法可以很容易的代数化，这就是我们要给出的*多项式范畴*的定义。
    #definition[多项式范畴][
      设 $cat$ 是一个笛卡尔闭范畴，$A, B$ 是其中对象，$x : A -> B$ 是一个未定元。称一个范畴 $cat[x]$ 是 $cat$ 关于 $x$ 的*多项式范畴*，如果它满足以下条件：
      - 存在笛卡尔闭函子 $H : cat -> cat[x]$
      - 对于任何笛卡尔闭范畴 $cat'$，笛卡尔闭函子 $F : cat -> cat'$ 和态射 $b : F A -> F B$，存在唯一笛卡尔闭函子 $F'$ 使得：
        #align(center)[#commutative-diagram(
        node((0, 0), $cat$, 1),
        node((0, 1), $cat'$, 2),
        node((1, 0), $cat[x]$, 3),
        arr(1, 2, $F$),
        arr(3, 2, $exists! F'$, dashed_str),
        arr(1, 3, $H_x$),)]
        并且 $F' x = b$
    ]
    #proposition[
      对于任何笛卡尔闭范畴 $cat$ 和对象 $A, B$，以及态射 $x : A -> B$，多项式范畴 $cat[x]$ 都存在且唯一。
    ]<polycat-existence>
    #proof[
      大体来说我们使用以下的技术：在范畴 $cat$ 的基础上，我们添加一个新的箭头 $x : A -> B$，并且让它按照笛卡尔闭范畴的规则自由生成。我们忽略一些形式化的细节#footnote[更加详细的讨论见附录]并记这样得到的笛卡尔闭范畴就是 $cat[x]$。事实上，$cat[x]$ 中的对象就是 $cat$ 中的对象，而态射无非由以下几种情况归纳产生：
      - $cat$ 中的态射 $f$
      - $x$ 本身
      - 两个含 $x$ 的态射的复合 $f(x) compose g(x)$
      - 两个含 $x$ 的态射的乘积 $inner(f(x), g(x))$
      - 含 $x$ 态射的右伴随 $eta(f(x)) where f: A times B -> C$
      而 $H_x$ 的定义是平凡的。回到命题本身，我们证明其中的泛性质。递归的，我们定义这样的函子 $F'$:
      - $F' X = F X$，其中 $X$ 是 $cat, cat[x]$ 中的对象
      - 在态射上满足以下递归定义：
        - $F' f = F f$，其中 $f$ 是 $cat$ 中的态射
        - $F' x = b$
        - $F'(f(x) compose g(x)) = F' f(x) compose F' g(x)$
        - $F'(inner(f(x), g(x))) = inner(F' f(x), F' g(x))$
        - $F'(eta(f(x))) = eta(F' f(x))$
      不难验证，这样的 $F'$ 当然是满足交换图条件的。至于唯一性，假设 $F''$ 是另一个满足条件的函子，检查上面的定义规则：
      - $F'' f = F f = F' f$ 是由交换图决定的
      - $F'' x = b = F' x$ 是由定义要求的
      - 其余三条都是笛卡尔闭函子必要的
      这就表明，$F''$ 只能是 $F'$
    ]
    #proposition[
      对于两个未定元 $x_1, x_2$，我们有：
      $
        cat[x_1][x_2] eqv cat[x_2][x_1] eqv cat[inner(x_1, x_2)]
      $
      进而，我们可以忽略其顺序，定义 $cat[x_1, x_2] := cat[inner(x_1, x_2)]$
    ]
    #proof[
      略
    ]

    定义了多项式范畴之后，自然会想到@dd-theorem 能否推广到多项式范畴中。答案是肯定的。
    #theorem[函数完备性][
      设未定元 $x : 1 -> A$，对于所有多项式 $phi(x) : B -> C$（也即 $cat[x]$ 中的一个态射），存在 $cat$ 中唯一一个态射 $f : A times B -> C$ 使得：
      $
        f compose inner((x compose circle : B -> A), id\: B -> B)) = phi(x)
      $
    ]<func-completeness>
    #proof[
      类似的，对 $phi(x)$ 进行归纳：
      - 若 $phi(x) = x$，则 $f = pi_1$ 即满足要求
      - 若 $phi(x) = inner(phi_1 (x), phi_2 (x))$，设：
        $
          f_1 compose inner(x compose circle, id) = phi_1(x), f_2 compose inner(x compose circle, id) = phi_2(x)
        $
        立刻就有：
        $
          inner(f_1, f_2) compose inner(x compose circle, id) = inner(phi_1(x), phi_2(x)) = phi(x)
        $
      - 若 $phi(x) = phi_1 (x) compose phi_2 (x)$，设：
        $
          f_1 compose inner(x compose circle, id) = phi_1(x), f_2 compose inner(x compose circle, id) = phi_2(x)
        $
        则：
        $
          phi(x) &= f_1 compose inner(x compose circle, id) compose f_2 compose inner(x compose circle, id) \
          &= f_1 compose inner(x compose circle compose f_2, f_2) compose inner(x compose circle, id) \
          &= f_1 compose inner(x compose circle , f_2) compose inner(x compose circle, id) \
          &= f_1 compose inner(x compose circle compose inner(x compose circle, id), f_2 compose inner(x compose circle, id)) \
          &= f_1 compose inner(x compose circle , f_2 compose inner(x compose circle, id)) \
          &= f_1 compose inner(pi_1, f_2) compose inner(x compose circle, id) \
        $
        可见取 $f = f_1 compose inner(pi_1, f_2)$ 即可满足要求
      - 若 $phi(x) : B -> (C_1 => C_2) = duel(phi_1(x): B times C_1 -> C_2)$，设：
        $
          (f_1: A times (B times C_1) -> C_2) compose inner(x compose circle, id) = phi_1(x)
        $
        则（应用@duel-distribute） ：
        $
          // duel(f_1 compose eqv) compose (x compose circle) = duel(f_1 compose inner(x compose circle, pi_2)) = duel(f_1 compose inner(x compose circle, id) compose pi_2) = duel(phi_1(x) compose pi_2)
          duel(f_1 compose eqv) compose inner(x compose circle, id) &= duel(f_1 compose eqv compose inner(inner(x compose circle, id) compose pi_1, pi_2)) \
          &= duel(f_1 compose eqv compose inner(inner(x compose circle, pi_1), pi_2)) \
          &= duel(f_1 compose inner(x compose circle, inner(pi_1, pi_2))) \
          &= duel(f_1 compose inner(x compose circle, id)) \
          &= duel(phi_1 (x)) \
          &= phi(x) \
        $
        其中 $eqv: (A times B) times C_1 -> A times (B times C_1)$\
        可见取 $f = duel(f_1 compose eqv)$ 即满足要求
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
      略
    ]
    #let bL = $bold(L)$

    对于不同的类型系统，上下文的范畴化处理是一个重要话题。本文采用的多项式范畴技术来自 @Deductive_systems_and_categories。随着对范畴与类型系统的研究逐渐深入，*纤维范畴*（fiber category）等更为精细的工具也被引入到这一领域中来，可以参考@jacobs_categorical_nodate 中的相关介绍。
  == #lamCalc 与 #CartN 的范畴同构
    最后，我们可以开始着手进行本章的最终结论了。我们将证明，#(STLC)构成的范畴 #lamCalc 与所有含有弱自然数对象的笛卡尔闭范畴构成的范畴 #CartN 是范畴同构的。为此，我们分别构造两个方向上的函子。

    #definition[
      称一个带弱自然数对象的笛卡尔闭范畴 $cat$ 的*内语言*（internal language）为如下定义的#(STLC) $scrL(cat)$:
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
    ]<cat-func>
    之前提到过，我们用多项式范畴来处理在#(STLC)中引入未定常量的操作。下面的定理再次严格说明了这一点：
    #theorem[
      $cat(scrL)[x : 1 -> A] eqv cat(scrL[x : 1 -> A])$，且该同构关于 $scrL$ 是自然的
    ]
    #proof[
      根据定义，$cat(scrL[x : 1 -> A])$ 中每个 $1 -> A$ 的态射就是 $scrL[x : 1 -> A]$ 中每个 $A$ 类型的项（注意到 $1$ 类型的项是唯一的），因此结论是显然的。
    ]
    最终，我们可以着手证明#lamCalc 与 #CartN 的范畴同构了。
    #theorem[
      $cat(*), scrL(*)$ 构成了一对范畴之间的等价 $lamCalc eqv CartN$
    ]
    #proof[
      也就是要验证 $cat(*) scrL(*) eqv id$ 和 $scrL(*) cat(*) eqv id$
      - 对于一个#(STLC) $L$，考虑 $scrL(cat(L))$，其类型就是 $L$ 中的类型，$Gamma$ 上下文中的 $A$ 类型的项就是 $cat(L)[Gamma]$ 中的 $1 -> A$ 的态射。而：
        $
          cat(L)[Gamma] eqv cat(L[Gamma])
        $
        立刻得到 $Gamma$ 上下文下 $scrL(cat(L))$ 的项和 $L$ 的项同构。由于该关系对 $L$ 是自然的，因此该同构具有函子性。
      - 对于一个含有弱自然数对象的笛卡尔闭范畴 $cat$，考虑 $cat(scrL(cat))$，其对象就是 $scrL(cat)$ 中的类型，也即 $cat$ 中的对象。对于 $A, B$ 两个对象，$A -> B$ 的态射就是二元组 $(x, t[x])$，其中 $x$ 是 $cat$ 中 $1 -> A$ 的态射，而 $t[x]$ 是 $cat[x]$ 中 $1 -> B$ 的态射。根据@func-completeness 的推论，我们有：
        $
          exists! g: A -> B. g compose x = t[x]
        $
        且 $g$ 是 $cat$ 中的态射。这表明 $cat(scrL(cat))$ 中的态射唯一对应 $cat$ 中的一个同类型态射。

        反之，对于任何 $cat$ 中的态射 $g: A -> B$，根据定义所有的二元组：
        $
          (x, g)
        $
        都相等，既然总有：
        $
          x tack g = g
        $
        因此 $g$ 也唯一对应 $cat(scrL(cat))$ 中的一个态射。

        不难验证，以上两个方向的对应具有函子性，且是互逆的。这就给出了 $cat(scrL(cat))$ 与 $cat$ 之间的同构。
    ]
    范畴等价意味着，对于#(STLC)的研究和笛卡尔闭范畴的研究（在代数意义下）几乎是完全一致的。例如说，既然 #SetCat 是一个平凡的笛卡尔闭范畴，我们可以以其为基础构造出对应的#(STLC)。如果检查定义，它基本上就恰好描述了数学家基于集合论的所有函数演算。如同 Church @church_formulation_1940 最早所给出的直观，数学家常见的符号：
    $
      integral_(a)^(b) f(x) dif x
    $
    可以形式化的表示为以下#(STLC)中的项：
    $
      sep(integral, a, b, (lambda x: RR. f space x)) where integral: RR => RR => (RR => RR) => RR
    $
    同时，对于 $lamCalc$ 中的始对象 $Lambda_0$，其中的许多可计算性已经充分地得到了研究@church_formulation_1940 @pierce_types_2002，这也就意味着，在任何#STLC/笛卡尔闭范畴中，由定义所给出的基础等价关系都是可以判定的，例如：
    $
      sep(integral, a, b, (lambda x: RR. f space x)) = sep(integral, a, b, f)
    $
    便是可以机械性判定的结论。

    需要说明的是，本章内容大体上以@def-pic 为模板引入连接词和推导规则。以此为基础，我们可以进行许多并不困难的拓展，例如：
    - 在类型系统中引入和类型，在笛卡尔闭范畴中引入余积#footnote[这样的范畴有时也称作*双笛卡尔闭范畴*，（bicartesian closed category）]。它们都对应着（直觉主义的）命题逻辑中的析取操作。
    - 在类型系统中引入空类型，在笛卡尔闭范畴中引入始对象。它们都对应着命题逻辑中的假值。在假值 $F$ 的基础上，$A$ 的否定就可以定义为 $A => F$。
    - 在以上拓展的基础上，如果进一步引入规则：
      $
        tack "exclude_middle" : A or not A
      $
      也就是说 $A or not A$ 这个命题总为真，就相当于从直觉主义逻辑回到了经典逻辑。
    基于以上的拓展（或者其中的一部分），我们也可以得到类似的同构结论。这也说明，我们建立的理论是足够普遍的。
#let MBL = "Mitchell–Bénabou 语言"
= Topos 与#MBL
    在@lambda-calculus 中，我们大体上处理了与逻辑学中的*命题逻辑*对应的部分。很自然的，我们希望仿照这样的方式处理带量词的逻辑系统。在看似与此无关的一侧，Lawvere @38b76542-b771-32c2-a3ea-ba3f392713d3 首先意识到范畴论也可以起到类似集合论的作用，成为其他数学理论的逻辑基础。这个想法迅速的被发展为所谓的 *Grothendieck topos*。在 topos 中，人们也找到了内部的类型理论，它被称为 #MBL#footnote[在原书中它被称为*直觉主义类型系统*，但现代文献中的“直觉主义类型系统”通常是指 Martin-Löf 的依赖类型理论 @Martin-Lof1980-MARITT-18，它是一些现代常用的定理证明器，如 Rocq@Rocq , Lean@Lean 的理论基础。而这里所说的类型系统相较而言更为简化，主要设计目的是与 topos 理论之间建立对应。这里使用的称呼来自于 @mac_lane_sheaves_1994。]。读者将会看到，在 #(MBL) / topos 中，我们可以“复刻”出一个基于经典集合论的形式逻辑系统。
  == #MBL
    #let ineq = $eq.o$
    首先，我们建立所谓*#MBL*。
    #definition[#MBL][
      我们称一个*#MBL*为满足以下条件的类型系统：
      - 类型的构造规则包括：
        - 单位类型
          #centerProofTree(
            rule(
              $1 : Type$
            )
          )
        - 自然数类型
          #centerProofTree(
            rule(
              $N : Type$
            )
          )
        - 乘积类型
          #centerProofTree(
            rule(
              $A : Type$,
              $B : Type$,
              $A times B : Type$
            )
          )
        - 命题类型
          #centerProofTree(
            rule(
              $Omega : Type$
            )
          )
        - 幂集类型
          #centerProofTree(
            rule(
              $A : Type$,
              $P(A) : Type$
            )
          )
      - 项的构造规则包括：
        - 对于每个类型 $A$，存在可数多的变量 $x_i^A$
        - 单位类型包含单位项
          #centerProofTree(
            rule(
              $* : 1$
            )
          )
        - 乘积类型包含配对项
          #centerProofTree(
            rule(
              $tack a : A$,
              $tack b : B$,
              $tack pair(a, b) : A times B$
            )
          )
        - 幂集类型包含元素关系项
          #centerProofTree(
            rule(
              $tack a : A$,
              $tack b : P(A)$,
              $a in b : Omega$
            )
          )
        - 幂集类型的分类规则
          #centerProofTree(
            rule(
              $x : A tack p(x) : Omega$,
              $tack {x: A | p(x)} : P(A)$
            )
          )
          有时，当类型没有歧义时，我们也采用下面的记号：
          $
            p(-) := {x : A | p(x)}
          $
        - 自然数的皮亚诺规则
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack 0 : N$,
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
        - 命题类型的逻辑规则：
          #align(center)[#rule-set(
            prooftree(
              rule(
                $tack a : A$,
                $tack a' : A$,
                $tack a ineq a' : Omega$
              )
            )
            // prooftree(
            //   rule(
            //     $tack top : Omega$,
            //   )
            // ),
            // prooftree(
            //   rule(
            //     $tack bot : Omega$,
            //   )
            // ),
            // prooftree(
            //   rule(
            //     $tack p : Omega$,
            //     $tack q : Omega$,
            //     $tack p and q : Omega$
            //   )
            // ),
            // prooftree(
            //   rule(
            //     $tack p : Omega$,
            //     $tack q : Omega$,
            //     $tack p or q : Omega$
            //   )
            // ),
            // prooftree(
            //   rule(
            //     $tack p : Omega$,
            //     $tack q : Omega$,
            //     $tack p => q : Omega$
            //   )
            // ),
            // prooftree(
            //   rule(
            //     $x : A tack p(x) : Omega$,
            //     $tack forall x. p(x) : Omega$
            //   )
            // ),
            // prooftree(
            //   rule(
            //     $x : A tack p(x) : Omega$,
            //     $tack exists x. p(x) : Omega$
            //   )
            // )
          )
          ]
    ]<def-intu-type-sys>
    除了 $P, Omega$ 外，其余的构造规则应当都是熟悉的。事实上，$P, Omega$ 共同构成了一个*高阶逻辑*（higher-order logic）的基础。其中，我们用 $ineq$ 表示逻辑内的相等，以免后续与元理论中的相等混淆。我们可以使用它们来定义其他的逻辑符号，包括：
    $
      top &:= * ineq *\
      p and q &= pair(p, q) ineq pair(top, top)\
      p => q &= p and q ineq p\
      forall x. p(x) &= {x : A | p(x)} ineq {x : A | top}\
      bot &:= forall t: Omega. Omega\
      p or q &:= forall t: Omega. ((p => t) and (q => t) => t)\
      exists x. p(x) &:= forall t: Omega. ((forall x. p(x) => t) => t)\
    $
    此外，我们也会使用其他常用的逻辑符号：
    $
      not p   &:= p => bot \
      p <=> q &:= (p => q) and (q => p) \
      a = a' &:= forall u: P A. (a in u <=> a' in u)\
      {a} &:= {x : A | x ineq a}\
      exists! x. p(x) &:= exists x'. p(-) ineq {x'}\
      alpha subset beta &:= forall x: A. (x in alpha => x in beta)
    $<extra-signature>
    #let intacke = $attach(tack, br: "in")$
    #let intack(gamma) = $attach(tack, br: "in", tr: #gamma)$
    #definition[续@def-intu-type-sys][
      我们用：
      $
        Delta intack(Gamma) p
      $
      表示上下文 $Gamma$ 下，$Omega$ 内部的逻辑推理关系#footnote[
        为了符号统一，我们将 $tack$ 留给类型断言，而使用 $intacke$ 来表示逻辑推理
      ]，其中 $Delta$ 是一些 $Omega$ 中的项，$p$ 也是 $Omega$ 中的项。

      我们要求一个#(MBL)中有标准的高阶逻辑推理规则。
    ]<def-intu-type-sys-2>
  == Topos
    #let char(x) = $"char"(#x)$
    #definition[子对象分类器（Subobject classifier）][
      设 $cat$ 是一个范畴，称对象 $Omega$ 是一个*子对象分类器*，如果
      - 存在态射 $top: 1 -> Omega$
      - 对于所有 $h: A -> Omega$，等化子 $ker(h, top compose circle)$ 存在，也记为 $ker h$
      - 对于所有单态射 $m : B -> A$，存在唯一态射 $char(m) : A -> Omega$ 使得 $B = ker char(m)$ 且 $m$ 就是核态射。
    ]<def-subobj-classifier>
    #proposition[
      图表：
      #align(center)[#commutative-diagram(
      node((0, 0), $B$, 1),
      node((0, 1), $1$, 2),
      node((1, 0), $A$, 3),
      node((1, 1), $Omega$, 4),
      arr(1, 2, $circle$),
      arr(1, 3, $m$, inj_str),
      arr(2, 4, $top$),
      arr(3, 4, $h = char(m)$),)]
      是一个拉回图表。
    ]<topos-pullback>
    #proof[
      假设
      #align(center)[#commutative-diagram(
      node((0, 0), $B$, 1),
      node((0, 1), $1$, 2),
      node((1, 0), $A$, 3),
      node((1, 1), $Omega$, 4),
      node((1, -1), $B'$, 5),
      arr(1, 2, $circle$),
      arr(1, 3, $m$, inj_str),
      arr(2, 4, $top$),
      arr(3, 4, $h = char(m)$),
      arr(5, 3, $$),
      arr(5, 2, $$)
      )]
      为了运用等化子的性质，验证：
      $
        top compose circle_A compose (B' -> A) = top compose circle_B' = B' -> Omega = h compose (B' -> A)
      $
      显然，等化子的泛性质就说明上面的图表是拉回图表。
    ]
    #let Sub = "Sub"
    #proposition[
      等价的，假设 $cat$ 包含所有有限极限，子对象分类器可以定义为对象 $Omega$ 使得有自然同构：
      $
        Sub eqv Hom(-, Omega)
      $
      其中 $Sub$ 是指取子对象，具体被定义为：
      $
        funcDef(Sub, C^op, SetCat, X, {U inja X} quo ~ )
      $
      其中两个单态射 $i, j$ 被视作等价，如果存在同构 $k$ 使得 $i = j compose k$，它在态射上被定义为 $Sub(f) : Sub(B) -> Sub(A)$，将子对象 $i: U inja B$ 通过拉回图表：
      #align(center)[#commutative-diagram(
      node((0, 0), $U times_B A$, 1),
      node((0, 1), $U$, 2),
      node((1, 0), $A$, 3),
      node((1, 1), $B$, 4),
      arr(1, 2, $$,),
      arr(1, 3, $$,  inj_str),
      arr(2, 4, $$, inj_str),
      arr(3, 4, $$),)]
      得到 $A$ 的子对象 $U times_i A$
    ]
    #proof[
      只证明其中一个方向。假设 $Sub eqv^tau Hom(-, Omega)$，其中 $tau$ 是从左到右的函数。
      对于任何 $A$ 都有：
      #align(center)[#commutative-diagram(
        node((0, 0), $Sub(A)$, 1),
      node((0, 1), $Hom(A, Omega)$, 2),
      node((1, 0), $Sub(Omega)$, 3),
      node((1, 1), $Hom(Omega, Omega)$, 4),
      arr(1, 2, $tau$, bij_str),
      arr(3, 1, $Sub(tau(id_A))$),
      arr(4, 2, $Hom(tau(id_A), Omega))$),
      arr(3, 4, $tau$, bij_str),)]
      右下取 $id$ 得
      $
        Sub(tau(id_A))(Inv(tau)(id)) = Inv(tau)(tau(id_A)) = id_A
      $
      也即：
      #align(center)[#commutative-diagram(
      node((0, 0), $A$, 1),
      node((0, 1), $U$, 2),
      node((1, 0), $A$, 3),
      node((1, 1), $Omega$, 4),
      arr(1, 2, $$),
      arr(1, 3, $id$),
      arr(2, 4, $Inv(tau)(id)$),
      arr(3, 4, $tau(id_A)$),)]
      是拉回图表。我们记 $top = Inv(tau)(id)$ 可以看出，所有对象到 $U$ 都存在一个态射。

      // 此外，对于任何 $A -> U$ 的态射 $h$，都有：
      // #align(center)[#commutative-diagram(
      //   node((0, 0), $Sub(A)$, 1),
      // node((0, 1), $Hom(A, Omega)$, 2),
      // node((1, 0), $Sub(U)$, 3),
      // node((1, 1), $Hom(U, Omega)$, 4),
      // arr(1, 2, $tau$, bij_str),
      // arr(3, 1, $Sub(tau(id_A))$),
      // arr(4, 2, $Hom(tau(id_A), Omega))$),
      // arr(3, 4, $tau$, bij_str),)]
      // 然而 $id compose tilde(h) = id => tilde(h) = id$，这表明：
      // $
      //   h = A -> U
      // $
      // 换言之，我们证明了所有对象到 $U$ 恰有一个态射，进而：
      // $
      //   U = 1
      // $
      // 因此，可以取 $top := Inv(tau)(id)$
        // #align(center)[#commutative-diagram(
        // node((0, 0), $Sub(A)$, 1),
        // node((0, 1), $Hom(A, Omega)$, 2),
        // node((1, 0), $Sub(1)$, 3),
        // node((1, 1), $Hom(1, Omega)$, 4),
        // arr(1, 2, $tau $, bij_str),
        // arr(3, 1, $Sub(circle) $),
        // arr(4, 2, $Hom(circle, Omega)$),
        // arr(3, 4, $tau$, bij_str),)]
        // 就有：
        // $
        //   Sub(circle) (id) = Sub(circle) (Inv(tau)(top)) = Inv(tau) (Hom(circle, Omega) (top)) = Inv(tau) (top compose circle)\
        //   top compose circle = tau(Sub(circle)(id))
        // $
        // 其中 $Sub(circle) (id)$ 是指：
        // #align(center)[#commutative-diagram(
        // node((0, 0), $1 times A$, 1),
        // node((0, 1), $1$, 2),
        // node((1, 0), $A$, 3),
        // node((1, 1), $1$, 4),
        // arr(1, 2, $$,),
        // arr(1, 3, $$,  inj_str),
        // arr(2, 4, $id$, inj_str),
        // arr(3, 4, $circle$),)]
        // 根据 $1 times A eqv A$，有 $tau(Sub(circle)(id)) = tau(id)$

        // 而：
        // #align(center)[#commutative-diagram(
        // node((0, 0), $Sub(Omega)$, 1),
        // node((0, 1), $Hom(Omega, Omega)$, 2),
        // node((1, 0), $Sub(1)$, 3),
        // node((1, 1), $Hom(1, Omega)$, 4),
        // arr(1, 2, $tau$, bij_str),
        // arr(1, 3, $Sub(top)$),
        // arr(2, 4, $Hom(top, Omega)$),
        // arr(3, 4, $tau$, bij_str),)]
        // 左上取 $top$，有：
        // $
        //   tau(top) compose top = tau(Sub(top)(top))
        // $
        // #align(center)[#commutative-diagram(
        // node((0, 0), $1 times_omega 1$, 1),
        // node((0, 1), $1$, 2),
        // node((1, 0), $1$, 3),
        // node((1, 1), $Omega$, 4),
        // arr(1, 2, $$),
        // arr(1, 3, $$),
        // arr(2, 4, $top$),
        // arr(3, 4, $top$),)]
        // 显然，$Sub(top)(top) = id$，因此：
        // $
        //   tau(top) compose top
        //   = tau(id) = top
        // $
        // 另外：
        // #align(center)[#commutative-diagram(
        // node((0, 0), $Sub(Omega)$, 1),
        // node((0, 1), $Hom(Omega, Omega)$, 2),
        // node((1, 0), $Sub(Omega)$, 3),
        // node((1, 1), $Hom(Omega, Omega)$, 4),
        // arr(1, 2, $tau$, bij_str),
        // arr(1, 3, $Sub(tau(top))$),
        // arr(2, 4, $Hom(tau(top), Omega)$),
        // arr(3, 4, $tau$, bij_str),)]
        // // 左上取 $top$，有：
        // // $
        // //   tau(top) compose tau(top) = tau(Sub(tau(top))(top))
        // // $
        // // #align(center)[#commutative-diagram(
        // // node((0, 0), $1?$, 1),
        // // node((0, 1), $1$, 2),
        // // node((1, 0), $Omega$, 3),
        // // node((1, 1), $Omega$, 4),
        // // arr(1, 2, $$),
        // // arr(1, 3, $$),
        // // arr(2, 4, $top$),
        // // arr(3, 4, $tau(top)$),)]
        // // 右上取 $id$，就有：
        // // $
        // //   Sub(top)(Inv(tau)(id)) = Inv(tau)(top) = id
        // // $
        // // 也即：
        // // #align(center)[#commutative-diagram(
        // // node((0, 0), $1$, 1),
        // // node((0, 1), $U$, 2),
        // // node((1, 0), $1$, 3),
        // // node((1, 1), $Omega$, 4),
        // // arr(1, 2, $  $),
        // // arr(1, 3, $id$, bij_str),
        // // arr(2, 4, $Inv(tau)(id)$),
        // // arr(3, 4, $top$),)]


        // 此外，任取 $m : B inja A$，令 $h: A -> Omega = tau(m)$，根据自然性：
        // #align(center)[#commutative-diagram(
        // node((0, 0), $Sub(A)$, 1),
        // node((0, 1), $Hom(A, Omega)$, 2),
        // node((1, 0), $Sub(B)$, 3),
        // node((1, 1), $Hom(B, Omega)$, 4),
        // arr(1, 2, $tau$),
        // arr(1, 3, $Sub(m)$),
        // arr(2, 4, $Hom(m, Omega)$),
        // arr(3, 4, $tau$),)]
        // $
        //   tau(m) compose m = tau(Sub(m)(m))
        // $
        // 容易验证 $Sub(m)(m) = id$，因此：
        // $
        //   h compose m = tau(m) compose m = tau(id) = top compose circle
        // $
        同时，任取 $h: A -> Omega$，设 $m = Inv(tau)(h)$，有：
        #align(center)[#commutative-diagram(
        node((0, 0), $Sub(A)$, 1),
        node((0, 1), $Hom(A, Omega)$, 2),
        node((1, 0), $Sub(Omega)$, 3),
        node((1, 1), $Hom(Omega, Omega)$, 4),
        arr(1, 2, $tau $, bij_str),
        arr(3, 1, $Sub(h) $),
        arr(4, 2, $Hom(h, Omega)$),
        arr(3, 4, $tau$, bij_str),)]
        右下角取 $id$，就有：
        $
          m = Inv(tau)(h) = Sub(h) (top)
        $
        也即有以下拉回图表：
        #align(center)[#commutative-diagram(
        node((0, 0), $B = A times_Omega Omega$, 1),
        node((0, 1), $U$, 2),
        node((1, 0), $A$, 3),
        node((1, 1), $Omega$, 4),
        // node((1, -1), $B$, 5),
        arr(1, 2, $$,),
        arr(1, 3, $m$,  inj_str),
        arr(2, 4, $top$, inj_str),
        arr(3, 4, $h$),
        // arr(5, 3, $m$, inj_str),
        // arr(5, 2, $$),
        // arr(5, 1, $$, dashed_str),
        )]
        对于所有 $A -> U$ 的态射 $f$，取 $h = top compose f$，上面的结论结合下面的拉回图表：
        #align(center)[#commutative-diagram(
        node((0, 0), $A$, 1),
        node((0, 1), $U$, 2),
        node((1, 0), $A$, 3),
        node((1, 1), $Omega$, 4),
        // node((1, -1), $B$, 5),
        arr(1, 2, $f$,),
        arr(1, 3, $id$),
        arr(2, 4, $top$, inj_str),
        arr(3, 4, $top compose f$),
        // arr(5, 3, $m$, inj_str),
        // arr(5, 2, $$),
        // arr(5, 1, $$, dashed_str),
        )]
        都给出：
        $
          Inv(tau)(top compose f) = id_A, top compose f = tau(id_A)
        $
        这表明对于 $f, f': A -> U$：
        $
          top compose f = top compose f' => f = f'
        $
        也即 $A -> U$ 的态射有且只有 $f$

        再结合之前的结论，这表明 $U$ 就是终对象 $1$，因此之前的图表变为：
        #align(center)[#commutative-diagram(
        node((0, 0), $B = A times_Omega Omega$, 1),
        node((0, 1), $1$, 2),
        node((1, 0), $A$, 3),
        node((1, 1), $Omega$, 4),
        // node((1, -1), $B$, 5),
        arr(1, 2, $$,),
        arr(1, 3, $m$,  inj_str),
        arr(2, 4, $top$, inj_str),
        arr(3, 4, $h$),
        // arr(5, 3, $m$, inj_str),
        // arr(5, 2, $$),
        // arr(5, 1, $$, dashed_str),
        )]
        // 图上可得：
        // $
        //   top compose (Y -> U) = top compose phi
        // $
        // 结合 $top$ 是单态射就有 $Y -> U = phi$
        只要取 $char(m) = tau(m), ker(h, top compose circle) = tau(h)$，所有性质都由上面的拉回图表给出了。


        // 合并之前的图表：
        // #align(center)[#commutative-diagram(
        // node((0, 0), $B = A times_Omega U$, 1),
        // node((0, 1), $U$, 2),
        // node((1, 0), $A$, 3),
        // node((1, 1), $Omega$, 4),
        // node((-1, 1), $1$, 5),
        // arr(1, 2, $$,),
        // arr(1, 3, $m$,  inj_str),
        // arr(2, 4, $Inv(tau)(id)$, inj_str),
        // arr(3, 4, $h$),
        // arr(1, 5, $circle$),
        // arr(5, 2, $$)
        // // arr(5, 3, $m$, inj_str),
        // // arr(5, 2, $$),
        // // arr(5, 1, $$, dashed_str),
        // // )]
        // 左下取 $top$ 就有：
        // $
        //   tau(top) compose h = tau(Sub(h)(top))
        // $
        // $
        //   m = Sub(h)(top)\
        //   h = tau(Sub(h)(top))
        // $
        // #align(center)[#commutative-diagram(
        // node((0, 0), $A times_Omega 1$, 1),
        // node((0, 1), $1$, 2),
        // node((1, 0), $A$, 3),
        // node((1, 1), $Omega$, 4),
        // arr(1, 2, $$),
        // arr(1, 3, $$, inj_str),
        // arr(2, 4, $top$, inj_str),
        // arr(3, 4, $h$),)]

    ]
#let scrT = $scr(T)$
== #(MBL)生成的 topos
  前面介绍了 topos 的定义以及 topos 的内语言 #MBL，现在我们可以反过来，给出一个#(MBL)生成的 topos 的构造方法。由于 #(MBL)是#(STLC)的拓展，我们可以根据@cat-func 得到一个笛卡尔闭范畴。不幸的是，这个范畴一般而言并不是一个 topos，可能需要额外的理论将其与一个 topos 连接起来。

  这里，我们展示另一种构造：
  #definition[
    给定一个#(MBL) $scrL$，我们定义 $scr(A)(scrL)$ 是如下定义的范畴：
    - 其对象是所有 $P A$ 类型的闭项的等价类，其中 $alpha = alpha'$ 定义为两者具有相同的类型，且：
      $
        intacke alpha ineq alpha'
      $
      看起来，每个对象就像是一个闭项的集合。
    - 态射 $f: alpha -> beta$ 定义为 $P(A times B)$ 中的闭项 $abs(f)$，满足：
      $
        intacke abs(f) subset alpha times beta
      $
      （其中 $subset$ 的定义来自 @extra-signature。我们将 $abs(f)$ 称作 $f$ 的*图像（graph）*）

      商掉以下的等价关系：
      $
        (f = g) := (intacke abs(f) ineq abs(g))
      $
      看起来，这样的态射就像是两个集合之间的二元关系。类似的，单位元被定义为自反关系，而态射的复合则被定义为关系的复合：
      $
        abs(g compose f) = {inner(x, z) : A times C | exists y: B. inner(x, y) in abs(f) and inner(y, z) in abs(g)}
      $
      仿照二元关系，我们定义 $f$ 的逆关系 $f^(-1)$ 为：
      $
        abs(Inv(f)) = {inner(y, x) : B times A | inner(x, y) in abs(f)}
      $
  ]
  #definition[
    定义 $scrT(scrL)$ 是 $scr(A)(scrL)$ 的一个子范畴，其对象是所有 $scr(A)$ 中的对象，而态射 $f : alpha -> beta$ 是满足以下条件的态射：
    $
      intacke forall x. (x in alpha => exists! y. inner(x, y) in abs(f))
    $
    也就是一般集合论中的*函数*的定义。它也等价于说：
    $
      intacke abs(id) subset abs(Inv(f) compose f) and abs(id) subset abs(f compose Inv(f))
    $
  ]
  我们有以下颇为熟悉的结论：
  #lemma[
    $scrT(scrL)$ 中的态射 $f: alpha -> beta$  是单态射当且仅当 $Inv(f) compose f = id$
  ]
  #proof[
    与标准集合论的证明相似。
  ]
  根据集合论中 $SetCat$ 范畴的直观，当然也有以下命题：
  #proposition[
    $scrT(scrL)$ 是笛卡尔闭范畴，其中：
    - 乘积对象 $alpha times beta$ 定义为 ${inner(x, y) | x in alpha, y in beta}$
    - 指数对象 $beta^alpha$ 定义为 ${f: P(A times B) | f "是函数"}$
    并且，$N$ 是 $scrT(scrL)$ 中的一个自然数对象。
  ]
  #proof[略]
  我们距离 topos 只差一个子对象分类器了。
  // 同样根据集合论的直观，子对象分类器的定义也呼之欲出：
  #theorem[
    若设：
    $
      Omega_(scrT(scrL)) &:= {t: Omega | top}\
      T : 1 -> &Omega_(scrT(scrL)) := {inner(*, top)}
    $
    则 $Omega, T$ 是 $scrT(scrL)$ 中的一个子对象分类器。
  ]
  #proof[
    先证明下面的引理：
    #lemma[
      任取态射 $h: alpha -> Omega$，$ker h$ 总存在，也即存在 $ker h$ 使得下图：
      #align(center)[#commutative-diagram(
      node((0, 0), $ker h$, 1),
      node((0, 1), $1$, 2),
      node((1, 0), $alpha$, 3),
      node((1, 1), $Omega$, 4),
      arr(1, 2, $$),
      arr(1, 3, $$),
      arr(2, 4, $T$),
      arr(3, 4, $h$),)]
      是拉回图表。
    ]
    #proof[
      事实上，可以定义：
      $
        ker h := {x : A | inner(x, top) in abs(h)},\
        abs(ker h -> alpha) := {inner(x, x) : A times A | inner(x, top) in abs(h)}
      $
      则上图交换是显然的。此外，任取 $f: beta -> alpha$ 使得：
      $
        h compose f = T compose circle
      $
      就有：
      $
        abs(h compose f) = abs(T compose circle) = {inner(y, top): B times 1| y in beta}
      $
      只需定义 $g: beta -> ker h$ 使得 $abs(g) = abs(f)$，不难验证它就是唯一所满足拉回图表性质的态射
    ]
    我们已经给出了 $ker$ 的定义方法，对于所有单态射 $m$，再定义 $char(m)$ 为：
    $
      abs(char(m)) := {inner(x, t): A times Omega | t = (exists y: B, inner(y, x) in abs(m)}
    $#footnote[接近于标准集合论中，$m$ 的原像]
    不难验证 $char(m)$ 的核映射就是 $m$ 本身，这就得到了所有的性质。
    ]
    综上，我们就得到了：
    #theorem[
      对于任何#(MBL)，$scrT(scrL)$ 是一个 topos
    ]
  #let Lang = $bold("Lang")$
  == Topos 与内语言
    根据之前的章节，我们自然希望能够证明 topos 与 #(MBL)之间的某种范畴同构。一个直观问题是，#(MBL)中似乎并没有显式给出的“指数/函数类型”，因此，我们暂时也对 topos 的定义放松这个限制：
    #definition[弱 topos][
      称一个范畴 $cat$ 是一个*弱 topos*，如果它满足 topos 的大多数要求，除了不要求一般的指数对象存在，只要求 $P A = Omega^A$ 的相关结构存在。
    ]
    所幸，可以证明这个放松并不改变 topos 的本质结构：
    #lemma[
      每个弱 topos 都同构于一个 topos
    ]
    #proof[略]
    接下来，我们逐步建立最终的理论：
    #let Top = $bold("Top")$
    #definition[
      定义 $Top$ 是以下的范畴：
      - 其对象是所有弱 topos
      - 其态射是函子 $F$，要求其保持所有弱 topos 的结构
    ]
    #definition[
      定义 $Lang$ 是以下的范畴：
      - 其对象是所有#(MBL)
      - 其态射是满足以下条件的*翻译（translation）* $F$：
        - $F$ 将类型映成类型，并保持所有类型构造规则
        - $F$ 将闭项映成闭项，并（在内部相等 $ineq$ 意义下）保持所有项构造规则
        - $F$ 保持所有的定理
        商掉如下定义的等价关系：
        $
          (F = F') := forall Gamma, a. intack(Gamma) F(a) ineq F'(a)
        $
    ]
    同时，前几节中介绍的 $scrL, scrT$ 操作也可以顺利的拓展成为 $Top$ 和 $Lang$ 之间的函子
    #definition[
      定义 $scrL: Top -> Lang$ 是如下定义的函子：
      - 对于每个弱 topos $scrT$，$scrL(scrT)$ 就是之前构造的内语言
      - 对于每个态射 $F: scrT -> scrT'$，$scrL(F)$ 定义为：
        - 对于 $scrL(scrT)$ 中的类型 $A$ （也是 $scrT$ 中的对象），有：
          $
          scrL(F)(A) = F A
          $
        - 对于 $scrL(scrT)$ 中的闭项 $a: A$（也是 $scrT$ 中 $1 -> A$ 的态射），有：
          $
          scrL(F)(a) = F a
          $
      可以验证，$scrL(F)$ 的确是一个翻译，并且 $scrL$ 确实是函子。
    ]
    #proposition[
      $scrL$ 是全忠实函子
    ]
    #proof[略]
    #definition[
      定义 $scrT: Lang -> Top$ 是如下定义的函子：
      - 对于每个#(MBL) $scrL$，$scrT(scrL)$ 就是之前构造的 topos
      - 对于每个态射 $F: scrL -> scrL'$，$scrT(F)$ 定义为：
        - 对于 $scrT(scrL)$ 中的对象 $alpha$（也是 $scrL$ 中 $P A$ 类型的闭项），有：
          $
          scrT(F)(alpha) = F alpha
          $
        - 对于 $scrT(scrL)$ 中的态射 $f: alpha -> beta$（也是 $scrL$ 中 $P(A times B)$ 类型的闭项），有：
          $
          abs(scrT(F)(f)) = F abs(f)
          $
      可以验证，$scrT(F)$ 的确是一个保持弱 topos 结构的函子，并且 $scrT$ 确实是函子。
    ]
    #let bf = $bold("f")$
    #definition[
      对于任何 topos $scrT$，我们定义以下的 #Top 中的态射 $xi_scrT: scrT -> scrT(scrL(scrT))$：
      - 它把对象 $A$ 映成“集合” $bA := {x : A | top}$
      - 它把态射 $f : A -> B$ 映射成 $bf : bA -> bB$，满足：
        $
          abs(bf) = {inner(x, y) : A times B | f compose x = y}#footnote[
            回忆 $scrL(scrT)$ 中的项是 $scrT$ 中 $1 -> A$ 的态射
          ]
        $
    ]
    下面的结果应当是非常直接的：
    #proposition[
      $xi_scrT$ 保持所有弱 topos 的结构，继而是 #Top 中的态射。
    ]
    然而，这样的 $xi_scrT$ 并不能忠实地保持指数对象。考虑：
    - $xi(B^A) = {x : B^A | top}$
    - $xi(B) ^ xi(A) = {f: P(A times B) | f "是函数"}$
    尽管两者的确是同构的对象，但很明显并不相等。然而，可以证明 $xi$ 还保持了 $delta_(*, Omega)$ 对象，并且：
    #theorem[
      $xi$ 是范畴同构
    ]<xi-isom>
    #proof[略]


    #let ba = $bold(a)$
    #definition[
      对于任何#(MBL) $scrL$，我们定义以下的 #Lang 中的态射 $eta_scrL: scrL -> scrL(scrT(scrL))$：
      - 它把类型 $A$ 映成 $bA := {x : A | top}$
      - 它把闭项 $a$ 映成 $ba: 1 -> bA$，满足：
        $
          abs(ba) = {inner(*, a)}
        $
    ]
    下面的结论说明，如此定义的 $eta$ 忠实地保留了#(MBL) 内部的逻辑结构。
    #lemma[
      对于任何类型 $A$，$eta_scrL$ 建立了以下等价关系：
      $
        ({"类型为" P A "的闭项" } quo ineq) eqv ({"类型为" bP bA "的闭项" } = {u: P A | top})
      $
      特别的，$intacke p$ 当且仅当 $intacke eta_scrL (p)$
    ]<eta-lemma>
    我们有如下有趣的结论：
    #proposition[
      对于任何 topos $scrT$，总有：
      $
        scrL(xi_(scrT)) = eta_(scrL(scrT))\
      $
    ]
    这个性质也表明，我们不能一般的期待 $scrL, scrT$ 是一对范畴同构。这是因为如果它们构成范畴同构，则根据@xi-isom 和上面的结论，我们会得到 $eta$ 也是一个#(MBL)之间的同构。然而稍加思考就会发现，$eta$ 往往不是一个同构。直观上，$scrL$ 中 $P A$ 类型的闭项全部在 $scrL(scrT(scrL))$ 变成了新的类型，这会导致 $scrL(scrT(scrL))$ 中的类型远多于 $scrL$。

    同时，$eta$ 在类型上也不是单的。在我们的定义下，$A != A'$ 不能排除 $P A = P A'$ 的可能，继而导致 $eta(A) = eta(A')$
    #proposition[
      $eta, xi$ 都是自然变换
    ]
    #proof[略]
    虽然并不能得到 $eta$ 是自然同构的事实，但既然我们构造出了 $xi: id -> scrT scrL$ 和 $eta: id -> scrL scrT$，并且 $xi$ 本身是自然同构。自然会想到，是否可以退一步，使用 $Inv(xi)$ 和 $eta$ 形成伴随对？ 大体来说，这样的想法是成立的。但为了使得 $Inv(xi)$ 保持逻辑结构，我们需要做出一点额外的限制条件，并且得到最终的结论：
    #theorem[
      假设 topos $scrT$*具有典范的子对象*#footnote[具体定义请参考 @lambek_introduction_1986 中的相关内容]，则存在自然变换 $epsilon: scrT scrL -> id$ 使得 $epsilon compose xi = id$，并且 $epsilon, eta$ 构成一对单位/余单位@ai_jabr ，进而 $(scrL, scrT)$ 构成一对伴随对。
    ]
    为了展现这对伴随对的作用，考虑如下的问题：在 #Lang 中，我们可以很容易的找到一个始对象，也就是所有的项/类型都恰好按照规则归纳产生的 #MBL $scrL_0$。使用伴随函子，立刻可以得到 $scrT(scrL_0)$ 也是一个始对象。然而，如果没有 topos 的内语言作为桥梁，仅从定义出现，#Top 中始对象的存在性并不是如此直观的。



#change_appendix()

= 多项式与多项式范畴
  在正文中，我们省略了诸多关于多项式范畴的细节。这里，我们给出更详尽的解释。

  #let RAlgCat(R) = $#R - bold("Alg")$
  #let CommRingCat = $bold("CommRing")$
  #let coslice(C, c) = $#C arrow.b #c$
  #let cosliceP(C, c) = $(#C arrow.b #c)^*$
  == 范畴语言下的多项式
    首先，这里我们使用范畴语言重新定义交换环上的多项式。
    #definition[余切片范畴@borceux_handbook_1994][
      设 $cat$ 是一个范畴，$A$ 是 $cat$ 中的一个对象，则称 $cat arrow.b A$ 是 $cat$ 的*余切片范畴*（coslice category，也称为下范畴（under category）)，如果：
      - 其对象是 $cat$ 中所有以 $A$ 为起点的态射，即所有 $f: A -> B$
      - 其态射 $h: f -> g$ 是满足 $h compose f = g$ 的态射，即下图：
        #align(center)[#commutative-diagram(
        node((0, 0), $B_1$, 1),
        node((0, 1), $A$, 2),
        node((1, 0), $B_2$, 3),
        arr(2, 1, $f$),
        arr(2, 3, $g$),
        arr(1, 3, $h$),)]
    ]
    #example[
      设 $CommRingCat$ 是交换环组成的范畴，$R$ 是一个交换环，$coslice(CommRingCat, R)$ 的定义与 $R-$交换代数范畴 $RAlgCat(R)$ 的定义完全相同。
    ]
    #definition[带点的余切片范畴][
      设 $cat$ 是一个范畴，对于任何 $cat$ 中的对象 $A$，任何 $U: coslice(cat, A) -> SetCat$ 是函子，定义如下的范畴：
      - 其对象是 $cat$ 中所有以 $A$ 为起点的态射 $f: A -> B$，以及 $U(f)$ 中的一个元素 $b$，即 $(f, b)$
      - 其态射 $h: (f, a) -> (g, b)$ 来自于 $h: B_1 -> B_2$，并满足：
        - 余切片范畴的条件：$h compose f = g$
        #align(center)[#commutative-diagram(
          node((0, 0), $B_1$, 1),
          node((0, 1), $A$, 2),
          node((1, 0), $B_2$, 3),
          arr(2, 1, $f$),
          arr(2, 3, $g$),
          arr(1, 3, $h$),)]
        - 态射保持点不动： $U(h)(a) = b$
      记作 $cosliceP(cat, A)$
    ]
    #theorem[
      设 $R$ 是交换环，则多项式环 $R[x]$ 恰为 $cosliceP(CommRingCat, R)$ 中的始对象，其中 $U: cosliceP(CommRingCat, R) -> SetCat$ 取遗忘函子。
    ]
    #proof[
      基本上是多项式环的定义。
    ]
  == 多项式范畴
    #theorem[
      设 $cat$ 是笛卡尔闭范畴，则 $cat[x : A -> B]$ 就是 $cosliceP(Cart, cat)$ 的始对象，其中 $U: cosliceP(Cart, cat) -> SetCat$ 就取 $F |-> Hom(F A, F B)$#footnote[
        严格来说，为了使其合法，我们讨论的 $Cart$ 只由所有局部小的笛卡尔闭范畴组成
      ]。
    ]
    #proof[
      同样的，基本上是多项式范畴的定义。
    ]
  == 自由笛卡尔闭范畴
    作为范畴语言的实际应用，我们在这里具体给出任何一个图上的*自由*笛卡尔闭范畴的形式化构造方法。它回答了正文中多项式范畴的构造方式，以及与其相关的证明的合理性。

    #let GraCat = $bold("Graph")$

    #definition[
      定义所有图构成的范畴为 $GraCat$，其中对象就是所有的有向图（顶点数量可能无穷），而态射就是所有的图同态。
    ]
    #proposition[
      $GraCat$ 中有平凡的始对象（空图），并且图的积/余积就是 $GraCat$ 中的积/余积。
    ]
    #proposition[
      设 $cat$ 是恰由两点 $a, b$ 以及箭头 $id: a -> a, s: a -> b, t: a -> b, id: b -> b$ 构成的范畴，则：
      $
        FunctorCat(cat, SetCat) eqv GraCat
      $
      这里的 $eqv$ 是指范畴同构。
    ]
    #proof[
      - 任取 $F : FunctorCat(cat, SetCat)$，可以构造一个图，其顶点集为 $F b$，边集为 $F a$，对于任何一个边 $e: F a$，其起点就是 $(F s)(e)$，终点就是 $(F t)(e)$。
      - 任取 $G : GraCat$，可以构造一个函子 $F: cat -> SetCat$，满足 $F a = E$，$F b = V$，$F id = id$，$(F s)(e) = s(e)$，$(F t)(e) = t(e)$
      很容易证明以上的两个构造保持态射，且是互逆的，证毕。
    ]
    #corollary[
      $GraCat$ 是某个范畴的预层范畴，继而具有所有的极限/余极限 @stacks-project
    ]
    #definition[
      记 $GraCat'$ 是所有带有终对象的图构成的范畴，态射仍然是图同态（注意到图同态一定保持终对象）。不难验证 $GraCat'$ 与 $GraCat$ 同构，通过删去/添加终对象的方式给出。
    ]
    接下来，我们都在 $GraCat'$ 中讨论问题。如果开始的图没有终对象，只需要简单的添加一个终对象即可。

    使用集合论的语言，可以将一个自由构造过程描述为：
    - 将一步的构造定义为集合到集合的函数
    - 从某个初始对象出发，反复迭代这些构造函数，得到一个序列 $X_0, X_1, X_2, ...$，其中 $X_(n+1)$ 是通过对 $X_n$ 应用所有的构造函数得到的集合
    - 最终的自由对象就是 $X_0, X_1, X_2, ...$ 的某种极限（典型的，例如 $Union_(i: NN) X_i$ ）
    使用范畴论的语言，我们也可以复刻这一过程。上面对于极限/余极限存在性的论述就确保了最后一步取极限在理论上是安全的，因此接下来我们的主要工作便是将构造过程定义为某种函子了。
    #definition[
      回顾笛卡尔闭范畴的定义，我们将以下构造过程定义为 $GraCat' -> GraCat'$ 的自函子 $F$：
      - 首先，对图 $G$ 添加所有二元直积和指数对象，得到图 $G'$
        - $G'$ 的顶点集是 $G$ 的顶点集，加上所有的 $A times B, B^A$ 形式的顶点，其中 $A, B$ 是 $G$ 的顶点。这些顶点都是语法的，也就是说，与原图中的顶点完全独立#footnote[
          例如，假设 $G$ 本身就是笛卡尔闭范畴，$A, B$ 是其中对象，那么 $G$ 中原本就有直积对象 $A times B$，但这里我们仍然添加一个新对象 $A times B$，在对象意义下与原来的 $A times B$ 并不相等。但读者可以想象，根据我们对态射的定义方式，它们最终是同构的。类似的，我们之后构造的边（态射）也是形式的。
        ]。
        - $G'$ 的边集是 $G$ 的边集，加上：
          $
          &pi_1: A times B -> A, pi_2: A times B -> B, forall A, B\
          &inner(f, g): C -> A times B, forall A, B, C, f: C -> A, g: C -> B\
          &epsilon: B^A times B -> A, forall A, B\
          $
          同样的，这些边也是语法的。
      - 之后，对 $G'$ 取自反，复合闭包
      - 再补上边：
        $
          &duel(h): A -> C^B, forall A, B, C, h: A times B -> C
        $
      - 再次取复合闭包
      - 添加必要的边使得原终对象仍然是终对象
      - 对边集做商，商掉的等价关系为@prop-ccc 中的所有等式
      对于图同态 $xi: G_1 -> G_2$，$F xi$ 定义为：
        - $(F xi) A = xi A, forall A in Ob(G_1)$
        - $(F xi) (A times B) = (xi A) times (xi B), forall A, B in Ob(G_1)$
        - $(F xi) (B^A) = (xi B) ^ (xi A), forall A, B in Ob(G_1)$
        - $(F xi) id = id$
        - $(F xi) f = xi f, forall f in "Mor"(G_1)$
        - $(F xi) pi_1 = pi_1, (F xi) pi_2 = pi_2$
        - $(F xi) inner(f, g) = inner(xi f, xi g)$
        - $(F xi) epsilon = epsilon$
        - $(F xi) (f compose g) = (F xi) f compose (F xi) g$
        - $(F xi) duel(h) = duel((F xi) h)$
      可以验证 $(F xi_1) compose (F xi_2) = F (xi_1 compose xi_2)$，因此 $F$ 确实是一个函子。

    ]
    #remark[
      如果我们删去其中商掉等价关系的一步，我们得到的就是一个自由的正直觉主义演算的构造步骤了。这也反映了正文中提及的，逻辑演算与对应范畴之间的关系。
    ]
    #lemma[
      对于任何图同态 $f$，$F f$ 都是一个“保持笛卡尔闭结构”的图同态
    ]
    #proof[
      由定义显然。
    ]
    #lemma[
      $F$ 在对象上是单的（$F X = F Y => X = Y$），进而 $F$ 的像构成范畴 $F GraCat'$
    ]
    #proof[
      检查定义即可。
    ]
    #lemma[
      有伴随关系：
      $
        Hom_(F GraCat') (F G_1, F G_2) eqv Hom_(GraCat') (G_1, G_2)
      $
      也即：
      $
        Hom_(F GraCat') (F G_1, G'_2) eqv Hom_(GraCat') (G_1, U G'_2)
      $
      其中 $U$ 是遗忘函子 $F GraCat' -> GraCat'$。
    ]
    #proof[
      事实上，这就是说 $F$ 是忠实的（对于所有态射，$F f = F g => f = g$），检查定义可知这是显然的。
    ]
    #corollary[
      $F$ 保持余极限
    ]
    #proof[
      只需运用如下基本性质：伴随对的左函子保持余极限（见 @ai_jabr）
    ]

    接下来，我们给出一些方便使用的定义和结论，它们保证了我们可以对 $F$ 这个构造过程取极限，并且这个极限具有良好的性质。
    #definition[$F-$代数范畴][
      设 $cat$ 是范畴，$F: cat -> cat$ 是 $cat$ 上的一个函子，则称 $RAlgCat(F)$ 是 $F$ 的*代数范畴*，如果：
      - 其对象是 $cat$ 中的对象 $A$，以及 $cat$ 中的态射 $a: F A -> A$，即 $(A, a)$
      - 其态射 $h: (A_1, a_1) -> (A_2, a_2)$ 来自于 $h: A_1 -> A_2$，并满足：
        $
          h compose a_1 = a_2 compose F h
        $
    ]
    #theorem[Adámek@adamek_automata_1990][
      设 $cat$ 是具有始对象 $0$ 的范畴，$F$ 保持余极限，对于如下的链：
      $
        0 ->^i F(0) ->^F(i) F^2(0) ->^(F^2(i)) F^3(0) -> ...
      $
      如果其余极限存在，则它是 $RAlgCat(F)$ 的始对象。
    ]<adamek>
    #proof[
      基本上直接验证定义即可。
    ]
    #theorem[Lambek][
      设 $RAlgCat(F)$ 中有始对象 $(X, a)$，则 $a: F X -> X$ 是同构。换言之，$X$ 是 $F$ 的一个*不动点*。
    ]<lambek>
    #proof[
      注意到 $(F X, F a)$ 也是一个 $F-$代数，根据定义，存在唯一态射 $b: X -> F X$ 使得：
      $
        b compose a = F a compose F b = F (a compose b)
      $
      这表明，$a compose b$ 也是 $(X, a) -> (X, a)$ 的态射，因为：
      $
        a compose b compose a = a compose F (a compose b)
      $
      根据始对象的性质，立刻有：
      $
        a compose b = id\
        b compose a = F (a compose b) = F id = id
      $
    ]
    接下来，我们继续之前的构造过程。假设 $G$ 是一个带有终对象的图，则 $G$ 自然的成为了 $coslice(GraCat', G)$ 的始对象。同时，我们有：
    #proposition[
      余完备范畴的余切片范畴也是余完备的
    ]
    #proof[
      详见@stacks-project
    ]
    同时，使用显然的图同态 $alpha: G -> F G$，$F$ 自然的延伸为 $coslice(GraCat', G)$ 上的自函子 $F'$，它将 $f: G -> H$ 映射为 $F' f = F f compose alpha$，将：
    #align(center)[#commutative-diagram(
    node((0, 0), $G$, 1),
    node((0, 1), $H_1$, 2),
    node((1, 0), $H_2$, 3),
    arr(1, 2, $f_1$),
    arr(3, 2, $h$),
    arr(1, 3, $f_2$),)]
    映为：
    #align(center)[#commutative-diagram(
    node((0, 0), $G$, 1),
    node((0, 1), $F H_1$, 2),
    node((1, 0), $F H_2$, 3),
    arr(1, 2, $F' f_1 = F f_1 compose alpha$),
    arr(3, 2, $F 'h = F h$, label-pos: right),
    arr(1, 3, $F' f_2 = F f_2 compose alpha$, label-pos: right))]
    并且不难验证 $F'$ 也保持余极限。根据@adamek，可以找到 $RAlgCat(F')$ 的一个始对象，将其记作 $cal(C) G$，根据@lambek 立刻有：
    #lemma[
      $F (cal(C) G) eqv cal(C) G$
    ]
    #theorem[
      设 $H$ 是 $F$ 的不动点，则 $H$ 是笛卡尔闭范畴
    ]
    #proof[
      考虑 $F$ 的构造过程，所有我们需要的结构都可以从 $F X$ 中找到，将之映回 $X$ 即可。
    ]
    截止到现在，我们建立了如下的映射：
    $
      cal(C): GraCat' -> Cart
    $
    它使用上述的构造过程使用一个图产生了一个笛卡尔闭范畴。不难验证，它自然的作用到态射上，因此是一个函子。为了保证这个过程确实是*自由构造*，我们还需要经典的伴随关系：
    $
      Hom(cal(C) G, C) eqv Hom(G, U C)
    $
    其中 $U$ 是遗忘函子。为此，我们还需要进一步的性质。
    #proposition[
      设 $C$ 是笛卡尔闭范畴，则 $F C$ 与 $C$ 范畴等价
    ]<fc-equiv>
    #proof[
      我们取 $eta: F C -> C$ 将所有新构造的结构，包括二元积和指数对象及其相关的态射，映回 $C$ 中对应的结构。不难验证它满足本质满，全忠实的条件，因此是范畴等价@ai_jabr。
    ]
    #remark[
      通常来说，$F C$ 与 $C$ 并不是同构的，换言之，在图的意义下两者并不一致。这是因为构造过程中，我们形式地构造了众多冗余的直积对象，指数对象等。
      // 它们与原先标准的直积对象，指数对象等虽然在范畴内同构，但并不相等。@fc-equiv 也是我们将终对象独立处理的原因之一。读者可以检查，如果我们仿照其他结构，语法地构造终对象，那么@fc-equiv 就不成立了。
    ]
    #corollary[
      $cal(C) C$ 与 $C$ 范畴等价
    ]<calc-equiv>
    #proposition[
      $cal(C), U$ 是一对伴随函子
    ]<free-forget>
    #proof[
      - 任取 $f: G -> U C$，由此构造 $U C$ 为 $coslice(GraCat', G)$ 中的一个对象，而@fc-equiv 中定义的 $eta: F C -> C$ 给出了一个 $F'-$代数结构，根据始对象性质，立刻得到一个态射：
        $
          g: cal(C) G -> C
        $
        并且满足：
        $
          g compose (beta: F' (cal(C) G) -> cal(C) G) = eta compose F' g
        $
        我们断言 $g$ 一定保持所有笛卡尔闭范畴的结构。例如有：
        $
          eta compose (F' g) (A times B) = eta (g A times g B) = g A tensorProduct g B\
          g compose beta (A times B) = g (A tensorProduct B)
        $
        其中，我们用 $tensorProduct$ 表示笛卡尔闭范畴内蕴的直积结构，$times$ 表示构造过程中，语法性的二元直积结构，因此上式表明 $g$ 保持直积。其他的结构是类似的。
      - 任取 $g: cal(C) G -> C$，直接取 $f = g compose (alpha: G -> cal(C) G)$，其中 $alpha$ 来自于 $cal(C) G$ 的 $G$ 切片对象。
      可以验证，以上构造对于 $G, C$ 都满足自然性，且是互逆的，因此证毕。
    ]
    至此，我们就圆满完成了自由笛卡尔闭范畴的构造。
  == 多项式范畴的构造
    作为结果，我们终于可以解释正文中的多项式范畴的来龙去脉了。
    #theorem[
      设 $C$ 是一个笛卡尔闭范畴，选择未定元 $x: A -> B$，将其加入 $C$ 中得到一个图 $C(x)$，则 $cal(C) C(x)$ 就是 $C$ 上的多项式范畴 $C[x]$
    ]
    #proof[
      @free-forget 给出：
      $
        Hom(cal(C) C(x), D) eqv Hom(C(x), U D)
      $
      按照多项式范畴的定义，对于任何给定的 $F: C -> D$ 和 $y: F A -> F B$，条件：
      - $H$ 在 $C$ 上保持 $F$
      - $H$ 将 $x$ 映为 $y$
      显然唯一确定了上式右侧的一个图同态，因此也唯一确定了上式左侧的一个态射 $cal(C) C(x) -> D$，证毕。
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
感谢夏壁灿老师，王迪老师，胡振江老师对这篇文章以及对我之前及今后学习历程的指导。感谢北京大学众多老师在过去的几年内对我的指导和栽培。感谢所有参考文献的作者对知识的贡献，以及 ncatlab， Stack project 对众多相关零散信息的收集和整理。感谢所有数字工具的开发者帮助顺利高效地完成了这篇文章。最后，感谢所有亲朋好友对我的鼓励与支持。
// 感谢Typst开发者和原PhD论文模板开发者

// DOCUMENT END:标记文章结束，页面计数停止
#doc_end()


// 原创性与版权声明
#Statement(2026, 5, 17, teacher_sign : image("./images/老师签名.png"), my_sign: image("./images/本人签名.png")) <claim>
