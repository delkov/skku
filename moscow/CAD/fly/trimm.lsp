; (command "_.trim" pl1 ""  pt3 "")
; (command "_.trim" pl2 ""  pt1 "")
; (command "_.trim" pl3 ""  pt2 "")


;(setq temp_curve (vlax-ename->vla-object (entlast)))
;(setq curve (vlax-ename->vla-object (entlast)))

;(setq pt_list '())
(while (> (length break_list) 0)

;(setq temp_line (vlax-ename->vla-object (car break_list)))


(alert "aza")
(setq intersect_probe (vlax-invoke (vlax-ename->vla-object trace) 'IntersectWith (vlax-ename->vla-object (car break_list)) acextendnone))

(setq pt1 (list (nth 0 intersect_probe) (nth 1 intersect_probe) (nth 2 intersect_probe)))
(setq pt2 (list (nth 3 intersect_probe) (nth 4 intersect_probe) (nth 5 intersect_probe)))

;(setq pt_list (append pt_list (list p)))

(setq length_1 (vlax-curve-getDistAtPoint (vlax-ename->vla-object trace) pt1))
(setq length_2 (vlax-curve-getDistAtPoint (vlax-ename->vla-object trace) pt2))


(setq diff_length (abs (- length_1 length_2)))
(setq full_length (vlax-curve-getDistAtParam (vlax-ename->vla-object trace) (vlax-curve-getEndParam (vlax-ename->vla-object trace) )))

(if (>= (/ full_length 2) diff_length)
(progn
    (alert "aaaaa")

(setq pt3 (vlax-curve-getPointAtDist temp_curve (/(+ length_1 length_2) 2)))

); progn
); if


(if (< (/ full_length 2) diff_length)
(progn
    (alert "bbbbb")
(setq true_length length_1)
(if (> length_1 length_2)
(progn

(setq true_length length_2)
); progn
); if

(setq pt3 (vlax-curve-getPointAtDist temp_curve (- true_length 100)))

); progn
); if

    (alert "ccccc")

(command "_.trim" (vlax-vla-object->ename temp_line) ""  pt3 "")
(setq break_list (cdr break_list))

;)

; (while (> (length break_list) 0)

 ;(command "_.trim" (vlax-vla-object->ename temp_line) ""  pt3 "")

; (command "_.trim" (car break_list))




; (setq break_list (cdr break_list))
 )