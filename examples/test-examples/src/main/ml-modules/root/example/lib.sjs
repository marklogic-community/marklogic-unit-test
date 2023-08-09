const thsr = require("/MarkLogic/thesaurus.xqy");

function lookupTerm(term, outputKind) {
  if (outputKind === undefined) {
    outputKind = "objects";
  }
  return thsr.lookup("/thesaurus/example.xml", term, outputKind);
}

module.exports = {
  lookupTerm
}
