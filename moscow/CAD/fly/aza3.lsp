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



  (setq break_list break_back)
  (setq pt3_list pt3_back)

  (command "_.trim" (nth 0 break_list) ""  (nth 0 pt3_list) "")
;;; 2

  (setq break_list (cdr break_list))
  (setq pt3_list (cdr pt3_list))


  (while (> (length pt3_list) 0)
  (setq ent_last (entlast))
  (command "_.trim" (nth 0 break_list) ""  (nth 0 pt3_list) "")


    (setq sel_set (get_from_last ent_last))
  (ssadd ent_last sel_set)

  (c:pj_4)



  (setq break_list (cdr break_list))
  (setq pt3_list (cdr pt3_list))

  )