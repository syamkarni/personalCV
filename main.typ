#import "cv.typ": *

//#let cvdata = yaml("example.yml")
#let cvdata = json("data.json")

#let uservars = (
    headingfont: "Linux Libertine",
    bodyfont: "Linux Libertine",
    fontsize: 10pt, // 10pt, 11pt, 12pt
    linespacing: 6pt,
    showAddress: true, // true/false show address in contact info
    showNumber: true,  // true/false show phone number in contact info
    headingsmallcaps: false
)
#let customrules(doc) = {
    set page(
        paper: "us-letter", // a4, us-letter
        numbering: "1 / 1",
        number-align: center, // left, center, right
        margin: 1.25cm, // 1.25cm, 1.87cm, 2.5cm
    )

    doc
}

#let cvinit(doc) = {
    doc = setrules(uservars, doc)
    doc = showrules(uservars, doc)
    doc = customrules(doc)

    doc
}
#show: doc => cvinit(doc)
#cvheading(cvdata, uservars)
#cvabout(cvdata)
#cvwork(cvdata)
#cveducation(cvdata)

#cvprojects(cvdata)
#cvskills(cvdata)
#cvaffiliations(cvdata)
#cvvdata(cvdata)
#endnote()