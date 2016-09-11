(defun c:t50 ( / obj )
    (if
        (and
            (setq obj (car (entsel)))
            (setq obj (vlax-ename->vla-object obj))
            (vlax-property-available-p obj 'entitytransparency t)
            (vlax-write-enabled-p obj)
        )
        (vla-put-entitytransparency obj 95)
    )
    (princ)
)
(vl-load-com) (princ)


(vl-load-com)
(defun C:Cloak (/ selset index)
(prompt "Select objects to cloak...")
(setq selset (ssget) index (sslength selset))
(repeat index (vla-put-Visible
(vlax-ename->vla-object (ssname
selset (setq index (1- index))
) )
:vlax-false
) )
(princ)
)

(defun C:DeCloak (/ selset index)
(setq selset (ssget "X" '((60 . 1))) index (sslength selset))
(repeat index (vla-put-Visible
(vlax-ename->vla-object (ssname
selset (setq index (1- index))
) )
:vlax-true
) )
(princ)
)