using ClassicalCiphers
using Base.Test

# Wikipedia example
@test encrypt_playfair("Hide the gold in the tree stump", "playfair example") == "BMODZBXDNABEKUDMUIXMMOUVIF"

# Simon Singh Black Chamber example
@test encrypt_playfair("meet me at hammersmith bridge tonight", "charles") == "GDDOGDRQARKYGDHDNKPRDAMSOGUPGKICQY"

# doc examples
@test encrypt_playfair("Hello, World!", "playfair example") == "DMYRANVQCRGE"
@test (arr = ['P' 'L' 'A' 'Y' 'F'; 'I' 'R' 'E' 'X' 'M'; 'B' 'C' 'D' 'G' 'H'; 'K' 'N' 'O' 'Q' 'S'; 'T' 'U' 'V' 'W' 'Z']; 
	   encrypt_playfair("Hello, World!", arr) == "DMYRANVQCRGE")

@test encrypt_playfair("HELXLOWORLD", "PLAYFIREXM") == "DMYRANVQCRGE"

@test encrypt_playfair("IJXYZA", "PLAYFIREXM", combined=('I', 'J')) == "RMRMFWYE"
@test encrypt_playfair("IJXYZA", "PLAYFIREXM", combined=('X', 'Z')) == "BSGXEY"

@test decrypt_playfair("BSGXEY", "PLAYFIREXM", combined=('X', 'Z')) == "ijxyxa"
@test decrypt_playfair("RMRMFWYE", "PLAYFIREXM", combined=('I', 'J')) == "ixixyzax"
@test decrypt_playfair("DMYRANVQCRGE", "playfair example") == "helxloworldx"
@test (arr = ['P' 'L' 'A' 'Y' 'F'; 'I' 'R' 'E' 'X' 'M'; 'B' 'C' 'D' 'G' 'H'; 'K' 'N' 'O' 'Q' 'S'; 'T' 'U' 'V' 'W' 'Z']; 
	   decrypt_playfair("DMYRANVQCRGE", arr) == "helxloworldx")
@test decrypt_playfair("GDDOGDRQARKYGDHDNKPRDAMSOGUPGKICQY", "charles") == "meetmeathamxmersmithbridgetonightx"
@test decrypt_playfair("BMODZBXDNABEKUDMUIXMMOUVIF", "playfair example") == "hidethegoldinthetrexestump"