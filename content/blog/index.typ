#import "../index.typ": template, tufted

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

#title[Blog]

= 2026

- #blog-post-item(
    path: "2026-05-12-capture-process-amend/",
    title: [Capture, Process, Amend],
    date: datetime(year: 2026, month: 5, day: 12),
    read-time: 2,
  )
- #blog-post-item(
    path: "2026-04-30-start-small-build-big/",
    title: [Start Small, Build Big],
    date: datetime(year: 2026, month: 4, day: 30),
    read-time: 1,
  )
- #blog-post-item(
    path: "2026-04-23-thoughts-on-ai-assisted-coding/",
    title: [Thoughts on AI-Assisted Coding],
    date: datetime(year: 2026, month: 4, day: 23),
    read-time: 3,
  )
- #blog-post-item(
    path: "2026-04-17-how-to-reverse-park/",
    title: [How to Reverse Park],
    date: datetime(year: 2026, month: 4, day: 17),
    read-time: 7,
  )
- #blog-post-item(
    path: "2026-04-10-i-tried-making-a-document-accessible/",
    title: [I Tried Making a Document Accessible],
    date: datetime(year: 2026, month: 4, day: 10),
    read-time: 2,
  )
- #blog-post-item(
    path: "2026-04-01-why-i-start-taking-notes/",
    title: [Why I Start Taking Notes],
    date: datetime(year: 2026, month: 4, day: 1),
    read-time: 1,
  )
- #blog-post-item(
    path: "2026-03-25-i-would-like-to-start-another-blog/",
    title: [I Would like to Start Another Blog],
    date: datetime(year: 2026, month: 3, day: 25),
    read-time: 1,
  )
