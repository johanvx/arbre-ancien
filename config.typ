#import "@preview/tufted:0.1.1"
#import "@preview/sicons:16.0.0": sicon

#let template = tufted.tufted-web.with(
  header-links: (
    "/": "Home",
    "/blog/": "Blog",
    "/bilibili": sicon(slug: "bilibili"),
    "/github": sicon(
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

#let meta-redirect(second: int, to: str) = html.elem("meta", attrs: (
  http-equiv: "refresh",
  content: str(second) + "; url=" + to,
))

#let page-source = {
  if "path" in sys.inputs {
    let prefix = "https://github.com/johanvx/arbre-ancien/blob/main/content/"
    tufted.margin-note(
      link(prefix + sys.inputs.path)[(_page source_)],
    )
  }
}
