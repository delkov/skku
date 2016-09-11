(defun c:LPer (/ *error* ent pt)
  ;; Draw line perpendicular from selected curve
  ;; Required Subroutines: AT:GetSel
  ;; Alan J. Thompson, 09.29.09 / 12.20.10

  (vl-load-com)

  (defun *error* (msg)
    (and ent (redraw ent 4))
    (if (and msg (not (wcmatch (strcase msg) "*BREAK*,*CANCEL*,*QUIT*,")))
      (princ (strcat "\nError: " msg))
    )
  )

  (if (setq ent
             (car (AT:GetSel
                    entsel
                    "\nSelect curve: "
                    (lambda (x)
                      (not (vl-catch-all-error-p (vl-catch-all-apply 'vlax-curve-getEndParam (list (car x))))
                      )
                    )
                  )
             )
      )
    (progn
      (redraw ent 3)
      (while (setq pt (getpoint "\nSpecify point for line: "))
        (entmake
          (list '(0 . "LINE")
                (cons 10 (vlax-curve-getClosestPointToProjection ent (trans pt 1 0) '(0 0 1)))
                (cons 11 (trans pt 1 0))
          )
        )
      )
    )
  )
  (*error* nil)
  (princ)
)

(defun AT:GetSel (meth msg fnc / ent good)
  ;; meth - selection method (entsel, nentsel, nentselp)
  ;; msg - message to display (nil for default)
  ;; fnc - optional function to apply to selected object
  ;; Ex: (AT:GetSel entsel "\nSelect arc: " (lambda (x) (eq (cdr (assoc 0 (entget (car x)))) "ARC")))
  ;; Alan J. Thompson, 05.25.10
  (setvar 'errno 0)
  (while (not good)
    (setq ent (meth (cond (msg)
                          ("\nSelect object: ")
                    )
              )
    )
    (cond
      ((vl-consp ent)
       (setq good (cond ((or (not fnc) (fnc ent)) ent)
                        ((prompt "\nInvalid object!"))
                  )
       )
      )
      ((eq (type ent) 'STR) (setq good ent))
      ((setq good (eq 52 (getvar 'errno))) nil)
      ((eq 7 (getvar 'errno)) (setq good (prompt "\nMissed, try again.")))
    )
  )
)