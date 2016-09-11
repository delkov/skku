(defun fetch(e / pl etyp flgs ans)
  (setq etyp nil)
  (while (not (or (= etyp "LINE") (= etyp "POLYLINE"))) (progn
    (setq ename nil)

    (if e (progn
      (setq pl     (entget e)
      etyp   (fld 0 pl)
      ename  e)
      (if (or (= etyp "LINE") (= etyp "POLYLINE")) (progn
  (princ (strcat "\n" etyp " selected"))
  (if (= etyp "LINE")
    (setq e      (line2pline e)
    ename  e
    pl     (entget e))
  ))

        (if (= etyp "LWPOLYLINE")
    (setq e      (command "_.CONVERTPOLY" "H" e ""))
    ename  e
    pl     (entget e))
  ))

      ;else
  (progn  (princ "\nThat's not a LINE or POLYLINE, it's a ") (princ etyp))
      ); end if
    ); end progn
    ; else
      (princ "\nNothing Selected")
    ); end if
  )); end while