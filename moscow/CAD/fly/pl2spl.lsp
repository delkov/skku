; Converts Polylines into Splines.
 
; Only works if the Polylines have been modified to a "fit-curve"
 
(defun pl_sel ( / orig_selset pl_selset count)
 
(prompt "\nSelect Polylines: ")
 
(setq
 
orig_selset (ssget)
 
pl_selset (ssadd)
 
count -1
 
)
 
(repeat (sslength orig_selset)
 
(setq count (1+ count))
 
(if (= (cdr (assoc 0 (entget (ssname orig_selset count)))) "POLYLINE")
 
(ssadd (ssname orig_selset count) pl_selset)
 
)
 
)
 
pl_selset
 
)
 
(defun vertex ( sset / count ent_sup act_ent spl_list)
 
(setq count 0)
 
(repeat (sslength sset)
 
(setq
 
ent_sup (ssname sset count)
 
act_ent (entnext ent_sup)
 
count (1+ count)
 
spl_list nil
 
)
 
(while (/= (cdr (assoc 0 (entget act_ent ))) "SEQEND")
 
(if
 
(or
 
(= (cdr (assoc 70 (entget act_ent))) 0)
 
(= (cdr (assoc 70 (entget act_ent))) 16)
 
)
 
(setq
 
spl_list
 
(cons (cons 11 (cdr (assoc 10 (entget act_ent)))) spl_list)
 
)
 
)
 
(setq
 
act_ent (entnext act_ent)
 
)
 
)
 
(setq spl_list (reverse spl_list))
 
(foreach
 
cod
 
(list
 
(assoc 8 (entget ent_sup))
 
(cons 74 (length spl_list))
 
(cons 71 3)
 
(cons 100 "AcDbSpline")
 
(cons 100 "AcDbEntity")
 
(cons 0 "SPLINE")
 
)
 
(setq spl_list (cons cod spl_list))
 
)
 
(entmake spl_list)
 
(entdel ent_sup)
 
)
 
)
 
;;Command line function
 
(defun c:pl2sp ( / oce)
 
(setq oce (getvar "cmdecho"))
 
(setvar "cmdecho" 0)
 
(vertex (pl_sel))
 
(redraw)
 
(setvar "cmdecho" oce)
 
(princ)
 
)
 
;;----------------END PROGRAM-----------------------