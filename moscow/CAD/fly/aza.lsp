; (setq vla_curve (vlax-ename->vla-object ent_curve))

; (setq  pt3_list '())
 ;(setq break_list (list pl1 pl2 pl3 pl4 pl5))

; (while (> (length break_list) 0)
; (alert "aza")
; (setq temp_line (vlax-ename->vla-object (car break_list)))

; (setq intersect_probe (vlax-invoke vla_curve 'IntersectWith temp_line acextendnone))

; (setq pt1 (list (nth 0 intersect_probe) (nth 1 intersect_probe) (nth 2 intersect_probe)))
; (setq pt2 (list (nth 3 intersect_probe) (nth 4 intersect_probe) (nth 5 intersect_probe)))

; (setq length_1 (vlax-curve-getDistAtPoint vla_curve pt1))
; (setq length_2 (vlax-curve-getDistAtPoint vla_curve pt2))


; (setq diff_length (abs (- length_1 length_2)))
; (setq full_length (vlax-curve-getDistAtParam vla_curve (vlax-curve-getEndParam vla_curve )))

; (if (>= (/ full_length 2) diff_length)
; (progn
;     (alert "aaaaa")
; (setq pt3 (vlax-curve-getPointAtDist vla_curve (/(+ length_1 length_2) 2)))
; ); progn
; ); if


; (if (< (/ full_length 2) diff_length)
; (progn
;     (alert "bbbbb")
; (setq true_length length_1)
; (if (> length_1 length_2)
; (progn
; (setq true_length length_2)
; ); progn
; ); if

; (setq pt3 (vlax-curve-getPointAtDist vla_curve (- true_length 100)))
; ); progn
; ); if


; (setq break_list (cdr break_list))
; (setq pt3_list (append pt3_list (list pt3)))
; ); while




; (setq break_list (list pl1 pl2 pl3))

;  (setq pt3_back pt3_list)

;  (setq pt3_list (list  (nth 0 pt3_list) pt2 (nth 2 pt3_list)))
; (setq counter 0)

  (defun get_from_last(e / residue_set )
    (setq
     residue_set (ssadd)
    ; residue_ent '()
    )
      (while (setq e (entnext e))
        (setq
   ;       residue_ent (append residue_ent (list e))
          residue_set (ssadd e residue_set)
        )
      )
  )

(defun c:pj_4 ( / *error* sel val var )
    
    (defun *error* ( msg )
        (mapcar '(lambda ( a b ) (if b (setvar a b))) var val)
        (LM:endundo (LM:acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )

    (LM:startundo (LM:acdoc))

            (setq var '(cmdecho peditaccept)
                  val  (mapcar 'getvar var)
            )
            (mapcar '(lambda ( a b c ) (if a (setvar b c))) val var '(0 1))
            (command "_.pedit" "_m" sel_set "" "_j" "" "")

    (*error* nil)
    (princ)
)


(defun LM:ssget ( msg arg / sel )
    (princ msg)
    (setvar 'nomutt 1)
    (setq sel (vl-catch-all-apply 'ssget arg))
    (setvar 'nomutt 0)
    (if (not (vl-catch-all-error-p sel)) sel)
)

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.

(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Closes an Undo Group.

(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object

(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)
(vl-load-com) (princ)

  ; (while (> (length pt3_list) 0)
 ;(alert "111")
;;; 1
  ;(setq ent_last (entlast))
  (alert "cut")
  (command "_.trim" (nth 0 break_list) ""  (nth 0 pt3_list) "")
;;; 2

  (setq break_list (cdr break_list))
  (setq pt3_list (cdr pt3_list))


  (while (> (length pt3_list) 0)
  (alert "cut")
  (setq ent_last (entlast))
  (command "_.trim" (nth 0 break_list) ""  (nth 0 pt3_list) "")
  ;;;;добавить 
  (setq sel_set (get_from_last ent_last))
  (ssadd ent_last sel_set)

  (c:pj_4)



  (setq break_list (cdr break_list))
  (setq pt3_list (cdr pt3_list))
  )

  ; (setq pline_after_trim ;;;sel_set)

;;; FIND NEXT PLINE INTERSECT ;;;


  ;(setq after_trim_set (get_from_last ent_last))

  ;(command "_.pedit" "_m" after_trim_set "" "J" "" "")



         ;   (command "_.pedit" "_m" sel "" "_j" "" "")


   ;(alert "222")
  ;(setq break_list (cadr break_list))
  ;(setq pt3_list (cadr pt3_list))


  ; ); while

 ;  (command "_.trim" (nth 0 break_list) (nth 2 break_list) ""  (nth 0 pt3_list) (nth 2 pt3_list)"")
 ; (command "_.trim" (nth 0 break_list) ""  (nth 0 pt3_list) "")
 ; (command "_.trim" (nth 2 break_list) ""  (nth 2 pt3_list) "")


 ;(setq break_set (ssget))









