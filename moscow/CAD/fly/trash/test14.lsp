
(defun c:Test (/ p1 p2 p3)
(if (and (setq p1 (getpoint "\nSpecify leader starting point: "))
(setq p2 (getpoint p1 "\nSpecify next point: "))
)
(progn
(grdraw p1 p2 7 1)
(setq p3 (getpoint p2 "\nSpecify next point <Annotation>: "))
(redraw)
(initdia)
(if p3
(command "_.leader" "_non" p1 "_non" p2 "_non" p3 "_A" "" "_M" "")
(command "_.leader" "_non" p1 "_non" p2 "_A" "" "_M" "")
)
)
)
(princ)
)