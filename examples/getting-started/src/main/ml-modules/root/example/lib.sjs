const thsr = require("/MarkLogic/thesaurus.xqy");

function lookupTerm(term) {
  return {
    "term": term,
    "entries": thsr.lookup("/thesaurus/example.xml", term).toArray()
  }
}

module.exports = {
  lookupTerm
}
