conways_rules = (num_neighbors, alive) ->
  if alive
    num_neighbors in [2,3]
  else
    num_neighbors == 3

neighbor_coordinates = (grid, row, col) ->
  neighbors = []
  for delta_row in [-1..1]
    for delta_col in [-1..1]
      [x, y] = [row + delta_row, col + delta_col]
      unless x == row and y == col
        neighbors.push([x, y])
  neighbors

transition = (grid) ->
  [height, width, next_grid] = [grid.length, grid[0].length, []]
  for row in [0...height]
    next_grid[row] = []
    for col in [0...width]
      alive = grid[row][col]?
      neighbors = how_many_alive(grid, row, col)
      next_grid[row][col] = if conways_rules(neighbors, alive) then 1 else 0
  next_grid


how_many_alive = (grid, row, col) ->
  callback = (prev, current) ->
    [x, y] = current
    if grid[x]? and grid[x][y]? then prev += grid[x][y] else prev
  neighbor_coordinates(grid, row, col).reduce(callback, 0)


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
          @test_grid = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
          ]

        for row in [0...3]
          for col in [0...3]
            it "position #{row},#{col} has 0 neighbors", ->
              expect(how_many_alive(@test_grid, row, col)).toEqual(0)

        it "should transition to its next state", ->
          expect(transition(@test_grid)).toEqual(@test_grid)

      describe "that is full", ->
        beforeEach ->
          @test_grid = [
            [1, 1, 1],
            [1, 1, 1],
            [1, 1, 1],
          ]

        it "normal case has 8 neighbors", ->
          expect(how_many_alive(@test_grid, 1, 1)).toEqual(8)

        for side in [[0, 1], [1, 0], [1, 2], [2, 1]]
          it "side case #{side} has 5 neighbors", ->
            expect(how_many_alive(@test_grid, side[0], side[1])).toEqual(5)

        for corner in [[0, 0], [0, 2], [2, 0], [2, 2]]
          it "corner case #{corner} has 3 neighbors", ->
            expect(how_many_alive(@test_grid, corner[0], corner[1])).toEqual(3)

        it "should transition to its next state", ->
          expected = [
            [1, 0, 1],
            [0, 0, 0],
            [1, 0, 1],
          ]
          expect(transition(@test_grid)).toEqual(expected)


    describe "(4x4)", ->

      describe "that is full", ->
        beforeEach ->
          @test_grid = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
          ]

        it "should transition to its next state", ->
          expected = [
            [1, 0, 0, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [1, 0, 0, 1]
          ]
          expect(transition(@test_grid)).toEqual(expected)

    describe "(4x3)", ->

      describe "that is full", ->
        beforeEach ->
          @test_grid = [
            [1, 1, 1, 1],
            [1, 1, 1, 1],
            [1, 1, 1, 1],
          ]

        it "should transition to its next state", ->
          expected = [
            [1, 0, 0, 1],
            [0, 0, 0, 0],
            [1, 0, 0, 1]
          ]
          expect(transition(@test_grid)).toEqual(expected)
