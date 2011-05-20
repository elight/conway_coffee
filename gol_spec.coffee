conways_rules = (num_neighbors, alive = true) ->
  if alive
    num_neighbors in [2,3]
  else
    num_neighbors == 3

neighbor_coordinates = (grid, row, col) ->
  neighbors = []
  for delta_row in [-1..1]
    for delta_col in [-1..1]
      do (delta_row, delta_col) ->
        [x, y] = [row + delta_row, col + delta_col]
        unless x == row and y == col
          neighbors.push([x, y])
  neighbors

how_many_alive = (grid, row, col) ->
  sum = 0
  for [x, y] in neighbor_coordinates(grid, row, col)
    if grid[x]? and grid[x][y]?
      sum += grid[x][y]
  sum


describe "Conway's Game of Life", ->

  describe "Rules", ->

    describe "Living cell with", ->
      for num_neighbors in [0, 1, 4, 5, 6, 7, 8]
        do (num_neighbors) ->
          it "should die when it has #{num_neighbors} neighbors", ->
            expect(conways_rules(num_neighbors)).toBeFalsy()

      for num_neighbors in [2, 3]
        do (num_neighbors) ->
          it "should live when it has #{num_neighbors} neighbors", ->
            expect(conways_rules(num_neighbors)).toBeTruthy()

    describe "Dead cell ", ->
      it "should live when it has 3 neighbors", ->
        expect(conways_rules(3)).toBeTruthy()

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
            do (row, col) ->
              it "position #{row},#{col} has 0 neighbors", ->
                expect(how_many_alive(@test_grid, row, col)).toEqual(0)

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
          do (side) ->
            it "side case #{side} has 5 neighbors", ->
              expect(how_many_alive(@test_grid, side[0], side[1])).toEqual(5)
