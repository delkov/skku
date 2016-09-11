; GLOBAL
(setq end_flag 1)
(setq break_set (ssadd))
(setq merge_vpp 1)
(setq merge_vpp_points (ssadd))
(setq total_merge_vpp_list nil)
(setq temp_number 0)
(setq merge_set nil)
(setq total_ent_list nil)

;;;;; DEFINE FUNCTION ;;;;;;;;
(defun c:sperr(file_list color_list/ spSet ptLst Dr Ang sCurve oldEcho
          oldOsm dataLst fPt radius Ans)

;;;;; BEGIN_ACTIVE_X ;;;;;;;;;
(defun begin_activex ( / )
  (vl-load-com)
  (setq acad_application (vlax-get-acad-object))
  (setq active_document (vla-get-ActiveDocument acad_application))
  (setq model_space (vla-get-ModelSpace active_document))
  (setq paper_space (vla-get-PaperSpace active_document))
);  end of begin
;;;;; HIDE ERROR FUNCTION ;;;;;;;;;
  (defun *error* (msg)
   (setvar "CMDECHO" oldEcho)
   (setvar "OSMODE" oldOsm)
  (princ)
  ); end of *error*

;;;;; DRAWING SETING ;;;;;;;;;
  (setq
    oldEcho(getvar "CMDECHO")
    oldOsm(getvar "OSMODE")
     ;file_list (vl-directory-files "c:\\Users\\delko_000\\Desktop\\fly\\data" "*" 1)
     ;file_name_list (mapcar 'vl-filename-base file_list)
     ;color_list  '(10 100 70 50 40 30 20)
     scale_list '(15 40 30 25 20 15 10 10 10 10 10)
  ); end setq

  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)

(princ "\n<<< Select spline >>>")
  (if (setq spSet (ssget  '((0 . "SPLINE"))))    
    (progn

;;;;; MERGE VPP ? ;;;;
      (if (= merge_vpp 1)
        (progn
(princ "\n<<< Select spline for merge >>>")
          (if (setq merge_set (ssget  '((0 . "SPLINE"))))
          (progn   
            )
          )
          )
        )
;;; END MERGE VPP ;;;
      
;;;;;;;;; FILE CYCLE ::::::::::::::::
    (foreach temp_name file_list

      (setq
        total_sel (ssadd) 
        count_spline (sslength spSet)
        temp_number 0
        merge_vpp_points (ssadd)
      ); end setq  

;;;;;;;;; SPLINE CYCLE ;;;;;;;;;;;;;;;;;
(setq break_set (ssadd))

      (repeat count_spline
      (setq 
        sCurve(vlax-ename->vla-object(ssname spSet temp_number))
        dataLst '()
        end_point nil
        start_point nil
        temp_number (+ temp_number 1)
      ); end setq

      (setq
        radius_length '()
        counter_test 1
        step 10
        temp_length -10
        point_list (list )
        spline_length (vlax-curve-getDistAtPoint sCurve (vlax-curve-getEndPoint sCurve))
        true_count (+ (/ spline_length step) 1)
        ok_point 1
      ); end setq

      (setq
        ff (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" temp_name ".txt") "r")
        ;trash_line (read-line ff)
      ); end setq

;;;;;;;;;;;;;; DRAW LINES ;;;;;;;;;;;;;;;;
      (while (and (> ok_point 0) (<= counter_test true_count))
        (setq probe_line (read-line ff))


        (if (= probe_line ())
          (setq ok_point 0)
        )

        (if (/= probe_line ())
          (progn
            (setq temp_radius (atoi probe_line))
            (setq counter_test (+ counter_test 1))
            (setq temp_length (+ temp_length step))
            (setq point_list (append point_list (list  (vlax-curve-getPointAtDist sCurve temp_length)))) 
            (setq radius_length (append radius_length (list temp_radius)))
          ); end progn
        ); end if
      ); end while



      (foreach pt point_list
        (setq Dr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve pt)))
        (setq
          Ang (- pi(atan(/(car Dr)(cadr Dr))))
          dataLst (append dataLst (list(list(trans pt 0 1) Ang))); 
        ); setq
      ); end point cycle

      (setq counter 0)  

      (while dataLst
        (setq 
          fPt (caar dataLst)
          Ang (cadar dataLst)
          radius(car radius_length)
        ); end setq

 ;;;;;;;;;; MAKE TRELISTICK (counter = 0) ;;;;;;;;;;;
        (if (= counter 0)  
          (progn
            (setq double_der (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt)));
            (setq base_anglee_point fPt)
            

            (if (> (cadr double_der) 0)
              (progn
                (command "_.line" fPt 
                (trans(polar fPt  (+ Ang 0.78)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt   (+ Ang 1.56)   radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt  (+ Ang 2.34)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq end_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)
              ); progn   
            ); if

            (if (<= (cadr double_der) 0)
              (progn
                (command "_.line" fPt 
                (trans(polar fPt  (- Ang 2.34)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt   (- Ang 1.56)   radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt  (- Ang 0.78)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq end_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)
              ); progn
            ) ; if
          ); progn
        ); if
 

; ;;;;;;;;;trelistnik;;;;;;;;
;                   (setq start_point (append start_point (list start_angle_point)))
;                   (setq end_point (append end_point (list end_angle_point)))
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;; SPLIT SPLINE ;;;;;;;;;;;;;;
          (if radius
            (progn
              (if (< (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
                (progn
                  ;(alert "split1")
                  (command "_.pline"  (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius)0 1) "")
                  (setq temp_line (vlax-ename->vla-object (entlast)))
                  (setq end_point (append end_point (list (vlax-curve-getEndPoint temp_line))))  
                  (setq start_point (append start_point (list (vlax-curve-getStartPoint temp_line))))
                  (entdel (entlast))
                  ;(entdel (entlast))
                )
              ); end if

              (if (>= (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
                (progn
                 ; (alert "split2")
                  (command "_.pline"  (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius) 0 1) "")
                  (setq temp_line (vlax-ename->vla-object (entlast)))
                  (setq end_point (append end_point (list (vlax-curve-getStartPoint temp_line))))  
                  (setq start_point (append start_point (list (vlax-curve-getEndPoint temp_line))))
                  (entdel (entlast))
                  ;(entdel (entlast))
                ); progn
              ); end if
            ); progn
          ); if


          (setq 
            dataLst (cdr dataLst)
            radius_length (cdr radius_length)
          ); setq

;;;;; BREAK at the END of the curve FOR #2 ;;;;;;;

(if (and (= (length dataLst) 1) (> ok_point 0))
  (progn
         (command "_.pline"  (trans(polar fPt Ang (* radius 1.1)) 0 1) (trans(polar fPt (- Ang Pi) (* radius 1.1)) 0 1) "")
         (ssadd (entlast) break_set)  ;;;HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEe
         (alert "add to set")
         (setq total_ent_list (append total_ent_list (list (entlast))))

  )
);


          (if (not dataLst)
            (princ)
          ); if
          (setq counter (+ counter 1))


        ); end while datalist


       (if (= ok_point 1)
          (setq point_list_for_sort point_list)
          (setq point_list (append point_list (list (vlax-curve-getEndPoint sCurve))))
           
       ); if

        (close ff)
    
        (setq ff nil)
        (setq temp_spline nil)
        (setq intersect_probe nil)
        (setq intersect_probe_again nil)
        (setq intersect_probe_again_2 nil)


;; TRELISTNIK zasovavaem k rectanglam ;;;;
(setq base_start_angle (list (car start_point)))
(setq base_end_angle (list (car end_point)))

  (setq temp_angle_spline  (append base_start_angle  end_angle_point med_angle_point start_angle_point base_end_angle base_start_angle))

  (command "._PLINE")
  (apply 'command temp_angle_spline);
  (command "")
  
  (ssadd (entlast) total_sel)
;;;;;;;;;;; END TRELISTNIK ;;;;;;;;;;;;;;;;


;;;;;;;;; CREATE RECTANGLE'S POINT FOR MERGE VPP ;;;;;;;;;;;;;;;;
 (if (ssmemb (ssname spSet (- temp_number 1)) merge_set)
   (progn
    (command ".point" (car end_point))
     (ssadd (entlast) merge_vpp_points)
    (setq total_merge_vpp_list (append total_merge_vpp_list (list (entlast))))
   ; (setq total_ent_list (append total_ent_list (list (entlast))))
    (command "point" (car start_point))
     (ssadd (entlast) merge_vpp_points)
         (setq total_merge_vpp_list (append total_merge_vpp_list (list (entlast))))
  ;  (setq total_ent_list (append total_ent_list (list (entlast))))
   ); progn
 ); if
;;;;;;;;;;;;; END CREATE RECTANGLE FOR MERGE VPP ;;;;;;;;

;;; DRAW RECTANGLES ;;;
        (repeat  (- (length start_point) 1) 
        (setq temp_spline (append (list (car start_point) (cadr start_point) (cadr end_point) (car end_point) (car start_point))))

  (command "._PLINE")
  (apply 'command temp_spline);
  (command "")
  ;(alert "first done")
        (setq temp_spline_vla (vlax-ename->vla-object (entlast)))
        (setq intersect_probe (vlax-invoke temp_spline_vla 'IntersectWith temp_spline_vla acextendnone))

        (if (> (length intersect_probe) 12)

               (progn
               (entdel (entlast))
               (setq temp_spline_shit (append (list (car start_point) (cadr start_point) (car end_point) (cadr end_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit);
               (command "" )
               )
        )
        (setq temp_spline_shit (vlax-ename->vla-object (entlast)))
        (setq intersect_probe_again (vlax-invoke temp_spline_shit 'IntersectWith temp_spline_shit acExtendNone))

         (if (> (length intersect_probe_again) 12)
               (progn
               (entdel (entlast));
               (setq temp_spline_shit_again (append (list (car start_point) (car end_point) (cadr end_point) (cadr start_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit_again);
               (command ""  )
         )
         )
        
        (setq temp_spline_shit_2 (vlax-ename->vla-object (entlast)))
        (setq intersect_probe_again_2 (vlax-invoke temp_spline_shit_2 'IntersectWith temp_spline_shit_2 acExtendNone))

         (if (> (length intersect_probe_again_2) 12)
               (progn
               (entdel (entlast));
               (setq temp_spline_shit_again_2 (append (list (car start_point) (cadr end_point) (car end_point) (cadr start_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit_again);
               (command ""  )
         )
         )

        (ssadd (entlast) total_sel)
        (setq start_point (cdr start_point))
        (setq end_point (cdr end_point))

        ); repeat
;; END DRAW RECTANGLES ;;;

      ); END SPLINE CYCLE!!!


;;;;;;;;;;;;; MERGE VPP ;;;;;;;

(defun LM:ConvexHull ( lst / ch p0 )
    (cond
        (   (< (length lst) 4) lst)
        (   (setq p0 (car lst))
            (foreach p1 (cdr lst)
                (if (or (< (cadr p1) (cadr p0))
                        (and (equal (cadr p1) (cadr p0) 1e-8) (< (car p1) (car p0)))
                    )
                    (setq p0 p1)
                )
            )
            (setq lst
                (vl-sort lst
                    (function
                        (lambda ( a b / c d )
                            (if (equal (setq c (angle p0 a)) (setq d (angle p0 b)) 1e-8)
                                (< (distance p0 a) (distance p0 b))
                                (< c d)
                            )
                        )
                    )
                )
            )
            (setq ch (list (caddr lst) (cadr lst) (car lst)))
            (foreach pt (cdddr lst)
                (setq ch (cons pt ch))
                (while (and (caddr ch) (LM:Clockwise-p (caddr ch) (cadr ch) pt))
                    (setq ch (cons pt (cddr ch)))
                )
            )
            ch
        )
    )
)

;; Clockwise-p  -  Lee Mac
;; Returns T if p1,p2,p3 are clockwise oriented or collinear
                 
(defun LM:Clockwise-p ( p1 p2 p3 )
    (<  (-  (* (- (car  p2) (car  p1)) (- (cadr p3) (cadr p1)))
            (* (- (cadr p2) (cadr p1)) (- (car  p3) (car  p1)))
        )
        1e-8
    )
)


            (repeat (setq i (sslength merge_vpp_points))
                (setq l (cons (cdr (assoc 10 (entget (ssname merge_vpp_points (setq i (1- i)))))) l))
            )
            (setq l (LM:ConvexHull l))
            (entmakex
                (append
                    (list
                       '(000 . "LWPOLYLINE")
                       '(100 . "AcDbEntity")
                       '(100 . "AcDbPolyline")
                        (cons 90 (length l))
                       '(070 . 1)
                    )
                    (mapcar '(lambda ( x ) (cons 10 x)) l)
                )
            )

        (ssadd (entlast) total_sel)
      ;  (setq merge_vpp_points (ssadd))
(setq l nil)

;;;;;;;;; UNION AREAS ;;;;;;;;;;;;

(setq 
  areas nil
  ss nil
  el nil
)
(defun c:mp( / )
  
  (defun getfromlast(e / s)
    (setq
     s (ssadd)
    )
      (while (setq e (entnext e))
        (setq
          s (ssadd e s)
        )
      )
  )


   (setq ss total_sel)
   (setq el (entlast))
  
  (command ".region" ss "")  
  (command ".union" (getfromlast el) "")

  (setq el (entlast))
  (command ".explode" (entlast) )  
  (setq el_2 (entlast))
;(alert "aaaa")

(setq areas (getfromlast el))
(setq explode_counter 0)



(if (= (cdr (cadr (entget (ssname areas 1)))) "REGION")
  (progn

(setq total_fit (ssadd))
(repeat (sslength areas)
(setq el (entlast))
(command ".explode" (ssname areas explode_counter))
(command ".pedit" (entlast) "y" "j" (getfromlast el) "" "")
(setq total_fit (ssadd (entlast) total_fit))  

      (setq
        str   temp_name
        file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
        fn    (open file "w")
      ;  exprt (getvar 'expert)
      ); setq
      (write-line (strcat "*" str ", ---" str "---") fn)
      (write-line (strcat "A,.5,-0.5,[\""str"\",STANDARD,S=0.2,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
      (close fn)
        ;(setvar 'expert 5)

      (if (= (tblsearch "LTYPE" temp_name) nil)
        (command ".-linetype" "load" "*" file "")
      ); end if
          ;(setvar 'expert exprt)
      (vl-file-delete file)
      (command "._CHANGE" (entlast) "" "Properties" "LType" temp_name "")
      (command "._CHANGE" (entlast) "" "Properties" "LtScale" (car scale_list) "")
      (command "._CHANGE" (entlast) "" "Properties" "Color" (car color_list) "")



(setq explode_counter (+ explode_counter 1))

 ;(alert "explode_counter")

); repeat



(setq fit_counter 0)
(repeat (sslength total_fit)
 (command ".pedit" (ssname total_fit fit_counter) "Fit" "")
 (setq fit_counter (+ fit_counter 1))
); repeat fit


);progn
);if

    ;(alert "one")

(if (= (cdr (cadr (entget (ssname areas 1)))) "LINE")
  (progn
    (alert "one")
    ;(command ".pedit" (entlast) "y" "j" (getfromlast el) "" "")
    (command "_.pedit" "_m" (getfromlast el) "" "Y" "J" "" "")



 (setq
        str   temp_name
        file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
        fn    (open file "w")

      ); setq
      (write-line (strcat "*" str ", ---" str "---") fn)

            (write-line (strcat "A,1.5,-0.05,[\""str"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
      (close fn)
        ;(setvar 'expert 5)

      (if (= (tblsearch "LTYPE" temp_name) nil)
        (command ".-linetype" "load" "*" file "")
      ); end if

      (vl-file-delete file)


    (setq closed_pline (getfromlast el_2))
    (setq closed_pline_counter 0)

    (repeat (sslength closed_pline)

    (command ".pedit" (ssname closed_pline closed_pline_counter) "Spline" "")
    (command ".pedit" (ssname closed_pline closed_pline_counter) "L" "On" "")

     
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "Properties" "LType" temp_name "")
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "Properties" "LtScale" (car scale_list) "")
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "Properties" "Color" (car color_list) "")
      
      (setq closed_pline_counter (+ closed_pline_counter 1))
    ); repeat

    ); progn 
  ); if



      (if (/= (cdr color_list) nil)
        (setq color_list (cdr color_list))
      ); end if

      (if (/= (cdr scale_list) nil)
        (setq scale_list (cdr scale_list))
      ); end if




  (princ)
)  ;;;; end MP


(c:mp) 
    (setq total_ent_list (append total_ent_list (list (entlast))))

      ); END FILE CYCLE!!!



; (setq merge_counter 0)
; (repeat (sslength merge_vpp_points)
;  (entdel (ssname merge_vpp_points merge_counter))
;  (setq merge_counter (+ merge_counter 1))
; (alert "aaa")
; )
(setq total_merge_vpp_list (mapcar 'vlax-ename->vla-object total_merge_vpp_list))
(mapcar 'vla-Delete total_merge_vpp_list)


      ); end progn --- empty select
    ); end if --- empty select

;;;;;;;;; RESET DEFAULT SETTING;;;;;

    (mapcar 'entdel merge_vpp_points)
    (setvar "CMDECHO" oldEcho)
    (setvar "OSMODE" oldOsm)
   ; (setvar "CECOLOR" oldColor)
    ;(setvar "CELTSCALE" oldCeltscale)
  (princ)
  ); end of c:sper
