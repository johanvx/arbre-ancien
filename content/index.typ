#import "../config.typ": page-source, template, tufted
#import "@preview/cmarker:0.1.8"
#show: template

#page-source

= Johan

// NOTE: This page is generated from the README.md file
#{
  let md-content = read("../README.md")
  let md-content = md-content.trim(regex("\s*#.+?\n")) // Remove first-level heading

  // Render markdown content with custom image handling
  cmarker.render(
    md-content,
    scope: (
      image: (source, alt: none, format: auto) => figure(image(
        "../" + source, // Modify paths for images
        alt: alt,
        format: format,
      )),
    ),
  )
}
