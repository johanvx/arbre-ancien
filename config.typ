#import "@preview/tufted:0.1.1"
#import "@preview/sicons:16.0.0": sicon

#let template = tufted.tufted-web.with(
  header-links: (
    "/": "Home",
    "/blog/": "Blog",
    "https://johanvx.fyi/bilibili": sicon(slug: "bilibili"),
    "https://johanvx.fyi/github": sicon(
      slug: "github",
      icon-color: "#888888",
    ),
  ),
  title: "Johan Xie",
)

#let info-above-title(
  date: datetime,
  read-time: int,
  date-display: "[year]-[month]-[day]",
) = tufted.full-width({
  date.display(date-display) + " · " + str(read-time) + " min. read"
})
