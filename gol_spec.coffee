conways_rules = (num_neighbors, alive) ->
  if alive
    num_neighbors in [2,3]
  else
    num_neighbors == 3

class Grid
  constructor: (@grid) ->

  neighbor_coordinates: (row, col) ->
    neighbors = []
    for delta_row in [-1..1]
      for delta_col in [-1..1]
        [x, y] = [row + delta_row, col + delta_col]
        unless x == row and y == col
          neighbors.push([x, y])
    neighbors

  transition: ->
    [height, width, next_grid] = [@grid.length, @grid[0].length, []]
    for row in [0...height]
      next_grid[row] = []
      for col in [0...width]
        alive = @grid[row][col]?
        neighbors = @how_many_alive(row, col)
        next_grid[row][col] = if conways_rules(neighbors, alive) then 1 else 0
    @grid = next_grid

  cell_present: (x, y) ->
    @grid[x]? and @grid[x][y]?

  how_many_alive: (row, col) ->
    callback = (prev, current) =>
      [x, y] = current
      if @cell_present(x, y) then prev += @grid[x][y] else prev
    @neighbor_coordinates(row, col).reduce(callback, 0)


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
              expect(@test_grid.how_many_alive(row, col)).toEqual(0)

        it "should transition to its next state", ->
          expect(@test_grid.transition()).toEqual(@input)

      describe "that is full", ->
        beforeEach ->
          input = [
            [1, 1, 1],
            [1, 1, 1],
            [1, 1, 1],
          ]
          @test_grid = new Grid(input)

        it "normal case has 8 neighbors", ->
          expect(@test_grid.how_many_alive(1, 1)).toEqual(8)

        for side in [[0, 1], [1, 0], [1, 2], [2, 1]]
          it "side case #{side} has 5 neighbors", ->
            expect(@test_grid.how_many_alive(side[0], side[1])).toEqual(5)

        for corner in [[0, 0], [0, 2], [2, 0], [2, 2]]
          it "corner case #{corner} has 3 neighbors", ->
            expect(@test_grid.how_many_alive(corner[0], corner[1])).toEqual(3)

        it "should transition to its next state", ->
          expected = [
            [1, 0, 1],
            [0, 0, 0],
            [1, 0, 1],
          ]
          expect(@test_grid.transition()).toEqual(expected)


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
          expect(@test_grid.transition()).toEqual(expected)

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
          expect(@test_grid.transition()).toEqual(expected)
