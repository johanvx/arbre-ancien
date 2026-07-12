#import "../index.typ": blog-post-info, template
#show: template.with(title: "Invisible Stars :: Johan Xie")

#blog-post-info(
  date: datetime(year: 2026, month: 7, day: 12),
  read-time: 1,
)

#title[Invisible Stars]

I've starred 1,400 projects on GitHub, but I don't remember most of them. They
left no impression because I never actually used them.

Starring costs nothing: I see something interesting, click on the star button,
then move on. I get the satisfaction of discovery without the work of
understanding.

I've confused collecting with learning.

I want to change that.

I'm adding a page to my site for the projects that genuinely interest me. For an
application, I'll include my own configuration. For a library, I'll build a
small application with it — I'm calling these _gadgets_. The goal isn't to build
something polished. It's to understand the tool by using it.

#let nob-h = link("https://github.com/nobh/nob.h")[nob.h]
#let tmtheme = link("https://github.com/johanvx/tmtheme")[tmtheme]

For example, I starred #nob-h, a single-header C build system. I've been meaning
to try it with #tmtheme, a little CLI tool that generates `.tmTheme` files. The
idea: replace tmtheme's current build setup with nob.h and document the process
on the page — what worked, what didn't, and what the final configuration looks
like.

No more invisible stars. Just things I've actually touched.
