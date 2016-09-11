(defun C:CHL (/ ss)
(setq ss (entlast))
(if ss
(progn
(setvar "cmdecho" 0)
(setvar "CELTSCALE" 100)
(command "._CHANGE" ss "" "Properties" "LType" "ByBlock" "")
(setvar "cmdecho" 1)
);progn
);if
(princ)
);defun 