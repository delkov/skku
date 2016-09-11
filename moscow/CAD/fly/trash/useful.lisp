    (initget "Yes No")
    (setq Ans(getkword "\n>>> Mirror line? [Yes/No] <No>: "))
    (if(null Ans)(setq Ans "No"))
    (if(= Ans "Yes")
     (progn
       (command "_.erase" (entlast) "")
       (command "_.line" fPt
        (trans(polar fPt(- Ang Pi)radius)0 1)"")
        ); end progn
      ); end if
