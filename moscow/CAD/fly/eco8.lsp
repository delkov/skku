
; (defun w-error (s) (redraw) (grtext)
;   (princ "\nWeed Error: ") (princ s)
;   (exit)
; )

; ;*----- Exit Routine

; (defun exit()
;   (if (boundp 'f) (setq f (close f)))
;   (setvar "cmdecho"  cmdecho)
;   (setvar "blipmode" blipmode)
;   (setq *error* olderr)
;   (princ)
; )

; ;*----- Extract a field from a list

; (defun fld (num lst) (cdr (assoc num lst)))

; ;*----- Plot a temporary X

; (defun blip (blpoint / s x1 y1 x2 y2 p1 p2 p3 p4)

;    (setq s  (/ (getvar "viewsize") 100)      ; 1/100 of viewsize
;          x1 (+ (car blpoint) s)
;          y1 (- (cadr blpoint) s)
;          x2 (- (car blpoint) s)
;          y2 (+ (cadr blpoint) s)
;          p1 (list x1 y1) p2 (list x2 y2)
;          p3 (list x2 y1) p4 (list x1 y2))
;    (grdraw p1 p2 -1) (grdraw p3 p4 -1)
; )

; ;*----- Convert a line to a polyline entity

; (defun line2pline(ent / dat etype epnt ss1 ss2)
;   (if ent (progn
;     (setq dat   (entget ent)
;           etype (fld 0 dat))
;     (if (= etype "LINE") (progn
;       (princ "\nConverting LINE to PLINE")
;       (setq epnt (fld 10 dat)
;             ss1 (ssadd ent)
;             ss2 (ssget "C" (getvar "EXTMIN") (getvar "EXTMAX")))
;       (ssdel ent ss2)
;       (command "pedit" ss1 "y" "j" ss2 "" "x")
;       (ssname (ssget epnt) 0) ; return the new entity name
;     )
;     ;else return nil
;       (progn (princ "\nNot a Line")
;         nil)
;     )
;   );else
;   (progn
;     (princ "\nNothing selected")
;     nil)
;   )
; )

; ;*-----  Get a polyline or line entity

; (defun fetch(sel / pl etyp flgs ans)
;   (setq etyp nil)
;     (setq ename nil)
;     ;(setq e (car (entsel "\nSelect a PolyLine or Line: ")))
   

;     ;(command "_.convertpoly" "H" (ssget) "")

;     (command "_.convertpoly" "H" sel "")

;     (setq e      (entlast)
;     ename  e
;     pl     (entget e)
;     )
  



;   (setq flgs   (fld 70 pl))
;   (setq closed (=(boole 1 flgs 1) 1))
;   (if closed (princ "\nClosed Polyline"))
;   (cond
;     ((=(boole 1 flgs 2) 2) (progn
;       (setq ptyp "F")
;       (princ "\nFit curve verticies have been added")))
;     ((=(boole 1 flgs 4) 4) (progn
;       (setq ptyp "S")
;       (princ "\nSpline curve verticies have been added...")))
;     (t  (setq ptyp "N"))      ;Normal polyline
;   )
;   (if(/= ptyp "N") (progn
;     (initget "Y N")
;     (if(= (getkword "\nDecurve polyline during weeding[y/N]:") "Y")
;       (setq ptyp "N"))
;   ))
; )

; ;*----- Check vertex type

; (defun vt_ok ()
;   (if (= etype "VERTEX")
;     (cond
;       ((= ptyp "F") (or(=(boole 1 flags 1) 1) (= flags 0)))
;       ((= ptyp "S") (>(boole 1 flags 9) 0))
;       (t      (=(boole 1 flags 25) 0)) ;"N" normal, 1 8 16 off
;     )
;   ;else
;     t
;   )
; )

; ;*----- extract the list containing vertex coordinates

; (defun get_vertex(/ vert etype sub_ent flags)
;   (setq vert nil
;         etype nil)
;   (while (and e (null vert) (/= etype "SEQEND")) (progn
;     (setq v     (entnext e)
;           e     v
;           etype nil)
;     (if e (progn
;       (setq sub_ent   (entget v)
;       flags     (fld 70 sub_ent)
;             etype     (fld 0  sub_ent))
;       ;(princ "flags =")(princ flags)
;       (if (vt_ok)
;   (if (= etype "VERTEX")
;     (setq vert_cnt (1+ vert_cnt)
;     vert   (fld 10 sub_ent))
;   ; else return
;     nil
;   )
;       )
;     ))
;   ))
; )

; ;*----- Add a vertex to the temporary file for the new pline

; (defun add_vert(vt)
;   (if (null f) (setq f (open "weedtmp.$$$" "w")))
;   (prin1 vt f)
;   (princ "\n" f)
; )

; ;*----- Read a vertex from the temporary file for the new pline

; (defun read_vert(/ pt)
;    (setq pt (read-line f))
;    (if pt (read pt) nil)
; )

; ;*----- Read new polyline from the tempory file

; (defun retrieve()
;     (setq f (open "weedtmp.$$$" "r"))
;     (command ".PLINE")
;     (setq v (read_vert))
;     (while v (progn
;       (command v)
;       (setq v (read_vert))
;     ))
;     (command "")
;    ;(command "del" "weedtmp.$$$")
; )

; ;*----- Check the internal angle and leg lengths then add or delete

; (defun check_it(/ ang dist1 dist2 dist offset off)
;   (setq ang12  (abs(angle v1 v2))
;   ang13  (abs(angle v1 v3))
;   ang    (abs(- ang12 ang13))
;   dist1  (distance v1 v2)
;   dist2  (distance v2 v3)
;   dist   (max dist1 dist2)       ; largest distance
;   off    (* dist1 (sin ang))
;   offset (+ p_off off)
;   p_off  offset
;   )
;   (if
;     (and
;       (< offset max_offset)   ;offset distance criteria
;       (< dist min_dist)   ;minimum leg length criteria
;     )
;     ;then skip middle vertex
;     (progn (blip v2)      ;mark the deleted vertex
;        (setq v2   v3
;        v3   (get_vertex)
;        skip_cnt (1+ skip_cnt))
;       (princ "\nSkipping vertex # ") (princ (- vert_cnt 2))
; ;     (princ (strcat ", max_offset " (rtos max_offset 2 2) "
; ;     min_dist " (rtos min_dist 2 2)))
; ;     (princ (strcat ", offset " (rtos offset 2 2) " dist " (rtos dist 2 2)))
;     )
;   ;else add first vertex to list
;     (progn
;       (add_vert v2)
;       (setq v1 v2
;             v2 v3
;       v3 (get_vertex)
;       p_off  0)
;     ); end progn
;   ); end if
; )

; ;*----- The main routine...

; (defun C:WEED( sel / v1 v2 v3 ename v skip_cnt vert_cnt cmdecho blipmode f
;      olderr max_offset min_dist closed spline fit e_del
;      p_off vstart ptyp)

;   (setq cmdecho  (getvar "cmdecho")
;         blipmode (getvar "blipmode")
;   olderr   *error*
;   *error*  w-error
; ;  *error* nil
;   skip_cnt 0
;   p_off  0
;   f  nil
;   vert_cnt 0
;   )
;   (setvar "cmdecho" 0)
;   (setvar "blipmode" 0)
;   (initget (+ 1 2 4))
;   (setq max_offset 1000)
;   (initget (+ 1 2 4))
;   (setq min_dist 2000)

;   (setq e_del "Y")
;   (fetch sel)
;   (princ "\nChecking polyline verticies...")
;   (setq v1 (get_vertex)
;   vstart v1
;   v2 (get_vertex)
;         v3 (get_vertex))
;   (add_vert v1)
;   (while v3 (check_it))
;   (if (< (distance v1 v2) min_dist)
;     (progn (setq skip_cnt (1+ skip_cnt))
;      (princ "\nSkipping vertex # ") (princ vert_cnt))
;   ;else
;     (add_vert v1)
;   ); end if
;   (add_vert v2)
;   (if closed (add_vert vstart))
;   ; Delete old line and draw new Pline
;   (if (> skip_cnt 0) (progn
;     (close f)
;     (if (= e_del "Y") (entdel ename))
;     (retrieve)
;     (princ (strcat "\n" (itoa skip_cnt) " verticies removed "
;        "out of " (itoa vert_cnt) " tested ("
;        (rtos(/ (* 100.0 skip_cnt) vert_cnt) 2 2)
;        ") percent"))
;   )
;   ;else
;     (princ "\nNothing to change!")
;   )
;   (exit)
; )




;;; GLOBAL ;;;
(setq break_set (ssadd))
(setq merge_vpp_points (ssadd))
(setq total_merge_vpp_list nil)
(setq temp_number 0)
(setq test_total_fit (ssadd))
(setq total_ent_list '())
(setq global_ent_list '())
(setq file_list nil)
(setq true_file_list nil)
(setq color_list nil)
(setq break_list '())
(setq ent_curve nil)
(setq sel_set_fit (ssadd))
(setq sel_set (ssadd))
;;;;; DRAWING SETING ;;;;;;;;;
  (setq
    oldEcho(getvar "CMDECHO")
    oldOsm(getvar "OSMODE")
     ;file_list (vl-directory-files "c:\\Users\\delko_000\\Desktop\\fly\\data" "*" 1)
     ;file_name_list (mapcar 'vl-filename-base file_list)
  ); end setq
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)
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

(defun equal_add (Count Time Impact /)
(/(* 10 (log (/ (float Time) (* Count Impact) ))) (log 10))
);; EQUAL ADD

       (defun file_line (line_number /)
       (setq opened_file_to_read (open (strcat "C:\\fly\\settings.ini") "r"))
       (setq text_list nil)
       (while (setq temp_text (read-line opened_file_to_read))
       (setq text_list (append text_list (list temp_text)))
       ); WHILE
       (close opened_file_to_read)
       (setq opened_file_to_write (open (strcat "C:\\fly\\settings.ini") "w"))
       (setq line_counter 1)
       (foreach temp_text text_list
        (if (= line_counter line_number)
        (write-line changed_line opened_file_to_write)
        ); if
        (if (/= line_counter line_number)
        (write-line temp_text opened_file_to_write)
        ); if
        (setq line_counter (+ line_counter 1))
       ); FOREACH
       (close opened_file_to_write)
       ); END FILE_LINE
(defun fill_clr (name nc /)
(setq dx (dimx_tile name) dy (dimy_tile name))
    (start_image name)
    (fill_image 0 0 dx dy nc)
(end_image)
); END FILL_CLR
(defun change_clr (name /)
(setq dx (dimx_tile name) dy (dimy_tile name))
(setq nc (acad_colordlg 80))

(if nc
   (progn
    (start_image name)
    (fill_image 0 0 dx dy nc)
    (setq changed_line (itoa nc))
    (file_line line_numb)
    (end_image)
   ); progn
 ); if
); END CHANGE_CLR
(defun c:sample (/ spSet ptLst Dr Ang sCurve oldEcho oldOsm dataLst fPt radius Ans )
;;; START DIALOG ;;;
(setq break_list '())
(setq ini_file (open (strcat "C:\\fly\\settings.ini") "r"))
;(setq ent_for_del (entlast))
(if (< (setq dcl_id (load_dialog "C:\\fly\\dample.dcl")) 0) (exit))
(if (not (new_dialog "sample" dcl_id)) (exit))
;;;;;;;;;;;;;;; READ SETTING FROM SETTING.INI ;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; trash-line NOISE LEVEL--60
(read-line ini_file)
     (set_tile "db_1" (read-line ini_file))
     (set_tile "custom_1" (read-line ini_file))
     (set_tile "group_1" (read-line ini_file))
     (set_tile "takeoff_1" (read-line ini_file))
     (set_tile "put_down_1" (read-line ini_file))
     (fill_clr "clr_1" (atoi (read-line ini_file)))
     (set_tile "max_1" (read-line ini_file))
     (setq equal_proba (read-line ini_file))
     (set_tile "equal_1" equal_proba)
     (set_tile "day_1" (read-line ini_file))
     (set_tile "night_1" (read-line ini_file))
     (set_tile "impact_1" (read-line ini_file))
     (set_tile "count_1" (read-line ini_file))
        (if (= equal_proba "0")
          (progn
            (mode_tile "day_1" 1)
            (mode_tile "night_1" 1)
            (mode_tile "impact_1" 1)
            (mode_tile "count_1" 1)
          )
        )
     (set_tile "length_1" (read-line ini_file))
     (set_tile "width_1" (read-line ini_file))
     (set_tile "scale_1" (read-line ini_file))
     (set_tile "text_1" (read-line ini_file))



(read-line ini_file)
     (set_tile "db_2" (read-line ini_file))
     (set_tile "custom_2" (read-line ini_file))
     (set_tile "group_2" (read-line ini_file))
     (set_tile "takeoff_2" (read-line ini_file))
     (set_tile "put_down_2" (read-line ini_file))
     (fill_clr "clr_2" (atoi (read-line ini_file)))
     (set_tile "max_2" (read-line ini_file))
     (setq equal_proba_2 (read-line ini_file))
     (set_tile "equal_2" equal_proba_2)
        (if (= equal_proba_2 "0")
          (progn

            (mode_tile "day_2" 1)
            (mode_tile "night_2" 1)
            (mode_tile "impact_2" 1)
            (mode_tile "count_2" 1)
          )
        )
     (set_tile "day_2" (read-line ini_file))
     (set_tile "night_2" (read-line ini_file))
     (set_tile "impact_2" (read-line ini_file))
     (set_tile "count_2" (read-line ini_file))
     (set_tile "length_2" (read-line ini_file))
     (set_tile "width_2" (read-line ini_file))
     (set_tile "scale_2" (read-line ini_file))
     (set_tile "text_2" (read-line ini_file))



(read-line ini_file)
     (set_tile "db_3" (read-line ini_file))
     (set_tile "custom_3" (read-line ini_file))
     (set_tile "group_3" (read-line ini_file))
     (set_tile "takeoff_3" (read-line ini_file))
     (set_tile "put_down_3" (read-line ini_file))
     (fill_clr "clr_3" (atoi (read-line ini_file)))
     (set_tile "max_3" (read-line ini_file))
     (setq equal_proba_3 (read-line ini_file))
     (set_tile "equal_3" equal_proba_3)
        (if (= equal_proba_3 "0")
          (progn

            (mode_tile "day_3" 1)
            (mode_tile "night_3" 1)
            (mode_tile "impact_3" 1)
            (mode_tile "count_3" 1)
          )
        )
     (set_tile "day_3" (read-line ini_file))
     (set_tile "night_3" (read-line ini_file))
     (set_tile "impact_3" (read-line ini_file))
     (set_tile "count_3" (read-line ini_file))
     (set_tile "length_3" (read-line ini_file))
     (set_tile "width_3" (read-line ini_file))
     (set_tile "scale_3" (read-line ini_file))
     (set_tile "text_3" (read-line ini_file))


     (read-line ini_file)
     (set_tile "db_4" (read-line ini_file))
     (set_tile "custom_4" (read-line ini_file))
     (set_tile "group_4" (read-line ini_file))
     (set_tile "takeoff_4" (read-line ini_file))
     (set_tile "put_down_4" (read-line ini_file))
     (fill_clr "clr_4" (atoi (read-line ini_file)))
     (set_tile "max_4" (read-line ini_file))
     (setq equal_proba_4 (read-line ini_file))
     (set_tile "equal_4" equal_proba_4)
        (if (= equal_proba_4 "0")
          (progn

            (mode_tile "day_4" 1)
            (mode_tile "night_4" 1)
            (mode_tile "impact_4" 1)
            (mode_tile "count_4" 1)
          )
        )
     (set_tile "day_4" (read-line ini_file))
     (set_tile "night_4" (read-line ini_file))
     (set_tile "impact_4" (read-line ini_file))
     (set_tile "count_4" (read-line ini_file))
     (set_tile "length_4" (read-line ini_file))
     (set_tile "width_4" (read-line ini_file))
     (set_tile "scale_4" (read-line ini_file))
     (set_tile "text_4" (read-line ini_file))



     (read-line ini_file)
     (set_tile "db_5" (read-line ini_file))
     (set_tile "custom_5" (read-line ini_file))
     (set_tile "group_5" (read-line ini_file))
     (set_tile "takeoff_5" (read-line ini_file))
     (set_tile "put_down_5" (read-line ini_file))
     (fill_clr "clr_5" (atoi (read-line ini_file)))
     (set_tile "max_5" (read-line ini_file))
     (setq equal_proba_5 (read-line ini_file))
     (set_tile "equal_5" equal_proba_5)
        (if (= equal_proba_5 "0")
          (progn

            (mode_tile "day_5" 1)
            (mode_tile "night_5" 1)
            (mode_tile "impact_5" 1)
            (mode_tile "count_5" 1)
          )
        )
     (set_tile "day_5" (read-line ini_file))
     (set_tile "night_5" (read-line ini_file))
     (set_tile "impact_5" (read-line ini_file))
     (set_tile "count_5" (read-line ini_file))
     (set_tile "length_5" (read-line ini_file))
     (set_tile "width_5" (read-line ini_file))
     (set_tile "scale_5" (read-line ini_file))
     (set_tile "text_5" (read-line ini_file))



     (read-line ini_file)
     (set_tile "db_6" (read-line ini_file))
     (set_tile "custom_6" (read-line ini_file))
     (set_tile "group_6" (read-line ini_file))
     (set_tile "takeoff_6" (read-line ini_file))
     (set_tile "put_down_6" (read-line ini_file))
     (fill_clr "clr_6" (atoi (read-line ini_file)))
     (set_tile "max_6" (read-line ini_file))
     (setq equal_proba_6 (read-line ini_file))
     (set_tile "equal_6" equal_proba_6)
        (if (= equal_proba_6 "0")
          (progn

            (mode_tile "day_6" 1)
            (mode_tile "night_6" 1)
            (mode_tile "impact_6" 1)
            (mode_tile "count_6" 1)
          )
        )
     (set_tile "day_6" (read-line ini_file))
     (set_tile "night_6" (read-line ini_file))
     (set_tile "impact_6" (read-line ini_file))
     (set_tile "count_6" (read-line ini_file))
     (set_tile "length_6" (read-line ini_file))
     (set_tile "width_6" (read-line ini_file))
     (set_tile "scale_6" (read-line ini_file))
     (set_tile "text_6" (read-line ini_file))



     (read-line ini_file)
     (set_tile "db_7" (read-line ini_file))
     (set_tile "custom_7" (read-line ini_file))
     (set_tile "group_7" (read-line ini_file))
     (set_tile "takeoff_7" (read-line ini_file))
     (set_tile "put_down_7" (read-line ini_file))
     (fill_clr "clr_7" (atoi (read-line ini_file)))
     (set_tile "max_7" (read-line ini_file))
     (setq equal_proba_7 (read-line ini_file))
     (set_tile "equal_7" equal_proba_7)
        (if (= equal_proba_7 "0")
          (progn

            (mode_tile "day_7" 1)
            (mode_tile "night_7" 1)
            (mode_tile "impact_7" 1)
            (mode_tile "count_7" 1)
          )
        )
     (set_tile "day_7" (read-line ini_file))
     (set_tile "night_7" (read-line ini_file))
     (set_tile "impact_7" (read-line ini_file))
     (set_tile "count_7" (read-line ini_file))
     (set_tile "length_7" (read-line ini_file))
     (set_tile "width_7" (read-line ini_file))
     (set_tile "scale_7" (read-line ini_file))
     (set_tile "text_7" (read-line ini_file))




     (read-line ini_file)
     (set_tile "db_8" (read-line ini_file))
     (set_tile "custom_8" (read-line ini_file))
     (set_tile "group_8" (read-line ini_file))
     (set_tile "takeoff_8" (read-line ini_file))
     (set_tile "put_down_8" (read-line ini_file))
     (fill_clr "clr_8" (atoi (read-line ini_file)))
     (set_tile "max_8" (read-line ini_file))
     (setq equal_proba_8 (read-line ini_file))
     (set_tile "equal_8" equal_proba_8)
        (if (= equal_proba_8 "0")
          (progn

            (mode_tile "day_8" 1)
            (mode_tile "night_8" 1)
            (mode_tile "impact_8" 1)
            (mode_tile "count_8" 1)
          )
        )
     (set_tile "day_8" (read-line ini_file))
     (set_tile "night_8" (read-line ini_file))
     (set_tile "impact_8" (read-line ini_file))
     (set_tile "count_8" (read-line ini_file))
     (set_tile "length_8" (read-line ini_file))
     (set_tile "width_8" (read-line ini_file))
     (set_tile "scale_8" (read-line ini_file))
     (set_tile "text_8" (read-line ini_file))


     (read-line ini_file)
     (set_tile "db_9" (read-line ini_file))
     (set_tile "custom_9" (read-line ini_file))
     (set_tile "group_9" (read-line ini_file))
     (set_tile "takeoff_9" (read-line ini_file))
     (set_tile "put_down_9" (read-line ini_file))
     (fill_clr "clr_9" (atoi (read-line ini_file)))
     (set_tile "max_9" (read-line ini_file))
     (setq equal_proba_9 (read-line ini_file))
     (set_tile "equal_9" equal_proba_9)
        (if (= equal_proba_9 "0")
          (progn

            (mode_tile "day_9" 1)
            (mode_tile "night_9" 1)
            (mode_tile "impact_9" 1)
            (mode_tile "count_9" 1)
          )
        )
     (set_tile "day_9" (read-line ini_file))
     (set_tile "night_9" (read-line ini_file))
     (set_tile "impact_9" (read-line ini_file))
     (set_tile "count_9" (read-line ini_file))
     (set_tile "length_9" (read-line ini_file))
     (set_tile "width_9" (read-line ini_file))
     (set_tile "scale_9" (read-line ini_file))
     (set_tile "text_9" (read-line ini_file))



     (read-line ini_file)
     (set_tile "db_10" (read-line ini_file))
     (set_tile "custom_10" (read-line ini_file))
     (set_tile "group_10" (read-line ini_file))
     (set_tile "takeoff_10" (read-line ini_file))
     (set_tile "put_down_10" (read-line ini_file))
     (fill_clr "clr_10" (atoi (read-line ini_file)))
     (set_tile "max_10" (read-line ini_file))
     (setq equal_proba_10 (read-line ini_file))
     (set_tile "equal_10" equal_proba_10)
        (if (= equal_proba_10 "0")
          (progn

            (mode_tile "day_10" 1)
            (mode_tile "night_10" 1)
            (mode_tile "impact_10" 1)
            (mode_tile "count_10" 1)
          )
        )
     (set_tile "day_10" (read-line ini_file))
     (set_tile "night_10" (read-line ini_file))
     (set_tile "impact_10" (read-line ini_file))
     (set_tile "count_10" (read-line ini_file))
     (set_tile "length_10" (read-line ini_file))
     (set_tile "width_10" (read-line ini_file))
     (set_tile "scale_10" (read-line ini_file))
     (set_tile "text_10" (read-line ini_file))
;;; trah-line MISC
     (read-line ini_file)
     (set_tile "merge_vpp" (read-line ini_file))
     (set_tile "notify" (read-line ini_file))
     ;(set_tile "auto_trim" (read-line ini_file))
     (set_tile "delete_files" (read-line ini_file))
;;;;;;;;;;;; ACTION PROCESSING ;;;;;;;;;;;;;;;;;;;;

      ;;; NOISE LEVEL X 1 ;;;
     (action_tile "db_1" "(setq changed_line $value)(file_line 2 )")
     (action_tile "custom_1" "(setq changed_line $value)(file_line 3 )")
     (action_tile "group_1" "(setq changed_line $value)(file_line 4 )")
     (action_tile "takeoff_1" "(setq changed_line $value)(file_line 5 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "put_down_1" "(setq changed_line $value)(file_line 6 )(setq changed_line \"0\")(file_line 5 )")
     (action_tile "clr_1" "(setq line_numb 7)(change_clr \"clr_1\")")
     (action_tile "max_1" "(mode_tile \"count_1\" 1)(mode_tile \"impact_1\" 1)(mode_tile \"day_1\" 1)(mode_tile \"night_1\" 1)(setq changed_line $value)(file_line 8 )(setq changed_line \"0\")(file_line 9 )")
     (action_tile "equal_1" "(mode_tile \"count_1\" 0)(mode_tile \"impact_1\" 0)(mode_tile \"day_1\" 0)(mode_tile \"night_1\" 0)(setq changed_line $value)(file_line 9 )(setq changed_line \"0\")(file_line 8 )")
     (action_tile "day_1" "(setq changed_line $value)(file_line 10 )(setq changed_line \"0\")(file_line 11 )")
     (action_tile "night_1" "(setq changed_line $value)(file_line 11 )(setq changed_line \"0\")(file_line 10 )")
     (action_tile "impact_1" "(setq changed_line $value)(file_line 12 )")
     (action_tile "count_1" "(setq changed_line $value)(file_line 13 )")
     (action_tile "length_1" "(setq changed_line $value)(file_line 14 )")
     (action_tile "width_1" "(setq changed_line $value)(file_line 15 )")
     (action_tile "scale_1" "(setq changed_line $value)(file_line 16 )")
     (action_tile "text_1" "(setq changed_line $value)(file_line 17 )")


     (action_tile "db_2" "(setq changed_line $value)(file_line 19 )")
     (action_tile "custom_2" "(setq changed_line $value)(file_line 20 )")
     (action_tile "group_2" "(setq changed_line $value)(file_line 21 )")
     (action_tile "takeoff_2" "(setq changed_line $value)(file_line 22 )(setq changed_line \"0\")(file_line 23 )")
     (action_tile "put_down_2" "(setq changed_line $value)(file_line 23 )(setq changed_line \"0\")(file_line 22 )")
     (action_tile "clr_2" "(setq line_numb 24)(change_clr \"clr_2\")")
     (action_tile "max_2" "(mode_tile \"count_2\" 1)(mode_tile \"impact_2\" 1)(mode_tile \"day_2\" 1)(mode_tile \"night_2\" 1)(setq changed_line $value)(file_line 25 )(setq changed_line \"0\")(file_line 26 )")
     (action_tile "equal_2" "(mode_tile \"count_2\" 0)(mode_tile \"impact_2\" 0)(mode_tile \"day_2\" 0)(mode_tile \"night_2\" 0)(setq changed_line $value)(file_line 26 )(setq changed_line \"0\")(file_line 25 )")
     (action_tile "day_2" "(setq changed_line $value)(file_line 27 )(setq changed_line \"0\")(file_line 28 )")
     (action_tile "night_2" "(setq changed_line $value)(file_line 28 )(setq changed_line \"0\")(file_line 27 )")
     (action_tile "impact_2" "(setq changed_line $value)(file_line 29 )")
     (action_tile "count_2" "(setq changed_line $value)(file_line 30 )")
     (action_tile "length_2" "(setq changed_line $value)(file_line 31 )")
     (action_tile "width_2" "(setq changed_line $value)(file_line 32 )")
     (action_tile "scale_2" "(setq changed_line $value)(file_line 33 )")
     (action_tile "text_2" "(setq changed_line $value)(file_line 34 )")



     (action_tile "db_3" "(setq changed_line $value)(file_line 36 )")
     (action_tile "custom_3" "(setq changed_line $value)(file_line 37 )")
     (action_tile "group_3" "(setq changed_line $value)(file_line 38 )")
     (action_tile "takeoff_3" "(setq changed_line $value)(file_line 39 )(setq changed_line \"0\")(file_line 40 )")
     (action_tile "put_down_3" "(setq changed_line $value)(file_line 40 )(setq changed_line \"0\")(file_line 39 )")
     (action_tile "clr_3" "(setq line_numb 41)(change_clr \"clr_3\")")
     (action_tile "max_3" "(mode_tile \"count_3\" 1)(mode_tile \"impact_3\" 1)(mode_tile \"day_3\" 1)(mode_tile \"night_3\" 1)(setq changed_line $value)(file_line 42 )(setq changed_line \"0\")(file_line 43 )")
     (action_tile "equal_3" "(mode_tile \"count_3\" 0)(mode_tile \"impact_3\" 0)(mode_tile \"day_3\" 0)(mode_tile \"night_3\" 0)(setq changed_line $value)(file_line 43 )(setq changed_line \"0\")(file_line 42 )")
     (action_tile "day_3" "(setq changed_line $value)(file_line 44 )(setq changed_line \"0\")(file_line 45 )")
     (action_tile "night_3" "(setq changed_line $value)(file_line 45 )(setq changed_line \"0\")(file_line 44 )")
     (action_tile "impact_3" "(setq changed_line $value)(file_line 46 )")
     (action_tile "count_3" "(setq changed_line $value)(file_line 47 )")
     (action_tile "length_3" "(setq changed_line $value)(file_line 48 )")
     (action_tile "width_3" "(setq changed_line $value)(file_line 49 )")
     (action_tile "scale_3" "(setq changed_line $value)(file_line 50 )")
     (action_tile "text_3" "(setq changed_line $value)(file_line 51 )")


     (action_tile "db_4" "(setq changed_line $value)(file_line 53 )")
     (action_tile "custom_4" "(setq changed_line $value)(file_line 54 )")
     (action_tile "group_4" "(setq changed_line $value)(file_line 55 )")
     (action_tile "takeoff_4" "(setq changed_line $value)(file_line 56 )(setq changed_line \"0\")(file_line 57 )")
     (action_tile "put_down_4" "(setq changed_line $value)(file_line 57 )(setq changed_line \"0\")(file_line 56 )")
     (action_tile "clr_4" "(setq line_numb 58)(change_clr \"clr_4\")")
     (action_tile "max_4" "(mode_tile \"count_4\" 1)(mode_tile \"impact_4\" 1)(mode_tile \"day_4\" 1)(mode_tile \"night_4\" 1)(setq changed_line $value)(file_line 59 )(setq changed_line \"0\")(file_line 60 )")
     (action_tile "equal_4" "(mode_tile \"count_4\" 0)(mode_tile \"impact_4\" 0)(mode_tile \"day_4\" 0)(mode_tile \"night_4\" 0)(setq changed_line $value)(file_line 60 )(setq changed_line \"0\")(file_line 59 )")
     (action_tile "day_4" "(setq changed_line $value)(file_line 61 )(setq changed_line \"0\")(file_line 62 )")
     (action_tile "night_4" "(setq changed_line $value)(file_line 62 )(setq changed_line \"0\")(file_line 61 )")
     (action_tile "impact_4" "(setq changed_line $value)(file_line 63 )")
     (action_tile "count_4" "(setq changed_line $value)(file_line 64 )")
     (action_tile "length_4" "(setq changed_line $value)(file_line 65 )")
     (action_tile "width_4" "(setq changed_line $value)(file_line 66 )")
     (action_tile "scale_4" "(setq changed_line $value)(file_line 67 )")
     (action_tile "text_4" "(setq changed_line $value)(file_line 68 )")


     (action_tile "db_5" "(setq changed_line $value)(file_line 70 )")
     (action_tile "custom_5" "(setq changed_line $value)(file_line 71 )")
     (action_tile "group_5" "(setq changed_line $value)(file_line 72 )")
     (action_tile "takeoff_5" "(setq changed_line $value)(file_line 73 )(setq changed_line \"0\")(file_line 74 )")
     (action_tile "put_down_5" "(setq changed_line $value)(file_line 74 )(setq changed_line \"0\")(file_line 73 )")
     (action_tile "clr_5" "(setq line_numb 75)(change_clr \"clr_5\")")
     (action_tile "max_5" "(mode_tile \"count_5\" 1)(mode_tile \"impact_5\" 1)(mode_tile \"day_5\" 1)(mode_tile \"night_5\" 1)(setq changed_line $value)(file_line 76 )(setq changed_line \"0\")(file_line 77 )")
     (action_tile "equal_5" "(mode_tile \"count_5\" 0)(mode_tile \"impact_5\" 0)(mode_tile \"day_5\" 0)(mode_tile \"night_5\" 0)(setq changed_line $value)(file_line 77 )(setq changed_line \"0\")(file_line 76 )")
     (action_tile "day_5" "(setq changed_line $value)(file_line 78 )(setq changed_line \"0\")(file_line 79 )")
     (action_tile "night_5" "(setq changed_line $value)(file_line 79 )(setq changed_line \"0\")(file_line 78 )")
     (action_tile "impact_5" "(setq changed_line $value)(file_line 80 )")
     (action_tile "count_5" "(setq changed_line $value)(file_line 81 )")
     (action_tile "length_5" "(setq changed_line $value)(file_line 82 )")
     (action_tile "width_5" "(setq changed_line $value)(file_line 83 )")
     (action_tile "scale_5" "(setq changed_line $value)(file_line 84 )")
     (action_tile "text_5" "(setq changed_line $value)(file_line 85 )")


     (action_tile "db_6" "(setq changed_line $value)(file_line 87 )")
     (action_tile "custom_6" "(setq changed_line $value)(file_line 88 )")
     (action_tile "group_6" "(setq changed_line $value)(file_line 89 )")
     (action_tile "takeoff_6" "(setq changed_line $value)(file_line 90 )(setq changed_line \"0\")(file_line 91 )")
     (action_tile "put_down_6" "(setq changed_line $value)(file_line 91 )(setq changed_line \"0\")(file_line 90 )")
     (action_tile "clr_6" "(setq line_numb 92)(change_clr \"clr_6\")")
     (action_tile "max_6" "(mode_tile \"count_6\" 1)(mode_tile \"impact_6\" 1)(mode_tile \"day_6\" 1)(mode_tile \"night_6\" 1)(setq changed_line $value)(file_line 93 )(setq changed_line \"0\")(file_line 94 )")
     (action_tile "equal_6" "(mode_tile \"count_6\" 0)(mode_tile \"impact_6\" 0)(mode_tile \"day_6\" 0)(mode_tile \"night_6\" 0)(setq changed_line $value)(file_line 94 )(setq changed_line \"0\")(file_line 93 )")
     (action_tile "day_6" "(setq changed_line $value)(file_line 95 )(setq changed_line \"0\")(file_line 96 )")
     (action_tile "night_6" "(setq changed_line $value)(file_line 96 )(setq changed_line \"0\")(file_line 95 )")
     (action_tile "impact_6" "(setq changed_line $value)(file_line 97 )")
     (action_tile "count_6" "(setq changed_line $value)(file_line 98 )")
     (action_tile "length_6" "(setq changed_line $value)(file_line 99 )")
     (action_tile "width_6" "(setq changed_line $value)(file_line 100 )")
     (action_tile "scale_6" "(setq changed_line $value)(file_line 101 )")
     (action_tile "text_6" "(setq changed_line $value)(file_line 102 )")


     (action_tile "db_7" "(setq changed_line $value)(file_line 104 )")
     (action_tile "custom_7" "(setq changed_line $value)(file_line 105 )")
     (action_tile "group_7" "(setq changed_line $value)(file_line 106 )")
     (action_tile "takeoff_7" "(setq changed_line $value)(file_line 107 )(setq changed_line \"0\")(file_line 108 )")
     (action_tile "put_down_7" "(setq changed_line $value)(file_line 108 )(setq changed_line \"0\")(file_line 107 )")
     (action_tile "clr_7" "(setq line_numb 109)(change_clr \"clr_7\")")
     (action_tile "max_7" "(mode_tile \"count_7\" 1)(mode_tile \"impact_7\" 1)(mode_tile \"day_7\" 1)(mode_tile \"night_7\" 1)(setq changed_line $value)(file_line 110 )(setq changed_line \"0\")(file_line 111 )")
     (action_tile "equal_7" "(mode_tile \"count_7\" 0)(mode_tile \"impact_7\" 0)(mode_tile \"day_7\" 0)(mode_tile \"night_7\" 0)(setq changed_line $value)(file_line 111 )(setq changed_line \"0\")(file_line 110 )")
     (action_tile "day_7" "(setq changed_line $value)(file_line 112 )(setq changed_line \"0\")(file_line 113 )")
     (action_tile "night_7" "(setq changed_line $value)(file_line 113 )(setq changed_line \"0\")(file_line 112 )")
     (action_tile "impact_7" "(setq changed_line $value)(file_line 114 )")
     (action_tile "count_7" "(setq changed_line $value)(file_line 115 )")
     (action_tile "length_7" "(setq changed_line $value)(file_line 116 )")
     (action_tile "width_7" "(setq changed_line $value)(file_line 117 )")
     (action_tile "scale_7" "(setq changed_line $value)(file_line 118 )")
     (action_tile "text_7" "(setq changed_line $value)(file_line 119 )")

     (action_tile "db_8" "(setq changed_line $value)(file_line 121 )")
     (action_tile "custom_8" "(setq changed_line $value)(file_line 122 )")
     (action_tile "group_8" "(setq changed_line $value)(file_line 123 )")
     (action_tile "takeoff_8" "(setq changed_line $value)(file_line 124 )(setq changed_line \"0\")(file_line 125 )")
     (action_tile "put_down_8" "(setq changed_line $value)(file_line 125 )(setq changed_line \"0\")(file_line 124 )")
     (action_tile "clr_8" "(setq line_numb 126)(change_clr \"clr_8\")")
     (action_tile "max_8" "(mode_tile \"count_8\" 1)(mode_tile \"impact_8\" 1)(mode_tile \"day_8\" 1)(mode_tile \"night_8\" 1)(setq changed_line $value)(file_line 127 )(setq changed_line \"0\")(file_line 128 )")
     (action_tile "equal_8" "(mode_tile \"count_8\" 0)(mode_tile \"impact_8\" 0)(mode_tile \"day_8\" 0)(mode_tile \"night_8\" 0)(setq changed_line $value)(file_line 128 )(setq changed_line \"0\")(file_line 127 )")
     (action_tile "day_8" "(setq changed_line $value)(file_line 129 )(setq changed_line \"0\")(file_line 130 )")
     (action_tile "night_8" "(setq changed_line $value)(file_line 130 )(setq changed_line \"0\")(file_line 129 )")
     (action_tile "impact_8" "(setq changed_line $value)(file_line 131 )")
     (action_tile "count_8" "(setq changed_line $value)(file_line 132 )")
     (action_tile "length_8" "(setq changed_line $value)(file_line 133 )")
     (action_tile "width_8" "(setq changed_line $value)(file_line 134 )")
     (action_tile "scale_8" "(setq changed_line $value)(file_line 135 )")
     (action_tile "text_8" "(setq changed_line $value)(file_line 136 )")



     (action_tile "db_9" "(setq changed_line $value)(file_line 138 )")
     (action_tile "custom_9" "(setq changed_line $value)(file_line 139 )")
     (action_tile "group_9" "(setq changed_line $value)(file_line 140 )")
     (action_tile "takeoff_9" "(setq changed_line $value)(file_line 141 )(setq changed_line \"0\")(file_line 142 )")
     (action_tile "put_down_9" "(setq changed_line $value)(file_line 142 )(setq changed_line \"0\")(file_line 141 )")
     (action_tile "clr_9" "(setq line_numb 143)(change_clr \"clr_9\")")
     (action_tile "max_9" "(mode_tile \"count_9\" 1)(mode_tile \"impact_9\" 1)(mode_tile \"day_9\" 1)(mode_tile \"night_9\" 1)(setq changed_line $value)(file_line 144 )(setq changed_line \"0\")(file_line 145 )")
     (action_tile "equal_9" "(mode_tile \"count_9\" 0)(mode_tile \"impact_9\" 0)(mode_tile \"day_9\" 0)(mode_tile \"night_9\" 0)(setq changed_line $value)(file_line 145 )(setq changed_line \"0\")(file_line 144 )")
     (action_tile "day_9" "(setq changed_line $value)(file_line 146 )(setq changed_line \"0\")(file_line 147 )")
     (action_tile "night_9" "(setq changed_line $value)(file_line 147 )(setq changed_line \"0\")(file_line 146 )")
     (action_tile "impact_9" "(setq changed_line $value)(file_line 148 )")
     (action_tile "count_9" "(setq changed_line $value)(file_line 149 )")
     (action_tile "length_9" "(setq changed_line $value)(file_line 150 )")
     (action_tile "width_9" "(setq changed_line $value)(file_line 151 )")
     (action_tile "scale_9" "(setq changed_line $value)(file_line 152 )")
     (action_tile "text_9" "(setq changed_line $value)(file_line 153 )")


     (action_tile "db_10" "(setq changed_line $value)(file_line 155 )")
     (action_tile "custom_10" "(setq changed_line $value)(file_line 156 )")
     (action_tile "group_10" "(setq changed_line $value)(file_line 157 )")
     (action_tile "takeoff_10" "(setq changed_line $value)(file_line 158 )(setq changed_line \"0\")(file_line 159 )")
     (action_tile "put_down_10" "(setq changed_line $value)(file_line 159 )(setq changed_line \"0\")(file_line 158 )")
     (action_tile "clr_10" "(setq line_numb 160)(change_clr \"clr_10\")")
     (action_tile "max_10" "(mode_tile \"count_10\" 1)(mode_tile \"impact_10\" 1)(mode_tile \"day_10\" 1)(mode_tile \"night_10\" 1)(setq changed_line $value)(file_line 161 )(setq changed_line \"0\")(file_line 162 )")
     (action_tile "equal_10" "(mode_tile \"count_10\" 0)(mode_tile \"impact_10\" 0)(mode_tile \"day_10\" 0)(mode_tile \"night_10\" 0)(setq changed_line $value)(file_line 162 )(setq changed_line \"0\")(file_line 161 )")
     (action_tile "day_10" "(setq changed_line $value)(file_line 163 )(setq changed_line \"0\")(file_line 164 )")
     (action_tile "night_10" "(setq changed_line $value)(file_line 164 )(setq changed_line \"0\")(file_line 163 )")
     (action_tile "impact_10" "(setq changed_line $value)(file_line 165 )")
     (action_tile "count_10" "(setq changed_line $value)(file_line 166 )")
     (action_tile "length_10" "(setq changed_line $value)(file_line 167 )")
     (action_tile "width_10" "(setq changed_line $value)(file_line 168 )")
     (action_tile "scale_10" "(setq changed_line $value)(file_line 169 )")
     (action_tile "text_10" "(setq changed_line $value)(file_line 170 )")


     ;  ;;; MISC ;;;
      (action_tile "merge_vpp" "(setq changed_line $value)(file_line 172 )")
      (action_tile "notify" "(setq changed_line $value)(file_line 173 )")
     ; (action_tile "auto_trim" "(setq changed_line $value)(file_line 132 )")
      (action_tile "delete_files" "(setq changed_line $value)(file_line 174 )")

     ;;; CANCEL _OK ;;;
     (action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (unload_dialog dcl_id)
;;; OPEN TO DETECT ;;;
       (setq opened_file_to_read_group (open (strcat "C:\\fly\\settings.ini") "r"))

;;; NOISE 1;;;
        (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_1 (atoi (read-line opened_file_to_read_group)))
        (setq custom_1 (atoi (read-line opened_file_to_read_group)))
        (setq group_1  (1+ (atoi (read-line opened_file_to_read_group))))


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_1 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_1 "put_down") ; means put_down
        );


        (setq clr_1 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_1 0) ; means max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_1 1) ; means equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_1 16) ;  means say
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_1 8) ; means night
        );
        (setq impact_1 (atoi (read-line opened_file_to_read_group)))
        (setq count_1 (atoi (read-line opened_file_to_read_group)))
        (setq length_1 (atoi (read-line opened_file_to_read_group)))
        (setq width_1 (atoi (read-line opened_file_to_read_group)))
        (setq scale_1 (atoi (read-line opened_file_to_read_group)))
        (setq text_1 (read-line opened_file_to_read_group))
        (if (or (<= custom_1 39)(>= custom_1 101)(<= impact_1 0)(<= count_1 0)(<= length_1 0) (<= width_1 0) (<= scale_1 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )
;;; END NOISE 1 ;;;



;;; NOISE 2;;;
        (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_2 (atoi (read-line opened_file_to_read_group)))
        (setq custom_2 (atoi (read-line opened_file_to_read_group)))
        (setq group_2 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_2 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_2 "put_down") ; means put_down
        );


        (setq clr_2 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_2 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_2 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_2 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_2 8) ; 8 means night
        );
        (setq impact_2 (atoi (read-line opened_file_to_read_group)))
        (setq count_2 (atoi (read-line opened_file_to_read_group)))
        (setq length_2 (atoi (read-line opened_file_to_read_group)))
        (setq width_2 (atoi (read-line opened_file_to_read_group)))
        (setq scale_2 (atoi (read-line opened_file_to_read_group)))
        (setq text_2 (read-line opened_file_to_read_group))
        (if (or (<= custom_2 39)(>= custom_2 101)(<= impact_2 0)(<= count_2 0)(<= length_2 0) (<= width_2 0) (<= scale_2 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )




        (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_3 (atoi (read-line opened_file_to_read_group)))
        (setq custom_3 (atoi (read-line opened_file_to_read_group)))
        (setq group_3 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_3 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_3 "put_down") ; means put_down
        );


        (setq clr_3 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_3 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_3 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_3 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_3 8) ; 8 means night
        );
        (setq impact_3 (atoi (read-line opened_file_to_read_group)))
        (setq count_3 (atoi (read-line opened_file_to_read_group)))
        (setq length_3 (atoi (read-line opened_file_to_read_group)))
        (setq width_3 (atoi (read-line opened_file_to_read_group)))
        (setq scale_3 (atoi (read-line opened_file_to_read_group)))
        (setq text_3 (read-line opened_file_to_read_group))
        (if (or (<= custom_3 39)(>= custom_3 101)(<= impact_3 0)(<= count_3 0)(<= length_3 0) (<= width_3 0) (<= scale_3 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )


                (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_4 (atoi (read-line opened_file_to_read_group)))
        (setq custom_4 (atoi (read-line opened_file_to_read_group)))
        (setq group_4 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_4 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_4 "put_down") ; means put_down
        );


        (setq clr_4 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_4 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_4 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_4 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_4 8) ; 8 means night
        );
        (setq impact_4 (atoi (read-line opened_file_to_read_group)))
        (setq count_4 (atoi (read-line opened_file_to_read_group)))
        (setq length_4 (atoi (read-line opened_file_to_read_group)))
        (setq width_4 (atoi (read-line opened_file_to_read_group)))
        (setq scale_4 (atoi (read-line opened_file_to_read_group)))
        (setq text_4 (read-line opened_file_to_read_group))
        (if (or (<= custom_4 39)(>= custom_4 101)(<= impact_4 0)(<= count_4 0)(<= length_4 0) (<= width_4 0) (<= scale_4 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )


                (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_5 (atoi (read-line opened_file_to_read_group)))
        (setq custom_5 (atoi (read-line opened_file_to_read_group)))
        (setq group_5 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_5 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_5 "put_down") ; means put_down
        );


        (setq clr_5 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_5 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_5 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_5 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_5 8) ; 8 means night
        );
        (setq impact_5 (atoi (read-line opened_file_to_read_group)))
        (setq count_5 (atoi (read-line opened_file_to_read_group)))
        (setq length_5 (atoi (read-line opened_file_to_read_group)))
        (setq width_5 (atoi (read-line opened_file_to_read_group)))
        (setq scale_5 (atoi (read-line opened_file_to_read_group)))
        (setq text_5 (read-line opened_file_to_read_group))
        (if (or (<= custom_5 39)(>= custom_5 101)(<= impact_5 0)(<= count_5 0)(<= length_5 0) (<= width_5 0) (<= scale_5 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )



                (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_6 (atoi (read-line opened_file_to_read_group)))
        (setq custom_6 (atoi (read-line opened_file_to_read_group)))
        (setq group_6 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_6 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_6 "put_down") ; means put_down
        );


        (setq clr_6 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_6 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_6 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_6 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_6 8) ; 8 means night
        );
        (setq impact_6 (atoi (read-line opened_file_to_read_group)))
        (setq count_6 (atoi (read-line opened_file_to_read_group)))
        (setq length_6 (atoi (read-line opened_file_to_read_group)))
        (setq width_6 (atoi (read-line opened_file_to_read_group)))
        (setq scale_6 (atoi (read-line opened_file_to_read_group)))
        (setq text_6 (read-line opened_file_to_read_group))
        (if (or (<= custom_6 39)(>= custom_6 101)(<= impact_6 0)(<= count_6 0)(<= length_6 0) (<= width_6 0) (<= scale_6 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )




                (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_7 (atoi (read-line opened_file_to_read_group)))
        (setq custom_7 (atoi (read-line opened_file_to_read_group)))
        (setq group_7 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_7 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_7 "put_down") ; means put_down
        );


        (setq clr_7 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_7 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_7 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_7 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_7 8) ; 8 means night
        );
        (setq impact_7 (atoi (read-line opened_file_to_read_group)))
        (setq count_7 (atoi (read-line opened_file_to_read_group)))
        (setq length_7 (atoi (read-line opened_file_to_read_group)))
        (setq width_7 (atoi (read-line opened_file_to_read_group)))
        (setq scale_7 (atoi (read-line opened_file_to_read_group)))
        (setq text_7 (read-line opened_file_to_read_group))
        (if (or (<= custom_7 39)(>= custom_7 101)(<= impact_7 0)(<= count_7 0)(<= length_7 0) (<= width_7 0) (<= scale_7 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )



                (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_8 (atoi (read-line opened_file_to_read_group)))
        (setq custom_8 (atoi (read-line opened_file_to_read_group)))
        (setq group_8 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_8 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_8 "put_down") ; means put_down
        );


        (setq clr_8 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_8 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_8 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_8 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_8 8) ; 8 means night
        );
        (setq impact_8 (atoi (read-line opened_file_to_read_group)))
        (setq count_8 (atoi (read-line opened_file_to_read_group)))
        (setq length_8 (atoi (read-line opened_file_to_read_group)))
        (setq width_8 (atoi (read-line opened_file_to_read_group)))
        (setq scale_8 (atoi (read-line opened_file_to_read_group)))
        (setq text_8 (read-line opened_file_to_read_group))
        (if (or (<= custom_8 39)(>= custom_8 101)(<= impact_8 0)(<= count_8 0)(<= length_8 0) (<= width_8 0) (<= scale_8 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )




                (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_9 (atoi (read-line opened_file_to_read_group)))
        (setq custom_9 (atoi (read-line opened_file_to_read_group)))
        (setq group_9 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_9 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_9 "put_down") ; means put_down
        );


        (setq clr_9 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_9 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_9 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_9 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_9 8) ; 8 means night
        );
        (setq impact_9 (atoi (read-line opened_file_to_read_group)))
        (setq count_9 (atoi (read-line opened_file_to_read_group)))
        (setq length_9 (atoi (read-line opened_file_to_read_group)))
        (setq width_9 (atoi (read-line opened_file_to_read_group)))
        (setq scale_9 (atoi (read-line opened_file_to_read_group)))
        (setq text_9 (read-line opened_file_to_read_group))
        (if (or (<= custom_9 39)(>= custom_9 101)(<= impact_9 0)(<= count_9 0)(<= length_9 0) (<= width_9 0) (<= scale_9 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

        (read-line opened_file_to_read_group) ;;; trash-line
        (setq db_10 (atoi (read-line opened_file_to_read_group)))
        (setq custom_10 (atoi (read-line opened_file_to_read_group)))
        (setq group_10 (1+ (atoi (read-line opened_file_to_read_group)))) 


        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_10 "takeoff") ; means takeoff
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq action_10 "put_down") ; means put_down
        );


        (setq clr_10 (atoi (read-line opened_file_to_read_group)))
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_10 0) ; mean max
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate_10 1) ; mean equal
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_10 16) ; 16 means day
        );
        (if (= (read-line opened_file_to_read_group) "1")
        (setq time_10 8) ; 8 means night
        );
        (setq impact_10 (atoi (read-line opened_file_to_read_group)))
        (setq count_10 (atoi (read-line opened_file_to_read_group)))
        (setq length_10 (atoi (read-line opened_file_to_read_group)))
        (setq width_10 (atoi (read-line opened_file_to_read_group)))
        (setq scale_10 (atoi (read-line opened_file_to_read_group)))
        (setq text_10 (read-line opened_file_to_read_group))
        (if (or (<= custom_10 39)(>= custom_10 101)(<= impact_10 0)(<= count_10 0)(<= length_10 0) (<= width_10 0) (<= scale_10 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )


;;; END NOISE 2 ;;;

;;; MISC ;;;

        (read-line opened_file_to_read_group) ;;; trash-line
        (setq merge_vpp (atoi (read-line opened_file_to_read_group)))
        (setq notify (atoi (read-line opened_file_to_read_group)))
        ; (setq auto_trim (atoi (read-line opened_file_to_read_group)))
        (setq delete_files (atoi (read-line opened_file_to_read_group)))

;;; END MISC ;;;
;;; FORMAT RAW SETTINGS ;;;

;;; MAKE NEW FILE LIST ;;;

(setq file_list (list 40 45 50 55 60 65 70 75 80 85 90 95 100))


;;;; DETECT CUSTOM X 1 ;;;
(if (= db_1 1)
  (progn
    (if (= calculate_1 1)
      (progn
        (setq equ_level_1 (fix (round (equal_add count_1 (* time_1 3600) impact_1) 0)))
        (setq custom_1 (fix (round (+ custom_1 equ_level_1) 0)))
      )
    )
    (if (not (member custom_1 file_list))
        (progn
          (make_list group_1 action_1 custom_1)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK

;;;; DETECT CUSTOM X 1 ;;;
(if (= db_2 1)
  (progn
    (if (= calculate_2 1)
      (progn
        (setq equ_level_2 (fix (round (equal_add count_2 (* time_2 3600) impact_2) 0)))
        (setq custom_2 (fix (round (+ custom_2 equ_level_2) 0)))
      )
    )
    (if (not (member custom_2 file_list))
        (progn
          (make_list group_2 action_2 custom_2)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;







(if (= db_3 1)
  (progn
    (if (= calculate_3 1)
      (progn
        (setq equ_level_3 (fix (round (equal_add count_3 (* time_3 3600) impact_3) 0)))
        (setq custom_3 (fix (round (+ custom_3 equ_level_3) 0)))
      )
    )
    (if (not (member custom_3 file_list))
        (progn
          (make_list group_3 action_3 custom_3)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;



(if (= db_4 1)
  (progn
    (if (= calculate_4 1)
      (progn
        (setq equ_level_4 (fix (round (equal_add count_4 (* time_4 3600) impact_4) 0)))
        (setq custom_4 (fix (round (+ custom_4 equ_level_4) 0)))
      )
    )
    (if (not (member custom_4 file_list))
        (progn
          (make_list group_4 action_4 custom_4)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;




(if (= db_5 1)
  (progn
    (if (= calculate_5 1)
      (progn
        (setq equ_level_5 (fix (round (equal_add count_5 (* time_5 3600) impact_5) 0)))
        (setq custom_5 (fix (round (+ custom_5 equ_level_5) 0)))
      )
    )
    (if (not (member custom_5 file_list))
        (progn
          (make_list group_5 action_5 custom_5)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;



(if (= db_6 1)
  (progn
    (if (= calculate_6 1)
      (progn
        (setq equ_level_6 (fix (round (equal_add count_6 (* time_6 3600) impact_6) 0)))
        (setq custom_6 (fix (round (+ custom_6 equ_level_6) 0)))
      )
    )
    (if (not (member custom_6 file_list))
        (progn
          (make_list group_6 action_6 custom_6)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;




(if (= db_7 1)
  (progn
    (if (= calculate_7 1)
      (progn
        (setq equ_level_7 (fix (round (equal_add count_7 (* time_7 3600) impact_7) 0)))
        (setq custom_7 (fix (round (+ custom_7 equ_level_7) 0)))
      )
    )
    (if (not (member custom_7 file_list))
        (progn
          (make_list group_7 action_7 custom_7)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;



(if (= db_8 1)
  (progn
    (if (= calculate_8 1)
      (progn
        (setq equ_level_8 (fix (round (equal_add count_8 (* time_8 3600) impact_8) 0)))
        (setq custom_8 (fix (round (+ custom_8 equ_level_8) 0)))
      )
    )
    (if (not (member custom_8 file_list))
        (progn
          (make_list group_8 action_8 custom_8)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;



(if (= db_9 1)
  (progn
    (if (= calculate_9 1)
      (progn
        (setq equ_level_9 (fix (round (equal_add count_9 (* time_9 3600) impact_9) 0)))
        (setq custom_9 (fix (round (+ custom_9 equ_level_9) 0)))
      )
    )
    (if (not (member custom_9 file_list))
        (progn
          (make_list group_9 action_9 custom_9)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;


(if (= db_10 1)
  (progn
    (if (= calculate_10 1)
      (progn
        (setq equ_level_10 (fix (round (equal_add count_10 (* time_10 3600) impact_10) 0)))
        (setq custom_10 (fix (round (+ custom_10 equ_level_10) 0)))
      )
    )
    (if (not (member custom_10 file_list))
        (progn
          (make_list group_10 action_10 custom_10)
        ); progn not in list 60 65 70..
    ); if not in list 60 65 70..
  ); progn check box OK
); if check box OK;;;; END MAKE NEW FILE LIST ;;;;;



(setq true_file_list nil)
(setq group_list nil)
(setq action_list nil)
(setq color_list nil)
(setq scale_list nil)
(setq length_list nil)
(setq width_list nil)
(setq symbol_list nil)



(if (= db_1 1)
(progn
(setq group_list (append group_list (list group_1)))
(setq action_list (append action_list (list action_1)))
(setq color_list (append color_list (list clr_1)))
(setq scale_list (append scale_list (list scale_1)))
(setq length_list (append length_list (list length_1)))
(setq width_list (append width_list (list width_1)))
(setq symbol_list (append symbol_list (list text_1)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_1) "dB"))))
)
)


(if (= db_2 1)
(progn
(setq group_list (append group_list (list group_2)))
(setq action_list (append action_list (list action_2)))
(setq color_list (append color_list (list clr_2)))
(setq scale_list (append scale_list (list scale_2)))
(setq length_list (append length_list (list length_2)))
(setq width_list (append width_list (list width_2)))
(setq symbol_list (append symbol_list (list text_2)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_2) "dB"))))
)
)


(if (= db_3 1)
(progn
(setq group_list (append group_list (list group_3)))
(setq action_list (append action_list (list action_3)))
(setq color_list (append color_list (list clr_3)))
(setq scale_list (append scale_list (list scale_3)))
(setq length_list (append length_list (list length_3)))
(setq width_list (append width_list (list width_3)))
(setq symbol_list (append symbol_list (list text_3)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_3) "dB"))))
)
)


(if (= db_4 1)
(progn
(setq group_list (append group_list (list group_4)))
(setq action_list (append action_list (list action_4)))
(setq color_list (append color_list (list clr_4)))
(setq scale_list (append scale_list (list scale_4)))
(setq length_list (append length_list (list length_4)))
(setq width_list (append width_list (list width_4)))
(setq symbol_list (append symbol_list (list text_4)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_4) "dB"))))
)
)



(if (= db_5 1)
(progn
(setq group_list (append group_list (list group_5)))
(setq action_list (append action_list (list action_5)))
(setq color_list (append color_list (list clr_5)))
(setq scale_list (append scale_list (list scale_5)))
(setq length_list (append length_list (list length_5)))
(setq width_list (append width_list (list width_5)))
(setq symbol_list (append symbol_list (list text_5)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_5) "dB"))))
)
)


(if (= db_6 1)
(progn
(setq group_list (append group_list (list group_6)))
(setq action_list (append action_list (list action_6)))
(setq color_list (append color_list (list clr_6)))
(setq scale_list (append scale_list (list scale_6)))
(setq length_list (append length_list (list length_6)))
(setq width_list (append width_list (list width_6)))
(setq symbol_list (append symbol_list (list text_6)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_6) "dB"))))
)
)


(if (= db_7 1)
(progn
(setq group_list (append group_list (list group_7)))
(setq action_list (append action_list (list action_7)))
(setq color_list (append color_list (list clr_7)))
(setq scale_list (append scale_list (list scale_7)))
(setq length_list (append length_list (list length_7)))
(setq width_list (append width_list (list width_7)))
(setq symbol_list (append symbol_list (list text_7)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_7) "dB"))))
)
)

(if (= db_8 1)
(progn
(setq group_list (append group_list (list group_8)))
(setq action_list (append action_list (list action_8)))
(setq color_list (append color_list (list clr_8)))
(setq scale_list (append scale_list (list scale_8)))
(setq length_list (append length_list (list length_8)))
(setq width_list (append width_list (list width_8)))
(setq symbol_list (append symbol_list (list text_8)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_8) "dB"))))
)
)

(if (= db_9 1)
(progn
(setq group_list (append group_list (list group_9)))
(setq action_list (append action_list (list action_9)))
(setq color_list (append color_list (list clr_9)))
(setq scale_list (append scale_list (list scale_9)))
(setq length_list (append length_list (list length_9)))
(setq width_list (append width_list (list width_9)))
(setq symbol_list (append symbol_list (list text_9)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_9) "dB"))))
)
)


(if (= db_10 1)
(progn
(setq group_list (append group_list (list group_10)))
(setq action_list (append action_list (list action_10)))
(setq color_list (append color_list (list clr_10)))
(setq scale_list (append scale_list (list scale_10)))
(setq length_list (append length_list (list length_10)))
(setq width_list (append width_list (list width_10)))
(setq symbol_list (append symbol_list (list text_10)))
(setq true_file_list (append true_file_list (list (strcat (itoa custom_10) "dB"))))
)
)

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
    (foreach temp_name true_file_list

      (setq
        total_sel (ssadd) 
        count_spline (sslength spSet)
        temp_number 0
        merge_vpp_points (ssadd)
      ); end setq  
;;;;;;;;; SPLINE CYCLE ;;;;;;;;;;;;;;;;;
      (setq break_set (ssadd))
        (setq break_list '())
      (repeat count_spline
      (setq 
        sCurve(vlax-ename->vla-object(ssname spSet temp_number))
        dataLst '()
        end_point nil
        start_point nil
        temp_number (+ temp_number 1)
      ); end setq

      (setq
        width_coeff (/ (float (car width_list)) 100) 
        length_coeff  (/ (float (car length_list)) 100)
        radius_length '()
        counter_test 1
        step (* 1000 length_coeff)
        temp_length 0
        point_list (list )
        spline_length (vlax-curve-getDistAtPoint sCurve (vlax-curve-getEndPoint sCurve))
        true_count (+ (/ spline_length step) 1)
        ok_point 1
      ); end setq
;;;;;;;;;;;;;; READ FILE DATA ;;;;;;;;;;;;;;;;
      (setq
        ff (open (strcat "C:\\fly\\data\\group_" (itoa (car group_list)) "\\" (car action_list) "\\" temp_name ".txt") "r")
        ;trash_line (read-line ff)
      ); end setq

   



      (while (and (> ok_point 0) (<= counter_test true_count))
        (setq probe_line (read-line ff))

        (if (= probe_line ())
          (setq ok_point 0)
        )

        (if (/= probe_line ())
          (progn
            (setq temp_radius (* (float (atoi probe_line)) width_coeff))
            (setq counter_test (+ counter_test 1))

            (setq point_list (append point_list (list  (vlax-curve-getPointAtDist sCurve temp_length)))) 
                        (setq temp_length (+ temp_length step))
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
      ); end foreach 


(setq end_counter (length point_list))

      (setq counter 0)  
      
      (while dataLst
        (setq 
          fPt (caar dataLst)
          Ang (cadar dataLst)
          radius (car radius_length)
        ); end setq
 ;;;;;;;;;; MAKE TRELISTICK (counter = 0) ;;;;;;;;;;;





        (if (= counter 0)  
          (progn
            
(setq radius_vertex 20)
(setq delta_phi 0)
(setq add_phi (/ (* 2 pi) radius_vertex))
(setq radius_vertex_point_list '())

(repeat (+ radius_vertex 1)

                (command "_.line" fPt 
                (trans(polar fPt  delta_phi radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq radius_vertex_point_list (append radius_vertex_point_list (list (vlax-curve-getEndPoint temp_line))))
                (vla-Delete temp_line)
                (setq delta_phi (+ delta_phi add_phi))


)
 ; (alert "pk")



          ); progn
        ); if






        (if (= counter (- end_counter 1))  
          (progn
            
(setq radius_vertex_end 20)
(setq delta_phi_end 0)
(setq add_phi_end (/ (* 2 pi) radius_vertex_end))
(setq radius_vertex_point_list_end '())

(repeat (+ radius_vertex_end 1)

                (command "_.line" fPt 
                (trans(polar fPt  delta_phi_end radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq radius_vertex_point_list_end (append radius_vertex_point_list_end (list (vlax-curve-getEndPoint temp_line))))
                (vla-Delete temp_line)
                (setq delta_phi_end (+ delta_phi_end add_phi_end))


)
 ;(alert "pk2")



          ); progn
        ); if



;;;;;;;;;; SPLIT SPLINE ;;;;;;;;;;;;;;
          (if radius
            (progn
              (if (< (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
                (progn
                  (command "_.pline"  (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius)0 1) "")
                  (setq temp_line (vlax-ename->vla-object (entlast)))
                  (setq end_point (append end_point (list (vlax-curve-getEndPoint temp_line))))  
                  (setq start_point (append start_point (list (vlax-curve-getStartPoint temp_line))))
                  (entdel (entlast))
                )
              ); end if

              (if (>= (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
                (progn
                  (command "_.pline"  (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius) 0 1) "")
                  (setq temp_line (vlax-ename->vla-object (entlast)))
                  (setq end_point (append end_point (list (vlax-curve-getStartPoint temp_line))))  
                  (setq start_point (append start_point (list (vlax-curve-getEndPoint temp_line))))
                  (entdel (entlast))
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
         (command "_.pline"  (trans(polar fPt Ang (* radius 1.5)) 0 1) (trans(polar fPt (- Ang Pi) (* radius 1.5)) 0 1) "")
         (ssadd (entlast) break_set) 
         (setq break_list (append break_list (list (entlast))))
         (if (= notify 1)
         (alert "SHORT SPLINE! DONT FORGET TRIM IT!");;; NOTIFY !!!!!
         ); if
         ;(setq total_ent_list (append total_ent_list (list (entlast))))

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
; (setq base_start_angle (list (car start_point)))
; (setq base_end_angle (list (car end_point)))

;   (setq temp_angle_spline  (append base_start_angle  end_angle_point med_angle_point start_angle_point base_end_angle base_start_angle))


  

;;;;;;;;;;; END TRELISTNIK ;;;;;;;;;;;;;;;;
;;;;;;;;; CREATE RECTANGLE'S POINT FOR MERGE VPP ;;;;;;;;;;;;;;;;
(if (= merge_vpp 1) 
  (progn
     (if (ssmemb (ssname spSet (- temp_number 1)) merge_set)
        (progn
        (command "_.point" (car end_point))
        (ssadd (entlast) merge_vpp_points)
        (setq total_merge_vpp_list (append total_merge_vpp_list (list (entlast))))

        (command "_.point" (car start_point))
        (ssadd (entlast) merge_vpp_points)
        (setq total_merge_vpp_list (append total_merge_vpp_list (list (entlast))))

        ); progn
    ); if
  ); progn
); if
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


  (command "._PLINE")
  (apply 'command radius_vertex_point_list);
  (command "")
  ;(alert "aaa")

        (ssadd (entlast) total_sel)

          (command "._PLINE")
  (apply 'command radius_vertex_point_list_end);
  (command "")
  ;(alert "aaa2")

        (ssadd (entlast) total_sel)


;; END DRAW RECTANGLES ;;;
      ); END SPLINE CYCLE!!!



(setq break_back break_list)

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
); GETFROMLAST


  (setq ss total_sel)
  (setq el (entlast))
  
  (command "_.region" ss "")  
  (command "_.union" (getfromlast el) "")

  (setq el (entlast))
  (command "_.explode" (entlast) )  
  (setq el_2 (entlast))

  (setq areas (getfromlast el))
  (setq explode_counter 0)






;;;; add to total_ent
(if (= (cdr (cadr (entget (ssname areas 1)))) "REGION")
  (progn
;(alert "many")
        (setq trim_proba 0)
     (setq total_fit (ssadd))
     (setq total_ent_list '())
    (repeat (sslength areas)
    (setq el (entlast))

    (command "_.explode" (ssname areas explode_counter))
(setq el_3 (entlast))
      ;  (command "_.pedit" "_m" (getfromlast el) "" "_Y" "_J" "" "")

              (command "_.pedit" "_m" (getfromlast el) "" "_Y" "" "")
        (command "_.pedit" "_m" (getfromlast el) "" "_J" "" "")

;(alert "AAA")
    (setq ent_curve (entlast))


(if (= auto_trim 1)
  (progn

(if (= trim_proba 0)
  (progn


 (setq vla_curve (vlax-ename->vla-object ent_curve))
 (setq  pt3_list '())

 (setq true_break_list '())
 (setq sel_set_fit (ssadd))
 (setq sel_set (ssadd))
 ;;;; FIND CURVE AND POINTS ;;;;;;;
 (while (> (length break_list) 0)
   ;(alert "next pt3")
 (setq temp_line (vlax-ename->vla-object (car break_list)))
 (setq intersect_probe (vlax-invoke vla_curve 'IntersectWith temp_line acextendnone))

 (if (= (length intersect_probe) 6)
(progn
(setq pt1 (list (nth 0 intersect_probe) (nth 1 intersect_probe) (nth 2 intersect_probe)))
(setq pt2 (list (nth 3 intersect_probe) (nth 4 intersect_probe) (nth 5 intersect_probe)))
(setq length_1 (vlax-curve-getDistAtPoint vla_curve pt1))
(setq length_2 (vlax-curve-getDistAtPoint vla_curve pt2))
(setq diff_length (abs (- length_1 length_2)))
(setq full_length (vlax-curve-getDistAtParam vla_curve (vlax-curve-getEndParam vla_curve )))

(if (>= (/ full_length 2) diff_length)
(progn
(setq pt3 (vlax-curve-getPointAtDist vla_curve (/(+ length_1 length_2) 2)))
); progn
); if

(if (< (/ full_length 2) diff_length)
(progn
(setq true_length length_1)
(if (> length_1 length_2)
(progn
(setq true_length length_2)
); progn
); if
(setq pt3 (vlax-curve-getPointAtDist vla_curve (- true_length 100)))
); progn
); if

(setq true_break_list (append true_break_list (list (car break_list))))
(setq break_list (cdr break_list))
(setq pt3_list (append pt3_list (list pt3)))
); progn double points
); if double points


(if (/= (length intersect_probe) 6)
(progn
(setq break_list (cdr break_list))
); 
); 


 ); while 
 (setq pt3_back pt3_list)

 (setq break_list break_back)
 (setq pt3_back pt3_list)

(defun c:pj_4 ( / *error* sel val var )
        (defun *error* ( msg )
        (mapcar '(lambda ( a b ) (if b (setvar a b))) var val)
        (LM:endundo (LM:acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
    (LM:startundo (LM:acdoc))
            (setq var '(cmdecho peditaccept)
                  val  (mapcar 'getvar var)
            )
            (mapcar '(lambda ( a b c ) (if a (setvar b c))) val var '(0 1))
            (command "_.pedit" "_m" sel_set "" "_j" "" "")
    (*error* nil)
    (princ)
)
(defun LM:ssget ( msg arg / sel )
    (princ msg)
    (setvar 'nomutt 1)
    (setq sel (vl-catch-all-apply 'ssget arg))
    (setvar 'nomutt 0)
    (if (not (vl-catch-all-error-p sel)) sel)
)
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)
(vl-load-com) (princ)


(setq ent_last_for_fit (entlast))

 (if (> (length pt3_list) 0)
   (progn

   (setq ent_last_0 (entlast))
   (setq proba_fit 0)

   (command "_.trim" (nth 0 true_break_list) ""  (nth 0 pt3_list) "")
   (setq total_ent_list (append total_ent_list (list (entlast))))
   (setq sel_set (ssadd))
   (setq sel_set (getfromlast ent_last_0))



 (if (not sel_set)
 (setq sel_set (ssadd))
 )

   (ssadd ent_last_0 sel_set)


   (c:pj_4)

 ;;; 
   (setq true_break_list (cdr true_break_list))
   (setq pt3_list (cdr pt3_list))

           ;(alert "cut 00")
   (while (> (length pt3_list) 0)
   (setq proba_fit 1)
   (setq ent_last (entlast))
  

   (command "_.trim" (nth 0 true_break_list) ""  (nth 0 pt3_list) "")

               (setq total_ent_list (append total_ent_list (list (entlast))))

   (setq sel_set (getfromlast ent_last))

   (if (not sel_set)
 (setq sel_set (ssadd))
 )
   (ssadd ent_last sel_set)

   (c:pj_4)
   (setq true_break_list (cdr true_break_list))
   (setq pt3_list (cdr pt3_list))
  ); while
    (c:pj_4)

  ); progn
 ); if
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;; DELETE BREAK LINES ;;;

; (while (> (length break_back) 0)
; (entdel (nth 0 break_back))
; (setq break_back (cdr break_back))
; ); while


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;(alert "delete break")
; ;;;;;; SPLINE FIT ;;;;;;
; (if (= proba_fit 1)
; (setq sel_set_fit (getfromlast ent_last_for_fit))
; )
;   (if (not sel_set_fit)
; (setq sel_set_fit (ssadd))
; )
;                        ;     (alert "cut 11111ssss11")
; (ssadd ent_last_for_fit sel_set_fit)
;                          ; (alert "cut 11111ssss11")
; (setq sel_set_fit_counter 0)


; (repeat (sslength sel_set_fit)
; (command "_.pedit" (ssname sel_set_fit sel_set_fit_counter) "_Spline" "")

;               (setq total_ent_list (append total_ent_list (list (ssname sel_set_fit sel_set_fit_counter) )))

; (setq sel_set_fit_counter (+ sel_set_fit_counter 1))
; ); repeat



;(alert "regi")
;;;;;;;;;;;;;;;;;;;;;;;;
    ); progn AUTO TRIM REGION
); if AUTO TRIM REGION

); progn
); if


(setq counter_X 0)

(repeat (sslength (getfromlast el_3))
    (setq total_ent_list (append total_ent_list (list (ssname (getfromlast el_3) counter_X))));;;;;;;;;;;;;;
    (setq total_fit (ssadd (ssname (getfromlast el_3) counter_X) total_fit))
    (setq counter_X (+ 1 counter_X))
)  




    (setq explode_counter (+ explode_counter 1))

     ); repeat
(setq test_total_fit total_fit)

 (setq total_fit_counter 0)
 (repeat (sslength total_fit)
     (setq total_ent_list (append total_ent_list (list (ssname total_fit total_fit_counter))))
     (setq total_fit_counter (+ total_fit_counter 1))
 )








      (setq
        str   (car symbol_list)
        file  (strcat (getvar 'dwgprefix)  "_mylt.lin")
        fn    (open file "w")
      ); setq


            (write-line (strcat "*" str ", ---" str "---") fn)
            (write-line (strcat "A,1.5,-0.05,[\""str"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
      (close fn)


      (if (= (tblsearch "LTYPE" str) nil)
        (command "_.linetype" "_load" "*" file "")
      ); end if

      (vl-file-delete file)

;; GOO 

(setq fit_counter 0)
(repeat (sslength total_fit)
     (command "_.pedit" (ssname total_fit fit_counter) "_L" "_On" "")
      (command "._CHANGE" (ssname total_fit fit_counter) "" "_Properties" "_LType" str "")
      (command "._CHANGE" (ssname total_fit fit_counter) "" "_Properties" "_LtScale" (car scale_list) "")
      (command "._CHANGE" (ssname total_fit fit_counter) "" "_Properties" "_Color" (car color_list) "")

     (setq total_ent_list (append total_ent_list (list (ssname total_fit fit_counter)))) ;;;;;;;;;;;;;;;;;;

 (command "_.pedit" (ssname total_fit fit_counter) "_Spline" "");; OFF
 (setq fit_counter (+ fit_counter 1))
); repeat fit

);progn
);if












(if (= (cdr (cadr (entget (ssname areas 1)))) "LINE")
  (progn
    (setq trim_proba 1)
    ;(alert "one")
    (command "_.pedit" "_m" (getfromlast el) "" "_Y" "_J" "" "")




 (setq
        str   (car symbol_list)
        file  (strcat (getvar 'dwgprefix)  "_mylt.lin")
        fn    (open file "w")
      ); setq

      (write-line (strcat "*" str ", ---" str "---") fn)

            (write-line (strcat "A,1.5,-0.05,[\""str"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.012 (strlen str)) 2 3)) fn)
      (close fn)
        ;(setvar 'expert 5)

      (if (= (tblsearch "LTYPE" str) nil)
        (command "_.linetype" "_load" "*" file "")
      ); end if

      (vl-file-delete file)


    (setq closed_pline (getfromlast el_2))
    (setq closed_pline_counter 0)

    (repeat (sslength closed_pline)


(setq weed_ok 0)
;(C:WEED)
; (if (= weed_ok 1)
;   (progn
; (setq sel_set_weed (ssadd))
; (ssadd (ssname closed_pline closed_pline_counter) sel_set_weed)
; (c:weed sel_set_weed)
; )
;   )
;(alert "weed done")



   ; (if (= auto_trim 0)
    (command "_.pedit" (ssname closed_pline closed_pline_counter) "_Spline" "")
    ;)








    (command "_.pedit" (ssname closed_pline closed_pline_counter) "_L" "_On" "")


      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "_Properties" "_LType" str "")
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "_Properties" "_LtScale" (car scale_list) "")
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "_Properties" "_Color" (car color_list) "")
     (setq total_ent_list (append total_ent_list (list (ssname closed_pline closed_pline_counter))))
      (setq closed_pline_counter (+ closed_pline_counter 1))

    ); repeat

    ); progn 
  ); if

      (if (/= (cdr group_list) nil)
        (setq group_list (cdr group_list))
      ); end if

      (if (/= (cdr action_list) nil)
        (setq action_list (cdr action_list))
      ); end if


      (if (/= (cdr color_list) nil)
        (setq color_list (cdr color_list))
      ); end if

      (if (/= (cdr scale_list) nil)
        (setq scale_list (cdr scale_list))
      ); end if

                  (if (/= (cdr length_list) nil)
        (setq length_list (cdr length_list))
      ); end if

            (if (/= (cdr width_list) nil)
        (setq width_list (cdr width_list))
      ); end if

            (if (/= (cdr symbol_list) nil)
        (setq symbol_list (cdr symbol_list))
      ); end if

  (princ)
)  ;;;; end MP





(c:mp) 
   (setq global_ent_list (append global_ent_list total_ent_list))
      





;;;;;;;;;;;;;;;;;  BEGIAN AUTO TRIM ;;;;;;;;;;;;;;;;;

(setq ent_curve (entlast))
;(alert "next file")

(if (= auto_trim 1)

  (progn

(if (= trim_proba 1)
  (progn
(setq vla_curve (vlax-ename->vla-object ent_curve))
(setq  pt3_list '())

(setq true_break_list '())
(setq sel_set_fit (ssadd))
(setq sel_set (ssadd))
;;;; FIND CURVE AND POINTS ;;;;;;;
(while (> (length break_list) 0)
  ;(alert "next pt3")
(setq temp_line (vlax-ename->vla-object (car break_list)))
(setq intersect_probe (vlax-invoke vla_curve 'IntersectWith temp_line acextendnone))

(if (= (length intersect_probe) 6)
(progn
(setq pt1 (list (nth 0 intersect_probe) (nth 1 intersect_probe) (nth 2 intersect_probe)))
(setq pt2 (list (nth 3 intersect_probe) (nth 4 intersect_probe) (nth 5 intersect_probe)))
(setq length_1 (vlax-curve-getDistAtPoint vla_curve pt1))
(setq length_2 (vlax-curve-getDistAtPoint vla_curve pt2))
(setq diff_length (abs (- length_1 length_2)))
(setq full_length (vlax-curve-getDistAtParam vla_curve (vlax-curve-getEndParam vla_curve )))

(if (>= (/ full_length 2) diff_length)
(progn
(setq pt3 (vlax-curve-getPointAtDist vla_curve (/(+ length_1 length_2) 2)))
); progn
); if
(if (< (/ full_length 2) diff_length)
(progn
(setq true_length length_1)
(if (> length_1 length_2)
(progn
(setq true_length length_2)
); progn
); if
(setq pt3 (vlax-curve-getPointAtDist vla_curve (- true_length 100)))
); progn
); if
(setq true_break_list (append true_break_list (list (car break_list))))
(setq break_list (cdr break_list))
(setq pt3_list (append pt3_list (list pt3)))
); progn double points
); if double points


(if (/= (length intersect_probe) 6)
(progn
(setq break_list (cdr break_list))
); 
); 


); while 
(setq pt3_back pt3_list)

(setq break_list break_back)
(setq pt3_back pt3_list)

(defun c:pj_4 ( / *error* sel val var )
        (defun *error* ( msg )
        (mapcar '(lambda ( a b ) (if b (setvar a b))) var val)
        (LM:endundo (LM:acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
    (LM:startundo (LM:acdoc))
            (setq var '(cmdecho peditaccept)
                  val  (mapcar 'getvar var)
            )
            (mapcar '(lambda ( a b c ) (if a (setvar b c))) val var '(0 1))
            (command "_.pedit" "_m" sel_set "" "_j" "" "")
    (*error* nil)
    (princ)
)
(defun LM:ssget ( msg arg / sel )
    (princ msg)
    (setvar 'nomutt 1)
    (setq sel (vl-catch-all-apply 'ssget arg))
    (setvar 'nomutt 0)
    (if (not (vl-catch-all-error-p sel)) sel)
)
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)
(vl-load-com) (princ)


(setq ent_last_for_fit (entlast))

(if (> (length pt3_list) 0)
  (progn

  (setq ent_last_0 (entlast))
  (setq proba_fit 0)

  (command "_.trim" (nth 0 true_break_list) ""  (nth 0 pt3_list) "")
             (setq total_ent_list (append total_ent_list (list (entlast))))
  (setq sel_set (ssadd))
  (setq sel_set (getfromlast ent_last_0))



(if (not sel_set)
(setq sel_set (ssadd))
)

  (ssadd ent_last_0 sel_set)


  (c:pj_4)

;;; 
  (setq true_break_list (cdr true_break_list))
  (setq pt3_list (cdr pt3_list))

          ;(alert "cut 00")
  (while (> (length pt3_list) 0)

  (setq proba_fit 1)
  (setq ent_last (entlast))
  

  (command "_.trim" (nth 0 true_break_list) ""  (nth 0 pt3_list) "")

              (setq total_ent_list (append total_ent_list (list (entlast))))

  (setq sel_set (getfromlast ent_last))

  (if (not sel_set)
(setq sel_set (ssadd))
)
  (ssadd ent_last sel_set)

  (c:pj_4)
  (setq true_break_list (cdr true_break_list))
  (setq pt3_list (cdr pt3_list))
  ); while
    (c:pj_4)

  ); progn
); if
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;; DELETE BREAK LINES ;;;

(while (> (length break_back) 0)
(entdel (nth 0 break_back))
(setq break_back (cdr break_back))
); while


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(alert "delete break")
;;;;;; SPLINE FIT ;;;;;;
(if (= proba_fit 1)
(setq sel_set_fit (getfromlast ent_last_for_fit))
)
  (if (not sel_set_fit)
(setq sel_set_fit (ssadd))
)
                       ;     (alert "cut 11111ssss11")
(ssadd ent_last_for_fit sel_set_fit)
                         ; (alert "cut 11111ssss11")
(setq sel_set_fit_counter 0)


(repeat (sslength sel_set_fit)
(command "_.pedit" (ssname sel_set_fit sel_set_fit_counter) "_Spline" "")

              (setq total_ent_list (append total_ent_list (list (ssname sel_set_fit sel_set_fit_counter) )))

(setq sel_set_fit_counter (+ sel_set_fit_counter 1))
); repeat

;;;;;;;;;;;;;;;;;;;;;;;;
    ); progn AUTO TRIM
); if AUTO TRIM
); trim proba
); trim proba









      ); END FILE CYCLE!!!



(setq del_merge_counter 0)
(repeat (length total_merge_vpp_list)
(entdel (nth del_merge_counter total_merge_vpp_list))
(setq del_merge_counter (+ del_merge_counter 1))
)
(setq total_merge_vpp_list '())



      ); end progn --- empty select
    ); end if --- empty select


;;;; DELETE TEMP LIST FILES
;(alert "delete")
(if (= delete_files 1)
(progn
     (setq true_list (list "40dB.txt" "45dB.txt" "50dB.txt" "55dB.txt" "60dB.txt" "65dB.txt" "70dB.txt" "75dB.txt" "80dB.txt" "85dB.txt" "90dB.txt" "95dB.txt" "100dB.txt"))
     (setq temp_list (vl-directory-files (strcat "C:\\fly\\data\\" group_number "\\" action "\\")  "*" 1))

(defun LM:ListDifference ( l1 l2 )
  (vl-remove-if '(lambda ( x ) (member x l2)) l1)
)
(setq diff (LM:ListDifference temp_list true_list))
(setq delete_list '())
(while (>(length diff) 0)
(setq delete_list (append delete_list (list (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (nth 0 diff))) ))
(setq diff (LM:ListDifference diff (list (nth 0 diff))))
)
(mapcar 'vl-file-delete delete_list)
); progn
); if
;;;;;;;;;
















;;;;;;;;; RESET DEFAULT SETTING;;;;;
    (setvar "CMDECHO" oldEcho)
    (setvar "OSMODE" oldOsm)

  (princ)

  ); END SAMPLE


(defun rem_list (lst)
  (if (car lst)
    (cons (car lst) (rem_list (vl-remove (car lst) (cdr lst))))
  )
)


(defun c:eco_clean (/)
(setq global_ent_list (rem_list global_ent_list))
(while (/= (length total_ent_list) 0)
 (if (/= (length (entget (nth 0 global_ent_list))) 0)
 (progn
     (entdel (nth 0 global_ent_list))
 ); progn
 ); if
(setq global_ent_list (cdr global_ent_list))
)
); eco_clean




(defun c:eco_save (/)
(setq global_ent_list '())
)


(setq 
  areas_2 nil
  ss_2 nil
  el_2 nil
)

(defun c:mpu( / )
  
  (defun getfromlast_2(e / s)
    (setq
     s (ssadd)
    )
      (while (setq e (entnext e))
        (setq
          s (ssadd e s)
        )
      )
  )

  (setq  ss_2 (ssget (list (cons 0 "*POLYLINE"))))
   ;(setq ss total_sel)
   (setq el_2 (entlast))
  
  (command "_.region" ss_2 "")  
  (command "_.union" (getfromlast_2 el_2) "")

  (setq el_2 (entlast))
  (command "_.explode" (entlast) )  


(setq areas (getfromlast_2 el_2))
(setq explode_counter_2 0)



(if (= (cdr (cadr (entget (ssname areas_2 1)))) "_REGION")
  (progn
    ;(alert "men2")
(repeat (sslength areas_2)
(setq el_2 (entlast))
(command "_.explode" (ssname areas_2 explode_counter_2))
(command "_.pedit" (entlast) "_y" "_j" (getfromlast_2 el_2) "" "")  
(setq explode_counter_2 (+ explode_counter_2 1))
)
);progn
);if
 
(if (= (cdr (cadr (entget (ssname areas_2 1)))) "_LINE")
  (progn
  ;  (alert "one")
    (command "_.pedit" (entlast) "_y" "_j" (getfromlast_2 el_2) "" "")
)
  )
 ; (command ".union" (getfromlast el)  "")  

  (princ)
) 

(defun round (num dp / fac)
  (setq fac (float (expt 10 dp)))

  (if (< 0.5 (rem (setq num (* fac num)) 1))
    (/ (1+ (fix num)) fac)
    (/     (fix num)  fac))
 )



(defun make_list (group_number action custom_level /)

  (setq file_list (list 40 45 50 55 60 65 70 75 80 85 90 95 100))

    (if (not (member custom_level file_list))
        (progn
(setq file_list (append file_list (list custom_level)))
(setq sort_file_list (vl-sort file_list '<))
(setq db_position (vl-position custom_level sort_file_list))
(setq file_list_length (vl-list-length sort_file_list))

(setq opened_file_db_custom_level (open (strcat "C:\\fly\\data\\group_" (itoa group_number) "\\" action "\\" (itoa custom_level) "dB.txt" ) "w"))

(if (/= db_position 0)
    (progn
(if (/= db_position (- file_list_length 1))
  (progn




(setq opened_file_approx_1_count (open (strcat "C:\\fly\\data\\group_" (itoa group_number) "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq opened_file_approx_2_count (open (strcat "C:\\fly\\data\\group_" (itoa group_number) "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq file_length_1 0)
(setq file_length_2 0)
; (setq alpha_list (list ))

(while (read-line opened_file_approx_1_count)
(setq file_length_1 (+ 1 file_length_1))
)
(while (read-line opened_file_approx_2_count)
(setq file_length_2 (+ 1 file_length_2))
)

(close opened_file_approx_1_count)
(close opened_file_approx_2_count)


(setq dNtoDel (- file_length_1 file_length_2))
;(setq dNtoDel_list (append dNtoDel_list (list dNtoDel)))



(setq opened_file_approx_1 (open (strcat "C:\\fly\\data\\group_" (itoa group_number) "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq opened_file_approx_2 (open (strcat "C:\\fly\\data\\group_" (itoa group_number) "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
;;;(setq delta_level (- (nth (+ db_position 1) sort_file_list) custom_level) )


(setq delta_level (- (nth (+ db_position 1) sort_file_list) custom_level ) )


;(setq delete_number (- custom_level (nth (- db_position 1) sort_file_list)))

(setq true_sum 0)
(setq false_sum 0)
(setq proba_number 0)
(setq split_number 5)
(setq number_to_write_counter 0)
;(setq delta_counter split_number)

(setq alpha (/ (float delta_level) split_number))
;(setq alpha_list (append alpha_list (list alpha )))
(while (setq sum_k (read-line opened_file_approx_1))

(setq true_sum2 0)
(if (setq sum_k_1 (read-line opened_file_approx_2))
    (progn
(setq true_sum2 1)
(setq last_sum_k_1 sum_k_1)
(setq med (+ (* alpha (atof sum_k)) (* (- 1 alpha) (atof sum_k_1))))
(setq true_sum (+ 1 true_sum))
(write-line (rtos med) opened_file_db_custom_level)
); progn sum2 no 0
); if sum2 not 0

(if (= true_sum2 0)
(progn
 (setq number_to_write (fix (* dNtoDel alpha)))
(if (< number_to_write_counter number_to_write)
(progn
;(alert "add")
(setq number_to_write_counter (+ 1 number_to_write_counter))
 (setq med (+ (* alpha (atof sum_k)) (* (- 1 alpha) (atof last_sum_k_1))))
 (setq false_sum (+ 1 false_sum))
(write-line (rtos med) opened_file_db_custom_level)
) ; progn
); if
); progn
); if


); while


(close opened_file_approx_1)
(close opened_file_approx_2)


); progn poi\sition not end
); if positiom not end
); progn
); if






















; (if (= db_position 0)
; (progn
; (setq opened_file_approx_1 (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
; (setq step_from_less ( - (nth (+ db_position 1) sort_file_list) custom_level))
; (setq coeff (+ 1 (*(/ (float step_from_less) 100) 3)))
; (while (setq sum1 (read-line opened_file_approx_1))

; (setq med (*(atoi sum1) coeff ))
; (write-line (rtos med) opened_file_db_custom_level)
; ); while
; (close opened_file_approx_1)
;     ); progn position 0
; ); if position 0

; (if (= db_position (- file_list_length 1))
; (progn

; (setq opened_file_approx_1 (open (strcat "C:\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
; (setq step_from_less (- custom_level (nth (- db_position 1) sort_file_list)))
; (setq coeff (- 1 (*(/ (float step_from_less) 100) 3)))
; (while (setq sum1 (read-line opened_file_approx_1))

; (setq med (* (float (atoi sum1)) coeff ))
;     (write-line (rtos med) opened_file_db_custom_level)
; ); while
; (close opened_file_approx_1)
; ); progn position end
; ); if position end


(close opened_file_db_custom_level) 


)
;(alert "add")
        ); progn not in list 60 65 70..
    

(setq file_list (vl-remove custom_level file_list))
;(setq file_list (append file_list (list custom_level)))

    )










