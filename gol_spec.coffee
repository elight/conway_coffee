conways_rules = (num_neighbors, alive = true) -> 
  if alive
    num_neighbors in [2,3]
  else
    num_neighbors == 3


describe "Conway's Game of Life", -> 

  describe "Rules", ->

    describe "Living cell with", ->
      for num_neighbors in [0, 1, 4, 5, 6, 7, 8]
        do (num_neighbors) ->
          it "should die when it has " + num_neighbors + " neighbors", ->
            expect(conways_rules(num_neighbors)).toBeFalsy()

      for num_neighbors in [2, 3]
        do (num_neighbors) ->
          it "should live when it has " + num_neighbors + " neighbors", ->
            expect(conways_rules(num_neighbors)).toBeTruthy()

    describe "Dead cell ", ->
      it "should live when it has 3 neighbors", ->
        expect(conways_rules(3)).toBeTruthy()

      for num_neighbors in [0, 1, 2, 4, 5, 6, 7, 8]
        do (num_neighbors) ->
          it "should die when it has " + num_neighbors + " neighbors", ->
            expect(conways_rules(num_neighbors, false)).toBeFalsy()
