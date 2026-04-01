#import "../index.typ": page-source, template, tufted

#let blog-post-info(
  date: datetime,
  read-time: int,
  date-display: "[year]-[month]-[day]",
) = tufted.full-width({
  date.display(date-display) + " · " + str(read-time) + " min. read"
})

#let blog-post-item(
  path: str,
  title: content,
  date: datetime,
  read-time: int,
  date-display: "[year]-[month]-[day]",
) = {
  [#link(path)[#title] #tufted.margin-note({
      date.display(date-display) + " · " + str(read-time) + " min. read"
    })]
}

#show: template.with(title: "Blog :: Johan Xie")

#page-source

= Blog

== 2026

- #blog-post-item(
    path: "2026-03-25-i-would-like-to-start-another-blog/",
    title: [I would like to start another blog],
    date: datetime(year: 2026, month: 3, day: 25),
    read-time: 1,
  )
