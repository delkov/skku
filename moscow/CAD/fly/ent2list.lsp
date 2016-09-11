;;----------------=={ Entity to Point List }==----------------;;
;;                                                            ;;
;;  Returns a list of points describing or approximating the  ;;
;;  supplied entity, else nil if the entity is not supported. ;;
;;------------------------------------------------------------;;
;;  Author: Lee Mac, Copyright © 2011 - www.lee-mac.com       ;;
;;------------------------------------------------------------;;
;;  Arguments:                                                ;;
;;  ent - Entity for which to return Point List.              ;;
;;------------------------------------------------------------;;
;;  Returns:  List of Points describing/approximating entity  ;;
;;------------------------------------------------------------;;

(defun LM:Entity->PointList ( ent / der di1 di2 di3 elst fun inc lst par rad )
    (setq elst (entget ent))
    (cond
        (   (eq "POINT" (cdr (assoc 0 elst)))
            (list (cdr (assoc 10 elst)))
        )
        (   (eq "LINE" (cdr (assoc 0 elst)))
            (list (cdr (assoc 10 elst)) (cdr (assoc 11 elst)))
        )
        (   (member (cdr (assoc 0 elst)) '("CIRCLE" "ARC"))
            (setq di1 0.0
                  di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam ent))
                  inc (/ di2 (1+ (fix (* 35.0 (/ di2 (cdr (assoc 40 elst)) (+ pi pi))))))
                  fun (if (vlax-curve-isclosed ent) < <=)
            )
            (while (fun di1 di2)
                (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
                      di1 (+ di1 inc)
                )
            )
            lst
        )
        (   (or (eq (cdr (assoc 0 elst)) "LWPOLYLINE")
                (and (eq (cdr (assoc 0 elst)) "POLYLINE") (zerop (logand (cdr (assoc 70 elst)) 80)))
            )
            (setq par 0)
            (repeat (fix (1+ (vlax-curve-getendparam ent)))
                (if (setq der (vlax-curve-getsecondderiv ent par))
                    (if (equal der '(0.0 0.0 0.0) 1e-8)
                        (setq lst (cons (vlax-curve-getpointatparam ent par) lst))
                        (if (setq rad (distance '(0.0 0.0) (vlax-curve-getfirstderiv ent par))
                                  di1 (vlax-curve-getdistatparam ent par)
                                  di2 (vlax-curve-getdistatparam ent (1+ par))
                            )
                            (progn
                                (setq inc (/ (- di2 di1) (1+ (fix (* 35.0 (/ (- di2 di1) rad (+ pi pi)))))))
                                (while (< di1 di2)
                                    (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
                                          di1 (+ di1 inc)
                                    )
                                )
                            )
                        )
                    )
                )
                (setq par (1+ par))
            )
            (if (or (vlax-curve-isclosed ent) (equal '(0.0 0.0 0.0) der 1e-8))
                lst
                (cons (vlax-curve-getendpoint ent) lst)
            )
        )
        (   (eq (cdr (assoc 0 elst)) "ELLIPSE")
            (setq di1 (vlax-curve-getdistatparam ent (vlax-curve-getstartparam ent))
                  di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam   ent))
                  di3 (* di2 (/ (+ pi pi) (abs (- (vlax-curve-getendparam ent) (vlax-curve-getstartparam ent)))))
            )
            (while (< di1 di2)
                (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
                      der (distance '(0.0 0.0) (vlax-curve-getsecondderiv ent (vlax-curve-getparamatdist ent di1)))
                      di1 (+ di1 (/ di3 (1+ (fix (/ 35.0 (/ di3 der (+ pi pi)))))))
                )
            )
            (if (vlax-curve-isclosed ent)
                lst
                (cons (vlax-curve-getendpoint ent) lst)
            )
        )
        (   (eq (cdr (assoc 0 elst)) "SPLINE")
            (setq di1 (vlax-curve-getdistatparam ent (vlax-curve-getstartparam ent))
                  di2 (vlax-curve-getdistatparam ent (vlax-curve-getendparam   ent))
                  inc (/ di2 25.0)
            )
            (while (< di1 di2)
                (setq lst (cons (vlax-curve-getpointatdist ent di1) lst)
                      der (/ (distance '(0.0 0.0) (vlax-curve-getsecondderiv ent (vlax-curve-getparamatdist ent di1))) inc)
                      di1 (+ di1 (if (equal 0.0 der 1e-10) inc (min inc (/ 1.0 der (* 10. inc)))))
                )
            )
            (if (vlax-curve-isclosed ent)
                lst
                (cons (vlax-curve-getendpoint ent) lst)
            )
        )
    )
)




;; Test Function

(defun c:test ( / ent )
    (if (setq ent (car (entsel)))
        (foreach x (LM:Entity->PointList ent)
            (entmake (list '(0 . "POINT") (cons 10 x)))
        )
    )
    (princ)
)
(vl-load-com) (princ)