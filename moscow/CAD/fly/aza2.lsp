(setq vla_curve (vlax-ename->vla-object ent_curve))

(setq  pt3_list '())
 (setq break_list (list pl1 pl2 pl3 pl4))

(while (> (length break_list) 0)
(alert "aza")
(setq temp_line (vlax-ename->vla-object (car break_list)))

(setq intersect_probe (vlax-invoke vla_curve 'IntersectWith temp_line acextendnone))

(setq pt1 (list (nth 0 intersect_probe) (nth 1 intersect_probe) (nth 2 intersect_probe)))
(setq pt2 (list (nth 3 intersect_probe) (nth 4 intersect_probe) (nth 5 intersect_probe)))

(setq length_1 (vlax-curve-getDistAtPoint vla_curve pt1))
(setq length_2 (vlax-curve-getDistAtPoint vla_curve pt2))


(setq diff_length (abs (- length_1 length_2)))
(setq full_length (vlax-curve-getDistAtParam vla_curve (vlax-curve-getEndParam vla_curve )))

(if (>= (/ full_length 2) diff_length)
(progn
    (alert "aaaaa")
(setq pt3 (vlax-curve-getPointAtDist vla_curve (/(+ length_1 length_2) 2)))
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

(setq pt3 (vlax-curve-getPointAtDist vla_curve (- true_length 100)))
); progn
); if


(setq break_list (cdr break_list))
(setq pt3_list (append pt3_list (list pt3)))
); while

 (setq break_list (list pl1 pl2 pl3 pl4))