#import "../index.typ": blog-post-info, template
#show: template.with(
  title: "HACI 2026: Notes from an HPC User :: Johan Xie",
)

#blog-post-info(
  date: datetime(year: 2026, month: 5, day: 28),
  read-time: 2,
)

#title[HACI 2026: Notes from an HPC User]

#let haci2026-begin = datetime(year: 2026, month: 5, day: 22)
#let haci2026-end = datetime(year: 2026, month: 5, day: 25)
#let haci2026-range = [
  #haci2026-begin.display("[day]")--#haci2026-end.display(
    "[day] [month repr:long] [year]",
  )
]

Last weekend#footnote[#haci2026-range], I attended #link(
  "https://haci2026.haciconference.com",
)[HACI 2026], the International Forum for HPC & AI Co-Driven Innovation.

I build scalable scientific simulation codes, and I also use AI tools in daily
development. However, my simulation stack is still mostly FP64/FP32 brute force.
Given that constraint, I listened with one question: _What can a small lab with
two consumer GPUs actually do next?_

Four talks stayed with me.

- *Jack Dongarra*: The plausible path to “effective zettascale” is not
  brute-force FP64, but certified mixed-precision algorithms,
  communication-avoiding methods, AI-augmented reduced-order models, and hybrid
  AI+simulation workflows with rigorous error control and uncertainty
  quantification. His weather prediction example was concrete: AI trained on
  \~40 years of data can predict 10-day weather in seconds, but should run
  alongside numerical models.
- *Taisuke Boku*: Fugaku-NEXT and a practical migration path: from Fortran CPU
  code with OpenMP pragmas to C/C++ CPU-GPU code using OpenACC/OpenMP target
  offload. His HAIRDESC public GPU course reinforces this point: migration needs
  method and training, not only hardware.
- *Bingsheng He*: In LLM systems, small teams (2--3 people) plus agents can
  build production systems quickly.
- *Zeyi Wen* (parallel session 2): Efficient fine-tuning and inference of
  frontier LLMs on a single RTX 4090, with >95% peak performance and lossless
  results.

For a small lab, the conclusion is straightforward: _optimize for attainable
performance first_. My possible next steps would be:

+ Measure data movement bottlenecks before adding compute.
+ Expand mixed precision only where error behavior is controlled.
+ Build one small AI+simulation prototype with validation.
+ Reproduce one single-GPU optimization result on our own RTX hardware.

HACI 2026 was broad. My output is narrow: one clearer direction and one smaller
next step.
