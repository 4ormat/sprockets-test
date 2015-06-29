# A data structure for storing a fraction as a tuple of
# integers. Motivated by the desire to do accurate
# calculations with image aspect ratios.
#
# We assume that arguments named 'numerator', 'denominator',
# and 'integer' are integers. Violating this contract may
# yield unexpected results.

class Fraction
  @fromRatio: (ratioString) ->
    return null unless ratioString?.length > 0
    [numerator, denominator] = ratioString.split(':')
    numerator = parseInt(numerator)
    denominator = if denominator? then parseInt(denominator) else 1
    new Fraction(numerator, denominator)

  constructor: (@numerator, @denominator) ->

  multiply: (frac) ->
    new Fraction(@numerator * frac.numerator, @denominator * frac.denominator)

  divide: (frac) ->
    new Fraction(@numerator * frac.denominator, @denominator * frac.numerator)

  scale: (integer) ->
    new Fraction(@numerator * integer, @denominator)

  invert: ->
    new Fraction(@denominator, @numerator)

  toNumber: ->
    @numerator / @denominator

  calculateUnknownByRatio: (ratio) ->
    solveForUnknown = (relFrac, known) -> relFrac.scale(known).toNumber()
    if !@numerator? then solveForUnknown(ratio, @denominator)
    else if !@denominator? then solveForUnknown(ratio.invert(), @numerator)
    else throw new Error('calculateUnknownInEquality: no unknown quantities to calculate.')

window._4ORMAT ?= {}
window._4ORMAT.Fraction = Fraction
