;(command "_.LINE" "0,0" "210,0" "210,297" "0,297" "_C")
(defun AddRegion ()
  (vl-load-com)
  (setq acadapp (vlax-get-Acad-Object)
acaddoc (vla-get-ActiveDocument acadapp)
mspace (vla-get-ModelSpace acaddoc)
  )
  (setq arcObj (vla-AddArc
   mspace
   (vlax-3d-point '(5.0 3.0 0.0))
   2.0
   0.0
   pi
        )
  )
  (setq arcClr (vla-Put-Color arcObj acYellow))
  (setq arcStrtPoint (vla-Get-StartPoint arcObj))
  (setq arcEndPoint (vla-Get-EndPoint arcObj))
  (setq lineObj (vla-AddLine mspace arcStrtPoint arcEndPoint))
  (setq lClr (vla-Put-Color lineObj acGreen))

  (setq objArray (vlax-make-safearray vlax-vbObject '(0 . 1)))
  (vlax-safearray-fill objArray (list arcObj lineObj))


  (setq regionObjList (vla-AddRegion mspace objArray))
  (setq rSA (vlax-variant-value regionObjList))
  (setq regionList (vlax-safearray->list rSA))
  (setq regionObj (car regionList))
  (setq rClr (vla-Put-Color regionObj acMagenta))


;;; Release the Objects:
  (if regionObj
    (if (null (vlax-object-released-p regionObj))
      (progn (vlax-release-object regionObj) (setq regionObj nil))
    )
  )
  (if arcObj
    (if (null (vlax-object-released-p arcObj))
      (progn (vlax-release-object arcObj) (setq arcObj nil))
    )
  )
  (if lineObj
    (if (null (vlax-object-released-p lineObj))
      (progn (vlax-release-object lineObj) (setq lineObj nil))
    )
  )
  (if mspace
    (if (null (vlax-object-released-p mspace))
      (progn (vlax-release-object mspace) (setq mspace nil))
    )
  )
  (if acaddoc
    (if (null (vlax-object-released-p acaddoc))
      (progn (vlax-release-object acaddoc) (setq acaddoc nil))
    )
  )
  (if acadapp
    (if (null (vlax-object-released-p acadapp))
      (progn (vlax-release-object acadapp) (setq acadapp nil))
    )
  )
  (princ)
)
(princ "\nAddRegion loaded. Enter (addregion) to run.")
(princ)