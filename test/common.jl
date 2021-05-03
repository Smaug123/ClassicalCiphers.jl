@test ClassicalCiphers.letters_only("Se9Wj8NK2:'n") == "SeWjNKn"

@test ClassicalCiphers.rotate_left([78, 18, 53, 96, 15, 35, 72, 29, 34, 26], 3) == [96, 15, 35, 72, 29, 34, 26, 78, 18, 53]
@test ClassicalCiphers.rotate_right([78, 18, 53, 96, 15, 35, 72, 29, 34, 26], 3) == [29, 34, 26, 78, 18, 53, 96, 15, 35, 72]

@test ClassicalCiphers.rotate_string("Se9Wj8NK2:'n", 5) == "8NK2:'nSe9Wj"
@test ClassicalCiphers.rotate_left("Se9Wj8NK2:'n", 3) == "Wj8NK2:'nSe9"
@test ClassicalCiphers.rotate_right("Se9Wj8NK2:'n", 3) == ":'nSe9Wj8NK2"

@test ClassicalCiphers.split_by([78, 18, 53, 96, 15, 35, 72, 29, 34, 26], x -> x > 52) == [[78], [18], [53, 96], [15, 35], [72], [29, 34, 26]]

# @test get_trigram_fitness() # I don't think we need this test because the function in question is immediately called and used in ../src/common.jl

@test ClassicalCiphers.string_fitness("Se9Wj8NK2:'n") == 11.640550700535616

@test ClassicalCiphers.frequencies("hello") == Dict('h' => 1, 'e' => 1, 'l' => 2, 'o' => 1)

@test ClassicalCiphers.index_of_coincidence("hello world") == 0.5777777777777777
@test ClassicalCiphers.index_of_coincidence("smaug123classicalciphers") == 0.6190476190476191
