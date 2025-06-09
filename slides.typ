#import "@preview/polylux:0.4.0": *
#import "@preview/metropolis-polylux:0.1.0" as metropolis
#import metropolis: new-section, focus
#import "@preview/finite:0.5.0": automaton
#import "@preview/cetz:0.3.4": canvas, draw, tree


#show: metropolis.setup.with(
  text-font: "Iosevka",
  math-font: "Latin Modern Math",
  code-font: "Iosevka",
  text-size: 28pt,
)

#slide[
  #set page(header: none, footer: none, margin: 3em)


  #text(size: 1.3em)[
    *From Regular Expressions to Regular Languages*
  ]

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
  #toolbox.side-by-side[
    What #highlight("[a-z]{2}", fill: yellow) #highlight("[^A-Z]+", fill: teal) #highlight("(\w*)\?", fill: gray)

    What #highlight("is", fill: yellow) #highlight("regular", fill: teal) #highlight("expression?", fill: gray)
  ][#image("regular_expressions.png")]



]


#slide[
  = Regex usecases

  #let h = 8em
  #toolbox.side-by-side(columns: (auto, auto))[
    #figure(image("image-11.png", height: h), caption: "1. Text search", supplement: none)
  ][
    #figure(image("image-12.png", height: h), caption: "2. Text validation", supplement: none)
  ]

]


#slide[
  = Where can I use regex?
  #image("word.png", height: 100%)
]

#slide[
  = Where can I use regex?
  #image("excel.png", height: 100%)
]

#slide[
  = Where can I use regex?
  #image("editor.png", height: 100%)
]

#slide[
  = Where can I use regex?

  #image("cli.png", height: 100%)
]

#slide[
  = Regex syntax by example
  #footnote[https://regexone.com/]
  #image("image-13.png")
]


#new-section[Regex tips in practice]

#slide[
  #set text(size: 24pt)
  = Use anchor (`^$`) when possible

  Regex: `/treature/`

  #[
    #show regex("treature"): set text(red)
    ```
    treature here, treature there, everywhere treature
    ```
  ]

  #line(length: 100%)

  Regex: `/^treature/`

  #[
    #show regex("^treature"): set text(red)
    ```
    treature here, treature there, everywhere treature
    ```
  ]

  #line(length: 100%)

  Regex: `/treature$/`

  #[
    #show regex("treature$"): set text(red)
    ```
    treature here, treature there, everywhere treature
    ```
  ]

]


#slide[
  = `/.*/` is rarely what you want
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


#slide[
  = Regex is code
  #toolbox.side-by-side(columns: (1fr, 1fr))[
    - Catastrophic backtracking <cf>
    - Regular Expression Denial of Service
  ][
    #image("image-14.png")
  ]

  #footnote[https://blog.cloudflare.com/details-of-the-cloudflare-outage-on-july-2-2019/] <cf>
]


#slide[
  = Use visualization tools

  #toolbox.side-by-side(columns: (1fr, 1fr))[
    #figure(
      image("image-15.png"),
      caption: "regexper.com",
      supplement: none,
    )
  ][
    #figure(
      image("1.png"),
      caption: "regex101.com",
      supplement: none,
    )
  ]
]

#let code(
  caption: none, // content of caption bubble (string, none)
  bgcolor: rgb("#fefae0"), // back ground color (color)
  strokecolor: 1pt + maroon, // frame color (color)
  hlcolor: auto, // color to use for highlighted lines (auto, color)
  width: 100%,
  radius: 3pt,
  inset: 5pt,
  numbers: false, // show line numbers (boolean)
  stepnumber: 1, // only number lines divisible by stepnumber (integer)
  numberfirstline: false, // if the firstline isn't divisible by stepnumber, force it to be numbered anyway (boolean)
  numberstyle: auto, // style function to apply to line numbers (auto, style)
  firstnumber: 1, // number of the first line (integer)
  highlight: none, // line numbers to highlight (none, array of integer)
  content,
) = {
  if type(hlcolor) == "auto" {
    hlcolor = bgcolor.darken(10%)
  }
  if type(highlight) == "none" {
    highlight = ()
  }
  block(
    width: width,
    fill: bgcolor,
    stroke: strokecolor,
    radius: radius,
    inset: inset,
    clip: false,
    {
      // Draw the caption bubble if a caption was set
      if caption != none {
        style(styles => {
          let caption_block = block(
            width: auto,
            inset: inset,
            radius: radius,
            fill: bgcolor,
            stroke: strokecolor,
            h(.5em) + caption + h(.5em),
          )
          place(
            top + left,
            dx: 0em,
            dy: -(measure(caption_block, styles).height / 2 + inset),
            caption_block,
          )
        })
        // skip some vertical space to avoid the caption overlapping with
        // the beginning of the content
        v(.6em)
      }

      let (columns, align, make_row) = {
        if numbers {
          // line numbering requested
          if type(numberstyle) == "auto" {
            numberstyle = text.with(
              style: "italic",
              slashed-zero: true,
              size: .6em,
            )
          }
          (
            (auto, 1fr),
            (right + horizon, left),
            e => {
              let (i, l) = e
              let n = i + firstnumber
              let n_str = if (calc.mod(n, stepnumber) == 0) or (numberfirstline and i == 0) {
                numberstyle(str(n))
              } else { none }
              (n_str + h(.5em), raw(lang: content.lang, l))
            },
          )
        } else {
          (
            (1fr,),
            (left,),
            e => {
              let (i, l) = e
              raw(l)
            },
          )
        }
      }
      table(
        stroke: none,
        columns: columns,
        rows: (auto,),
        gutter: 0pt,
        inset: 2pt,
        align: (col, _) => align.at(col),
        fill: (c, row) => if (row / 2 + firstnumber) in highlight { hlcolor } else { none },
        ..content
          .text
          .split("\n")
          .enumerate()
          .map(make_row)
          .flatten()
          .map(c => if c.has("text") and c.text == "" { v(1em) } else { c })
      )
    },
  )
}

#new-section[Regular Languages]

#slide[
  = What is regular languages?

  #grid(columns: 3, gutter: 1.25em)[
    #rect(inset: 0.5em)[/a(bb)+a/]
  ][#text("-->", size: 40pt)][
    #code()[```
      abba
      abbbba
      abbbbbba
      abbbbbbbba
      abbbbbbbbbba
      .....
      ```]

    #line(length: 100%)

    $
      L = {a(bb)^n a | n >= 1}
    $

  ]
]

#slide[
  = Finite Automata?

  #grid(columns: 3, gutter: 1.25em)[
    #rect(inset: 0.5em)[/a(bb)+a/]
  ][#text("<--", size: 40pt)][
    #code()[```
      abba
      abbbba
      abbbbbba
      abbbbbbbba
      abbbbbbbbbba
      .....
      ```]
  ]
  #set text(size: 18pt)
  #line(length: 100%)
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
    caption: "/a(bb)+a/ finite automata",
  )
]

#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q0: (fill: red)
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em)[a]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]

#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q1: (fill: red)
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]

#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q2: (fill: red)
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]


#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q3: (fill: red)
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]



#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q4: (fill: red)
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]



#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
      (
        q0: (q1: "a"),
        q1: (q2: ""),
        q2: (q3: "b"),
        q3: (q4: "b"),
        q4: (q2: "backtrack", q5: ""),
        q5: (q6: "a"),
      ),
      initial: "q0",
      final: ("q6",),
        style: (
            q2: (fill: red),
            q4-q2: (stroke: yellow)
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]



#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q3: (fill: red),
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]


#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q4: (fill: red),
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]



#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q5: (fill: red),
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em)[a]
        ]
        
    ]
    
  ]
]


#slide[
  #set text(size: 18pt)
  #align(center)[
    #grid(gutter: 4em)[
        #automaton(
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
        style: (
            q6: (fill: green),
        )
    )
    ][
        #stack(dir: ltr)[
            #rect(inset: 1em, fill: blue)[a]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[b]
        ][
            #rect(inset: 1em, fill: blue)[a]
        ]
        
    ]
    
  ]
]


#slide[
  = Catastrophic backtracking
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
      caption: "/a(bb)+a/ state machine",
    )
  ]
]


#slide[
  = Catastrophic Backtracking
  #toolbox.side-by-side(columns: (1fr, auto))[
    Pattern: `^(a+)+$`

    Text: `aaaaaaaaaaaab`

    -> #text("~12.000 steps", fill: red)
  ][
    #image("image-7.png")
  ]
]

#new-section([Introduction to parser])


#slide[
  = Why do we need parser?

  #toolbox.side-by-side(columns: (1fr, auto))[
    Regex can't "count"

    - html: <\tag/>
    - json: {}

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
  = Regex vs Parsers
  Parsers are more *powerful* and *intuitive*
  #align(center)[
    #toolbox.side-by-side(columns: (1fr, 1fr))[
      Regex

      `/<p\s+(?:[^>]*\s+)?class\s*=\s*["\']([^"\']*)["\'][^>]*>((?:[^<]|<(?!/p>))*)</p>/`

      #line(length: 100%)

      Match all p tag with text

    ][

      HTML tree

      #let data = (
        [html],
        ([div], ([div], [p], [p]), [span]),
        [image],
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
  = Parsers required more understanding
  #align(center)[
    #figure(
      [#code()[```
          from lark import Lark
          grammar = """
              start: expr
              expr: term ("+" term | "-" term)*
              term: factor ("*" factor | "/" factor)*
              factor: NUMBER | "(" expr ")"
              NUMBER: /[0-9]+/
          """

          parser = Lark(grammar)
          tree = parser.parse("2 + 3 * 4")```]],
      caption: "Parser that match simple math",
    )

  ]
]



#slide[
  = Parser usecases
  #toolbox.side-by-side(columns: (1fr, 1fr))[

    - Compilers & Interpreters
    - Data validation: JSON, XML
    - Configuration files: YAML, TOML

  ][
    #box(width: 100%, height: 80%)[
      #place(
        dx: 30mm,
        dy: 20mm,
        rotate(-15deg)[
          #text(size: 18pt, fill: rgb("#2E86AB"))[*Recusive Decent*]
        ],
      )

      #place(
        dx: 60mm,
        dy: 60mm,
        rotate(-15deg)[
          #text(size: 26pt, fill: rgb("#35464d"))[*Parser*]
        ],
      )

      #place(
        dx: 100mm,
        dy: 45mm,
        rotate(25deg)[
          #text(size: 16pt, fill: rgb("#A23B72"))[*Pratt algorithm*]
        ],
      )

      #place(
        dx: 60mm,
        dy: 100mm,
        rotate(8deg)[
          #text(size: 17pt, fill: rgb("#F18F01"))[*Parser generator (yacc)*]
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

#new-section([Summary])

#slide[
  - Regex is a powerful tools to match "flat" structure extremely fast
  - Modern regex is complicated and require careful consideration
  - When regex become too hard, consider a parser
]



#slide[
  #align(center)[
    Questions?
  ]
]
