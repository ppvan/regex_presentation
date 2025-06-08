#import "@preview/polylux:0.4.0": *
#import "@preview/metropolis-polylux:0.1.0" as metropolis
#import metropolis: new-section, focus
#import "@preview/finite:0.5.0": automaton
#import "@preview/cetz:0.3.4": canvas, draw, tree


#show: metropolis.setup.with(
  text-font: "Iosevka",
  math-font: "Math",
  code-font: "Iosevka",
  text-size: 24pt,
)

#slide[
  #set page(header: none, footer: none, margin: 3em)


  #text(size: 1.3em)[
    *From Regular Expressions to Regular Languages*
  ]

  a.k.a How to build a regex engine

  #metropolis.divider

  #set text(size: .8em, weight: "light")
  Phúc Phạm

  June 10, 2025

]

#slide[
  = Outline

  #metropolis.outline
]


#new-section[Regex basics]


#slide[

  // Bố cục lại cho đẹp hơn

  = What is a regular expression?
  #set quote(block: true)
  #toolbox.side-by-side[
    #quote(
      attribution: "Wikipedia",
    )[A regular expression is a sequence of characters that specifies a match pattern in text.]
  ][
    What #highlight("[a-z]{2}", fill: yellow) #highlight("[^A-Z]+", fill: teal) #highlight("(\w*)\?", fill: gray)

    What #highlight("is", fill: yellow) #highlight("regular", fill: teal) #highlight("expression?", fill: gray)

  ]

]


#slide[
  = Where can I use regex?

  #toolbox.side-by-side[
    Any where there is text search feature, there is a decent chance it support regex
    - Text search
    - Pattern validation
  ][#image("regular_expressions.png")]

]


#slide[
  Word/Google Docs

  #image("word.png", height: 70%)
]

#slide[
  Excel

  #image("excel.png", height: 70%)
]

#slide[
  Text editor

  #image("editor.png", height: 70%)
]

#slide[
  Command line program

  #image("cli.png", height: 70%)
]



#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Literal (normal character)
    - any ascii character
  ][

    Regex: `/a/`
    #show regex("a"): set text(red)
    #line(length: 100%)
    ```
    Every object will remain at rest or in uniform motion in a straight line unless compelled to change its state by the action of an external force
    ```
  ]
]


#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Alternation (pipe)
    - a OR b
  ][

    Regex: `/a|b|e/`
    #show regex("a|b|e"): set text(red)
    #line(length: 100%)
    ```
    Every object will remain at rest or in uniform motion in a straight line unless compelled to change its state by the action of an external force
    ```
  ]
]



#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Characters group
    - Match character in []
    - [milk] = m|i|l|k
  ][
    Regex: `/[milk]/`
    #show regex("[milk]"): set text(red)
    #line(length: 100%)
    ```
    Energy cannot be created or destroyed; it can only be transformed from one form to another.
    ```
  ]
]


#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Characters group exclude
    - Match what's *not* in the []
  ][
    Regex: `/[^milk]/`
    #show regex("[^milk]"): set text(red)
    #line(length: 100%)
    ```
    Energy cannot be created or destroyed; it can only be transformed from one form to another.
    ```
  ]
]

#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Characters group short hand
    - `[0-9]` #sym.equiv `[0123456789]`
    - `[a-z]` #sym.equiv `[abcdefghijklmnopqrstuvwxyz]`
    - `\w` #sym.equiv `[0-9a-zA-Z_]`
    - `\d` #sym.equiv `[0-9]`
    - `\W` #sym.equiv `[^\w]`

  ][
    Regex: `/\W/`
    #show regex("\W"): set text(red)
    #line(length: 100%)
    ```
    Energy cannot be created or destroyed; it can only be transformed from one form to another.
    ```
  ]
]

#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    The dot
    - Match every thing
    - Escape to match only actual dot (\\.)
  ][
    Regex: `/./`

    #[
      #show regex("."): set text(red)
      ```
      Electrons orbit the nucleus only in certain allowed energy levels.
      ```
    ]

    #line(length: 100%)


    Regex: `/\./`
    #show regex("\."): set text(red)
    ```
    Electrons orbit the nucleus only in certain allowed energy levels.
    ```
  ]
]


#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Repetitions
    - `{3}`: exactly three times
    - `{2, 6}`: from 2 to 6 times
  ][
    Regex: `/w{3}/`

    #[
      #show regex("\b\w{3}\b"): set text(red)
      ```
      At a constant temperature, the current through a conductor is directly proportional to the voltage across it.
      ```
    ]

    #line(length: 100%)


    Regex: `/w{2,6}/`

    #[
      #show regex("\b\w{2,6}\b"): set text(red)
      ```
      At a constant temperature, the current through a conductor is directly proportional to the voltage across it.
      ```
    ]
  ]
]


#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Repetitions (unknown times)
    - `?`: zezo or one
    - `*`: zezo or more
    - `+`: one or more

  ][
    Regex: `/colou?r/`

    #[
      #show regex("colou?r"): set text(red)
      ```
      The colour of light depends on its frequency
      ```
    ]

    #line(length: 100%)

    Regex: `/\w*e/`

    #[
      #show regex("\w*e\b"): set text(red)
      ```
      A force can cause an object to move, stop, or change direction
      ```
    ]

    #line(length: 100%)

    Regex: `/s\w+/`


    #[
      #show regex("s\w+"): set text(red)
      ```
      An accelerating object gains speed as time passes
      ```
    ]

  ]
]



#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Anchor
    - `^`: start of string
    - `$`: end of string

  ][
    Regex: `/treature/`

    #[
      #show regex("treature"): set text(red)
      ```
      treature here, treature there, everywhere treature
      ```
    ]

    #line(length: 100%)

    Regex: `/treature/`

    #[
      #show regex("^treature"): set text(red)
      ```
      treature here, treature there, everywhere treature
      ```
    ]

    #line(length: 100%)

    Regex: `/treature/`

    #[
      #show regex("treature$"): set text(red)
      ```
      treature here, treature there, everywhere treature
      ```
    ]
  ]
]



#slide[
  = How do I use regex?
  #toolbox.side-by-side[
    Capture group
    - Extract information from match
    - Mostly used in code
  ][
    Regex: `/^(?P<file>.+)\.(?P<ext>.+)$/`

    #[
      // #show regex("(.+)\."): set text(red)
      // #show regex("\.(.+)"): set text(blue)

      #show regex("(?P<file>.+)\.(?P<ext>.+)"): it => {
        let inner = it.text.split(".")

        [#text(inner.at(0), fill: red)\.#text(inner.at(1), fill: blue)]
      }

      ```
      Nắng ấm xa dần.mp3
      Hồng nhan.wav
      Bạc phận.flac
      Faded.mp3
      ```
    ]
  ]
]


#new-section[Regular Languages]

#slide[
  = What is regular languages?

  #toolbox.side-by-side[
    Regular language is a set of string can be recognized by an finite automata (FA).
    - Regex is way to describe it

    Example:

    `/a(bb)+a/`

    -> `L = {abba, abbba, abbbbbba..}`

  ][
    // #image("technically.png")
    #image("7090.1571152901.jpg")
  ]
]


#slide[
  = Finite Automata?

  #toolbox.side-by-side(columns: (1fr, auto))[

    A thing can "consume" regular language

    Regex engine actually compile regex to Non-determistic Finite Automata (NFA)

  ][
    // #image("technically.png")
    #set text(size: 18pt)

    #figure(
      automaton(
        (
          q0: (q1: "a"),
          q1: (q2: ""),
          q2: (q3: "b"),
          q3: (q4: "b"),
          q4: (q2: "", q5: ""),
          q5: (q6: "a"),
        ),
        initial: "q0",
        final: ("q6",),
      ),
      caption: "/a(bb)+a/ state machine",
    )
  ]
]


#slide[
  = NFA properties

  #toolbox.side-by-side(columns: (1fr, auto))[

    - Has a *finite* number of states
    - Doesn't have auxiliary memory

    -> Can't not consume "context-free" language

  ][
    #set text(size: 18pt)

    #figure(
      stack(
        automaton(
          (
            q0: (q1: "a"),
            q1: (q2: "b"),
          ),
          initial: "q0",
          final: ("q2",),
        ),
        automaton(
          (
            q0: (q1: "a"),
            q1: (q2: "a"),
            q2: (q3: "b"),
            q3: (q4: "b"),
          ),
          initial: "q0",
          final: ("q4",),
        ),
        [...],
      ),

      caption: "NFA can't represent {ab, aabb, aaabbb, ...}",
    )
  ]
]

#slide[
  = Backtracking
  #toolbox.side-by-side(columns: (1fr, auto))[
    Regex repetitions (e.g `?*+`) causes backtracking in regex

    -> `O(2^n)` complexity
  ][
    #figure(
      automaton(
        (q0: (q1: "a"), q1: (q2: ""), q2: (q3: "b"), q3: (q4: "b"), q4: (q2: "", q5: ""), q5: (q6: "a")),
        initial: "q0",
        final: ("q6",),
        style: (q4: (stroke: red), q4-q2: (stroke: blue), q4-q5: (stroke: blue)),
      ),
      caption: "q4 has 2 ways to move",
    )
  ]
]


#slide[
  = Backtracking
  #toolbox.side-by-side(columns: (1fr, auto))[
    Pattern: `^(a+)+$`

    Text: `aaaaaaaaaaaab`

    -> #text("~12.000 steps", fill: red)
  ][
    #image("image-7.png")
  ]
]

#new-section[Regex tips in practice]

#slide[
  #toolbox.side-by-side(columns: (1fr, 2fr))[
    Use anchor (`^$`) when possible
    - Make the engine fail early
    - Improve accuracy
  ][
    Regex: `/s/`

    #[
      #show regex("treature"): set text(red)
      ```
      treature here, treature there, everywhere treature
      ```
    ]

    #line(length: 100%)

    Regex: `/treature/`

    #[
      #show regex("^treature"): set text(red)
      ```
      treature here, treature there, everywhere treature
      ```
    ]

    #line(length: 100%)

    Regex: `/treature/`

    #[
      #show regex("treature$"): set text(red)
      ```
      treature here, treature there, everywhere treature
      ```
    ]
  ]
]


#slide[
  #toolbox.side-by-side(columns: (1fr, 2fr))[
    `/.*/` is rarely what you want
  ][
    Regex: `/user_id="(.*)"/`

    #[
      #show regex("user_id=\"(.*)\""): set text(red)
      ```ERROR 2024-01-15 user_id="123" action=login error="Invalid password" ip=192.168.1.100 session="abc123"
      ```
    ]

    #line(length: 100%)

    Regex: `/user_id="([^"])"/`

    #[
      #show regex("user_id=\"([^\"]*)\""): set text(red)
      ```ERROR 2024-01-15 user_id="123" action=login error="Invalid password" ip=192.168.1.100 session="abc123"
      ```
    ]
  ]
]


#slide[
  #toolbox.side-by-side(columns: (1fr, 1fr))[
    Regex is #text([*code*], fill: red). DO NOT execuate regex from user input
    - Regex can check prime number!
  ][
    Regex: `/^(?!(aa+)\1+$)aa+$/`

    #[

      #text("aa", fill: red) -> 2

      #text("aaa", fill: red) -> 3

      #text("aaaa", fill: black) -> 4

      #text("aaaaaaaaaaa", fill: red) -> 11

    ]
  ]
]


#slide[
  Document your regex

  #toolbox.side-by-side(columns: (1fr, 1fr))[
    - Always use named group
    - Document every thing with EXAMPLES
    - Use visualization tools
  ][
    #image("1.png")
  ]
]



#slide[
  Only use basic feature
  #toolbox.side-by-side(columns: (1fr, 1fr))[
    - Advanced features are implementation specific (regex flavors)

    -> If thing gets complicated, consider a parser
  ][
    #box(width: 100%, height: 80%)[
      #place(
        dx: 30mm,
        dy: 20mm,
        rotate(-15deg)[
          #text(size: 18pt, fill: rgb("#2E86AB"))[*Unicode*]
        ],
      )

      #place(
        dx: 60mm,
        dy: 60mm,
        rotate(-15deg)[
          #text(size: 26pt, fill: rgb("#35464d"))[*Regex*]
        ],
      )

      #place(
        dx: 100mm,
        dy: 45mm,
        rotate(25deg)[
          #text(size: 16pt, fill: rgb("#A23B72"))[*Back reference*]
        ],
      )

      #place(
        dx: 60mm,
        dy: 100mm,
        rotate(8deg)[
          #text(size: 17pt, fill: rgb("#F18F01"))[*Balance group*]
        ],
      )

      // Add some decorative elements
      #place(
        dx: 15mm,
        dy: 70mm,
        rotate(-45deg)[
          #text(size: 10pt, fill: rgb("#C73E1D").transparentize(60%))[◆]
        ],
      )

      #place(
        dx: 140mm,
        dy: 15mm,
        rotate(60deg)[
          #text(size: 12pt, fill: rgb("#2E86AB").transparentize(40%))[◇]
        ],
      )

      #place(
        dx: 100mm,
        dy: 120mm,
        rotate(-30deg)[
          #text(size: 8pt, fill: rgb("#A23B72").transparentize(50%))[●]
        ],
      )
    ]
  ]
]

#new-section([Introduction to parsing])



#slide[
  = Why we need parser?
  #toolbox.side-by-side(columns: (1fr, 1fr))[

    Regex can't handle "context-free" (stuctured) languages
    - math expression: `(1+2) * 3 + 4`
    - json/xml/html/yaml
    - python/javascript
  ][
    #image("7090.1571152901.jpg")
  ]

]



#slide[
  = What is a parser?


  #align(center)[
    #canvas({
      import draw: *

      // Define positions
      let raw-pos = (0, 0)
      let lexer-pos = (4, 0)
      let tokens-pos = (8, 0)
      let parser-pos = (12, 0)
      let ast-pos = (16, 0)

      // Style settings
      set-style(
        stroke: black + 1.5pt,
        fill: white,
      )

      // Raw String box
      rect(
        (raw-pos.at(0) - 1, raw-pos.at(1) - 0.8),
        (raw-pos.at(0) + 1, raw-pos.at(1) + 0.8),
        fill: red.lighten(80%),
      )
      content(raw-pos, text(size: 10pt, weight: "bold")[Raw String\ `"(1+2)*3+4"`])

      // Lexer box
      rect(
        (lexer-pos.at(0) - 0.8, lexer-pos.at(1) - 0.6),
        (lexer-pos.at(0) + 0.8, lexer-pos.at(1) + 0.6),
        fill: blue.lighten(80%),
      )
      content(lexer-pos, text(size: 11pt, weight: "bold")[Lexer])

      // Tokens box
      rect(
        (tokens-pos.at(0) - 1.2, tokens-pos.at(1) - 2.2),
        (tokens-pos.at(0) + 1.2, tokens-pos.at(1) + 2.2),
        fill: yellow.lighten(60%),
      )
      content(
        tokens-pos,
        text(size: 9pt, weight: "bold")[
          Tokens\
          `LPAREN`\
          `NUMBER(1)`\
          `PLUS`\
          `NUMBER(2)`\
          `RPAREN`\
          `MULTIPLY`\
          `NUMBER(3)`\
          `PLUS`\
          `NUMBER(4)`
        ],
      )

      // Parser box
      rect(
        (parser-pos.at(0) - 0.8, parser-pos.at(1) - 0.6),
        (parser-pos.at(0) + 0.8, parser-pos.at(1) + 0.6),
        fill: green.lighten(80%),
      )
      content(parser-pos, text(size: 11pt, weight: "bold")[Parser])

      // AST box
      rect(
        (ast-pos.at(0) - 1, ast-pos.at(1) - 1.2),
        (ast-pos.at(0) + 2, ast-pos.at(1) + 1.2),
        fill: purple.lighten(80%),
      )
      content((ast-pos.at(0) + 0.5, ast-pos.at(1)), text(size: 10pt, weight: "bold")[AST\ (Tree Structure)])

      // Arrows
      line(
        (raw-pos.at(0) + 1, raw-pos.at(1)),
        (lexer-pos.at(0) - 0.8, lexer-pos.at(1)),
        mark: (end: ">", size: 0.3),
      )

      line(
        (lexer-pos.at(0) + 0.8, lexer-pos.at(1)),
        (tokens-pos.at(0) - 1.2, tokens-pos.at(1)),
        mark: (end: ">", size: 0.3),
      )

      line(
        (tokens-pos.at(0) + 1.2, tokens-pos.at(1)),
        (parser-pos.at(0) - 0.8, parser-pos.at(1)),
        mark: (end: ">", size: 0.3),
      )

      line(
        (parser-pos.at(0) + 0.8, parser-pos.at(1)),
        (ast-pos.at(0) - 1, ast-pos.at(1)),
        mark: (end: ">", size: 0.3),
      )
    })

  ]

  // Title
  #align(center)[
    #text(size: 16pt, weight: "bold")[
      Compilation Pipeline: Lexical Analysis → Syntax Analysis
    ]
  ]

  #v(1em)

  // Description
  #align(center)[
    #text(size: 12pt)[
      Raw String → Lexer → Tokens → Parser → AST
    ]
  ]
]


#slide[
  = Regex vs AST
  Parsers are more *powerful* and *intuitive*
  #align(center)[
    #toolbox.side-by-side(columns: (1fr, 1fr))[
      Regex

      `/^\s*(?:\d+|\([^()]*(?:\([^()]*\)[^()]*)*\))\s*(?:[+\-*\/]\s*(?:\d+|\([^()]*(?:\([^()]*\)[^()]*)*\))\s*)*$/`

      #line(length: 100%)

      `(1+2) * 3 + 4`

    ][

      AST
      #let ast_data = (
        [+], // Root: addition operator
        (
          [\*], // Left subtree: multiplication
          (
            [+], // Left subtree of multiplication: (1+2)
            [1], // Left operand
            [2], // Right operand
          ),
          [3], // Right operand of multiplication
        ),
        [4], // Right operand of root addition
      )


      #let data = (
        [+],
        ([\*], ([+], [1], [2]), [3]),
        [4],
      )
      #canvas({
        import draw: *

        set-style(
          content: (padding: .2),
          fill: gray.lighten(70%),
          stroke: gray.lighten(70%),
        )

        tree.tree(
          data,
          spread: 2.5,
          grow: 1.5,
          draw-node: (node, ..) => {
            circle((), radius: .45, stroke: none)
            content((), node.content)
          },
          draw-edge: (from, to, ..) => {
            line(
              (a: from, number: .6, b: to),
              (a: to, number: .6, b: from),
              mark: (end: ">"),
            )
          },
          name: "tree",
        )

        // // Draw a "custom" connection between two nodes
        // let (a, b) = ("tree.0-0-1", "tree.0-1-0")
        // line((a, .6, b), (b, .6, a), mark: (end: ">", start: ">"))
      })

    ]
  ]
]


#slide[
  = Paser learning resource
  - Crafting Interpreters - Robert Nystrom
  - Compilers: Principles, Techniques, and Tools
]

#new-section([Summary])

#slide[
  - Regex is a powerful tools to match "flat" structure extremely fast
  - Modern regex is complicated and require careful consideration
  - When regex become too hard, consider parsing
]



#slide[
  #align(center)[
  Questions?
  ]
]
