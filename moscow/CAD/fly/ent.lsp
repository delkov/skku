
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