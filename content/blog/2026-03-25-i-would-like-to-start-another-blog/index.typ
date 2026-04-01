#import "../index.typ": blog-post-info, page-source, template, tufted
#import "@preview/cmarker:0.1.8"
#show: template.with(title: "I would like to start another blog :: Johan Xie")

#blog-post-info(
  date: datetime(year: 2026, month: 3, day: 25),
  read-time: 1,
)

#page-source

#tufted.margin-note[
  This post was written before I set up my new blog site.
]

// NOTE: This page is generated from the ./index.md file
#{
  let md-content = read("./index.md")
  cmarker.render(md-content)
}
