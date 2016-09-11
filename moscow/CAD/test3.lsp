;;;;; DEFINE FUNCTION ;;;;;;;;
(defun c:fly(/ spSet ptLst Dr Ang sCurve oldEcho
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



  (setq oldEcho(getvar "CMDECHO")
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
        count_spline (sslength spSet)
        temp_number 0
      ); end setq  
      (setq total_region nil) 
;;;;;;;;; SPLINE CYCLE ;;;;;;;;;;;;;;;;;
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
        temp_length 0
        point_list (list )
        spline_length (vlax-curve-getDistAtPoint sCurve (vlax-curve-getEndPoint sCurve))
        true_count (/ spline_length step)
        ok_point 1
      ); end setq

      (setq
        ff (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" temp_name ".txt") "r")
        trash_line (read-line ff)
      ); end setq
;;;;;;;;;;;;;; DRAW LINES ;;;;;;;;;;;;;;;;
      (while (and (> ok_point 0) (< counter_test true_count))
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
        (setq
          Dr(vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve pt))
          Ang(- pi(atan(/(car Dr)(cadr Dr))))
          dataLst(append dataLst (list(list(trans pt 0 1) Ang))); 
        ); end setq
      ); end point cycle
  
      (setq counter 0)
     
      (while dataLst
        (setq 
          fPt(caar dataLst)
          Ang(cadar dataLst)
          radius(car radius_length)
        ); end setq

;;;;;;;;;;; LOOK BEGIN POINT (counter = 0) ;;;;;;;;;;;
        (if (= counter 0)  
          (progn
            (setq double_der (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt)));

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


;;;;;;;;;; SPLIT SPLINE ;;;;;;;;;;;;;;
        (if radius
          (progn
            (if (< (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
              (progn
                (command "_.line" fPt (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius)0 1) "")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq end_point (append end_point (list (vlax-curve-getEndPoint temp_line))))  
                (setq start_point (append start_point (list (vlax-curve-getStartPoint temp_line))))
                (entdel (entlast))
                (entdel (entlast))
              )
            ); end if

            (if (>= (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
              (progn
                (command "_.line" fPt (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius)0 1) "")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq end_point (append end_point (list (vlax-curve-getStartPoint temp_line))))  
                (setq start_point (append start_point (list (vlax-curve-getEndPoint temp_line))))
                (entdel (entlast))
                (entdel (entlast))
              ); progn
            ); end if
          ); progn
        ); if


        (setq 
          dataLst (cdr dataLst)
          radius_length (cdr radius_length)
        ); setq
        (if (not dataLst)
          (princ)
        ); if
        (setq counter (+ counter 1))
      ); end while
     
     (if (= ok_point 1)
        (setq point_list (append point_list (list (vlax-curve-getEndPoint sCurve))))
     ); if

      (close ff)
      (setq 
        ff nil
        total_point (append med_angle_point end_angle_point start_point (reverse end_point) start_angle_point med_angle_point)
      )

;;;;;;;;;;;;;;; DRAW SPLINE ;;;;;;;;;;;;;;;;;;;
      ;(setvar "CELTSCALE" 100)
      ;(command ".-linetype" "load" "*" file "")

      (entmake
       (append (list '(0 . "SPLINE") '(100 . "AcDbEntity") '(100 . "AcDbSpline") '(70 . 40) '(71 . 3) (cons 74 (length total_point)) '(44 . 1.0e-005))
         (mapcar '(lambda (x) (cons 11 x)) total_point)
       ); append
      ); entmake
      

      (command "region" (entlast) "")


      (setq
        str   temp_name
        file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
        fn    (open file "w")
      ;  exprt (getvar 'expert)
      )
      (write-line (strcat "*" str ", ---" str "---") fn)
      (write-line (strcat "A,1.5,-0.05,[\""str"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
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

      (setq total_region (append total_region (list (entlast))))

      ); end spline cycle
;;;;;;;;; UNION AREAS ;;;;;;;;;;;;
   ;   (setvar "CELTSCALE" 10)
      (command "._UNION")
      (apply 'command total_region);
      (command "")
     ; (setq union_areas (append union_areas (entlast)))
      
     ; (command "._CHANGE" (entlast) "" "Properties" "LType" "GAS_LINE" "")
      ;(command "._CHANGE" (entlast) "" "Properties" "LtScale" "100" "")

      (if (/= (cdr color_list) nil)
        (setq color_list (cdr color_list))
      ); end if

      (if (/= (cdr scale_list) nil)
        (setq scale_list (cdr scale_list))
      ); end if

      ;(vl-file-delete file)
      ;(princ)


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