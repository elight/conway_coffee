conways_rules = (num_neighbors, alive) ->
  if alive
    num_neighbors in [2,3]
  else
    num_neighbors == 3

class Grid
  constructor: (@grid) ->
    @height = @grid.length
    @width = @grid[0].length

  set_cell: (x, y) ->
    @cell = {x: x, y: y}

  clone: (callback) ->
    next_grid = []
    for x in [0...@height]
      next_grid[x] = []
      for y in [0...@width]
        @set_cell(x, y)
        next_grid[x][y] = callback()
    next_grid


  neighbor_coordinates: (cell) ->
    neighbors = []
    for delta_x in [-1..1]
      for delta_y in [-1..1]
        continue if delta_x == 0 and delta_y == 0
        neighbors.push {x: cell.x + delta_x, y: cell.y + delta_y}
    neighbors

  transition_cell: =>
    num_neighbors = @how_many_alive()
    if conways_rules(num_neighbors, @cell_alive(@cell)) then 1 else 0

  transition: ->
    @grid = @clone(@transition_cell)
    @

  cell_alive: (cell) ->
    x = cell.x
    y = cell.y
    @grid[x]? and @grid[x][y]? and @grid[x][y] == 1

  how_many_alive: ->
    callback = (prev, current) =>
      prev++ if @cell_alive(current)
      prev
    @neighbor_coordinates(@cell).reduce(callback, 0)

  output: ->
    @grid


describe "Conway's Game of Life", ->

  describe "Rules", ->

    describe "Living cell with", ->
      for num_neighbors in [0, 1, 4, 5, 6, 7, 8]
        do (num_neighbors) ->
          it "should die when it has #{num_neighbors} neighbors", ->
            expect(conways_rules(num_neighbors, true)).toBeFalsy()

      for num_neighbors in [2, 3]
        do (num_neighbors) ->
          it "should live when it has #{num_neighbors} neighbors", ->
            expect(conways_rules(num_neighbors, true)).toBeTruthy()

    describe "Dead cell ", ->
      it "should live when it has 3 neighbors", ->
        expect(conways_rules(3, false)).toBeTruthy()

      for num_neighbors in [0, 1, 2, 4, 5, 6, 7, 8]
        do (num_neighbors) ->
          it "should die when it has #{num_neighbors} neighbors", ->
            expect(conways_rules(num_neighbors, false)).toBeFalsy()


  describe "The Grid", ->

    describe "(3x3)", ->

      describe "that is empty", ->
        beforeEach ->
          @input = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
          ]
          @test_grid = new Grid(@input)

        for row in [0...3]
          for col in [0...3]
            it "position #{row},#{col} has 0 neighbors", ->
              @test_grid.set_cell(row, col)
              expect(@test_grid.how_many_alive()).toEqual(0)

        it "should transition to its next state", ->
          expect(@test_grid.transition().output()).toEqual(@input)

      describe "that is full", ->
        beforeEach ->
          input = [
            [1, 1, 1],
            [1, 1, 1],
            [1, 1, 1],
          ]
          @test_grid = new Grid(input)

        it "normal case has 8 neighbors", ->
          @test_grid.set_cell(1, 1)
          expect(@test_grid.how_many_alive()).toEqual(8)

        for side in [[0, 1], [1, 0], [1, 2], [2, 1]]
          it "side case #{side} has 5 neighbors", ->
            @test_grid.set_cell(side[0], side[1])
            expect(@test_grid.how_many_alive()).toEqual(5)

        for corner in [[0, 0], [0, 2], [2, 0], [2, 2]]
          it "corner case #{corner} has 3 neighbors", ->
            @test_grid.set_cell(corner[0], corner[1])
            expect(@test_grid.how_many_alive()).toEqual(3)

        it "should transition to its next state", ->
          expected = [
            [1, 0, 1],
            [0, 0, 0],
            [1, 0, 1],
          ]
          expect(@test_grid.transition().output()).toEqual(expected)

        it "should transition multiple times", ->
          expected = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0],
          ]
          expect(@test_grid.transition().transition().output()).toEqual(expected)

    describe "(4x4)", ->

      describe "that is full", ->
        beforeEach ->
          input = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
          ]
          @test_grid = new Grid(input)

        it "should transition to its next state", ->
          expected = [
            [1, 0, 0, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [1, 0, 0, 1]
          ]
          expect(@test_grid.transition().output()).toEqual(expected)

    describe "(4x3)", ->

      describe "that is full", ->
        beforeEach ->
          input = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
          ]
          @test_grid = new Grid(input)

        it "should transition to its next state", ->
          expected = [
            [1, 0, 0, 1],
            [0, 0, 0, 0],
            [1, 0, 0, 1]
          ]
          expect(@test_grid.transition().output()).toEqual(expected)
