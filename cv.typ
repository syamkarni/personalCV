
// set rules
#let setrules(uservars, doc) = {
    set text(
        font: uservars.bodyfont,
        size: uservars.fontsize,
        hyphenate: false,
    )

    set list(
        spacing: uservars.linespacing
    )

    set par(
        leading: uservars.linespacing,
        justify: true,
    )

    doc
}

// show rules
#let showrules(uservars, doc) = {
    // uppercase section headings
    show heading.where(
        level: 2,
    ): it => block(width: 100%)[
        #set align(left)
        #set text(font: uservars.headingfont, size: 1em, weight: "bold")
        #if (uservars.at("headingsmallcaps", default:false)) {
            smallcaps(it.body)
        } else {
            upper(it.body)
        }
        #v(-0.75em) #line(length: 100%, stroke: 1pt + black) // draw a line
    ]

    // name title
    show heading.where(
        level: 1,
    ): it => block(width: 100%)[
        #set text(font: uservars.headingfont, size: 1.5em, weight: "bold")
        #if (uservars.at("headingsmallcaps", default:false)) {
            smallcaps(it.body)
        } else {
            upper(it.body)
        }
        #v(2pt)
    ]

    doc
}

// set page layout
#let cvinit(doc) = {
    doc = setrules(doc)
    doc = showrules(doc)

    doc
}



// address
#let addresstext(info, uservars) = {
    if uservars.showAddress {
        block(width: 100%)[
            #info.personal.location.city, #info.personal.location.region, #info.personal.location.country #info.personal.location.postalCode
            #v(-4pt)
        ]
    } else {none}
}


#let contacttext(info, uservars) = block(width: 100%)[
    #let profiles = (
        box(link("mailto:" + info.personal.email)),
        if uservars.showNumber {box(link("tel:" + info.personal.phone))} else {none},
        if info.personal.url != none {
            box(link(info.personal.url)[#info.personal.url.split("//").at(1)])
        }
    ).filter(it => it != none) // filter out none elements from the profile array

    #if info.personal.profiles.len() > 0 {
        for profile in info.personal.profiles {
            profiles.push(
                box(link(profile.url)[#profile.url.split("//").at(1)])
            )
        }
    }

    #set text(font: uservars.bodyfont, weight: "medium", size: uservars.fontsize * 1)
    #pad(x: 0em)[
        #profiles.join([#sym.space.en #sym.diamond.filled #sym.space.en])
    ]
]

#let cvheading(info, uservars) = {
    align(center)[
        = #info.personal.name
        #addresstext(info, uservars)
        #contacttext(info, uservars)
    ]
}


#let cvabout(info, isbreakable: true) = {
    if info.about != none {block(breakable: isbreakable)[
        == introduction
        #info.about
    ]}
}

#let cvwork(info, isbreakable: true) = {
    if info.work != none {block[
        == Work Experience
        #for w in info.work {
            block(width: 100%, breakable: isbreakable)[
                // line 1: company and location
                #if w.url != none [
                    *#link(w.url)[#w.organization]* #h(1fr) *#w.location* \
                ] else [
                    *#w.organization* #h(1fr) *#w.location* \
                ]
            ]
            // create a block layout for each work entry
            let index = 0
            for p in w.positions {
                if index != 0 {v(0.6em)}
                block(width: 100%, breakable: isbreakable, above: 0.6em)[
                    // parse ISO date strings into datetime objects
                    //#let start = utils.strpdate(p.startDate)
                    //#let end = utils.strpdate(p.endDate)
                    // line 2: position and date range
                    #text(style: "italic", weight: "semibold")[#p.position] #h(1fr)
                    #p.startDate #sym.dash.en #p.endDate \
                    // highlights or description
                    #for hi in p.highlights [
                        - #eval(hi, mode: "markup")
                    ]
                ]
                index = index + 1
            }
        }
    ]}
}

#let cveducation(info, isbreakable: true)={
  if info.education != none {block[
    == education
    #for edu in info.education {
      block(width: 100%, breakable: isbreakable)[
                // line 1: institution and location
                #if edu.url != none [
                    *#link(edu.url)[#edu.institution]* #h(1fr) *#edu.location* \
                ] else [
                    *#edu.institution* #h(1fr) *#edu.location* \
                ]
                // line 2: degree and date
                #text(style: "italic")[#edu.studyType in #edu.area] #h(1fr)
                #edu.startDate #sym.dash.en #edu.endDate \
                //#eval(edu-items, mode: "markup")
            ]
    }
  ]}

}


#let cvaffiliations(info, isbreakable: true) = {
    if info.affiliations != none {block[
        == Leadership & Activities
        #for org in info.affiliations {
            // parse ISO date strings into datetime objects
           // let start = utils.strpdate(org.startDate)
            //let end = utils.strpdate(org.endDate)

            // create a block layout for each affiliation entry
            block(width: 100%, breakable: isbreakable)[
                // line 1: organization and location
                #if org.url != none [
                    *#link(org.url)[#org.organization]* #h(1fr) *#org.location* \
                ] else [
                    *#org.organization* #h(1fr) *#org.location* \
                ]
                // line 2: position and date
                #text(style: "italic")[#org.position] #h(1fr)
                #start #sym.dash.en #end \
                // highlights or description
                #if org.highlights != none {
                    for hi in org.highlights [
                        - #eval(hi, mode: "markup")
                    ]
                } else {}
            ]
        }
    ]}
}

#let cvprojects(info, isbreakable: true) = {
    if info.projects != none {block[
        == Projects
        #for project in info.projects {
            // parse ISO date strings into datetime objects
            //let start = utils.strpdate(project.startDate)
           // let end = utils.strpdate(project.endDate)
            // create a block layout for each project entry
            block(width: 100%, breakable: isbreakable)[
                // line 1: project name
                #if project.url != none [
                    *#link(project.url)[#project.name]* #h(1fr) #project.startDate #sym.dash.en #project.endDate \
                ] else [
                    *#project.name* #h(1fr) #project.startDate #sym.dash.en #project.endDate \
                ]
                // line 2: organization and date
                #text(style: "italic")[#project.affiliation]  
                // summary or description
                #for hi in project.highlights [
                    - #eval(hi, mode: "markup")
                ]
            ]
        }
    ]}
}
#let cvskills(info, isbreakable: true) = {
    if (info.languages != none) or (info.skills != none) or (info.interests != none) {block(breakable: isbreakable)[
        == Skills, Languages, Interests
        #if (info.languages != none) [
            #let langs = ()
            #for lang in info.languages {
                langs.push([#lang.language (#lang.fluency)])
            }
            - *Languages*: #langs.join(", ")
        ]
        #if (info.skills != none) [
            #for group in info.skills [
                - *#group.category*: #group.skills.join(", ")
            ]
        ]
        #if (info.interests != none) [
            - *Interests*: #info.interests.join(", ")
        ]
    ]}
}

#let cvvdata(info, isbreakable: true) = {
    if info.vdata != none {block[
        == VOLUNTEER EXPERIENCE
        #for org in info.affiliations {
            // parse ISO date strings into datetime objects
           // let start = utils.strpdate(org.startDate)
            //let end = utils.strpdate(org.endDate)

            // create a block layout for each affiliation entry
            block(width: 100%, breakable: isbreakable)[
                // line 1: organization and location
                #if org.url != none [
                    *#link(org.url)[#org.organization]* #h(1fr) *#org.location* \
                ] else [
                    *#org.organization* #h(1fr) *#org.location* \
                ]
                // line 2: position and date
                #text(style: "italic")[#org.position] #h(1fr)
                #start #sym.dash.en #end \
                // highlights or description
                #if org.highlights != none {
                    for hi in org.highlights [
                        - #eval(hi, mode: "markup")
                    ]
                } else {}
            ]
        }
    ]}
}


#let endnote() = {
    place(
        bottom + right,
        block[
            #set text(size: 5pt, font: "Consolas", fill: silver)
            \*This document was last updated on #datetime.today().display("[year]-[month]-[day]") using #strike[LaTeX] #link("https://typst.app")[Typst].
        ]
    )
}