#import "../index.typ": info-above-title, template, tufted
#import "@preview/cmarker:0.1.8"
#show: template.with(title: "I would like to start another blog :: Johan Xie")

#info-above-title(
  date: datetime(year: 2026, month: 3, day: 25),
  read-time: 1,
)

#tufted.margin-note[
  This post was written before I set up my new blog site.
]

// NOTE: This page is generated from the ./index.md file
#{
  let md-content = read("./index.md")
  cmarker.render(md-content)
}
