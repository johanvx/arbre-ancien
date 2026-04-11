#import "../index.typ": template, tufted
#show: template.with(title: "Notes :: Johan Xie")

#let notes-info(
  series: content,
  created-date: datetime,
  updated-date: datetime,
  date-display: "[year]-[month]-[day]",
) = tufted.full-width([
  #series · #created-date.display(date-display) - #updated-date.display(
    date-display,
  )
])

#let notes-side-info(
  created-date: datetime,
  updated-date: datetime,
  date-display: "[year]-[month]-[day]",
) = tufted.margin-note([
  Last updated on #updated-date.display(date-display) \
  #"        "Created on #created-date.display(date-display)
])


#let notes-item(
  path: str,
  title: content,
  created-date: datetime,
  updated-date: datetime,
  date-display: "[year]-[month]-[day]",
) = {
  [#link(path)[#title] #notes-side-info(
      created-date: created-date,
      updated-date: updated-date,
      date-display: date-display,
    )]
}

#title[Notes]

= Microsoft Rust Training Series

- #notes-item(
    path: "rust-for-c-cpp-programmers/",
    title: [Rust for C/C++ programmers],
    updated-date: datetime(year: 2026, month: 4, day: 5),
    created-date: datetime(year: 2026, month: 3, day: 28),
  )
