#import "@preview/tufted:0.1.1"
#import "@preview/sicons:16.0.0": sicon

#let header-links = (
  "/": "Home",
  "/blog/": "Blog",
  "/notes/": "Notes",
  "/bilibili": sicon(slug: "bilibili"),
  "/github": sicon(
    slug: "github",
    icon-color: "#888888",
  ),
)
#{
  if "path" in sys.inputs {
    let prefix = "https://github.com/johanvx/arbre-ancien/blob/main/content/"
    header-links.insert(
      prefix + sys.inputs.path,
      [( #underline[_Page Source_] )],
    )
  }
}

#let template = tufted.tufted-web.with(
  header-links: header-links,
  title: "Johan Xie",
)

#let meta-redirect(second: int, to: str) = html.elem("meta", attrs: (
  http-equiv: "refresh",
  content: str(second) + "; url=" + to,
))
