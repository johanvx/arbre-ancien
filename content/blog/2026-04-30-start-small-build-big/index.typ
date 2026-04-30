#import "../index.typ": blog-post-info, template, tufted
#import "@preview/cmarker:0.1.8"
#show: template.with(title: "Start Small, Build Big :: Johan Xie")

#blog-post-info(
  date: datetime(year: 2026, month: 4, day: 30),
  read-time: 1,
)

#title[Start Small, Build Big]

#let channels = [
  Such as #link(
    "https://www.youtube.com/watch?v=zOTE4BN59u4",
  )[impl Rust: WAV noise generator] by #link(
    "https://www.youtube.com/@jonhoo",
  )[Jon Gjengset] and #link(
    "https://www.youtube.com/watch?v=iotrPxUnTdQ",
  )[Reference Counting in C] by #link(
    "https://www.youtube.com/@TsodingDaily",
  )[Tsoding Daily]
]

I’ve always been drawn to ambitious projects---but I often get lost in the early
stages. Watching live coding sessions#footnote(channels) showed me a simple
truth: Successful developers begin with tiny, concrete steps. They focus on the
_next_ small thing, then the one after that, letting complexity emerge
naturally.

The core issue? I lacked a clear vision and a way to break projects into
manageable pieces.

The solution: Start small.

+ *Define the goal* in a few sentences.
+ *Break it down* into tiny, actionable tasks.
+ *Track progress* with a checklist or Git commits.

Small steps don’t need to be perfect---they just need to move you forward.
Refinement comes later, one incremental step at a time.
