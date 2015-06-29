class @SpeedCalculator
  @defaultWeights = [0.5, 0.3, 0.2, 0.1, 0.1]
  constructor: (measurements = [], weights = null)->
    @measurements = measurements
    @weights = weights || @constructor.defaultWeights
    @memory_size = @weights.length

  addMeasurement: (measurement) ->
    @measurements.unshift measurement
    @measurements.pop() if @measurements.length > @memory_size

  averageSpeed: ->
    total = @measurements.reduce ((total, speed, index) => total + speed * @weights[index]), 0
    total / @weights.filter((_v, index) => index < @measurements.length ).
                     reduce(((total, weight) -> total + weight), 0)