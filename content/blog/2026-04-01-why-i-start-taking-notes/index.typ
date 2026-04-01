#import "../index.typ": blog-post-info, page-source, template, tufted
#import "@preview/cmarker:0.1.8"
#show: template.with(title: "Why I start taking notes :: Johan Xie")
#set quote(block: true)
#set par(justify: true)

#blog-post-info(
  date: datetime(year: 2026, month: 4, day: 1),
  read-time: 1,
)

#page-source

= Why I start taking notes

Taking notes has always been useless for me because I always felt like I'd never
actually look back at the notes I took.

#let takuya-matsuyama = footnote[
  He's a solo developer, the author of a Markdown note-taking app called
  #link("https://www.inkdrop.app/")[_Inkdrop_].
]

#let videos = footnote[
  #link(
    "https://www.youtube.com/watch?v=rjOuCFrs584",
  )[How I take tech notes as a note app author]
  and #link("https://www.youtube.com/watch?v=RhuAn4uLVpc")[Learning Svelte]
]

It wasn't until recently, after watching some videos#videos by Takuya
Matsuyama#takuya-matsuyama on how he takes notes, that something clicked.

I started to take notes, and the process of taking notes forced me to actively
engage with the material. That was surprisingly helpful for my understanding and
retention of the information.

#quote(attribution: [Richard P. Feynman])[
  The first principle is that you must not fool yourself and you are the easiest
  person to fool.
]

I'm now getting used to taking notes. No matter how small the note is and how
unstructured it is, I just write it down. It's a simple way to estimate whether
I'm fooling myself or not.
