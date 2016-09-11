
    (setvar "CELTSCALE" 100)
    (command ".-linetype" "set" "temp" "")

   (command "._LINE" '(10 50) '(400 50) "")

     (setvar "CELTSCALE" 1)
         (command ".-linetype" "set" "ByLayer" "")