;--------------------------------------------------------- mtrim:entnext ------
;;;(mtrim:entnext (car (entsel)))
(defun mtrim:entnext (ent)
  (setq ent (entnext ent))
  (cond ((not ent))
        ((member (cdr (assoc 0 (entget ent)))'("VERTEX" "ATTRIB" "SEQEND"))
           (while (/= (cdr (assoc 0 (entget ent))) "SEQEND")(setq ent (entnext ent)))
           (setq ent (entnext ent))
        )
  )
  ent
)
;--------------------------------------------------------- mtrim:EntLst -------
; subfunction to make a list of entities from a selection
(defun mtrim:EntLst (ss)
  (vl-remove-if-not (function (lambda (x)(= (type x) 'ENAME)))(mapcar 'cadr (ssnamex ss)))
)
;--------------------------------------------------------- mtrim:ltPts  -------
; subfunction to make points from intersection lines
(defun mtrim:ltPts  (lt / pts)
  (while (caddr lt)(setq pts (append (list (list (car lt)(cadr lt)(caddr lt))) pts) lt (cdddr lt)))
  pts
)
;--------------------------------------------------------- mtrim:seqPts -------
; sort the points sequential
(defun mtrim:seqPts ( ent pts)
  (mapcar 'cdr (vl-sort (mapcar (function (lambda (pt)
    (cons (vlax-curve-getDistAtPoint ent pt) pt)
  )) pts) '(lambda(a1 a2)(< (car a1) (car a2)))))
)
;--------------------------------------------------------- mtrim:closestEnt ---
; look for witch entity is closest to point pt
(defun mtrim:closestEnt (pt EntLst / pts)
  (setq pts (vl-sort (mapcar (function (lambda (ent)
    (cons (distance (vlax-curve-getclosestpointto ent pt) pt) ent))) EntLst)
    '(lambda(a1 a2)(< (car a1)(car a2)))))
  
  (if (or (= (caar pts) 0.0)(equal (caar pts) 0.0 1e-6))(cdar pts))
) 
;--------------------------------------------------------- mtrim:Pts ----------
;;; make a list of seuential points from a selection 
(defun mtrim:Pts (ent1 ss)
  (mtrim:seqPts ent1 (apply 'append (mapcar (function (lambda (ent2 / p )
    (setq p (vl-catch-all-apply 'vla-IntersectWith (list (vlax-ename->vla-object ent1)
      (vlax-ename->vla-object ent2) acExtendOtherEntity)))
    (if (not (vl-catch-all-error-p p))
      (if (< (vlax-safearray-get-u-bound (vlax-variant-value p) 1) 0)
        nil
        (mtrim:ltPts (vlax-safearray->list (vlax-variant-value p)))
      )
    )
  )) (mtrim:EntLst ss))))
)
;--------------------------------------------------------- mtrim:trim ---------
;;;
(defun mtrim:trim (ss tt / trLst)
  (command "_.trim" ss "")
  (mapcar (function (lambda (ent / pts EntL p sp ep)
    (setq trLst (list ent) pts (mtrim:Pts ent ss))
    (while (cadr pts)
      (setq EntL (entlast))
      (if (and
        (setq ent (mtrim:closestEnt (car pts) trLst))
        (setq sp (vlax-curve-getDistAtPoint ent (car pts)))
        (setq ep (vlax-curve-getDistAtPoint ent (cadr pts)))
        (setq p (vlax-curve-getPointAtDist ent (/ (+ sp ep) 2.0))))
          (command (list ent (trans p 0 1)))
      )
      (setq pts (cddr pts))
      (if (mtrim:entnext EntL)
        (progn
          (if (not (entupd ent))(setq trLst (vl-remove ent trLst)))
          (while (and EntL (setq EntL (mtrim:entnext EntL)))
            (if (not (ssmemb EntL tt))(setq tt (ssadd EntL tt)))
            (setq trLst (append trLst (list EntL)))
          )
        )
      )
    )
  ))(mtrim:EntLst tt))
  (command "")
)
;--------------------------------------------------------- c:mtrim ------------
(defun c:mtrim (/ ss tt p EntL)
  (setvar "cmdecho" 1)
  (prompt "select cutting edge(s)...")
  (if (setq ss (ssget '((0 . "3DPOLY,ARC,CIRCLE,ELLIPSE,*LINE"))))
    (progn
      (prompt "select object(s) to trim...")
      (if (setq tt (ssget '((0 . "3DPOLY,ARC,CIRCLE,ELLIPSE,*LINE"))))(mtrim:trim ss tt))
    )
  )
  (prin1)
)

