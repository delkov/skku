
(defun VxRegionToBounary (Ent / CurObj CurSet ObjArr)
(vl-load-com)
(setq CurSet (ssadd)
CurObj (vlax-ename->vla-object Ent)
ObjArr (vlax-safearray->list
(vlax-variant-value
(vla-Explode CurObj)
)
)
)
(foreach memb ObjArr
(setq CurSet (ssadd (vlax-vla-object->ename memb) CurSet))
)
(vla-delete CurObj) ;if the region should remain, remove this line
(command "_.PEDIT" (ssname CurSet 0) "_YES" "_JOIN" CurSet "" "")
(entlast)
)