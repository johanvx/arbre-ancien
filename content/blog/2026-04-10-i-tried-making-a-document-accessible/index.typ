#import "../index.typ": blog-post-info, template, tufted
#import "@preview/cmarker:0.1.8"
#show: template.with(title: "I Tried Making a Document Accessible :: Johan Xie")

#blog-post-info(
  date: datetime(year: 2026, month: 4, day: 10),
  read-time: 2,
)

#title[I Tried Making a Document Accessible]

Accessibility is essential in document design, enabling people with disabilities
or those using _Assistive Technology_ (AT) like screen readers to access
content.

#let undergradmath = link("https://gitlab.com/jim.hefferon/undergradmath")
#let typst-undergradmath = link(
  "https://github.com/johanvx/typst-undergradmath",
)
#let accessibility-guide = link(
  "https://typst.app/docs/guides/accessibility",
)
I ported _Undergradmath_, a concise 2-page math writing guide by Jim
Hefferon#footnote[#undergradmath], to Typst#footnote[#typst-undergradmath]. I
wanted to make my Typst port accessible, but wasn’t sure how---until I read the
official Typst Accessibility Guide#footnote[#accessibility-guide]. It turned out
to be simpler than expected.

The key is using semantic markup to clarify document structure. For example, use
`<h1>`, `<h2>` tags in HTML or `#`, `##` in Markdown for headings. In WYSIWYG
editors like Microsoft Word, apply _Styles_ linked to outline levels (e.g.,
_Heading 1_ for level 1). Just changing font size or alignment isn’t enough.

#let commit-link(body) = link(
  "https://github.com/johanvx/typst-undergradmath/commit/e14406129d02570ac8681189e0fb58c90e6e4e96",
  body,
)
Always provide alternative text (_alt text_) for non-text content like images,
charts, and equations. Typst’s `alt` argument makes this easy. For math, I write
alt text as I’d read the formula aloud. I used an LLM to generate alt texts for
all equations#footnote[See the commit #commit-link[e144061].], and the results
were good.

Other tips include ensuring color contrast and adding captions to figures. Check
out the Accessibility Guide for more.

#let release-link(body) = link(
  "https://github.com/johanvx/typst-undergradmath/releases/tag/v2.0.0",
  body,
)
The accessible version of my Typst port is a PDF/UA-1 file available at
#release-link[GitHub Release], compiled with `--pdf-standard ua-1`.
