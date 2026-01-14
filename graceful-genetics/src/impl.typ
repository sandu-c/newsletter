#let make-venue = move(dy: -1.9cm, {
  image("../../banners/Fortris-confluence-banner-01.png", width: 105%, height: 2.5cm, fit: "contain")
})

#let make-title(
  title,
  authors,
  date,
  abstract,
  keywords,
) = {
  set par(spacing: 1em)
  set text(font: "Manrope")
  
  par(
    justify: false,
    text(24pt, fill: rgb("F07C70"), title, weight: "bold")
  )

  let date-text = if type(date) == dictionary {
    str(date.month) + " " + str(date.day) + ", " + str(date.year)
  } else {
    str(date)
  }

  text(12pt,
    authors.enumerate()
    .map(((i, author)) => box[#author.name #super[#(i+1)]])
    .join(", ")
  )
  parbreak()

  for (i, author) in authors.enumerate() [
    #set text(8pt)
    #super[#(i+1)]
    #author.institution
    #link("mailto:" + author.mail) \
  ]
  align(right, text(8pt, fill: rgb("2f3849"), date-text))

  v(8pt)
  set text(12pt)
  set par(justify: true)

  [
    #heading(outlined: false, bookmarked: false)[Abstract]
    #text(font: "Manrope", abstract, size: 10pt)
    #v(3pt)
    #text(size: 9pt)[*Keywords:* #keywords.join(text(font: "Manrope", "; "))]
  ]
  v(18pt)
}

#let template(
    title: [],
    authors: (),
    date: [],
    doi: "",
    keywords: (),
    abstract: [],
    make-venue: make-venue,
    make-title: make-title,
    body,
) = {
    set page(
      paper: "a4",
      margin: (top: 3.9cm, bottom: 1in, x: 1.6cm),
      columns: 2,
      header: [
        #box(width: 100%, height: 2.5cm)[
          #image("../../banners/Fortris-confluence-banner-01.png", width: 100%, height: 2.5cm, fit: "contain")
          #place(left + top, dx: 20pt, dy: 31pt)[
            #text(font: ("3270Medium Nerd Font Mono", "TeX Gyre Heros", "Helvetica"), size: 20pt, weight: "bold", fill: white)[Platform Engineering]
          ]
          #place(left + top, dx: 21pt, dy: 48pt)[
            #text(font: ("Manrope", "Helvetica"), size: 8pt, weight: "regular", fill: rgb("#C9CED8"), tracking: 1.5pt)[NEWSLETTER]
          ]
        ]
      ],
      footer: align(center)[#context { counter(page).display() }],
    )
    set par(justify: true)
    set text(10pt, font: "Manrope", hyphenate: true)
    set list(indent: 8pt)
    // show link: set text(underline: false)
    show heading: set text(size: 11pt)
    show heading.where(level: 1): set text(font: "Manrope", fill: rgb("#F07C70"), size: 14pt)
    show heading: set block(below: 8pt)
    show heading.where(level: 1): set block(below: 12pt)

    show heading.where(level: 2): set text(font: "Manrope", fill: rgb("#2f3849"), size: 12pt)

    place(
      make-title(title, authors, date, abstract, keywords), 
      top, 
      scope: "parent",
      float: true
    )


    show figure: align.with(center)
    show figure: set text(8pt)
    show figure.caption: pad.with(x: 10%)

    // show: columns.with(2)
    body
  }
