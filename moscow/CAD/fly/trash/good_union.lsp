; GLOBAL
(setq end_flag 1)
(setq break_set (ssadd))
;;;;; DEFINE FUNCTION ;;;;;;;;
(defun c:sperr(/ spSet ptLst Dr Ang sCurve oldEcho
          oldOsm dataLst fPt radius Ans)

;;;;; BEGIN_ACTIVE_X ;;;;;;;;;
(defun begin_activex ( / )
  (vl-load-com)
  (setq acad_application (vlax-get-acad-object))
  (setq active_document (vla-get-ActiveDocument acad_application))
  (setq model_space (vla-get-ModelSpace active_document))
  (setq paper_space (vla-get-PaperSpace active_document))
);  end of begin
;;;;; ERROR FUNCTION ;;;;;;;;;
  (defun *error* (msg)
  ; (setvar "CMDECHO" oldEcho)
  ; (setvar "OSMODE" oldOsm)
  (princ)
  ); end of *error*

;;;;; DRAWING SETING ;;;;;;;;;
  (setq
    oldEcho(getvar "CMDECHO")
    oldOsm(getvar "OSMODE")
    ; oldColor(getvar "CECOLOR")
  ;   oldCeltscale(getvar "CELTSCALE")
     file_list (vl-directory-files "c:\\Users\\delko_000\\Desktop\\fly\\data" "*" 1)
     file_name_list (mapcar 'vl-filename-base file_list)
     color_list  '(10 100 70 50 40 30 20)
     scale_list '(15 40 30 25 20 15 10 10 10 10 10)
  ); end setq

  ;(setvar "CELTSCALE" 100)
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)
; ;;;;;;;;;;;LEE MAC;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;-----------------------=={ Outline Objects  }==-----------------------;;
; ;;                                                                      ;;
; ;;  This program enables the user to generate one or more closed        ;;
; ;;  polylines or regions outlining all objects in a selection.          ;;
; ;;                                                                      ;;
; ;;  Following a valid selection, the program calculates the overall     ;;
; ;;  rectangular extents of all selected objects and constructs a        ;;
; ;;  temporary rectangular polyline offset outside of such extents.      ;;
; ;;                                                                      ;;
; ;;  Using a point located within the offset margin between the extents  ;;
; ;;  of the selection and temporary rectangular frame, the program then  ;;
; ;;  leverages the standard AutoCAD BOUNDARY command to construct        ;;
; ;;  polylines and/or regions surrounding all 'islands' within the       ;;
; ;;  temporary bounding frame.                                           ;;
; ;;                                                                      ;;
; ;;----------------------------------------------------------------------;;
; ;;  Author:  Lee Mac, Copyright © 2014  -  www.lee-mac.com              ;;
; ;;----------------------------------------------------------------------;;
; ;;  Version 1.0    -    2014-11-30                                      ;;
; ;;                                                                      ;;
; ;;  First release.                                                      ;;
; ;;----------------------------------------------------------------------;;


; ;; Outline Objects  -  Lee Mac
; ;; Attempts to generate a polyline outlining the selected objects.
; ;; sel - [sel] Selection Set to outline
; ;; Returns: [sel] A selection set of all objects created

; (defun LM:outline ( sel / app are box cmd dis enl ent lst obj rtn tmp )
;     (if (setq box (LM:ssboundingbox sel))
;         (progn
;             (setq app (vlax-get-acad-object)
;                   dis (/ (apply 'distance box) 20.0)
;                   lst (mapcar '(lambda ( a o ) (mapcar o a (list dis dis))) box '(- +))
;                   are (apply '* (apply 'mapcar (cons '- (reverse lst))))
;                   dis (* dis 1.5)
;                   ent
;                 (entmakex
;                     (append
;                        '(   (000 . "LWPOLYLINE")
;                             (100 . "AcDbEntity")
;                             (100 . "AcDbPolyline")
;                             (090 . 4)
;                             (070 . 1)
;                         )
;                         (mapcar '(lambda ( x ) (cons 10 (mapcar '(lambda ( y ) ((eval y) lst)) x)))
;                            '(   (caar   cadar)
;                                 (caadr  cadar)
;                                 (caadr cadadr)
;                                 (caar  cadadr)
;                             )
;                         )
;                     )
;                 )
;             )
;             (apply 'vlax-invoke
;                 (vl-list* app 'zoomwindow
;                     (mapcar '(lambda ( a o ) (mapcar o a (list dis dis 0.0))) box '(- +))
;                 )
;             )
;             (setq cmd (getvar 'cmdecho)
;                   enl (entlast)
;                   rtn (ssadd)
;             )
;             (while (setq tmp (entnext enl)) (setq enl tmp))
;             (setvar 'cmdecho 0)
;             (command
;                 "_.-boundary" "_a" "_b" "_n" sel ent "" "_i" "_y" "_o" "_p" "" "_non"
;                 (trans (mapcar '- (car box) (list (/ dis 3.0) (/ dis 3.0))) 0 1) ""
;             )
;             (while (< 0 (getvar 'cmdactive)) (command ""))
;             (entdel ent)
;             (while (setq enl (entnext enl))
;                 (if (and (vlax-property-available-p (setq obj (vlax-ename->vla-object enl)) 'area)
;                          (equal (vla-get-area obj) are 1e-4)
;                     )
;                     (entdel enl)
;                     (ssadd  enl rtn)
;                 )
;             )
;             (vla-zoomprevious app)
;             (setvar 'cmdecho cmd)
;             rtn
;         )
;     )
; )

; ;; Selection Set Bounding Box  -  Lee Mac
; ;; Returns a list of the lower-left and upper-right WCS coordinates of a
; ;; rectangular frame bounding all objects in a supplied selection set.
; ;; s - [sel] Selection set for which to return bounding box

; (defun LM:ssboundingbox ( s / a b i m n o )
;     (repeat (setq i (sslength s))
;         (if
;             (and
;                 (setq o (vlax-ename->vla-object (ssname s (setq i (1- i)))))
;                 (vlax-method-applicable-p o 'getboundingbox)
;                 (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-getboundingbox (list o 'a 'b))))
;             )
;             (setq m (cons (vlax-safearray->list a) m)
;                   n (cons (vlax-safearray->list b) n)
;             )
;         )
;     )
;     (if (and m n)
;         (mapcar '(lambda ( a b ) (apply 'mapcar (cons a b))) '(min max) (list m n))
;     )
; )

; ;; Start Undo  -  Lee Mac
; ;; Opens an Undo Group.

; (defun LM:startundo ( doc )
;     (LM:endundo doc)
;     (vla-startundomark doc)
; )

; ;; End Undo  -  Lee Mac
; ;; Closes an Undo Group.

; (defun LM:endundo ( doc )
;     (while (= 8 (logand 8 (getvar 'undoctl)))
;         (vla-endundomark doc)
;     )
; )

; ;; Active Document  -  Lee Mac
; ;; Returns the VLA Active Document Object

; (defun LM:acdoc nil
;     (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
;     (LM:acdoc)
; )

; (vl-load-com) (princ)

; ;;----------------------------------------------------------------------;;
; ;;                             End of File                              ;;
; ;;----------------------------------------------------------------------;;

; ;;;;;;;;;;LEE MAC ;;;;;;;;;;;;;;;;;
(princ "\n<<< Select Spline >>>")
  (if (setq spSet (ssget  '((0 . "SPLINE"))))    
    (progn


;;;;;;;;; FILE CYCLE ::::::::::::::::
    (foreach temp_name file_name_list
    ;  (alert "test")

      ; (setq
      ;   str   temp_name
      ;   file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
      ;   fn    (open file "w")
      ;   exprt (getvar 'expert)
      ; )

      ; (write-line (strcat "*" str ", ---" str "---") fn)
      ; (write-line (strcat "A,5,-0.05,[\""str"\",STANDARD,S=0.1,R=0.0,X=-0.0,Y=-.05]," (rtos (* -0.1 (strlen str))2 3)) fn)

      ; (close fn)
      ; (setvar 'expert 5)
      ; ;(setvar 'celtscale 1000)
      ; (command ".-linetype" "load" "*" file "")
      ; (setvar 'expert exprt)
      ; ;(setvar "CELTSCALE" 100);

      (setq
        total_sel (ssadd) ;;; NEWWW
        count_spline (sslength spSet)
        temp_number 0
      ); end setq  
     ; (setq total_region nil) 
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
        ff (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" temp_name ".txt") "r")
        trash_line (read-line ff)
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

; (if (> ok_point 0)
;   (progn
;   (setq end_flag 0)
;  ; (alert "flag")
; )

; ); if

      (foreach pt point_list

        (setq Dr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve pt)))
         ;;; xitro, 0.00001+1=1;;;                                                     (alert "ok")
          ; (if (=  (+ (cadr Dr) 1) 1)
          ;                                     (alert "not ok")
          
        ; (setq
        ;   ;Dr(vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve pt))

        ;   Ang  (/ pi 2)
        ;   dataLst(append dataLst (list(list(trans pt 0 1) Ang))); 

        ; ); end setq
        ;         ); end if


        ;   (if (/=  (+ (cadr Dr) 1) 1)
        ;                                       (alert "ok2")
              ; (if (> (cadr Dr) 0.0000000000000000000000000000000000000000000000000000000001)
              ; (progn     
                         ; (alert "test0")      
        (setq
          Ang (- pi(atan(/(car Dr)(cadr Dr))))
          dataLst (append dataLst (list(list(trans pt 0 1) Ang))); 
             ); setq
         ;      ); progn

         ; ); if

        ;      (if (< (cadr Dr) 0.00000000000000000000000000000000000000000000000000000000001)
        ;      (progn 
        ;      (alert "test")       
        ; (setq
        ;   Ang (/ pi 2)
        ;   dataLst (append dataLst (list(list(trans pt 0 1) Ang))); 
        ;      ); setq
        ;      ); progn

        ; ); if



      ); end point cycle

      (setq counter 0)  
      (while dataLst
        (setq 
          fPt (caar dataLst)
          Ang (cadar dataLst)
          radius(car radius_length)
        ); end setq

 ;;;;;;;;;; MAKE TRELISTICK (counter = 0) ;;;;;;;;;;;

                                                              ;(alert "ok")
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
 ; (setq ok_point_2 0)
 ; (if (= end_flag 0)
         (command "_.pline"  (trans(polar fPt Ang (* radius 1.1)) 0 1) (trans(polar fPt (- Ang Pi) (* radius 1.1)) 0 1) "")
         (ssadd (entlast) break_set)  ;;;HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEe
         (alert "add to set")
         ;(sslength break_set)
  ;(alert "azazaaaa")
  ;); if
  
  ; (alert "azaz")
  )
);

; (if (and (= ok_point 0) (= ok_point_2 0))
;   (progn
;       (command "_.pline"  (trans(polar fPt Ang (* radius 1.1)) 0 1) (trans(polar fPt (- Ang Pi) (* radius 1.1)) 0 1) "")
;       (alert "azaza2")
; )

; );

;;;;;;;;;;;;;;;;



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

      ;(setq test_start_point start_point)
     ; (setq test_end_point end_point)






      ;(while (/= (length test_start_point) 0)
;         (setq true_start_point_list nil)
;         (setq true_start_point '(10 10 0))

;         (setq true_end_point_list nil)
;         (setq true_start_point_list nil)

;         (setq proba_start_point start_point)
      ;(setq sort_count (- length point_list 1))
      ;(repeat sort_count

      ;(setq begin_start_length 10000000000);

      ; (setq true_start_point_list nil)
      ; (setq true_end_point_list nil)


  ;     (foreach temp_point point_list_for_sort
  ;       (if (> (length start_point) 1)
  ;         (progn
  ;           (command "_.pline" temp_point (car start_point) "")
  ;           (setq PREVIOUS_temp_length_line (vlax-ename->vla-object (entlast)))
  ;           (setq PREVIOUS_distance_temp_length (vlax-curve-getDistAtPoint PREVIOUS_temp_length_line (car start_point)))

  ;           (command "_.pline" temp_point (cadr start_point) "")
  ;           (setq NEXT_temp_length_line (vlax-ename->vla-object (entlast)))
  ;           (setq NEXT_distance_temp_length (vlax-curve-getDistAtPoint NEXT_temp_length_line (cadr start_point)))

  ;           (if (< NEXT_distance_temp_length PREVIOUS_distance_temp_length)
  ;             (progn
  ;               (alert "ahtung")
  ;             (setq temp_var (car start_point))
  ;             (subst (cadr start_point) (car start_point) start_point)
  ;             (subst temp_var (cadr start_point) start_point)
  ;             )
  ;           )

           
  ;           (setq true_start_point_list (append true_start_point_list (list (car start_point))))
  ;           (setq start_point (cdr start_point))



  ;           (command "_.pline" temp_point (car end_point) "")
  ;           (setq PREVIOUS_temp_end_length_line (vlax-ename->vla-object (entlast)))
  ;           (setq PREVIOUS_distance_temp_end_length (vlax-curve-getDistAtPoint PREVIOUS_temp_end_length_line (car end_point)))

  ;           (command "_.pline" temp_point (cadr end_point) "")
  ;           (setq NEXT_temp_end_length_line (vlax-ename->vla-object (entlast)))
  ;           (setq NEXT_distance_temp_end_length (vlax-curve-getDistAtPoint NEXT_temp_end_length_line (cadr end_point)))

  ;           (if (> NEXT_distance_temp_end_length PREVIOUS_distance_temp_end_length)
  ;             (progn
  ;             (setq temp_end_var (car end_point))
  ;             (subst (cadr end_point) (car end_point) end_point)
  ;             (subst temp_end_var (cadr end_point) end_point)
  ;             )
  ;           )

           
  ;           (setq true_end_point_list (append true_end_point_list (list (car end_point))))
  ;           (setq end_point (cdr end_point))


  ;           (vl-remove (car start_point) start_point)
  ;         )
  ;       )
  ;    ); foreach
  ; ;(alert "azaz")
  ;       (setq true_start_point_list (append true_start_point_list (list (car start_point))))
  ;       (setq true_end_point_list (append true_end_point_list (list (car end_point))))




  ;    ); repeat




        
;         ;(alert temp_length)
;        ;(setq temp_length_list (append temp_length_list (list DISTANCE_temp_length)))
;         (if (> begin_start_length DISTANCE_temp_length)
;           (progn
;           ;(alert "Azaz")
;           (setq begin_start_length DISTANCE_temp_length)
;           (setq true_start_point temp_start_point)
;           ); progn
;         ); if
;       ); foreach

;      (setq start_point (vl-remove true_start_point start_point))
      
;      (setq true_start_point_list (append true_start_point_list (list true_start_point)))
      

;     ;  (setq test_start_point (cdr test_start_point))
;       ); repeat

; (setq proba_end_point end_point)

;       (repeat (length end_point)

;       (setq begin_end_length 1000000000);
;       ;(setq begin_start_length )
;       (foreach temp_end_point end_point

;         (command "_.pline" (vlax-curve-getStartPoint sCurve) temp_end_point "")
;         (setq temp_end_length_line (vlax-ename->vla-object (entlast)))

;         (setq DISTANCE_temp_end_length (vlax-curve-getDistAtPoint temp_end_length_line temp_end_point))
;         ;(alert temp_length)
;        ;(setq temp_length_list (append temp_length_list (list DISTANCE_temp_length)))
;         (if (> begin_end_length DISTANCE_temp_end_length)
;           (progn
;           ;(alert "Azaz")
;           (setq begin_end_length DISTANCE_temp_end_length)
;           (setq true_end_point temp_end_point)
;           ); progn
;         ); if
;       ); foreach

;      (setq end_point (vl-remove true_end_point end_point))
      
;      (setq true_end_point_list (append true_end_point_list (list true_end_point)))
      

;     ;  (setq test_start_point (cdr test_start_point))
;       ); repeat








        (setq 
          ;total_sel (ssadd)
          ff nil
         ; total_point (append med_angle_point end_angle_point start_point (reverse end_point) start_angle_point med_angle_point)
         ;total_point (append end_point)
        )
      ;  (setq total_spline_region nil)
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
;(alert "trelist")

;;;;;;;;;;; END TRELISTNIK ;;;;;;;;;;;;;;;;

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
                ;     (alert "inter1")
              ; (alert "azaza");
               (entdel (entlast))
              ; (alert "was removed inter1")
               (setq temp_spline_shit (append (list (car start_point) (cadr start_point) (car end_point) (cadr end_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit);
               (command "" )

               ;(alert "test2")
        
              )
        )
        (setq temp_spline_shit (vlax-ename->vla-object (entlast)))
        (setq intersect_probe_again (vlax-invoke temp_spline_shit 'IntersectWith temp_spline_shit acExtendNone))

         (if (> (length intersect_probe_again) 12)

               (progn
                ;            (alert "inter2")
               (entdel (entlast));
              ;             (alert "was removed inter2")
               (setq temp_spline_shit_again (append (list (car start_point) (car end_point) (cadr end_point) (cadr start_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit_again);
               (command ""  )
         ; (alert "test again")
         )
         )
        
        (setq temp_spline_shit_2 (vlax-ename->vla-object (entlast)))
        (setq intersect_probe_again_2 (vlax-invoke temp_spline_shit_2 'IntersectWith temp_spline_shit_2 acExtendNone))

         (if (> (length intersect_probe_again_2) 12)

               (progn
              ;               (alert "inter3")
               (entdel (entlast));
            ;                (alert "was removed inter3")
               (setq temp_spline_shit_again_2 (append (list (car start_point) (cadr end_point) (car end_point) (cadr start_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit_again);
               (command ""  )
         ; (alert "test again")
         )
         )

        ;(command ".region" (entlast) "")

        (ssadd (entlast) total_sel)

  ;(alert "next")


        (setq start_point (cdr start_point))
        (setq end_point (cdr end_point))

        )



       ;(alert "one_spline_done")




       ; (command "._UNION")
       ; (apply 'command total_spline_region);
       ; (command "")



;;;;;;;;;;;;;;; DRAW SPLINE ;;;;;;;;;;;;;;;;;;;
      ;(setvar "CELTSCALE" 100)
      ;(command ".-linetype" "load" "*" file "")


      ; (setq total_spline_region nil)

      ; (repeat (- (length true_start_point_list) 1)

      ; (setq temp_spline (append (list (car true_start_point_list) (cadr true_start_point_list) (cadr true_end_point_list) (car true_end_point_list) (car true_start_point_list))))
      ; (entmake
      ;  (append (list '(0 . "SPLINE") '(100 . "AcDbEntity") '(100 . "AcDbSpline") '(70 . 40) '(71 . 3) (cons 74 (length temp_spline)) '(44 . 1.0e-005))
      ;    (mapcar '(lambda (x) (cons 11 x)) temp_spline)
      ;  ); append
      ; ); entmake
      

      ; (command "region" (entlast) "")

      ; (setq total_spline_region (append total_spline_region (list (entlast))))




      ; (setq true_start_point_list (cadr true_start_point_list))
      ; (setq true_end_point_list (cadr true_end_point_list))
      ; (alert "test")
      ; )

      ; (command "._UNION")
      ; (apply 'command total_spline_region);
      ; (command "")

      ); end spline cycle

;;;;;;;;; UNION AREAS ;;;;;;;;;;;;
   ;   (setvar "CELTSCALE" 10)
     ; (setq union_areas (append union_areas (entlast)))
      
      ; (LM:outline total_sel)


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

 ; (setq  ss (ssget (list (cons 0 "*POLYLINE"))))
   (setq ss total_sel)
   (setq el (entlast))
  
  (command ".region" ss "")  
  (command ".union" (getfromlast el) "")

  (setq el (entlast))
  (command ".explode" (entlast) )  




(setq areas (getfromlast el))
(setq explode_counter 0)



(if (= (cdr (cadr (entget (ssname areas 1)))) "REGION")
  (progn
    ;(alert "men2")

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
      (write-line (strcat "A,.5,-0.05,[\""str"\",STANDARD,S=0.2,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
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
 ; (command ".explode" (ssname areas explode_counter))
 (setq fit_counter (+ fit_counter 1))
); repeat fit

);progn
);if



(if (= (cdr (cadr (entget (ssname areas 1)))) "LINE")
  (progn
   ; (alert "one")
    (command ".pedit" (entlast) "y" "j" (getfromlast el) "" "")
    (command ".pedit" (entlast) "Fit" "")

      (setq
        str   temp_name
        file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
        fn    (open file "w")
      ;  exprt (getvar 'expert)
      ); setq
      (write-line (strcat "*" str ", ---" str "---") fn)
      (write-line (strcat "A,.5,-0.05,[\""str"\",STANDARD,S=0.2,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
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

      ; (if (/= (cdr color_list) nil)
      ;   (setq color_list (cdr color_list))
      ; ); end if

      ; (if (/= (cdr scale_list) nil)
      ;   (setq scale_list (cdr scale_list))
      ; ); end if
      


)
  )

      (if (/= (cdr color_list) nil)
        (setq color_list (cdr color_list))
      ); end if

      (if (/= (cdr scale_list) nil)
        (setq scale_list (cdr scale_list))
      ); end if



 ; (command ".union" (getfromlast el)  "")  

  (princ)
)  


(c:mp) 

 ; (setq total_area (entlast))
;;;;;;;; LINETYPE !!!! ;;;;;;;;;;;;;;;;
;       (setq
;         str   temp_name
;         file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
;         fn    (open file "w")
;       ;  exprt (getvar 'expert)
;       )
;       (write-line (strcat "*" str ", ---" str "---" str "---" str "---") fn)
;       ;(write-line (strcat "A,.5,-.2,[\""str"\",STANDARD,S=.1,U=0.0,X=-0.1,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)

; ; (write-line (strcat "A,12.7,-5.08,[\""str"\",STANDARD,S=0.1,U=0.0,X=-2.54,Y=-1.27],"(rtos (* -0.1 (strlen str))2 3)) fn)

; (write-line (strcat "A,.1,-.2,[\""str"\",STANDARD,S=.1,U=0.0,X=-0.1,Y=-.05]," -.25) fn)

; ;       *GAS_LINE,Gas line ----GAS----GAS----GAS----GAS----GAS----GAS--
; ; A,12.7,-5.08,["GAS",STANDARD,S=2.54,U=0.0,X=-2.54,Y=-1.27],-6.35


;       (close fn)
;         ;(setvar 'expert 5)

;       (if (= (tblsearch "LTYPE" temp_name) nil)
;         (command ".-linetype" "load" "*" file "")
;       ); end if
;           ;(setvar 'expert exprt)
;       (vl-file-delete file)





;       ;(setq total_region (append total_region (list (entlast))))
; ;;;;; END LINETYPE ;;;;;;;;;;;;;;;;;;;;

;       (command "._CHANGE" total_area "" "Properties" "LType" temp_name "")
;       (command "._CHANGE" total_area "" "Properties" "LtScale" (car scale_list) "")
;       (command "._CHANGE" total_area "" "Properties" "Color" (car color_list) "")


; ;; delete skeleton ;;;;
  ; (setq i -1)
  ; (repeat (sslength total_sel)
  ; (setq i (+ 1 i))
  ; (entdel (ssname total_sel i))
  ; ); repeat


      ; (command "._UNION")
      ; (apply 'command total_region);
      ; (command "")
     ; (command "._CHANGE" (entlast) "" "Properties" "LType" "GAS_LINE" "")
      ;(command "._CHANGE" (entlast) "" "Properties" "LtScale" "100" "")



      ;(vl-file-delete file)
      ;(princ)



; ;;;;; BREAK #2 ;;;;;;
; (setq temp_total_ent (entlast))
; (setq temp_total_volume (vlax-ename->vla-object (entlast)))
; (setq break_number 0)
; (setq break_point_list nil)
; (setq pt1 nil)
; (setq pt2 nil)


; (repeat (sslength break_set)
; (setq temp_intersect_probe nil)

; (alert "break")
; (setq temp_break_line (vlax-ename->vla-object (ssname break_set break_number)))

; (setq temp_intersect_probe (vlax-invoke temp_total_volume 'IntersectWith temp_break_line acextendnone))

; (setq pt1 (append (list (nth 0 temp_intersect_probe)) (list (nth 1 temp_intersect_probe))))
; (setq length_start_p1 (vlax-curve-getDistAtPoint temp_total_volume pt1))

; (setq pt2 (append (list (nth 3 temp_intersect_probe)) (list (nth 4 temp_intersect_probe))))
; (alert "break3")
; (setq length_start_p2 (vlax-curve-getDistAtPoint temp_total_volume pt2))
; ;(setq length_start_p2 (vlax-curve-getDistAtPoint temp_total_volume pt2))

; (setq break_point (vlax-curve-getPointAtDist temp_total_volume (/ (+ length_start_p1 length_start_p2) 2)  ))
; ;(alert "break111")

; (setq break_point_list (append break_point_list (list break_point)))
; (alert "break2")




; ;(alert "break")
; ; (setq after_counter 0)

; ; (setq break_line_after (vlax-ename->vla-object (ssname break_set (+ break_number 1))))


; ; (repeat (sslength set_after_break)
; ;  ;(command ".pedit" (ssname total_fit fit_counter) "Fit" "")
; ;  ; (command ".explode" (ssname areas explode_counter))

; ; (setq total_after (vlax-ename->vla-object (ssname set_after_break after_counter)))
; ; (setq intersect_after (vlax-invoke total_after 'IntersectWith break_line_after acextendnone))

; ; (if (= (length intersect_after) 6)
; ; (progn
; ; ); progn
; ; ); if

; ; (setq after_counter (+ after_counter 1))
; ; ); repeat



; ;(setq temp_total_volume (vlax-ename->vla-object (entlast)))

; (setq break_number (+ break_number 1))
; ;(vla-Delete temp_break_line)
; ); repeat

; (if (= (sslength break_set) 1)
;   (progn
;     (alert "one 1")
; (command "trim" break_set ""  (append (list temp_total_ent) (list (nth 0 break_point_list))) "")
; ); progn
; ); if
;    ; (alert "two 2")
; (if (= (sslength break_set) 2)
;   (progn
;     (alert "two 2")
; (command "trim" break_set "" (append (list temp_total_ent) (list (nth 1 break_point_list))) (append (list temp_total_ent) (list (nth 0 break_point_list))) )
; ); progn
; ); if
; ; (if (= (sslength break_set) 1)
; ; (command "trim" break_set ""  (append (list temp_total_ent) (list (nth 0 break_point_list))) "")
; ; ); if
; ; (if (= (sslength break_set) 1)
; ; (command "trim" break_set ""  (append (list temp_total_ent) (list (nth 0 break_point_list))) "")
; ; ); if
; ; (if (= (sslength break_set) 1)
; ; (command "trim" break_set ""  (append (list temp_total_ent) (list (nth 0 break_point_list))) "")
; ; ); if
; ; (if (= (sslength break_set) 1)
; ; (command "trim" break_set ""  (append (list temp_total_ent) (list (nth 0 break_point_list))) "")
; ; ); if
; ; 
; ;;;;;;;; BREAK ;;;;;;;;;;;;;
; (setq del_counter 0)
; (repeat (sslength break_set)
; (entdel (ssname break_set del_counter))
; (setq del_counter (+ del_counter 1))
; ); repeat

      ); end file cycle


      ); end progn --- empty select
    ); end if --- empty select

;;;;;;;;; RESET DEFAULT SETTING;;;;;
    ;(command "_.EXPLODE")
    ;(apply 'command union_areas)

    (setvar "CMDECHO" oldEcho)
    (setvar "OSMODE" oldOsm)
   ; (setvar "CECOLOR" oldColor)
    ;(setvar "CELTSCALE" oldCeltscale)
  (princ)
  ); end of c:sper