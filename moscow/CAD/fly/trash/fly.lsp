(defun begin_activex ( / )
  (vl-load-com)
  (setq acad_application (vlax-get-acad-object))
  (setq active_document (vla-get-ActiveDocument acad_application))
  (setq model_space (vla-get-ModelSpace active_document))
  (setq paper_space (vla-get-PaperSpace active_document))
); defun begin_activex







(defun pl:obj-filter-select-manual (sel filter / i)
  (vla-SelectOnScreen sel (vlax-safearray-fill (vlax-make-safearray
      vlax-vbInteger (setq i (cons 1 (length filter))))
      (mapcar (function car) filter))
      (vlax-safearray-fill (vlax-make-safearray vlax-vbVariant i)
      (mapcar (function cdr) filter)))
)




(setq sel (vla-get-ActiveSelectionSet(vla-get-ActiveDocument (vlax-get-acad-object))))





(via-Clear sel);

(pl:obj-filter-select-manual sel '((8 . "*")))
(pl:obj-filter-select-manual sel '((8 . "*")))
(vlax-for i sel (setq slist (cons i slist)));

;(cdr slists)






(setq obj (vla-get-ModelSpace actdoc))
(vla-AddArc obj (vlax-3D-point (getpoint)) 150 (/pi 4) (*pi 1.5))