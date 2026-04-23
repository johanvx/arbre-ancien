#import "../index.typ": blog-post-info, template, tufted
#import "@preview/cmarker:0.1.8"
#show: template.with(title: "Thoughts on AI-Assisted Coding :: Johan Xie")

#blog-post-info(
  date: datetime(year: 2026, month: 4, day: 23),
  read-time: 3,
)

#title[Thoughts on AI-Assisted Coding]

I've been using AI-assisted coding tools ever since the first release of GitHub
Copilot Neovim plugin in 2021. So far, I've tried out and currently use all
sorts of AI tools, such as code completion/suggestions, chatbots, and agents.

In the early days, when AI autocomplete was pretty much the only popular thing
on the Internet, I didn't follow any tutorials. Instead, I explored and adjusted
how I used AI on my own, based on how happy I was with the results it provided.
This became a habit, and even as more types of AI tools emerged, I've continued
to use AI in this way:

/ Never try to make an AI understand the entire codebase:
  Letting them roam freely through the codebase and potentially exceed the
  context limit is not a good idea. Some might argue there are ways around this.
  I agree, but the point is: It's the human who needs to understand the
  codebase, not the AI. When you know everything about the project, you can
  easily come up with a detailed, well-structured, and less error-prone prompt
  or plan to guide the AI agent to do the work for you without going off track.

#let ask-yourself-dumb-questions = [
  I learnt this from a blog post of Terence Tao, famous mathematician and Fields
  Medalist. See #link(
    "https://terrytao.wordpress.com/career-advice/ask-yourself-dumb-questions-and-answer-them/",
  )[_Ask yourself dumb questions -- and answer them!_]
]
/ Use AI for learning by brainstorming:
  AI can be a great tool to help get unstuck and generate new ideas. When
  talking to AI, add your own thoughts and ideas to the conversation, so that
  the output of AI is likelier (I think) to be relevant and useful. You can try
  asking yourself dumb questions and answering them#footnote(
    ask-yourself-dumb-questions,
  ), then brainstorm with AI to get more ideas.

/ Let AI do the boring stuff that does not teach you anything new:
  Humans are lazy by nature, and that is not necessarily a bad thing. Use AI to
  handle the tedious tasks that teach you nothing new, such as adding debug
  prints, writing tests for trivial code, or performing simple refactors. That
  way, you can save your time for more creative and critical work, such as
  designing the architecture and APIs.

/ Double-check the output of AI:
  It is your responsibility to verify the results, as only you possess good
  taste, good sense, and the ability to define the gestalt of the project. You
  don't? Then use AI for learning, and improve yourself so that you can do so in
  the future.

#let mario-zechner = [Author of #link("https://pi.dev/")[pi]]
See also Mario Zechner's#footnote(mario-zechner) #link(
  "https://mariozechner.at/posts/2026-03-25-thoughts-on-slowing-the-fuck-down/",
)[blog post] about how we should and should not work with agents.
