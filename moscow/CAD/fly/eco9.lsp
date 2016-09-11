;; Purge-Pline (gile) 2007/11/25
;;
;; Removes all superfluous vertex (overwritten, colinear or concentric)
;; Keeps arcs and widths
;; Keeps aligne vertices which show a width break
;; Closes pline which start point and end point are overwritten

(defun purge-pline (pl        /     regular-width       colinear  concentric
            del-cadr  pour-car  elst      closed    old-p     old-b
            old-sw    old-ew    new-d     new-p     new-b     new-sw
            new-ew    b1    b2
           )

  ;; Evaluates if the pline width is regular on 3 successive points
  (defun regular-width (p1 p2 p3 ws1 we1 ws2 we2 / delta)
    (or (= ws1 we1 ws2 we2)
    (and (= we1 ws2)
         (/= 0 (setq delta (- we2 ws1)))
         (equal (/ (- (vlax-curve-getDistAtPoint pl (trans p2 pl 0))
              (vlax-curve-getDistAtPoint pl (trans p1 pl 0))
               )
               (- (vlax-curve-getDistAtPoint pl (trans p3 pl 0))
              (vlax-curve-getDistAtPoint pl (trans p1 pl 0))
               )
            )
            (/ (- we1 (- we2 delta)) delta)
            1e-9
         )
    )
    )
  )

  ;; Evaluates if 3 successive vertices are aligned
  (defun colinear (p1 p2 p3 b1 b2)
    (and (zerop b1)
     (zerop b2)
     (null (inters p1 p2 p1 p3)
     )
    )
  )

  ;; Evaluates if 3 sucessive vertices have the same center
  (defun concentric (p1 p2 p3 b1 b2 / bd1 bd2)
    (if
      (and (/= 0.0 b1)
       (/= 0.0 b2)
       (equal
         (caddr (setq bd1 (BulgeData b1 p1 p2)))
         (caddr (setq bd2 (BulgeData b2 p2 p3)))
         1e-9
       )
      )
       (tan (/ (+ (car bd1) (car bd2)) 4.0))
    )
  )

  ;; Removes the second item of the list
  (defun del-cadr (lst)
    (set lst (cons (car (eval lst)) (cddr (eval lst))))
  )

  ;; Pours the first item of a list to another one
  (defun pour-car (from to)
    (set to (cons (car (eval from)) (eval to)))
    (set from (cdr (eval from)))
  )


  (setq elst (entget pl))
  (and (= 1 (logand 1 (cdr (assoc 70 elst)))) (setq closed T))
  (mapcar (function (lambda (x)
              (cond
            ((= (car x) 10) (setq old-p (cons x old-p)))
            ((= (car x) 40) (setq old-sw (cons x old-sw)))
            ((= (car x) 41) (setq old-ew (cons x old-ew)))
            ((= (car x) 42) (setq old-b (cons x old-b)))
            (T (setq new-d (cons x new-d)))
              )
            )
      )
      elst
  )
  (mapcar (function (lambda (l)
              (set l (reverse (eval l)))
            )
      )
      '(old-p old-sw old-ew old-b new-d)
  )
  (and closed (setq old-p (append old-p (list (car old-p)))))
  (and (equal (cdar old-p) (cdr (last old-p)) 1e-9)
       (setq closed T
         new-d  (subst (cons 70 (Boole 7 (cdr (assoc 70 new-d)) 1))
               (assoc 70 new-d)
               new-d
            )
       )
  )
  (while (cddr old-p)
    (if (regular-width
      (cdar old-p)
      (cdadr old-p)
      (cdaddr old-p)
      (cdar old-sw)
      (cdar old-ew)
      (cdadr old-sw)
      (cdadr old-ew)
    )
      (cond
    ((colinear (cdar old-p)
           (cdadr old-p)
           (cdaddr old-p)
           (cdar old-b)
           (cdadr old-b)
     )
     (mapcar 'del-cadr '(old-p old-sw old-ew old-b))
    )
    ((setq bu (concentric
            (cdar old-p)
            (cdadr old-p)
            (cdaddr old-p)
            (cdar old-b)
            (cdadr old-b)
          )
     )
     (setq old-b (cons (cons 42 bu) (cddr old-b)))
     (mapcar 'del-cadr '(old-p old-sw old-ew))
    )
    (T
     (mapcar 'pour-car
         '(old-p old-sw old-ew old-b)
         '(new-p new-sw new-ew new-b)
     )
    )
      )
      (mapcar 'pour-car
          '(old-p old-sw old-ew old-b)
          '(new-p new-sw new-ew new-b)
      )
    )
  )
  (if closed
    (setq new-p (reverse (cons (car old-p) new-p)))
    (setq new-p (append (reverse new-p) old-p))
  )
  (mapcar
    (function
      (lambda (new old)
    (set new (append (reverse (eval new)) (eval old)))
      )
    )
    '(new-sw new-ew new-b)
    '(old-sw old-ew old-b)
  )
  (if (and closed
       (regular-width
         (cdr (last new-p))
         (cdar new-p)
         (cdadr new-p)
         (cdr (last new-sw))
         (cdr (last new-ew))
         (cdar new-sw)
         (cdar new-ew)
       )
      )
    (cond
      ((colinear (cdr (last new-p))
         (cdar new-p)
         (cdadr new-p)
         (cdr (last new-b))
         (cdar new-b)
       )
       (mapcar (function (lambda (l)
               (set l (cdr (eval l)))
             )
           )
           '(new-p new-sw new-ew new-b)
       )
      )
      ((setq bu (concentric
          (cdr (last new-p))
          (cdar new-p)
          (cdadr new-p)
          (cdr (last new-b))
          (cdar new-b)
        )
       )
       (setq new-b (cdr (reverse (cons (cons 42 bu) (cdr (reverse new-b))))))
       (mapcar (function (lambda (l)
               (set l (cdr (eval l)))
             )
           )
           '(new-p new-sw new-ew)
       )
      )
    )
  )
  (entmod
    (append new-d
        (apply 'append
           (apply 'mapcar
              (cons 'list (list new-p new-sw new-ew new-b))
           )
        )
    )
  )
)

;; BulgeData Retourne les données d'un polyarc (angle rayon centre)

(defun BulgeData (bu p1 p2 / ang rad cen)
  (setq ang (* 2 (atan bu))
    rad (/ (distance p1 p2)
           (* 2 (sin ang))
        )
    cen (polar p1
           (+ (angle p1 p2) (- (/ pi 2) ang))
           rad
        )
  )
  (list (* ang 2.0) rad cen)
)

;; TAN Retourne la tangente de l'angle

(defun tan (ang)
  (/ (sin ang) (cos ang))
)

;; SPL Calling function

(defun c:spl (/ ss n pl)
  (vl-load-com)
  (or *acad* (setq *acad* (vlax-get-acad-object)))
  (or *acdoc* (setq *acdoc* (vla-get-ActiveDocument *acad*)))
  (princ
    "\nSelect les polylines to be treated or <All>: "
  )
  (or
    (setq ss (ssget '((0 . "LWPOLYLINE"))))
    (setq ss (ssget "_X" '((0 . "LWPOLYLINE"))))
  )
  (if
    ss
     (progn
       (vla-StartUndoMark *acdoc*)
       (setq n -1)
       (while (setq pl (ssname ss (setq n (1+ n))))
     (purge-pline pl)
       )
       (princ (strcat "\n\t" (itoa n) " treated polyline(s)."))
       (vla-EndUndoMark *acdoc*)
     )
     (princ "\nNone selected polyline.")
  )
  (princ)
)

(princ
  "\nSimp-Pline loaded, type SPL to launch the function."
)
(princ)